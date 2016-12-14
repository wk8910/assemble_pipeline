export PATH=$PATH:/home/share/user/user101/software/soapdenovo/SOAPec_src_v2.02/bin/
KmerFreq_HA -k 23 -t 64 -p Wisent -l read.lst -L 100 >kmerfreq.log 2>kmerfreq.err
Corrector_HA -k 23 -l 3 -r 50 -t 10 Wisent.freq.gz read.lst >corr.log 2>corr.err
