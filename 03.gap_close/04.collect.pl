#! /usr/bin/env perl
use strict;
use warnings;
use Bio::SeqIO;

my @GC=<scaffolds/*/*.GC>;

open(O,"> wisent.gc.fa");
foreach my $file(@GC){
    my $fa=Bio::SeqIO->new(-file=>$file,-format=>'fasta');

    while(my $seq=$fa->next_seq){
        my $id=$seq->id;
        my $seq=$seq->seq;
        my $len=length($seq);
        print O ">$id\tsize:$len\n$seq\n";
    }
}
close O;
