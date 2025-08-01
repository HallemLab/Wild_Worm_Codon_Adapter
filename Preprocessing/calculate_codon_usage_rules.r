## Generate Usage Table Function
# Code that takes a .fasta file containing the CDS regions for an entire genome and saves a codon usage
# table and optimal codon list based on proteins that are at least 80 amino acids in length.

library(tidyverse)
library(magrittr)
library(biomaRt)
library(Biostrings)
library(cubar)

## Step 1: Import transcript sequences
FastaFile<- "/Users/astra/Downloads/rhabditophanes_kr3021.PRJEB1297.WBPS19.CDS_transcripts.fa"
SpeciesAbbreviation <-'RSKR'
sequences <- readDNAStringSet(FastaFile) %>% 
    cubar::check_cds(min_len = 240)

perc.codon.usage.tbl<-sequences %>%
count_codons() %>%
    est_rscu(level = "amino_acid") %>%
     dplyr::mutate(perc = prop * 100) %>%
     dplyr::select(-prop) %>%
     dplyr::relocate(w_cai, .after = dplyr::last_col()) %>%
    dplyr::add_row(aa_code = "*", codon = "TAA", perc = 100, w_cai = 1) %>%
    dplyr::add_row(aa_code = "*", codon = "TAG", perc = 0,   w_cai = 0) %>%
    dplyr::add_row(aa_code = "*", codon = "TGA", perc = 0,   w_cai = 0) %>%
    dplyr::arrange(aa_code, codon)

write_csv(perc.codon.usage.tbl,
          file = paste0("./", SpeciesAbbreviation, "_usage_counts.csv"))

opt_codons <- perc.codon.usage.tbl[w_cai == 1] %>%
    dplyr::select(aa_code, codon) %>%
    dplyr::rename(AA = aa_code, Codon = codon) %>%
    dplyr::mutate(Codon = tolower(Codon)) %>% 
    dplyr::arrange(AA)

write_csv(opt_codons,
          file = paste0("./", SpeciesAbbreviation, "_opt_codons.csv"))
