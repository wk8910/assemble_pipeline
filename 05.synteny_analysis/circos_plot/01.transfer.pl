#! /usr/bin/env perl
use strict;
use warnings;

my $maf="wisent2nc.swap.maf";
my $percent=0.1;
my $length_of_scaffold_plotted=100000;

my %link;
my %cattle_len;
my %wisent_len;

my $total_len=0;
my $link_num=0;
open I,"< $maf";
my $control=0;
while(<I>){
    chomp;
    next if(/^#/);
    my @alignment;
    if(/^a/){
	push @alignment,"$_";
	while(<I>){
	    chomp;
	    if(/^\s*$/){
		last;
	    }
	    else{
		push @alignment,"$_";
	    }
	}
    }
    my ($wisent_chr,$wisent_start,$wisent_end,$wisent_strand,$wisent_chr_len,$cattle_chr,$cattle_start,$cattle_end,$cattle_strand,$cattle_chr_len)=&read_maf(@alignment);
    next if($wisent_chr_len < $length_of_scaffold_plotted);
    $total_len += $wisent_end-$wisent_start+1;
    $link_num++;

    $cattle_chr=~s/chr//;
    if($cattle_chr eq "X"){
	$cattle_chr = 30;
    }
    elsif($cattle_chr eq "Y"){
        $cattle_chr=31;
    }
    $cattle_len{$cattle_chr} = $cattle_chr_len;
    $wisent_len{$wisent_chr} = $wisent_chr_len;
    $link{$cattle_chr}{$cattle_start} = {cattle_end => $cattle_end, cattle_strand => $cattle_strand, wisent_chr => $wisent_chr, wisent_start => $wisent_start, wisent_end => $wisent_end, wisent_strand => $wisent_strand};
    # last if($control++>10);
}
close I;

my $filter_percent = $link_num*$percent/$total_len;

open L,"> link.txt";
my %wisent_position;
my %wisent2cattle_len;
my %align_len;
my $link=0;
foreach my $cattle_chr(sort {$a<=>$b} keys %link){
    foreach my $cattle_start(sort {$a<=>$b} keys %{$link{$cattle_chr}}){
    	my $cattle_end = $link{$cattle_chr}{$cattle_start}{cattle_end};
    	my $cattle_strand = $link{$cattle_chr}{$cattle_start}{cattle_strand};

    	my $wisent_chr = $link{$cattle_chr}{$cattle_start}{wisent_chr};
    	my $wisent_start = $link{$cattle_chr}{$cattle_start}{wisent_start};
    	my $wisent_end = $link{$cattle_chr}{$cattle_start}{wisent_end};
    	my $wisent_strand = $link{$cattle_chr}{$cattle_start}{wisent_strand};
	
    	my $wisent_chr_len = $wisent_len{$wisent_chr};

    	push @{$wisent_position{$wisent_chr}{$cattle_chr}{pos}},$cattle_start;
    	$wisent2cattle_len{$wisent_chr}{$cattle_chr}+=$wisent_end-$wisent_start+1;
	$align_len{$wisent_chr}+=$wisent_end-$wisent_start+1;

	my $x = rand(1)/($wisent_end-$wisent_start+1);
	if($x > $filter_percent){
	    next;
	}

	$link++;
    	my $num=10000000+$link;
    	my $color=&get_color($cattle_chr);
	
        print L "link${num}bundle $cattle_chr $cattle_start $cattle_end color=$color\n";
        print L "link${num}bundle $wisent_chr $wisent_start $wisent_end color=$color\n";
    }
}
close L;

open C,"> chromosome.txt";
foreach my $cattle_chr(sort {$a<=>$b} keys %link){
    my $chr_len=$cattle_len{$cattle_chr};
    print C "chr - $cattle_chr $cattle_chr 1 $chr_len white\n";
}

open O,"> debug.txt";
foreach my $wisent_chr(sort keys %align_len){
    my $len = $align_len{$wisent_chr};
    my $wisent_chr_len=$wisent_len{$wisent_chr};
    my $percent = $len/$wisent_chr_len;
    print O "$wisent_chr\t$wisent_chr_len\t$len\t$percent\n";
}
close O;

my %result;
foreach my $wisent_chr(sort keys %wisent2cattle_len){
    foreach my $cattle_chr(sort {$wisent2cattle_len{$wisent_chr}{$b} <=> $wisent2cattle_len{$wisent_chr}{$a}} keys %{$wisent2cattle_len{$wisent_chr}}){
        my $chr=$cattle_chr;
	my @wisent_position=sort {$a<=>$b} @{$wisent_position{$wisent_chr}{$cattle_chr}{pos}};
	my $len=@wisent_position;
	my $mid=int(($len/2)+0.5);
	if($mid >= $len-1){
	    $mid=$len-1;
	}
	elsif($mid < 0){
	    $mid = 0;
	}
	my $pos=$wisent_position[$mid];
	$result{$chr}{$wisent_chr}=$pos;
        last;
    }
}

foreach my $chr(sort {$b<=>$a} keys %result){
    foreach my $wisent_chr(sort {$result{$chr}{$b}<=>$result{$chr}{$a}} keys %{$result{$chr}}){
        my $pos=$result{$chr}{$wisent_chr};
        my $chr_len=$wisent_len{$wisent_chr};
        print C "chr - $wisent_chr $wisent_chr 1 $chr_len white\n";
    }
}

close C;

sub read_maf{
    my @alignment=@_;
    # print "\n\n**************************START**************************\n";
    # print join "\n",@alignment;
    # print "\n***************************END***************************\n\n";
    my @speciesA=split /\s+/,$alignment[1];
    my @speciesB=split /\s+/,$alignment[2];
    my $chrA=$speciesA[1];
    my $chrB=$speciesB[1];

    my($startA,$lenA,$strandA,$chr_lenA)=($speciesA[2],$speciesA[3],$speciesA[4],$speciesA[5]);
    my $endA;
    if($strandA eq "+"){
        $startA = $startA + 1;
        $endA = $startA + $lenA - 1;
    }
    else{
        $startA = $chr_lenA - $startA;
        $endA = $startA - $lenA + 1;

        my $temp = $startA;
        $startA = $endA;
        $endA = $temp;
    }

    my($startB,$lenB,$strandB,$chr_lenB)=($speciesB[2],$speciesB[3],$speciesB[4],$speciesB[5]);
    my $endB;
    if($strandB eq "+"){
        $startB = $startB + 1;
        $endB = $startB + $lenB - 1;
    }
    else{
        $startB = $chr_lenB - $startB;
        $endB = $startB - $lenB + 1;

        my $temp = $startB;
        $startB = $endB;
        $endB = $temp;
    }
    return($chrA,$startA,$endA,$strandA,$chr_lenA,$chrB,$startB,$endB,$strandB,$chr_lenB);
}

sub get_color{
    my $chr=shift;
    my $color="chr$chr";
    if($chr > 24){
        $chr=$chr-24;
        $color="chr$chr";
    }

    return($color);
}
