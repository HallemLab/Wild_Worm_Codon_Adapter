# Script for codon optimizing an amino acid sequence

## Translate AA sequence back into nucleotide, using codon lookup table
cds_opt <- sapply(AA_dat, match, table = lut$AA) %>%
    lut$Codon[.]

opt <- c2s(cds_opt) %>%
    s2c(.)

## Caclulate info for optimized sequence
GC_opt <- GC(opt)
CAI_opt <- as.numeric(cai(opt, w = w))