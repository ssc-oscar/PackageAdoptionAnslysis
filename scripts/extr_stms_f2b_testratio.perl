#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;

my $fname="$ARGV[0]";
my (%clones);
my $hdb = TokyoCabinet::HDB->new();

if(!tie(%clones, "TokyoCabinet::HDB", "$fname",
                  TokyoCabinet::HDB::OREADER)){
        print STDERR "tie error for $fname\n";
}

open(my $fstms, '<', $ARGV[1]) or die "Could not open file $ARGV[1] !";
my @stms = ();

while(my $row = <$fstms>){
  #chop $row;
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

my $offset = 0;
while (<STDIN>){
  chop ();
  my $k = $_;
  if (! defined $clones{$k}){
    print "$k is not found\n";
    next;
  }
  my $vs = $clones{$k};
  my $l = length($vs);
  $offset = $offset + $l/20;
} 
  print "$offset\n";
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
