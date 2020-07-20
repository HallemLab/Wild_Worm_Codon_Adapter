# Get cDNA sequences for given geneIDs from BioMaRT
gene.seq <- getBM(attributes=c('wbps_gene_id', 'cdna'),
                  # grab the ensembl annotations for Wormbase Parasite genes
                  mart = useMart(biomart="parasite_mart", 
                                 dataset = "wbps_gene", 
                                 host="https://parasite.wormbase.org", 
                                 port = 443),
                  filters = c('species_id_1010', 'wbps_gene_id'),
                  values = list('ststerprjeb528', genelist$geneID)) %>%
    as_tibble() %>%
    #we need to rename the columns retreived from biomart
    dplyr::rename(gene_name = wbps_gene_id, cDNA = cdna)

gene.seq$cDNA <- tolower(gene.seq$cDNA)

## Calculate info each sequence
temp<- lapply(gene.seq$cDNA, function (x){
    s2c(x) %>%
        calc_sequence_stats(.,w)
}) 
names(temp) <-gene.seq$gene_name

info.gene.seq<- temp %>%
    map("GC") %>%
    unlist() %>%
    as_tibble_col(column_name = 'GC (%)')

info.gene.seq<- temp %>%
    map("CAI") %>%
    unlist() %>%
    as_tibble_col(column_name = 'CAI') %>%
    add_column(info.gene.seq, .)

info.gene.seq <- info.gene.seq %>%
    add_column(geneID = gene.seq$gene_name, .before = 'GC (%)')
vals$geneIDs <- info.gene.seq