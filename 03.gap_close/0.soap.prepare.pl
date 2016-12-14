#! /usr/bin/env perl
use strict;
use warnings;

my @fq1=<*.1.fq.gz>;

open(O,"> soap.config");
print O "#maximal read length\nmax_rd_len=100\n";
foreach my $fq1(@fq1){
    my $fq2=$fq1;
    $fq2=~s/1.fq.gz/2.fq.gz/;
    $fq1=~/(\d+)bp/;
    my $insert=$1;
    #next if($insert<2000);
    my $r=0;
    my $asm_flags=3;
    my $rank=1;
    my $cut_off=3;
    my $map_len=65;
    if($insert>=2000){
        $r=1;
        $asm_flags=3;
        $cut_off=5;
        $map_len=32;
        if($insert==2000){
            $rank=2;
        }
        elsif($insert==5000){
            $rank=3;
        }
        elsif($insert==10000){
            $rank=4;
        }
        elsif($insert=20000){
            $rank=5;
        }
    }
    print O "[LIB]
avg_ins=$insert
reverse_seq=$r
asm_flags=$asm_flags
rank=$rank
pair_num_cutoff=$cut_off
map_len=$map_len
";
    if($insert>=2000){
        print O "q1=$fq1
q2=$fq2
";
    }
    else{
        print O "q1=$fq1
q2=$fq2
";
    }
}
close O;
