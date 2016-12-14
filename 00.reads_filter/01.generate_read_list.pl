#! /usr/bin/env perl
use strict;
use warnings;

open O,"> read.lst";
my @fq1=<SeqV2/*/*1.fq.gz>;
foreach my $fq1(@fq1){
    my $fq2=$fq1;
    $fq2=~s/1.fq.gz/2.fq.gz/;
    $fq1=~/(\d+)bp/;
    next if($1>=2000);
    print O "$fq1\n$fq2\n";
}
close O;
