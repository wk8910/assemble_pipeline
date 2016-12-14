#! /usr/bin/env perl
use strict;
use warnings;

my @fa=<scaffolds/scaffold*/*.fa>;

foreach my $fa(@fa){
    $fa=~/^(.*)\/(\w+\.fa)/;
    my $dir=$1;
    $fa=$2;
    print "cd $dir ; cp /path/to/0.soap.prepare.pl . ; perl 0.soap.prepare.pl ;  GapCloser -a $fa -b soap.config -o $fa.GC -p 31 -t 32 ; cd - \n";
}
