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

my $debug = 0;
$debug = $ARGV[0]+0 if defined $ARGV[0];
my $sections = 128;
my $parts = 2;

my $fbasec="All.sha1c/commit_";

my (%fhob, %fhost, %fhosc);
for my $sec (0 .. ($sections-1)){
  my $pre = "/fast1/";
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

while (<STDIN>){
  chop();
  my ($cmt, $pkg) = split(/;/, $_, -1);
  print $pkg.";";
  getCmt ($cmt);
}

sub getCmt {
  my ($cmt) = $_[0];
  my ($tree, $parents, $auth, $cmtr, $ta, $tc, @rest) = extrCmt ($cmt);
  my $msg = join '\n\n', @rest;
  $msg =~ s/\n/__NEWLINE__/g;
  if ($debug){
    $msg =~ s/__NEWLINE__$//;
    print "$msg;$cmt\n";
  }else{
    print "$cmt;$tree;$parents;$auth;$cmtr;$ta;$tc\n";
  }
}

sub extrCmt {
  my $cmt = $_[0];
  my $sec = hex (substr($cmt, 0, 2)) % $sections;
  my $cB = fromHex ($cmt);
  if (! defined $fhosc{$sec}{$cB}){
     print STDERR "no commit $cmt in $sec\n";
     return ("","","","","","","");
  }
  my $codeC = $fhosc{$sec}{$cB};
  my $code = safeDecomp ($codeC);
  print STDERR "$code\n" if $debug > 1;

  my ($tree, $parent, $auth, $cmtr, $ta, $tc) = ("","","","","","");
  my ($pre, @rest) = split(/\n\n/, $code, -1);
  for my $l (split(/\n/, $pre, -1)){
     #print "$l\n";
     $tree = $1 if ($l =~ m/^tree (.*)$/);
     $parent .= ":$1" if ($l =~ m/^parent (.*)$/);
     ($auth, $ta) = ($1, $2) if ($l =~ m/^author (.*)\s([0-9]+\s[\+\-]+\d+)$/);
     ($cmtr, $tc) = ($1, $2) if ($l =~ m/^committer (.*)\s([0-9]+\s[\+\-]+\d+)$/);

  }
  $parent =~ s/^:// if defined $parent;
  return ($tree, $parent, $auth, $cmtr, $ta, $tc, @rest);
}




for my $sec (0 .. ($sections-1)){
  untie %{$fhosc{$sec}};
}

