#! /usr/bin/env perl
use strict;
use warnings;
use FileHandle;

my $outdir="scaffolds";

`mkdir $outdir` if(!-e "$outdir");

my $insert=shift;
my $id=shift;

die "Usage: $0 <insert size> <id>\n" if(!$insert || !$id);

# my $cigar="100M";
# if($insert>=2000){
#     $cigar="49M";
# }

print "$insert\t$id\n";

my %fh;
open(I,"< head.txt");
while (<I>) {
    next unless(/SN:(\S+)\s+LN:(\d+)/);
    my ($chr,$len)=($1,$2);
    $chr=~/(scaffold\d+)/;
    $chr=$1;
    if($len<500000){
        $chr="rest";
    }
    my $name=$chr;
    `mkdir $outdir/$name` if(!-e "$outdir/$name");
    if(exists $fh{$name}{fq1} && $fh{$name}{fq2}){
        next;
    }
    open($fh{$name}{fq1},"| gzip -> $outdir/$name/$id.1.fq.gz");
    open($fh{$name}{fq2},"| gzip -> $outdir/$name/$id.2.fq.gz");
}
close I;

my $num=0;
print  "start\n";
while (<>) {
    next if(/^\@/);
    my $line1=$_;
    my $line2=<>;
    chomp $line1;
    chomp $line2;
    my @a=split(/\s+/,$line1);
    my @b=split(/\s+/,$line2);
    my $flag_left=$a[5];
    my $flag_right=$b[5];
    if($flag_left eq $flag_right){
        next if($flag_left =~/^\d+M$/ || $flag_left eq "*");
    }
    my ($name1,$name2)=("NA","NA");
    if(!($a[1] & 4)){
        my $name_pre=$a[2];
        $name_pre=~/(scaffold\d+)\|size(\d+)/;
        $name_pre=$1;
        my $len=$2;
        $name_pre="rest" if($len<500000);
        $name1=$name_pre;
    }
    if(!($b[1] & 4)){
        my $name_pre=$b[2];
        $name_pre=~/(scaffold\d+)\|size(\d+)/;
        $name_pre=$1;
        my $len=$2;
        $name_pre="rest" if($len<500000);
        $name2=$name_pre;        
    }
    $num++;
    print STDERR "Proceeding...$num...\r";

    if($insert>=2000){
        $a[9]=~tr/ATCGatcg/TAGCtagc/;
        $a[9]=reverse($a[9]);
        $a[10]=reverse($a[10]);
    }
    else{
        $b[9]=~tr/ATCGatcg/TAGCtagc/;
        $b[9]=reverse($b[9]);
        $b[10]=reverse($b[10]);
    }
    if($name1 eq $name2){
        $fh{$name1}{fq1}->print("@"."$a[0]/1\n$a[9]\n+\n$a[10]\n");
        $fh{$name1}{fq2}->print("@"."$b[0]/2\n$b[9]\n+\n$b[10]\n");
    }
    else{
        if($name1 ne "NA"){
            $fh{$name1}{fq1}->print("@"."$a[0]/1\n$a[9]\n+\n$a[10]\n");
            $fh{$name1}{fq2}->print("@"."$b[0]/2\n$b[9]\n+\n$b[10]\n");
        }
        if($name2 ne "NA"){
            $fh{$name2}{fq1}->print("@"."$a[0]/1\n$a[9]\n+\n$a[10]\n");
            $fh{$name2}{fq2}->print("@"."$b[0]/2\n$b[9]\n+\n$b[10]\n");
        }
    }
}
foreach my $name(keys %fh){
    close $fh{$name}{fq1};
    close $fh{$name}{fq2};
}
