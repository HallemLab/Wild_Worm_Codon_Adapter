# Script for codon optimizing an amino acid sequence

## Translate AA sequence back into nucleotide, using codon lookup table
cds_opt <- sapply(AA_dat, match, table = lut$AA) %>%
    lut$Codon[.] %>%
    toupper

opt <- c2s(cds_opt) %>%
    s2c(.)

# ## Save variables for export
# vals$seq_opt <- c2s(opt)
# vals$cds_opt <- toupper(cds_opt)
