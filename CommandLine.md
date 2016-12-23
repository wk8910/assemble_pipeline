# Part1 Assembly
### SOAPec
#### Version: 2.02
#### Command Line
```
KmerFreq_HA -k 23 -t 64 -p Wisent -l read.lst -L 100
Corrector_HA -k 23 -l 3 -r 50 -t 10 Wisent.freq.gz read.lst
```
### ABySS
#### Version: 1.5.1
#### Command Line
```
abyss-pe -C <out dir> j=64 np=64 k=75 name=wisent lib='pe1 pe2 ...' \
pe1='lib1.1.fq.gz lib1.2.fq.gz' pe2='lib2.2.fq.gz lib2.2.fq.gz' ... # more libs were omitted in this line
```
### SSPACE
#### Version: 3.0_linux-x86_64
#### Command Line
```
SSPACE_Standard_v3.0.pl -l libraries.txt -s contig.fa -T 32
```
# Part2 Assessment
### BUSCO
#### Version: 1.22
#### Command Line
```
BUSCO_v1.22.py -c 32 -o <out dir> -in wisent.pep -l vertebrata -m OGS
BUSCO_v1.22.py -c 32 -o <out dir> -sp human -in wisent.fa -l vertebrata -m genome --long
```
### CEGMA
#### Version: 2.5
#### Command Line
```
cegma -T 30 -g wisent.fa -o <output prefix>
```
### FRCurve
#### Version: 1.3.0
#### Command Line
```
FRC --genome-size 2980000000 --pe-sam il230.bam --mp-sam il20000.bam --pe-max-insert 230 --mp-max-insert 25000 --out frc_curve
```
# Part3 SNPs and InDels
### BWA
#### Version: 0.7.12
#### Command Line
```
bwa mem -t 12 -R '@RG ID:<sample id>  SM:<sample id>  LB:<sample id>' wisent.fa lib1.1.fq.gz lib1.2.fq.gz | samtools sort -O bam -T ./ -l 3 -o <sample id>.bam -
samtools rmdup <sample id>.bam <sample id>.rmdup.bam
```
### GATK
#### Version: 3.3
#### Command Line
```
java -Xmx10g -jar GenomeAnalysisTK.jar -R wisent.fa -T RealignerTargetCreator -o <sample id>.intervals -I <sample id>.rmdup.bam
java -Xmx10g -jar GenomeAnalysisTK.jar -R wisent.fa -T IndelRealigner -targetIntervals <sample id>.intervals -o <sample id>.realn.bam -I <sample id>.rmdup.bam
java -Xmx10g -jar GenomeAnalysisTK.jar -nct 12 -R wisent.fa -T HaplotypeCaller -I <sample id>.realn.bam -out_mode EMIT_VARIANTS_ONLY -o <sample id>.vcf
```
# Part4 Annotation
### RepeatMasker
#### Version: 1.323
#### Command Line
```
RepeatMasker -nolow -no_is -norna -parallel 1 -species mammal -gff wisent.fa
```
### RepeatProteinMask
#### Version: 1.36
#### Command Line
```
RepeatProteinMask -engine ncbi -noLowSimple -pvalue 0.0001 wisent.fa
```
### TRF
#### Version: 407b
#### Command Line
```
trf wisent.fa 2 7 7 80 10 50 2000 -d -h
```
### LTR_FINDER
#### Version: 1.0.6
#### Command Line
```
ltr_finder wisent.fa
```
### PILER
#### Version: 1.0
#### Command Line
```
pals -self wisent.fa -out wisent.fa.pals.gff 
piler2 -trs wisent.fa.pals.gff -out wisent.fa.trs.gff
piler2 -trs2fasta wisent.fa.trs.gff -seq wisent.fa -path family -prefix wisent
for i in family/* ; do muscle -in $i -out $i.aligned.fasta -maxiters 1 -diags1 ; done 
for I in family/*aligned.fasta ; do piler2 -cons $i -out $i.cons -label $i ; done 
cat family/*cons > wisent_library.fasta
RepeatMasker -lib wisent_library.fasta -pa 30 wisent.fa
```
### RepeatScout
#### Version: 1.05
#### Command Line
```
BuildDatabase -name wisent wisent.fa
RepeatModeler -pa 30 -database wisent
RepeatMasker -lib RM*/consensi.fa.classified -pa 30 wisent.fa
```
### BLAST
#### Version: 2.26
#### Command Line
```
blastall -p tblastn -d <db> -i <query> -e 1E-5 -o protein2query.out -a 12
```
### BLAST2GENE
#### Version: 17
#### Command Line
```
blast.parse.pl protein2query.out > protein2query.bp
blast2gene.pl protein2query.bp > protein2query.bl2g
```
### GeneWise
#### Version: 2.41
#### Command Line
```
genewise -u <start> -v <end> -<trev|tfor> -gff query.fa <chr name>.fa > genewise.gff
```
### Augustus
#### Version: 2.5.5
#### Command Line
```
augustus --species=human <chr name>.fa > <chr name>.gff
```
### GenScan
#### Version: Not available
#### Command Line
```
genscan HumanIso.smat <chr name>.fa > <chr name>.out
```
### EVM
#### Version: 1.1.1
#### Command Line
```
evidence_modeler.pl --genome <chr name>.fa --weights weights.txt --gene_predictions ab_initio.gff --protein_alignments homolog.gff > evm.out; EVM_to_GFF3.pl evm.out <chr name> > evm.out.gff
```
# Part5 Synteny
### last
#### Version: 761
#### Command Line
```
lastdb -uNEAR -cR11 ref_db ref.fa
lastal -P48 -m100 -E0.05 ref_db wisent.fa | last-split > query2db.maf
maf-swap query2db.maf | last-split > cattle.wisent.sing.maf # same parameters were applied for the other species
```
### multiz
#### Version: 012109
#### Command Line
```
roast -T=. E=cattle ((((bison wisent) yak) (cattle indicus)) buffalo) cattle.bison.sing.maf cattle.wisent.sing.maf cattle.yak.sing.maf cattle.indicus.sing.maf cattle.buffalo.sing.maf cattle.maf | sh
```
# Part6 Evolution analysis
### ExaML
#### Version: 8.1.17
#### Command Line
```
clustalw2 -INFILE=align.part.fa -CONVERT -OUTFILE=alian.part.phy -OUTPUT=PHYLIP
raxmlHPC -s alian.part.phy -n start.tree -m GTRGAMMA -p 31415
clustalw2 -INFILE=align.fa -CONVERT -OUTFILE=align.phy -OUTPUT=PHYLIP
parse-examl -s align.phy -n align.bin -m DNA
examl-AVX -s alignment.bin.binary -n output.phb -m GAMMA -t start.tree
raxmlHPC -# 100 -b 12345 -f j -m GTRCAT -s align.phy -n REPS # the generated alignments were applied for bootstrap
```
### orthoMCL
#### Version: 2.0.9
#### Command Line
```
orthomclInstallSchema orthomcl.config.template
orthomclAdjustFasta compliantFasta/cat cattle.pep 1
orthomclAdjustFasta compliantFasta/dog dog.pep 1
orthomclAdjustFasta compliantFasta/hor horse.pep 1
orthomclAdjustFasta compliantFasta/hum human.pep 1
orthomclAdjustFasta compliantFasta/she sheep.pep 1
orthomclAdjustFasta compliantFasta/wis wisent.pep 1
orthomclAdjustFasta compliantFasta/yak yak.pep 1
orthomclFilterFasta compliantFasta/ 10 20
makeblastdb -in goodProteins.fasta -dbtype prot
blastp -db goodProteins.fasta -query goodProteins.fasta -out all-all.blastp.out -evalue 1e-5 -outfmt 6 -num_threads 24
orthomclBlastParser all-all.blastp.out compliantFasta > similarSequences.txt
perl -p -i -e 's/0\t0/1\t-181/' similarSequences.txt
orthomclLoadBlast orthomcl.config.template similarSequences.txt
orthomclPairs orthomcl.config.template orthomcl_pairs.log cleanup=no
orthomclDumpPairsFiles orthomcl.config.template
mcl mclInput --abc -I 1.5 -o mclOutput
orthomclMclToGroups cluster 1 < mclOutput > groups.txt
```
### PAML
#### Version: 4.8
#### Command Line
```
codeml codeml.ctl
```
We used the Codeml program from the PAML package with a branch-site model (runmode = -2, model = 2, NSsites = 2) to detect positively selected genes in focal lineages. A likelihood ratio test was constructed to compare a model that allows sites to be under positive selection on the foreground branch with the null model in which sites may evolve neutrally and under purifying selection. The p-values were computed based on the Chi-square statistic adjusted by the FDR method and genes with adjusted p-value < 0.05 were treated as candidates for positive selection.
