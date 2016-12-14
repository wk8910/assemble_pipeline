#! /usr/bin/env perl
use strict;
use warnings;

my @fq1=<clean_reads/*.1.fq.gz>;

open O,"> $0.sh";
foreach my $fq1(@fq1){
    my $fq2=$fq1;
    $fq2=~s/1.fq.gz/2.fq.gz/;
    $fq1=~/\/(.*)\.1\.fq\.gz/;
    my $lib=$1;
    $lib=~/(\d+)bp/;
    my $insert=$1;
    print O "bowtie2 -p 32 --very-sensitive --no-sq -x wisent.fa -1 $fq1 -2 $fq2 | perl get_reads.pl $insert $lib\n";
}
close O;
