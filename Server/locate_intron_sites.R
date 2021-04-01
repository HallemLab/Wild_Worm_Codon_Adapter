# Script to identify intron insertion sites

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
## which is the canonical choice established by Andy Fire's lab.
## This will determine up to 3 possible insertion sites, which will be filled 
## as needed, starting from the 5' site and 
## moving towards the 3' end of the gene
num_Ex <- 4 #num_Int + 1

opt_iS <- seq(from = floor(length_x/num_Ex), 
              to = length_x, 
              by = floor(length_x/num_Ex))
opt_iS <- opt_iS[1:num_Int]

if (input$mode_Int == "Equidist") {
    ## If spacing exons equidistantly, do that
    loc_iS <- opt_iS
} else {
    ## If using conserved exon splice sequences, find all the possible sites using the
    ## preferred consensus sequences
    
    insertSites <-c('AGG', 'AGA') ## These are consensus sequences for invertebrate 
    ## exon splice sites. 
    ## References: 
    ## * https://www.ncbi.nlm.nih.gov/books/NBK20075/
    ## * https://www.ncbi.nlm.nih.gov/pmc/articles/PMC306199/
    
    index_iS <- str_locate_all(x, insertSites) %>%
        do.call(rbind, .)
    index_iS <- index_iS[,1]
    
    ##  QUALITY CONTROL 1 
    ##  If there are fewer than 3 possible insertion sites,
    ##  insert as many introns as there are sites
    ##  
    if (is_empty(index_iS) || length(index_iS) < num_Int) {
        num_Int <- length(index_iS)
    }
    
    ## Generate nucleotide locations of splice sites 
    ## where an intron can be inserted
    
    if (!is_empty(index_iS)) {
        loc_iS <- sapply(opt_iS, function(x) {which.min(abs(index_iS-x[1]))}) %>%
            index_iS[.] %>%
            magrittr::add(.,2)
    } else {
        loc_iS <- NA
    }

}
## QUALITY CONTROL NOTE
## We'd like these sites to be roughly equidistant from each other. 
## Ideally, we might check to make sure the distance between these elements
## is close to optimal, or greater than a certain value. 
## 
## But rather than making assumptions,
## the user can choose to manually delete an artifical intron.



