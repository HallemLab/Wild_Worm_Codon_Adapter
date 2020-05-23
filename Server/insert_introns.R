# Insert artificial introns into identified splice sites
# Uses 3 canonical artificial introns from Fire lab

syntrons <- list(
    alpha = 'gtaagtttaaacatatatatactaactaaccctgattatttaaattttcag',
    beta = 'gtaagtttaaacagttcggtactaactaaccatacatatttaaattttcag',
    gamma = 'gtaagtttaaacatgattttactaactaactaatctgatttaaattttcag'
)

segmented_x <- substring(x, 
                         first = c(1,loc_iS), 
                         last = c(loc_iS - 1 , length_x)) %>%
    toupper


intronic_opt<-sapply(1:num_Int, function(x) {
    paste0(segmented_x[[x]], syntrons[[x]])}) %>%
    paste0(collapse = "") %>%
    paste0(segmented_x[[num_Ex]])


cds_wintrons <- splitseq(s2c(intronic_opt), frame = 0, word = 3) 

