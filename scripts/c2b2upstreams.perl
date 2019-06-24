#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;

#my $fname="$ARGV[0]";
my (%clones);
my $hdb = TokyoCabinet::HDB->new();

#if(!tie(%clones, "TokyoCabinet::HDB", "$fname",
#                  TokyoCabinet::HDB::OREADER)){
#        print STDERR "tie error for $fname\n";
#}





open(my $fstms, '<', $ARGV[0]) or die "Could not open file $ARGV[0] !";
my @stms = ();

while(my $row = <$fstms>){
  chop ($row);
  push @stms,$row;
}

close $fstms;


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

my $split = 1;
$split = $ARGV[1] + 0 if defined $ARGV[1];

my %c2b;
for my $sec (0..($split-1)){
  my $fname = "$ARGV[2].$sec.tch";
  #$fname = $ARGV[?] if ($split == 1);
  tie %{$c2b{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
}


my $offset = 0;
while (<STDIN>){
  chop ();
  #my $k = $_;
  my($prj,@cmts) = split(/;/,$_,-1);
  for my $cmt (@cmts){
    my $c = fromHex($cmt);
    my $sec = (unpack "C", substr ($c, 0, 1))%$split;
    if(!defined $c2b{$sec}{$c}){
      print STDERR "Commit $cmt not found in $sec\n";
      next;
    }

    my $v = $c2b{$sec}{$c};
    #my $c1 = toHex($c);
    my $ns = length($v)/20;
    #my %tmp = ();
    for my $i (0..($ns-1)){
      my $b2 = substr ($v, 20*$i, 20);
      my $sec = hex(unpack "H*", substr($b2, 0, 1)) % $sections;
      my $codeC = getBlob ($b2,$sec);
      my $hh = $b2;
      $hh = unpack 'H*', $b2 if length($b2) == 20;
      my $code = $codeC;
      $code = safeDecomp ($codeC, "$offset;$hh");
      $code =~ s/\r//g;
      for my $elem (@stms){
        my ($match,$pkg) = split(/;/,$elem,-1);
        if ($code =~ m/$match/){
          print "$prj;$cmt;$hh;$pkg\n";
        }
      }
      $offset++;
      #print ";".(toHex($c2));
    }
    #print "\n";
  } 

  #for my $sec (keys %list){
  #  for my $hb (keys %{$list{$sec}}){
  #    print "$sec;".(toHex($hb))."\n";
  #  }
  #}
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

for my $sec (0 .. ($split-1)){
        untie %{$c2b{$sec}};
        #my $f = $fhob{$sec};
        #close $f;
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


