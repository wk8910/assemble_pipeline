#! /usr/bin/env perl
use strict;
use warnings;

while(my $line1=<>){
    chomp $line1;
    my $line2 = <>;
    chomp $line2;
    my @arr1 = split(/\s+/, $line1);
    my @arr2 = split(/\s+/, $line2);
    next if( $arr1[2] eq "*" || $arr2[2] eq "*");
    next if( $arr1[2] eq $arr2[2] );
    my ($tig1,$start1,$end1, $tig2,$start2,$end2) = ($arr1[2], $arr1[3], ($arr1[3]+length($arr1[9])), $arr2[2],$arr2[3],($arr2[3]+length($arr2[9])));
    if ($arr1[1] & 16) {
        $end1 = $start1;
        $start1 = $start1 + length($arr1[9]);
    }
    if ($arr2[1] & 16) {
        $end2 = $start2;
        $start2 = $start2 + length($arr2[9]);
    }
    print "$tig1\t$start1\t$end1\t$tig2\t$start2\t$end2\n";
}
