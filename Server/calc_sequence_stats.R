## Calculate  information and statistics for DNA sequence
## sequence is a vector of chars (representing a series of nucleotides).
## Use the utility seqinr::s2c to parse a single string (e.g. "Chickens!")
## into the necessary form (c("C", "h", "i", "c", "k", "e", "n", "s", "!"))

calc_sequence_stats <- function(sequence, w){
    
    results <- list(
        
        ## Calculate GC content
        GC = GC(sequence),
        
        ## Calculate codon adaptation index 
        ## relative to a given optimal codon index
        CAI = as.numeric(cai(sequence, w = w))
    )

}