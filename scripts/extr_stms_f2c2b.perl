#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;

#my $hdb = TokyoCabinet::HDB->new();
#
sub toHex { 
        return unpack "H*", $_[0]; 
} 

sub fromHex { 
        return pack "H*", $_[0]; 
}


#open(my $fstms, '<', $ARGV[1]) or die "Could not open file $ARGV[1] !";
my @stms = ();
push @stms,'angular';
push @stms,'ember';
push @stms,'react';
#while(my $row = <$fstms>){
  #chop $row;
#  push @stms,$row;
#}

#close $fstms;


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


=begin comment
my $split = 1;
$split = $ARGV[1] + 0 if defined $ARGV[1];
my %f2c;
for my $sec (0..($split-1)){
  my $fname = "$ARGV[0].$sec.tch";
  $fname = $ARGV[0] if ($split == 1);
  tie %{$f2c{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
}
=end comment
=cut

my $split2 = 1;
$split2 = $ARGV[1] + 0 if defined $ARGV[1];
my %c2b;
for my $sec (0..($split2-1)){
  my $fname = "$ARGV[0].$sec.tch";
  $fname = $ARGV[0] if ($split2 == 1);
  tie %{$c2b{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
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
  chop();
  #my $f = $_;
  #my $sec = (unpack "C", substr ($f, 0, 1))%$split;
  #if (defined  $f2c{$sec}{$f}){
  #  my $vs = $f2c{$sec}{$f};
  #  my $l = length($vs);
  
  #for my $i (0..($l/20-1)){
      
      #my $hc = substr($vs, $i*20, 20);
      my $hhc = $_;
      my $hc = fromHex($hhc);
      my $sec2 = hex(unpack "H*", substr($hc, 0, 1)) % $split2;
    #$list{$sec}{$hb}++;
      if (defined  $c2b{$sec2}{$hc}){
         my $bvs = $c2b{$sec2}{$hc};
         my $bl = length($bvs);

         for my $j (0..($bl/20-1)){
           my $hb = substr($bvs, $j*20, 20);
           my $sec3 = hex(unpack "H*", substr($hb, 0, 1)) % $sections; 
           my $codeC = getBlob ($hb,$sec3);    
           my $hh = $hb;
           $hh = unpack 'H*', $hb if length($hb) == 20;
           my $code = $codeC;
           $code = safeDecomp ($codeC, "$offset;$hh");
           $code =~ s/\r//g;
        #$code =~ s/\n/NEWLINE/g;
        #regex match
        #
        #
          for my $elem (@stms){
            if ($code =~ m/$elem/){
              print "$hhc;$hh;$elem\n";
            #exit;
            }
          }
        #print "$hh;$code\n";
        $offset++;
        }
      }

  else {
    print STDERR "$hhc is not in map c2b.$sec2\n";
  }
  

  #for my $sec (keys %list){
  #  for my $hb (keys %{$list{$sec}}){
  #    print "$sec;".(toHex($hb))."\n";
  #  }
  #}
} 


for my $sec (0 .. ($sections-1)){
        untie %{$fhosc{$sec}};
        my $f = $fhob{$sec};
        close $f;
}
for my $sec (0 .. ($split2-1)){
        untie %{$c2b{$sec}};
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


