## Script for translating a nucleotide sequence to amino acids 

## Translate clean nucleotides to AA
AA_dat <- translate(dat)

## Split original sequence into codons (for plotting)
cds_dat <- splitseq(dat, frame = 0, word = 3) 


