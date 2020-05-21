# Static script to generate lookup table for optimal *Strongyloides* codons
#b2fasta('AFDrGC(35).gb','AFDrGC(35).fasta')


## Load *Strongyloides* codon usage charts
codonChart <- read_csv('Static/codon_usage_chart.csv', 
                       quote = "", 
                       col_types = 'fcd'
)

## Calculate the relative adaptiveness of each codon
codonChart <- codonChart %>%
    mutate(Codon = tolower(Codon)) %>%
    group_by(AA) %>%
    mutate (relAdapt = Sr_optimal / max(Sr_optimal))

## Generate lookup table with "optimal" *Strongyloides ratti* codons
lut <- codonChart %>%
    filter(relAdapt == 1) %>%
    select(c(AA, Codon)) %>%
    ungroup() %>%
    add_row(AA = '*', Codon = 'taa')

## Arrange relative adaptiveness values into format readable by seqinr::cai function
w <- codonChart %>%
    arrange(-desc(Codon)) %>%
    ungroup() %>%
    select(c(relAdapt, Codon)) %>%
    column_to_rownames(var = "Codon") %>%
    pull()
