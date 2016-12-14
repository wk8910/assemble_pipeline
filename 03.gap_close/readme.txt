We applied Gapcloser (version 1.12) from SOAPdenovo package to fill the gap in the scaffolds. In order to make this more efficiently, we split the reads into each scaffold and perform the Gapclose seperatedly.
### step1 ###
Run script "01.split_scaffold.pl" to split the scaffold file.
ps: the scaffold which has a length less than 500kb were combined in the rest file.

### step2 ###
Run script "02.runbowtie.pl" to generate a new script to split reads.
ps: note that the script "get_reads.pl" is very important for this step. Users have to configure it appropriately.
ps: the file "head.txt" is the dict file of genome, which could be generated with "samtools dict wisent.fa > head.txt".

### step3 ###
Runs script "03.gapcloser.pl" to generate a new script to execute the Gapcloser.
ps: the path of each program must be configured appropriately.
