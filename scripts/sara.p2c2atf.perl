#!/usr/bin/perl -I /home/audris/lib64/perl5
use strict;
use warnings;
use Error qw(:try);

use TokyoCabinet;
use Compress::LZF;

#convert 20 bytes  to 40
sub toHex { 
        return unpack "H*", $_[0]; 
} 

#convert 40 bytes  to 20
sub fromHex { 
        return pack "H*", $_[0]; 
} 


my $split = 1; #the number of splits that exist in the data base for that data
$split = $ARGV[1] + 0 if defined $ARGV[1];

my %p2c; # %is used for dictionary, $ is used for variable, @ is for list
#sec = the index od pieces
#the part of the database name before the number
for my $sec (0..($split-1)){
  my $fname = "$ARGV[0].$sec.tch";
  $fname = $ARGV[0] if ($split == 1);
  #tie means open
  tie %{$p2c{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,   
        16777213, -1, -1, TokyoCabinet::TDB::TLARGE, 100000
      or die "can not open $fname\n";
}

my $split2 = 1;
$split2 = $ARGV[3] + 0 if defined $ARGV[3];

my %c2f;
for my $sec (0..($split2-1)){
  my $fname = "$ARGV[2].$sec.tch";
  $fname = $ARGV[2] if ($split2 == 1);
  tie %{$c2f{$sec}}, "TokyoCabinet::HDB", "$fname", TokyoCabinet::HDB::OREADER,
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
  chop(); #strip in python = removes space and newline
  my $p = $_;
  my $sec = (unpack "C", substr ($p, 0, 1))%$split;
  #print "$sec;$p\n";
  #defined = is it is in dic or not
  if (defined  $p2c{$sec}{$p}){
    #print "$p";
    list ($p, $p2c{$sec}{$p});
  }else{
    if (defined $p2c{$sec}{"$p\n"}){
     # print "$p";
      list ($p, $p2c{$sec}{"$p\n"});
    }
  }
}
for my $sec (0..($split-1)){
  untie %{$p2c{$sec}};
}
for my $sec (0..($split2-1)){
  untie %{$c2f{$sec}};
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
    my ($auth, $ta) = extrAuth($c);
    #extract file from $c
    my $files = extrfiles($c);
    if ($auth ne "" && $files ne ""){
      my @filelist = split(/;/,$files);
      foreach my $file (@filelist){ 
         if (defined $auths{$auth}{$file}){
             my $start = $auths{$auth}{$file}[0];
             my $end = $auths{$auth}{$file}[1];
             $start = $ta if $ta < $start;
             $end = $ta if $ta > $end;
             $auths{$auth}{$file} = [$start,$end];
         }
         else{
             $auths{$auth}{$file} = [$ta,$ta];
         }
      }
    }
  }
  while (my ($key,$values) = each(%auths)){
    while (my ($eafile, $eatl) = each(%{$values})){
      my $ts = join(",",@{$eatl});
      print "$key;$eafile;$ts\n";
    }
  }
  #my $output = join ";", keys %auths;
  #print ";$output\n";
  #%auths = ();
}


sub extrfiles {
  my $cmt = $_[0];
  my $sec = (unpack "C", substr ($cmt, 0, 1))%$split2;
  if (defined $c2f{$sec}{$cmt}) {
     my $v = $c2f{$sec}{$cmt};
     my $v1 = safeDecomp ($v);
     return $v1;
  }
  else{
     return "";
  }
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
  my @ta_zone = split(/\s+/,$ta);
  $ta = shift @ta_zone;
  #shift pops out the most left in the list
  return ($auth, $ta);
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

