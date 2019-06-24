#!/usr/bin/perl
use strict;
use warnings;
use Error qw(:try);

use Digest::MD5 qw(md5 md5_hex md5_base64);
use TokyoCabinet;
use Compress::LZF;

#deal extension based file recognition

my $fname="$ARGV[0]";
my (%clones);
my $hdb = TokyoCabinet::HDB->new();

if(!tie(%clones, "TokyoCabinet::HDB", "$fname",
                  TokyoCabinet::HDB::OREADER)){
        print STDERR "tie error for $fname\n";
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
my @fileextension = ();

while (<STDIN>){
  chop ();
  push @fileextension, $_;
}

my $num = 0;



#foreach my $key (keys %clones){
while (my ($key, $v) = each %clones){
  for my $elem (@fileextension){
     if ($key =~ m/$elem/){
       print "$key\n";
#      exit;
     }
  }
#  print "$key\n";
  $num ++;
  if (!($num % 400000)){
    #untie %clones;
    #exit;
    print STDERR "$num\n"; 
  }
}
untie %clones;

