use strict;
use warnings;

my @lib=</home/share/user/user101/projects/Wisent2014/1.assembly/06.finalAssemble/clean_reads/*1.fq.gz>;

my %pe;
my %mp;
my $num=0;
my $line0="export PATH=\$PATH:/home/share/user/user101/software/abyss/abyss-1.5.1-build/bin\nnohup abyss-pe -C contig j=64 np=64 k=75 name=wisent ";
my @line1;
my @line2;
my $line3;
foreach my $fq1(@lib){
    $num++;
    my $name="";
    my $fq2=$fq1;
    $fq2=~s/1.fq.gz/2.fq.gz/g;
    $fq1=~/reads\/lib\.(\d+)bp/;
    my $insert=$1;
    if(!$insert){
        print "$fq1\t$fq2\n";
    }
    next if($insert>=2000);
    if($insert>=2000){
        $name="mp"."$num";
        $mp{$name}="$fq1 $fq2";
        push @line2,$name;
        $line3.=$name."='$fq1 $fq2 ' ";
    }
    else{
        $name="pe"."$num";
        $pe{$name}="$fq1 $fq2";
        push @line1,$name;
        $line3.=$name."='$fq1 $fq2 ' ";
    }
}

my $line1="lib='".join " ",@line1,"'";
open O,"> $0.sh";
print O "$line0 $line1 $line3 2>&1 | tee abyss.err &\n";
close O;
