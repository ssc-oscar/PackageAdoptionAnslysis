#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use TokyoCabinet;
use Compress::LZF;

sub toHex { 
        return unpack "H*", $_[0]; 
} 

sub fromHex { 
        return pack "H*", $_[0]; 
} 

sub safeDecomp {
  my ($codeC, $n) = @_;
  try {
    my $code = decompress ($codeC);
    return $code;
  } catch Error with {
    my $ex = shift;
    print STDERR "Error: $ex; $n\n";
    return "";
  }
}


my $detail = 0;
$detail = $ARGV[1]+0 if defined $ARGV[1];
my $split = 1;
$split = $ARGV[2] + 0 if defined $ARGV[2];

my %p2c;
for my $sec (0..($split-1)){
  my $fname = "$ARGV[0].$sec.tch";
  $fname = $ARGV[0] if ($split == 1);
  tie %{$p2c{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
}

while (<STDIN>){
  chop ();
  my @fields = split /;/, $_;
  my $pkg = shift @fields;
  for my $c1 (@fields){
    my $c = fromHex($c1);
    my $sec = (unpack "C", substr ($c, 0, 1))%$split;
    if (defined $p2c{$sec}{$c}){
      my @fs = split /;/, safeDecomp($p2c{$sec}{$c});
      for my $f (@fs){
        print  $c1.";".$pkg.";".$f."\n"  if $f =~ m"\.[cC]$";
      }
    }
    #list ($c, $p2c{$sec}{$c}) if defined $p2c{$sec}{$c};
  }
}

for my $sec (0..($split-1)){
  untie %{$p2c{$sec}};
}


sub list {
  my ($c, $v) = @_;
  my $c1 = toHex($c);
  my $ns = length($v)/20;
  my %tmp = ();
  print "$c1;$ns";
  if ($detail != 0){
    for my $i (0..($ns-1)){
      my $c2 = substr ($v, 20*$i, 20);
      print ";".(toHex($c2));
    }
  }
  print "\n";
}


