fetch_cDNAseq <- function(species = NULL, inputIDs = NULL, inputFilter = NULL){
    # species = character vector containing values of the bioMart filter 'species_id_1010' (e.g. 'caelegprjna13758')
    # inputFilter = character vector containing the filter that should be used in the bioMart query. Should correspond to the ID type provided by the inputIDs vectors (e.g. 'wbps_transcript_id')
    # inputIDs = character vector containing the values for the inputFilter. (e.g. list of transcript IDs)
    
    dat <- getBM(attributes=c('wbps_gene_id', 'wbps_transcript_id', 'cdna'),
          # grab the cDNA sequences for the given genes from WormBase Parasite
          mart = useMart(biomart="parasite_mart",
                         dataset = "wbps_gene",
                         host="https://parasite.wormbase.org",
                         port = 443),
          filters = c('species_id_1010',
                      inputFilter),
          values = list(species,
                        inputIDs),
          useCache = F) %>%
        as_tibble() %>%
    # rename the columns retreived from biomart
        dplyr::rename(geneID = wbps_gene_id, transcriptID = wbps_transcript_id, cDNA = cdna) %>%
        dplyr::group_by(geneID)
    # If we wanted to have a filtering step that only selected a single copy of the gene, here would be the place to put that code
    
    dat
}