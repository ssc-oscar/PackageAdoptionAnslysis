#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);
use JSON qw( decode_json );

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;

my $fname="$ARGV[0]";
my (%clones);
my $hdb = TokyoCabinet::HDB->new();

my $sections = 128;
my $parts = 2;
my $fbasec="All.sha1c/";
my (%fhob, %fhost, %fhosc);
for my $sec (0 .. ($sections-1)){
  my $pre = "/fast1";
  #open $fhob{$sec}, "/data/All.blobs/blob_$sec.bin";
  #$pre = "/fast1" if $sec % $parts;
  tie %{$fhosc{$sec}}, "TokyoCabinet::HDB", "$pre/${fbasec}$fname.$sec.tch", TokyoCabinet::HDB::OREADER,  
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
     or die "cant open $pre/${fbasec}$fname.$sec.tch\n";
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
  my $k = fromHex($_);
  my $sec = hex(unpack "H*", substr($k, 0, 1)) % $sections;
  if (! defined $fhosc{$sec}{$k}){
    print STDERR "$_ can't be found in ${fbasec}$fname.$sec\n";
    next;
  }
  my $v = $fhosc{$sec}{$k};
  my $code = safeDecomp($v);
  $code =~ s/\r//g;
  $code =~ s/\n//g;
  print $code;
#  my $vs = $clones{$k};
#  my $l = length($vs);
  #my %list = ();
  #
#for my $sec (0 .. ($sections-1)){
#  while (my ($key, $v) = each %{$fhosc{$sec}}){
#  print "".toHex($key)."\n";
  #print safeDecomp($v);
  #my $json = safeDecomp($v);
  #my $decoded = decode_json($json);
  #if (defined $decoded{'devDependencies'}){
  #  if (defined $decoded{'devDependencies'}{'hoek'}){
  #    print "succeed!\n";
  #  }
  #}
  #exit();
  #regular expressions here
#  }
}

#  for my $i (0..($l/20-1)){
#    my $hb = substr($vs, $i*20, 20);
#    my $sec = hex(unpack "H*", substr($hb, 0, 1)) % $sections;
#    #$list{$sec}{$hb}++;
#    my $codeC = getBlob ($hb,$sec);    
#    my $hh = $hb;
#    $hh = unpack 'H*', $hb if length($hb) == 20;
#    my $code = $codeC;
#        $code = safeDecomp ($codeC, "$offset;$hh");
#        $code =~ s/\r//g;
        #$code =~ s/\n/NEWLINE/g;
        #regex match
#        for my $elem (@stms){
#          if ($code =~ m/$elem/){
#            print "$k;$hh\n";
#            #exit;
#          }
#        }
        #print "$hh;$code\n";
#        $offset++;
#  }

  #for my $sec (keys %list){
  #  for my $hb (keys %{$list{$sec}}){
  #    print "$sec;".(toHex($hb))."\n";
  #  }
  #}
#} 
#untie %clones;

sub toHex { 
        return unpack "H*", $_[0]; 
} 
sub fromHex { 
        return pack "H*", $_[0]; 
} 

for my $sec (0 .. ($sections-1)){
        untie %{$fhosc{$sec}};
#        my $f = $fhob{$sec};
#        close $f;
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


