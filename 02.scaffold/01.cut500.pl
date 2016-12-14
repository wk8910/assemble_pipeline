#! /usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $file=shift;

my $fa=Bio::SeqIO->new(-file=>"wisent-contigs.fa",-format=>'fasta');

open O,"> pre.fa" or die "Cannot create pre.fa!\n";
while(my $seq=$fa->next_seq){
    my $id=$seq->id;
    my $seq=$seq->seq;
    my $len=length($seq);
    next if($len<500);
    print O ">$id\n$seq\n";
}
close O;
