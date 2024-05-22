## Generate Usage Table Function
# Code that takes a .fasta file containing the CDS regions for an entire genome and produces a codon usage
# based on proteins that are at least 80 amino acids in length.
generate_usage_table <- function(filename){
    setProgress(0.2)
dat <- suppressMessages(readDNAStringSet(filename)) %>%
    cubar::check_cds(min_len = 240) %>% # only use CDS with length at least 80 amino acids
    count_codons() %>%
    est_rscu()
setProgress(0.7)
opt_codons <- dat[w_cai == 1] %>%
    dplyr::select(aa_code, codon) %>%
    dplyr::rename(AA = aa_code, Codon = codon) %>%
    dplyr::add_row(AA = "*", Codon = "TAA") %>%
    dplyr::arrange(AA)
setProgress(0.9)
opt_codons
}
