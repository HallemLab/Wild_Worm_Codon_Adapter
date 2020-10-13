# This script takes species-specific counts of codon occurances and calculates the frequency each codon "i" encodes amino acid "AA"
# These values will be passed to the quantification of relative adaptiveness, the first step for calculating codon adaptation index.

# Generate tibble with stop codon codes
stop_cdns <- tibble(AA = factor("*","*","*"),
                    Codon = c("TAA", "TAG", "TGA"),
                    Frequency = c(0,0,0))

# Load S. ratti count data
# Source: Mitreva et al 2006; counts taken from 50 most common expressed sequence tag clusters (putative genes)
Sr.dat <- read_csv('Sr_top50_usage_counts.csv',
                   quote = "",
                   col_types = 'fcd')

Sr.codon.freq <- Sr.dat %>%
    dplyr::mutate(AA = seqinr::a(AA)) %>%
    dplyr::arrange(AA, Codon) %>%
    dplyr::mutate(AA = factor(AA)) %>%
    group_by(AA) %>%
    dplyr::mutate (Frequency = Count / sum(Count)) %>%
    dplyr::mutate (Frequency = Frequency *100) %>%
    dplyr::mutate (Frequency = signif(Frequency, digits = 9)) %>%
    dplyr::full_join(stop_cdns, by = c("AA", "Codon", "Frequency")) %>%
    dplyr::rename("Sr_optimal" = "Frequency") %>%
    dplyr::select(!Count)

# Load C. elegans count data
# Soruce: Sharp and Bradnam, 1997; https://www.ncbi.nlm.nih.gov/books/NBK20194/
Ce.dat <- read_csv('Ce_usage_counts.csv', 
                   quote = "", 
                   col_types = 'ccd'
)

Ce.codon.freq <- Ce.dat %>%
    dplyr::mutate(AA = seqinr::a(AA)) %>%
    dplyr::arrange(AA, Codon) %>%
    dplyr::mutate(AA = factor(AA)) %>%
    group_by(AA) %>%
    dplyr::mutate (Frequency = Count / sum(Count)) %>%
    dplyr::mutate (Frequency = Frequency *100) %>%
    dplyr::mutate (Frequency = signif(Frequency, digits = 9)) %>%
    dplyr::full_join(stop_cdns, by = c("AA", "Codon", "Frequency")) %>%
    dplyr::rename("Ce_optimal" = "Frequency") %>%
    dplyr::select(!Count)

codon_usage_chart <- dplyr::full_join(Sr.codon.freq, 
                                      Ce.codon.freq,
                                      by = c("AA", "Codon")
)

write_csv(codon_usage_chart,
          path = "codon_usage_chart.csv")
