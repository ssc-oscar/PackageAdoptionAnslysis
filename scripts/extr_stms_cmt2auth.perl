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


#my $detail = 0;
#$detail = $ARGV[1] if defined $ARGV[1];
#my $split = 1;
#$split = $ARGV[2] + 0 if defined $ARGV[2];

my %c2au;
#for my $sec (0..($split-1)){
  my $fname = "$ARGV[0]";
  #$fname = $ARGV[0] if ($split == 1);
  tie %c2au, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
         16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
#}

while (<STDIN>){
  chop ();
  my $c1 = $_;
  my $c = fromHex($c1);
  #my $sec = (unpack "C", substr ($c, 0, 1))%$split;
  if (! defined $c2au{$c}){
    print "NULL\n";
    next;
  }
  list ($c, $c2au{$c});
}
#for my $sec (0..($split-1)){
  untie %c2au;
#}


sub list {
  my ($c, $v) = @_;
  my $c1 = toHex($c);
  #my $v1 = safeDecomp ($v);
#  print "$v\n"
  my @ps = split(/\;/, $v, -1);
  print "$ps[0]\n";
#  print "$c1;".($#ps+1);

#  if ($detail){
#    print ";$v1";
#  }
#  print "\n";
}


