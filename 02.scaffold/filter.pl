#! /usr/bin/env perl
use strict;
use warnings;

while(<>){
    next if(/^\@/);
    /^\S+\s+(\S+)/;
    my $flag=$1;
    next if($flag>=256);
    print "$_";
}
