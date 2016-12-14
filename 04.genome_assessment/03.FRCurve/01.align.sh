# version of samtools: 1.3.1-34-g26e1ea5-dirty
# Using htslib 1.3.1-42-gb6aa0e6
/home/share/user/user101/software/bwa/bwa-0.7.8/bwa mem -t 32 umd31.fa il20000.1.fq.gz il20000.2.fq.gz | /home/share/user/user101/bin/samtools sort -O bam -T ./ -o il20000.bam
/home/share/user/user101/software/bwa/bwa-0.7.8/bwa mem -t 32 umd31.fa il230.1.fq.gz il230.2.fq.gz | /home/share/user/user101/bin/samtools sort -O bam -T ./ -o il230.bam -
