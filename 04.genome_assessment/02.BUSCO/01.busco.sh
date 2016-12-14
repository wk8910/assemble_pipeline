export PATH=$PATH:/home/share/software/blast/ncbi-blast-2.2.28+/bin
export PATH=$PATH:/home/share/user/user101/software/HMMER/hmmer-3.1b2-linux-intel-x86_64-build/bin
export PATH=$PATH:/home/share/user/user101/software/augustus/augustus-3.0.3/bin
export AUGUSTUS_CONFIG_PATH=/home/share/user/user101/software/augustus/augustus-3.0.3/config
export PATH=/home/share/user/user101/software/python3/ActivePython-3.4.3.2-linux-x86_64-build/bin:$PATH
python3 /home/share/user/user101/software/busco/BUSCO_v1.22/BUSCO_v1.22.py -c 32 -o wisent_genome_pep -in wisent.pep -l /home/share/user/user101/software/busco/vertebrata -m OGS
python3 /home/share/user/user101/software/busco/BUSCO_v1.22/BUSCO_v1.22.py -c 32 -o wisent_genome_long_SPhuman -sp human -in wisent.fa -l /home/share/user/user101/software/busco/vertebrata -m genome --long 2>&1 | tee run.sh.sp_human.log
