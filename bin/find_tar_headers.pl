#!/usr/bin/perl -w
use strict;

# 99.9% of all credits for this script go 
# to Tore Skjellnes <torsk@elkraft.ntnu.no>
# who is the originator.

my $tarfile;
my $c;
my $hit;
my $header;

# if you don't get any results, outcomment the line below and
# decomment the line below the it and retry
my @src = (ord('u'),ord('s'),ord('t'),ord('a'),ord('r'),ord(" "), ord(" "),0);
#my @src = (ord('u'),ord('s'),ord('t'),ord('a'),ord('r'),0,ord('0'),ord('0'));

die "No tar file given on command line" if $#ARGV != 0;

$tarfile = $ARGV[0];

open(IN,$tarfile) or die "Could not open `$tarfile': $!";

$hit = 0;
 $| = 1;
seek(IN,257,0) or die "Could not seek forward 257 characters in `$tarfile': $!";
while (read(IN,$c,1) == 1)
{
    ($hit = 0, next) unless (ord($c) == $src[$hit]);
    $hit = $hit + 1;
    ( print "hit: $hit", next ) unless $hit > $#src;

    
    # we have a probable header at (pos - 265)!
    my $pos = tell(IN) - 265;
    seek(IN,$pos,0)
	or (warn "Could not seek to position $pos in `$tarfile': $!", next);

    (read(IN,$header,512) == 512)
	or (warn "Could not read 512 byte header at position $pos in `$tarfile': $!", seek(IN,$pos+265,0),next);

    my ($name, $mode, $uid, $gid, $size, $mtime, $chksum, $typeflag,
	$linkname, $magic, $version, $uname, $gname,
	$devmajor, $devminor, $prefix)
	= unpack ("Z100a8a8a8Z12a12a8a1a100a6a2a32a32a8a8Z155", $header);
    $size = int $size;
    printf("%s:%s:%s:%s\n",$tarfile,($pos+1),$name,$size);

    $hit = 0;
}

close(IN) or warn "Error closing `$tarfile': $!";
