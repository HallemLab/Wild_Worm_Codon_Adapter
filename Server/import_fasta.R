# Read and clean sequence imported from a .fasta file

# Import .fasta file
dat <- read.fasta('AFDrGC(35).fasta', 
                  seqtype = 'DNA') 

name <- getName(dat)

## Generate clean sequence, trimming any leading/trailing spaces
clean_dat <- c2s(dat[[1]]) %>%
    trimSpace(.) %>%
    s2c(.) 