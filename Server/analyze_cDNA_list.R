# This script includes the the primary computation for analyzing a list of coding
# sequences for the Wild Worm Codon Adapter App in Analyze Sequences Mode
# This script is very similar to analyze_geneID_list.R, except since the user has 
# already provided coding sequences, the calls to BioMart are skipped. Code will analyse 
# GC content and CAI values for each gene using calls to `calc_sequence_stats.R`.

analyze_cDNA_list <- function(gene.seq, vals){
    withProgress(message = "Calculating...",expr = {
        setProgress(0)
    calc.inc <- 0.3/nrow(gene.seq)
    
    # Strongyloides CAI values ----
    Sr.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Sr_relAdap)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    ## Calculate info each sequence (S. ratti index)
    info.gene.seq<- Sr.temp %>%
        map("GC") %>%
        unlist() %>%
        as_tibble_col(column_name = 'GC')
    
    info.gene.seq<- Sr.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Sr_CAI') %>%
        add_column(info.gene.seq, .)
    
    info.gene.seq <- info.gene.seq %>%
        add_column(geneID = gene.seq$geneID, .before = 'GC') 
    
    
    # C. elegans CAI values ----
    setProgress(0.35)
    ## Calculate info each sequence (C. elegans index)
    Ce.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Ce_relAdapt)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    Ce.info.gene.seq<- Ce.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Ce_CAI')
    
    # B. malayi CAI values ----
    setProgress(0.7)
    ## Calculate info each sequence (B. malayi index)
    Bm.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Bm_relAdapt)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    Bm.info.gene.seq<- Bm.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Bm_CAI')

    # N. brasiliensis CAI values ----
    # 
    ## Calculate info each sequence ( N. brasiliensis index) 
    Nb.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Nb_relAdapt)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    Nb.info.gene.seq<- Nb.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Nb_CAI')
    
    # P. pacificus CAI values ----
    # 
    ## Calculate info each sequence ( P. pacificus index) 
    Pp.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Pp_relAdapt)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    Pp.info.gene.seq<- Pp.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Pp_CAI')
    
    # P. trichosuri CAI values ----
    # 
    ## Calculate info each sequence ( P. trichosuri index) 
    Pt.temp<- lapply(gene.seq$coding, function (x){
        incProgress(amount = calc.inc)
        if (!is.na(x)) {
            s2c(x) %>%
                calc_sequence_stats(.,w.tbl$Pt_relAdapt)}
        else {
            list(GC = NA, CAI = NA)
        }
    }) 
    
    Pt.info.gene.seq<- Pt.temp %>%
        map("CAI") %>%
        unlist() %>%
        as_tibble_col(column_name = 'Pt_CAI')
    
    ## Merge tibbles ----
    info.gene.seq <- add_column(info.gene.seq, 
                                Ce_CAI = Ce.info.gene.seq$Ce_CAI,
                                Bm_CAI = Bm.info.gene.seq$Bm_CAI,
                                Nb_CAI = Nb.info.gene.seq$Nb_CAI,
                                Pp_CAI = Pp.info.gene.seq$Pp_CAI,
                                Pt_CAI = Pt.info.gene.seq$Pt_CAI,
                                .after = "Sr_CAI")
    
    vals$geneIDs <- suppressMessages(info.gene.seq %>%
                                         left_join(.,gene.seq)%>%
                                         dplyr::rename(coding.sequence = coding)) 
    
    setProgress(1)
    info.gene.seq
    })
    
    
}