# Static script to generate lookup table for optimal *Strongyloides* codons
#b2fasta('AFDrGC(35).gb','AFDrGC(35).fasta')


## Load *Strongyloides* codon usage charts
codonChart <- read_csv('Static/codon_usage_chart.csv', 
                       quote = "", 
                       col_types = 'fcdd'
)

# For Strongyloides ----
## Calculate the relative adaptiveness of each codon
Sr_codonChart <- codonChart %>%
    dplyr::select(-Ce_optimal) %>%
    dplyr::mutate(Codon = tolower(Codon)) %>%
    group_by(AA) %>%
    dplyr::mutate (relAdapt = Sr_optimal / max(Sr_optimal))

## Generate lookup table with "optimal" *Strongyloides ratti* codons
lut <- Sr_codonChart %>%
    dplyr::filter(relAdapt == 1) %>%
    dplyr::select(c(AA, Codon)) %>%
    ungroup() %>%
    add_row(AA = '*', Codon = 'taa')

## Arrange relative adaptiveness values into 
## format readable by seqinr::cai function
w <- Sr_codonChart %>%
    dplyr::arrange(-dplyr::desc(Codon)) %>%
    ungroup() %>%
    dplyr::select(c(relAdapt, Codon)) %>%
    column_to_rownames(var = "Codon") %>%
    pull()

## Generate list of amino acids
AAs <- str_c(lut$AA, collapse = "") %>%
    tolower()%>%
    paste0("[", . , "]")

# For C. elegans ----
## Calculate the relative adaptiveness of each codon
## Arrange relative adaptiveness values into 
## format readable by seqinr::cai function
Ce.w <- codonChart %>%
    dplyr::select(-Sr_optimal) %>%
    dplyr::mutate(Codon = tolower(Codon)) %>%
    group_by(AA) %>%
    dplyr::mutate (relAdapt = Ce_optimal / max(Ce_optimal))%>%
    dplyr::arrange(-dplyr::desc(Codon)) %>%
    ungroup() %>%
    dplyr::select(c(relAdapt, Codon)) %>%
    column_to_rownames(var = "Codon") %>%
    pull()
