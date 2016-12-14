#! /usr/bin/env perl
use strict;
use warnings;

`mkdir tab` if(!-e "tab");

my @fq1=</home/share/user/user101/projects/Wisent2014/1.assembly/06.finalAssemble/clean_reads//*1.fq.gz>;

my %hash;
foreach my $fq1(@fq1){
    my $fq2=$fq1;
    $fq2=~s/1.fq.gz/2.fq.gz/g;
    $fq1=~/(\d+)bp/;
    my $insert=$1;
    #next if($insert<2000 && $fq1!~/pair_1.fq.gz/);
    $hash{$insert}{$fq1}=$fq2;
}

my $num=1;
open(L,"> libraries.txt");
open(R,"> runSAM2TAB.sh");
my $file_no=0;
foreach my $insert(sort {$a<=>$b} keys %hash){
    $num++ if($insert>=2000);
    #next if($insert<10000);
    my $lib="lib".$num;
    my $var=0.25;
    my $ori="FR";
    if($insert>=2000){
        $var=0.5;
        $ori="RF";
    }
    foreach my $fq1(sort keys %{$hash{$insert}}){
        $file_no++;
        my $fq2=$hash{$insert}{$fq1};
        #print L "$lib\tbowtie\t$fq1\t$fq2\t$insert\t$var\t$ori\n";
        print L "$lib\tTAB\ttab/file.$file_no.tab\t$insert\t$var\t$ori\n";
        #print R "bwa mem -t 32 pre.fa $fq1 $fq2 | ./filter.pl | ./sam2tab.pl > tab/file.$file_no.tab\n";
        print R "bowtie2 -x pre.fa -1 $fq1 -2 $fq2 --very-sensitive -p 32 | ./filter.pl | ./sam2tab.pl > tab/file.$file_no.tab\n";
    }
}
close L;
close R;
