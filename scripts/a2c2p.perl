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


my %a2c;
my $fname1 = "$ARGV[0].tch";
tie %a2c, "TokyoCabinet::HDB", "$fname1", TokyoCabinet::HDB::OREADER,
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname1\n";

#my $detail = 0;
#$detail = $ARGV[1]+0 if defined $ARGV[1];
my $split = 1;
$split = $ARGV[2] + 0 if defined $ARGV[2];

my %c2p;
for my $sec (0..($split-1)){
  my $fname = "$ARGV[1].$sec.tch";
  $fname = $ARGV[1] if ($split == 1);
  tie %{$c2p{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
}

while (<STDIN>){
  chop();
  my $au = $_;
  if (! defined $a2c{$au}){
    print STDERR "author $au is not in au2cmt map\n";
    next;
  }
  print "$au";
  my $cs = $a2c{$au};
  my $nc = length($cs)/20;
  my %prjs;
  for my $i (0..($nc-1)){
    my $c = substr ($cs, 20*$i, 20);
    my $sec = (unpack "C", substr ($c, 0, 1))%$split;
    my $tmp;
    if (defined  $c2p{$sec}{$c}){
      $tmp = list ($c, $c2p{$sec}{$c});
    }else{
      $tmp = list ($c, $c2p{$sec}{"$c\n"}) if defined $c2p{$sec}{"$c\n"};
    }
    if (defined $tmp){
      my @ps = split(/\;/, $tmp, -1);
      for my $j (@ps){
        $prjs{$j} = 1;
      }
    }
  }
  my $output = join ";", keys %prjs;
  print ";$output\n";
  %prjs = ();
}

for my $sec (0..($split-1)){
  untie %{$c2p{$sec}};
}

untie %a2c;

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


sub list {
  my ($c, $v) = @_;
  my $c1 = toHex($c);
  my $v1 = safeDecomp ($v);
  my @ps = split(/\;/, $v1, -1);
  return  ($v1);
}

