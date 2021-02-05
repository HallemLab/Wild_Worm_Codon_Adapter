# This script includes the the primary computation for analyzing a list of geneIDs
# for the Strongyloides Codon Adapter App in Analyze Sequences Mode
# If user has provided a list of geneIDs/transcriptIDs, pull cDNA sequence from BioMart and analyse 
# GC content and CAI values for each gene using calls to `calc_sequence_stats.R`.
# 

analyze_geneID_list <- function(genelist, vals){
    # Get cDNA sequences for given geneIDs from BioMaRT----
    Sspp.seq <- NULL
    Sr.seq <- NULL
    Ce.seq <- NULL
    transcript.seq <- NULL
    
    withProgress(message = "Searching for cDNA sequences...",expr = {
        setProgress(.05)
        # If any of the items in genelist contain the strings `SSTP`, `SVE`, `SPAL`, or `WB`, check if they are geneIDs
        if (any(grepl('SSTP|SVE|SPAL|WB|PTRK', genelist$queryID))) {
            Sspp.seq <- getBM(attributes=c('wbps_gene_id', 'wbps_transcript_id', 'cdna'),
                              # grab the cDNA sequences for the given genes from WormBase Parasite
                              mart = useMart(biomart="parasite_mart", 
                                             dataset = "wbps_gene", 
                                             host="https://parasite.wormbase.org", 
                                             port = 443),
                              filters = c('species_id_1010', 
                                          'wbps_gene_id'),
                              values = list(c('strattprjeb125',
                                              'ststerprjeb528',
                                              'stpapiprjeb525',
                                              'stveneprjeb530',
                                              'caelegprjna13758'),
                                            genelist$queryID),
                              useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = wbps_gene_id, transcriptID = wbps_transcript_id, cDNA = cdna)%>%
                dplyr::mutate(queryID = geneID) # save the query used for indexing
            Sspp.seq$cDNA <- tolower(Sspp.seq$cDNA)
        } 
        
        if (isTruthy(Sspp.seq) && nrow(Sspp.seq) == 0) {Sspp.seq <- NULL}
        setProgress(.2)
        # If any of the items in genelist contain the string `SRAE` check if they are external geneIDs
        if (any(grepl('SRAE', genelist$queryID))) {
            Sr.seq <- getBM(attributes=c('external_gene_id', 'wbps_transcript_id', 'cdna'),
                            # grab the cDNA sequences for the given genes from WormBase Parasite
                            mart = useMart(biomart="parasite_mart", 
                                           dataset = "wbps_gene", 
                                           host="https://parasite.wormbase.org", 
                                           port = 443),
                            filters = c('species_id_1010',
                                        'gene_name'),
                            values = list(c('strattprjeb125'),
                                          genelist$queryID),
                            useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = external_gene_id, transcriptID = wbps_transcript_id, cDNA = cdna)%>%
                dplyr::mutate(queryID = geneID) # save the query used for indexing
            Sr.seq$cDNA <- tolower(Sr.seq$cDNA)
        }
        if (isTruthy(Sr.seq) && nrow(Sr.seq) == 0) {Sr.seq <- NULL}
        
        setProgress(0.4)
        
        # If any of the items in genelist contain the string `Ce-`, remove that string and search as gene names
        if (any(grepl('Ce', genelist$queryID))) {
            genelist$queryID <- genelist$queryID %>%
                gsub("^Ce-", "",.)
            Ce.seq <- getBM(attributes=c('external_gene_id', 'wbps_transcript_id','cdna'),
                            # grab the cDNA sequences for the given genes from WormBase Parasite
                            mart = useMart(biomart="parasite_mart",
                                           dataset = "wbps_gene",
                                           host="https://parasite.wormbase.org",
                                           port = 443),
                            filters = c('species_id_1010',
                                        'gene_name'),
                            values = list('caelegprjna13758',
                                          genelist$queryID),
                            useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = external_gene_id, transcriptID = wbps_transcript_id, cDNA = cdna)%>%
                dplyr::mutate(queryID = geneID) # save the query used for indexing
            Ce.seq$cDNA <- tolower(Ce.seq$cDNA)
        }
        if (isTruthy(Ce.seq) && nrow(Ce.seq) == 0) {Ce.seq <- NULL}
        
        setProgress(0.6)
        
        # Check to see if all the queryIDs have been found, if not, search for transcript IDs
        if (any(isTruthy(Ce.seq), isTruthy(Sspp.seq), isTruthy(Sr.seq)) && 
            nrow(bind_rows(Ce.seq, Sr.seq, Sspp.seq)) >= length(genelist$queryID)) {
            transcript.seq <- NULL
        } else {
        # Check all items in geneList to see if they are transcript ids
        transcript.seq <- getBM(attributes=c('wbps_gene_id','wbps_transcript_id', 'cdna'),
                                # grab the cDNA sequences for the given genes from WormBase Parasite
                                mart = useMart(biomart="parasite_mart", 
                                               dataset = "wbps_gene", 
                                               host="https://parasite.wormbase.org", 
                                               port = 443),
                                filters = c('species_id_1010', 
                                            'wbps_transcript_id'),
                                values = list(c('strattprjeb125',
                                                'ststerprjeb528',
                                                'stpapiprjeb525',
                                                'stveneprjeb530',
                                                'caelegprjna13758'),
                                              genelist$queryID),
                                useCache = F) %>%
            as_tibble() %>%
            #we need to rename the columns retreived from biomart
            dplyr::rename(geneID = wbps_gene_id, transcriptID = wbps_transcript_id, cDNA = cdna) %>%
            dplyr::mutate(queryID = transcriptID) # save the query used for indexing
        transcript.seq$cDNA <- tolower(transcript.seq$cDNA)
        if (isTruthy(transcript.seq) && nrow(transcript.seq) == 0) {transcript.seq <- NULL}
        }
        
        validate(
            need({isTruthy(Sspp.seq)|isTruthy(Sr.seq)|isTruthy(transcript.seq)|isTruthy(Ce.seq)}, "The call to BioMaRT did not return any records matching the submitted gene(s). \n Please check the gene lists and try again. \n Note: letters must be capitalized correctly, i.e. 'srae_' and 'CE' will produce errors.")
        )
        setProgress(0.7)
        gene.seq <- dplyr::bind_rows(Sspp.seq,Sr.seq,transcript.seq,Ce.seq) %>%
            dplyr::left_join(genelist, . , by = "queryID")
        
        
        calc.inc <- 0.1/nrow(gene.seq)
        
        # Strongyloides CAI values ----
        Sr.temp<- lapply(gene.seq$cDNA, function (x){
            incProgress(amount = calc.inc)
            if (!is.na(x)) {
                s2c(x) %>%
                    calc_sequence_stats(.,w.tbl$Sr_relAdapt)}
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
        
        # Gene Identifiers
        info.gene.seq <- info.gene.seq %>%
            add_column(geneID = gene.seq$geneID, .before = 'GC') %>%
            add_column(transcriptID = gene.seq$transcriptID, .after = 'geneID') %>%
            add_column(queryID = gene.seq$queryID, .after = 'transcriptID')
        
        # C. elegans CAI values ----
        # 
        ## Calculate info each sequence (C. elegans index)
        Ce.temp<- lapply(gene.seq$cDNA, function (x){
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
        # 
        ## Calculate info each sequence (B. malayi index)
        Bm.temp<- lapply(gene.seq$cDNA, function (x){
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
        browser()
        # N. brasiliensis CAI values ----
        # 
        ## Calculate info each sequence ( N. brasiliensis index) 
        Nb.temp<- lapply(gene.seq$cDNA, function (x){
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
        
        
        ## Merge tibbles ----
        info.gene.seq <- add_column(info.gene.seq, 
                                    Ce_CAI = Ce.info.gene.seq$Ce_CAI,
                                    Bm_CAI = Bm.info.gene.seq$Bm_CAI,
                                    Nb_CAI = Nb.info.gene.seq$Nb_CAI,
                                    .after = "Sr_CAI") %>%
            drop_na() #remove any rows that just have NA values
        
        vals$geneIDs <- suppressMessages(info.gene.seq %>%
           left_join(.,gene.seq) %>%
            rename('cDNA sequence' = cDNA) %>%
            dplyr::select(!queryID))
       
        info.gene.seq %>%
            dplyr::select(!queryID)
        
    })
}