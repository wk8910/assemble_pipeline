### step1 ###
Run script "01.cut500.pl" to filter contig with a length less than 500bp.

### step2 ###
Config and run script "02.prepare.pl" to generate "libraries.txt" and "runSAM2TAB.sh".

### step3 ###
Run script "runSAM2TAB.sh". 
ps: It should be noted that this require bowtie2 in PATH. We had adopted version 2.2.2 here.
ps: The script "filter.pl" and "sam2tab.pl" should be found in the current directory and should be given executable permissions.

### step4 ###
Run script "03.sspace.sh". A directory named "standard_output" will be generated and the final result named "standard_output.final.scaffolds.fasta" will be found in this directory.
We have copied the log file "standard_output.summaryfile.txt" to this directory.
