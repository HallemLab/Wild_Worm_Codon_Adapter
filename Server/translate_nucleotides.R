## Script for translating a nucleotide sequence to amino acids 

## Translate clean nucleotides to AA
AA_dat <- translate(clean_dat)

## Split original sequence into codons (for plotting)
cds_dat <- splitseq(clean_dat, frame = 0, word = 3)

