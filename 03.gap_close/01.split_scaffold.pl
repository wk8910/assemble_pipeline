#! /usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $file = "wisent.fa";
my $out_dir = "scaffolds";

my $fa=Bio::SeqIO->new(-file=>$file,-format=>'fasta');

my %fh;

while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    $id=~/(scaffold\d+)\|size(\d+)/;
    my $name=$1;
    my $len=$2;
    my $dir=$name;
    
    $dir="rest" if($len<500000);

    `mkdir $out_dir/$dir` if(!-e "$out_dir/$dir");
    if(!exists $fh{$dir}){
	open($fh{$dir},"> $out_dir/$dir/$dir.fa");
    }

    $fh{$dir}->print(">$name\n$seq\n");
}

foreach my $name(keys %fh){
    close $fh{$name};
}
