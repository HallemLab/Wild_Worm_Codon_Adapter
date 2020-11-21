# This script includes the the primary computation for analyzing a list of geneIDs
# for the Strongyloides Codon Adapter App in Analyze Sequences Mode
# If user has provided a list of geneIDs/transcriptIDs, pull cDNA sequence from BioMart and analyse 
# GC content and CAI values for each gene using calls to `calc_sequence_stats.R`.
# 

analyze_geneID_list <- function(genelist, vals){
    # Get cDNA sequences for given geneIDs from BioMaRT
    Sspp.seq <- NULL
    Sr.seq <- NULL
    Ce.seq <- NULL
    transcript.seq <- NULL
    
    withProgress(message = "Accessing BioMaRT",expr = {
        setProgress(.05)
        # If any of the items in genelist contain the strings `SSTP`, `SVE`, `SPAL`, or `WB` check if they are geneIDs
        if (any(grepl('SSTP|SVE|SPAL|WB', genelist$geneID))) {
            Sspp.seq <- getBM(attributes=c('wbps_gene_id', 'cdna'),
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
                                            genelist$geneID),
                              useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = wbps_gene_id, cDNA = cdna)
            Sspp.seq$cDNA <- tolower(Sspp.seq$cDNA)
        } 
        setProgress(.2)
        # If any of the items in genelist contain the string `SRAE` check if they are external geneIDs
        if (any(grepl('SRAE', genelist$geneID))) {
            Sr.seq <- getBM(attributes=c('external_gene_id', 'cdna'),
                            # grab the cDNA sequences for the given genes from WormBase Parasite
                            mart = useMart(biomart="parasite_mart", 
                                           dataset = "wbps_gene", 
                                           host="https://parasite.wormbase.org", 
                                           port = 443),
                            filters = c('species_id_1010',
                                        'gene_name'),
                            values = list(c('strattprjeb125'),
                                          genelist$geneID),
                            useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = external_gene_id, cDNA = cdna)
            Sr.seq$cDNA <- tolower(Sr.seq$cDNA)
        }
        setProgress(0.4)
        # Check all items in geneList to see if they are transcript ids
        transcript.seq <- getBM(attributes=c('wbps_transcript_id', 'cdna'),
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
                                              genelist$geneID),
                                useCache = F) %>%
            as_tibble() %>%
            #we need to rename the columns retreived from biomart
            dplyr::rename(geneID = wbps_transcript_id, cDNA = cdna)
        transcript.seq$cDNA <- tolower(transcript.seq$cDNA)
        if (nrow(transcript.seq) == 0) {
            transcript.seq <- NULL}
        
        setProgress(0.6)
        # If any of the items in genelist contain the string `Ce-`, remove that string and search as gene names
        if (any(grepl('Ce', genelist$geneID))) {
            genelist$geneID <- genelist$geneID %>%
                gsub("^Ce-", "",.)
            Ce.seq <- getBM(attributes=c('external_gene_id', 'cdna'),
                            # grab the cDNA sequences for the given genes from WormBase Parasite
                            mart = useMart(biomart="parasite_mart", 
                                           dataset = "wbps_gene", 
                                           host="https://parasite.wormbase.org", 
                                           port = 443),
                            filters = c('species_id_1010',
                                        'gene_name'),
                            values = list('caelegprjna13758',
                                          genelist$geneID),
                            useCache = F) %>%
                as_tibble() %>%
                #we need to rename the columns retreived from biomart
                dplyr::rename(geneID = external_gene_id, cDNA = cdna)
            Ce.seq$cDNA <- tolower(Ce.seq$cDNA)
        }
        validate(
            need({isTruthy(Sspp.seq)|isTruthy(Sr.seq)|isTruthy(transcript.seq)|isTruthy(Ce.seq)}, "The call to BioMaRT did not return any records matching the submitted gene(s). \n Please check the gene lists and try again. \n Note: letters must be capitalized correctly, i.e. 'srae_' and 'CE' will produce errors.")
        )
        
        setProgress(0.7)
        gene.seq <- dplyr::bind_rows(Sspp.seq,Sr.seq,transcript.seq,Ce.seq) %>%
            dplyr::left_join(genelist, . , by = "geneID")
       
        ## Calculate info each sequence (S. ratti index) ----
        temp<- lapply(gene.seq$cDNA, function (x){
            if (!is.na(x)) {
                s2c(x) %>%
                    calc_sequence_stats(.,w)}
            else {
                list(GC = NA, CAI = NA)
            }
        }) 
        
        setProgress(0.8)
        # Strongyloides CAI values ----
        info.gene.seq<- temp %>%
            map("GC") %>%
            unlist() %>%
            as_tibble_col(column_name = 'GC')
        
        info.gene.seq<- temp %>%
            map("CAI") %>%
            unlist() %>%
            as_tibble_col(column_name = 'Sr_CAI') %>%
            add_column(info.gene.seq, .)
        
        info.gene.seq <- info.gene.seq %>%
            add_column(geneID = gene.seq$geneID, .before = 'GC') 
        
        
        # C. elegans CAI values ----
        # Only run this under certain conditions
        # 
        setProgress(0.9)
        ## Calculate info each sequence (C. elegans index) ----
        Ce.temp<- lapply(gene.seq$cDNA, function (x){
            if (!is.na(x)) {
                s2c(x) %>%
                    calc_sequence_stats(.,Ce.w)}
            else {
                list(GC = NA, CAI = NA)
            }
        }) 
        
        ce.info.gene.seq<- Ce.temp %>%
            map("CAI") %>%
            unlist() %>%
            as_tibble_col(column_name = 'Ce_CAI')
        
        setProgress(0.95)
        ## Merge both tibbles
        info.gene.seq <- add_column(info.gene.seq, 
                                    Ce_CAI = ce.info.gene.seq$Ce_CAI, .after = "Sr_CAI")
        
        vals$geneIDs <- info.gene.seq %>%
            left_join(.,gene.seq, by = "geneID") %>%
            rename('cDNA sequence' = cDNA)
        
        setProgress(1)
        info.gene.seq
        
    })
}