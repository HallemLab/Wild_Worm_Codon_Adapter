# Insert artificial introns into identified splice sites
# Uses 3 canonical artificial introns from Fire lab

syntrons <- list(
    alpha = 'gtaagtttaaacatatatatactaactaaccctgattatttaaattttcag',
    beta = 'gtaagtttaaacagttcggtactaactaaccatacatatttaaattttcag',
    gamma = 'gtaagtttaaacatgattttactaactaactaatctgatttaaattttcag'
)
## Remove any non-unique insert sites. Then remove potential insertion sites 
## where the distance from the preceeding site is less than or equal to 51 
## nucleotides (aka is shorter than the length
## of the syntrons being inserted).
loc_iS <- unique(loc_iS)
loc_iS[diff(loc_iS)>=51]


segmented_x <- substring(x, 
                         first = c(1,loc_iS), 
                         last = c(loc_iS - 1 , length_x)) %>%
    toupper

## If there aren't enough unique insertion sites for the desired 
## number of introns, use the maximum number of insertion sites
if (num_Int > length(loc_iS)) {num_Int <- length(loc_iS)}




intronic_opt<-sapply(1:num_Int, function(x) {
    paste0(segmented_x[[x]], syntrons[[x]])}) %>%
    paste0(collapse = "") %>%
    paste0(segmented_x[[length(segmented_x)]])


cds_wintrons <- splitseq(s2c(intronic_opt), frame = 0, word = 3) 

