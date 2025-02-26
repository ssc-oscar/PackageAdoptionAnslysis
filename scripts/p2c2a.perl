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


#my $detail = 0;
#$detail = $ARGV[1]+0 if defined $ARGV[1];
my $split = 1;
$split = $ARGV[1] + 0 if defined $ARGV[1];

my %p2c;
for my $sec (0..($split-1)){
  my $fname = "$ARGV[0].$sec.tch";
  $fname = $ARGV[0] if ($split == 1);
  tie %{$p2c{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "cant open $fname\n";
}

my $fbasec="All.sha1c/commit_";
my $sections = 128;
my (%fhob, %fhost, %fhosc);
for my $sec (0 .. ($sections-1)){
  #my $pre = "/fast1/";
  my $pre = "/fast1";
  tie %{$fhosc{$sec}}, "TokyoCabinet::HDB", "$pre/${fbasec}$sec.tch", TokyoCabinet::HDB::OREADER,  
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
     or die "cant open $pre/$fbasec$sec.tch\n";
}

while (<STDIN>){
  chop();
  my $p = $_;
  my $sec = (unpack "C", substr ($p, 0, 1))%$split;
  #print "$sec;$p\n";
  if (defined  $p2c{$sec}{$p}){
    print "$p";
    list ($p, $p2c{$sec}{$p});
  }else{
    if (defined $p2c{$sec}{"$p\n"}){
      print "$p";
      list ($p, $p2c{$sec}{"$p\n"});
    }
  }
}
for my $sec (0..($split-1)){
  untie %{$p2c{$sec}};
}

for my $sec (0..($sections-1)){
  untie %{$fhosc{$sec}};
}


sub list {
  my ($p, $v) = @_;
  my $ns = length($v)/20;
  my %tmp = ();
  $p =~ s/\n$//;
  #print "$p;$ns";
  #if ($detail != 0){
  my %auths;
  for my $i (0..($ns-1)){
    my $c = substr ($v, 20*$i, 20);
    #print ";".(toHex($c));
    my $auth = extrAuth($c);
    if ($auth ne ""){
       $auths{$auth} = 1;
    }
  }
  my $output = join ";", keys %auths;
  print ";$output\n";
  %auths = ();
}


sub extrAuth {
  my $cmt = $_[0];
  my $sec = hex (unpack "H*", substr($cmt, 0, 1)) % $sections;
  my $cB = toHex ($cmt);
  if (! defined $fhosc{$sec}{$cmt}){
     print STDERR "no commit $cB in $sec\n";
     return ("");
  }
  my $codeC = $fhosc{$sec}{$cmt};
  my $code = safeDecomp ($codeC);
  #print STDERR "$code\n" if $debug > 1;

  my ($tree, $parent, $auth, $cmtr, $ta, $tc) = ("","","","","","");
  my ($pre, @rest) = split(/\n\n/, $code, -1);
  for my $l (split(/\n/, $pre, -1)){
     ($auth) = ($1) if ($l =~ m/^author (.*)$/);
  }
  ($auth, $ta) = ($1, $2) if ($auth =~ m/^(.*)\s(-?[0-9]+\s+[\+\-]*\d+)$/);
  #print ";".$auth;
  return ($auth);
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

