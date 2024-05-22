# Insert artificial introns into identified splice sites
# sequences used for introns are either canonical Fire lab sequences,
# PATC-rich introns, P. pacificus native introns sequences, or
# custom intron sequences as specified by the user.

## Remove any non-unique insert sites. 
loc_iS <- unique(loc_iS)

## Could remove potential insertion sites 
## where the distance from the preceeding site is less than or equal to 51 
## nucleotides (aka is shorter than the length
## of the syntrons being inserted). 
## Or any other arbitrary length, really. Hunt et al 2016 reports the median
## exon length for Strongyloides spp (stercoralis = 265 bp, ratti = 263 bp)
## For now, not going to include the following line of code.
#loc_iS[diff(loc_iS)>=51]
## On the other hand, there is recent evidence that in C. elegans, 
## intron-mediated expression enhancement requires a first exon that is 
## <350 bp and preferably shorter than 150 bp.
## (https://www.nature.com/articles/s41467-020-19898-0)
## For now, let's stick with equidistant

segmented_x <- substring(x, 
                         first = c(1,loc_iS), 
                         last = c(loc_iS - 1 , length_x)) %>%
    toupper

## If there aren't enough unique introns for the desired 
## number of introns (i.e. for custom intron lists),
## use the maximum number of available introns
if (num_Int > length(syntrons)) {num_Int <- length(syntrons)}

## If there aren't enough unique insertion sites for the desired 
## number of introns, use the maximum number of available insertion sites
if (num_Int > length(loc_iS)) {num_Int <- length(loc_iS)}


intronic_opt<-sapply(1:num_Int, function(x) {
    paste0(segmented_x[[x]], syntrons[[x]])}) %>%
    paste0(collapse = "") %>%
    paste0(segmented_x[[length(segmented_x)]])

## Check to see if sequence is a multiple of 3, and if not, add space padding
## so that splitseq won't cut off nucleotides
if (nchar(intronic_opt)/3 != round(nchar(intronic_opt)/3)){
    paddingnum <- (ceiling(nchar(intronic_opt)/3)*3)-nchar(intronic_opt)
    pad <- rep_len(" ", paddingnum) %>% paste0(collapse = "")
    intronic_opt <- paste0(intronic_opt, pad)
}
cds_wintrons <- splitseq(s2c(intronic_opt), frame = 0, word = 3) 

