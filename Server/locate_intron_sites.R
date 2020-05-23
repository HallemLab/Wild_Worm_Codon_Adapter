# Script to identify intron insertion sites

insertSites <- c('AAGG', 'AAGA', 'CAGG', 'CAGA') ## The important thing here is 
## the AGR (AGG or AGA), which is the consensus sequence for C. elegans 
## exon splice sites. These more stringent options are taken from 
## Redemann et al 2011.
strict_iS <- TRUE

x <- c2s(cds_opt)

## Identifying putative exon sites. 
## Crane et al 2019 reports that in *C. elegans*, a single 5' intron is
## sufficient for intron mediated enhancement on gene expression, whereas a
## single 3' intron is not. Therefore, these introns maybe shouldn't be placed
## equidistantly, in cases where the desired number of introns is less than
## the canonical 3.

num_Int <- as.numeric(input$num_Int) ## number of desired introns

length_x <- str_length(x)

## Divide the sequence into 4 evenly sized "exons" 
## This assumes a maximum number of introns as 3, 
## which is the canonical choice established by Andy Fire's lab at Stanford.
## This will determine 3 possible insertion sites, which will be filled 
## as needed, starting from the 5' site and 
## moving towards the 3' end of the gene
num_Ex <- 4 #num_Int + 1

opt_iS <- seq(from = floor(length_x/num_Ex), 
              to = length_x, 
              by = floor(length_x/num_Ex))
opt_iS <- opt_iS[1:num_Int]


## Find all the possible intron insertion sites
index_iS <- str_locate_all(x, insertSites) %>%
    do.call(rbind, .)
index_iS <- index_iS[,1]

##  QUALITY CONTROL 1 
##  If the more stringent splice sites are not present,
##  or if there are fewer than 3 possible insertion sites,
##  use the minimal consensus sequences
##  Reference (see Fig. 3): https://www.ncbi.nlm.nih.gov/books/NBK20075/
if (is_empty(index_iS) || length(index_iS) < num_Int) {
    insertSites_alt <-c('AGG', 'AGA')
    index_iS <- str_locate_all(x, insertSites_alt) %>%
        do.call(rbind, .)
    index_iS <- index_iS[,1]
    strict_iS <- FALSE
}

## Generate nucleotide locations of splice sites 
## where an intron can be inserted
loc_iS <- sapply(opt_iS, function(x) {which.min(abs(index_iS-x[1]))}) %>%
    index_iS[.] %>%
    {if (strict_iS) magrittr::add(.,3) else magrittr::add(.,2)}

## QUALITY CONTROL NOTE
## We'd like these sites to be roughly equidistant from each other. 
## Ideally, we might check to make sure the distance between these elements
## is close to optimal, or greater than a certain value. 
## 
## But rather than making assumptions,
## the user can choose to manually delete an artifical intron.

## QUALITY CONTROL 3
## If the number of unique insertion sites is less than 3
## rerun with the minimal consensus sequences 
## (if that hasn't already been done)
if (length(unique(loc_iS)) < num_Int && strict_iS) {
    insertSites_alt <-c('AGG', 'AGA')
    index_iS <- str_locate_all(x, insertSites_alt) %>%
        do.call(rbind, .)
    index_iS <- index_iS[,1]
    
    loc_iS <- sapply(opt_iS, function(x) {which.min(abs(index_iS-x[1]))}) %>%
        index_iS[.] %>%
        magrittr::add(2)
    
} 




