#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;
#use Try::Tiny;

use lib qw(..);
use JSON qw(decode_json);

#my $fname="$ARGV[0]";
my (%clones);
my $hdb = TokyoCabinet::HDB->new();


my $sections = 128;
my $parts = 2;
my $fbasec="All.sha1o/sha1.blob_";
my (%fhob, %fhost, %fhosc);
for my $sec (0 .. ($sections-1)){
  my $pre = "/fast1";
  open $fhob{$sec}, "/data/All.blobs/blob_$sec.bin";
  $pre = "/fast1" if $sec % $parts;
  tie %{$fhosc{$sec}}, "TokyoCabinet::HDB", "$pre/${fbasec}$sec.tch", TokyoCabinet::HDB::OREADER,  
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
     or die "cant open $pre/$fbasec$sec.tch\n";
}

sub safeDecomp {
        my $codeC = $_[0];
        try {
                my $code = decompress ($codeC);
                return $code;
        } catch Error with {
                my $ex = shift;
                print STDERR "Error: $ex\n";
                return "";
        }
}

my $offset = 0;
while (<STDIN>){
  chop ();
  my $b2 = fromHex($_);
  my $sec = hex(unpack "H*", substr($b2, 0, 1)) % $sections;
  my $codeC = getBlob ($b2,$sec);
  my $hh = $b2;
  $hh = unpack 'H*', $b2 if length($b2) == 20;
  my $code = $codeC;
  $code = safeDecomp ($codeC, "$offset;$hh");
  $code =~ s/\r//g;
  try{
     my $data = decode_json($code);
     my %dependencies = %{$data->{'dependencies'}};
     print $_;
     for my $elem (keys %dependencies) {
         print ';'.$elem;
     }
     print "\n";

     } catch Error with {
     print STDERR "Blob $hh is not a package.json file or no dependencies listed\n";
  }


=begin comment
  # three types of match
  my %matches = ();
  #my $flag = 0;
  #install\.packages\(.*"data.table".*\);
  #library\(.*[\"']*?data\.table[\"']*?.*\);
  #require\(.*[\"']*?data\.table[\"']*?.*\);
  # only consider the case where one package is installed at a time
  # one case c(a,b,d) ... 
  # another case, multiple packages in one statement
  while ($code =~ /install\.packages\(.*?"([^\"',\)]+)".*?\)/g) {
        $matches{$1} = 1;
        #print $1."\n";
        #$flag = 1;
  }
  while ($code =~ /library\([\"']*?([^\"',\)]+)[\"']*?.*?\)/g) {
        #print $1;
        $matches{$1} = 1;
  }
  while ($code =~ /require\([\"']*?([^\"',\)]+)[\"']*?.*?\)/g) {
        $matches{$1} = 1;
  }
  if (%matches){
    print $_;
    for my $elem (keys %matches) {
    print ';'.$elem;
    }
    print "\n";
  }
  $offset++;
  #if ($flag){
  #  print $_."\n";
  #  last;
  #}
=end comment
=cut
}

untie %clones;

sub toHex { 
        return unpack "H*", $_[0]; 
} 
sub fromHex { 
        return pack "H*", $_[0]; 
} 

for my $sec (0 .. ($sections-1)){
        untie %{$fhosc{$sec}};
        my $f = $fhob{$sec};
        close $f;
}









#my %store;

#my $fbasec="/fast1/All.sha1o/sha1.blob_";
#my (%fhob, %fhost, %fhosc);
#open $fhob{$sec}, "/data/All.blobs/blob_$sec.bin";
#tie %{$fhosc{$sec}}, "TokyoCabinet::HDB", "${fbasec}$sec.tch", TokyoCabinet::HDB::OREADER,  
#  16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
#  or die "cant open $fbasec$sec.tch\n";

sub getBlob {
  my ($bB) = $_[0];
  my ($sec) = $_[1];
  if (! defined $fhosc{$sec}{$bB}){
     print STDERR "no blob ".(toHex($bB))." in $sec\n";
     return "";
  }
  my ($off, $len) = unpack ("w w", $fhosc{$sec}{$bB});
  my $f = $fhob{$sec};
  seek ($f, $off, 0);
  my $codeC = "";
  my $rl = read ($f, $codeC, $len);
  return ($codeC);
}



#untie %{$fhosc{$sec}};
#my $f = $fhob{$sec};
#close $f;


