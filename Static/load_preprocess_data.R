# This script loads species-specific data and does some minor preprocessing after
# initialization of the Wild Worm Codon Adapter App. 
# 
# Specific actions:
# 
# 1. generates lookup tables that are parsed by seqinr
# for optimal codons in different worm species, including:
# *Strongyloides spp.*  
# *C. elegans*
# *Pristionchus pacificus*
# *Brugia malai*
# *Nippostrongylus brasiliensis*
# 
# 2. specifies intron sequences that can be inserted into sequences.
# There are 3 options for intron sequences:
# - 3 canonical artificial introns from Fire lab
# - 3 PATC-rich artificial introns that in C. elegans offer significant protection from germline silencing, source: https://doi.org/10.1038/s41467-020-19898-0, specifically pCFJ1035, smu-2 intons 2, 3, and 4
# - 3 Pristionchus pacificus native introns source: https://doi.org/10.1534/genetics.120.303785

# Load optimized codon lookup tables ----
lut.tbl <- read_csv('Static/codon_lut.csv', 
                       quote = "", 
                       col_types = 'fccccc'
)

# Generate list of amino acids ----
AAs <- str_c(lut.tbl$AA, collapse = "") %>%
    tolower()%>%
    paste0("[", . , "]")

# Load/parse relative adaptiveness table ----
# Generate table containing columns that are vectors of relative adaptiveness
# for each codon. Columns are arranged in a format readable by 
# seqinr::cai function, as the "w" input.
w.tbl <- read_csv('Static/rel_adaptiveness_chart.csv', 
                                quote = "", 
                                col_types = 'fcnnnnnnnnnn'
) %>%
    dplyr::select(AA, Codon, contains("relAdapt"))  %>%
    add_column(custom_relAdapt = NA, none_relAdapt = NA)%>%
    group_by(AA) %>%
    dplyr::arrange(-dplyr::desc(Codon)) %>%
    ungroup() %>%
    dplyr::select(-AA)  %>%
    column_to_rownames(var = "Codon")

# Declare intron sequences
syntrons.list <- list(
    Canon = list(
        alpha = 'gtaagtttaaacatatatatactaactaaccctgattatttaaattttcag',
        beta = 'gtaagtttaaacagttcggtactaactaaccatacatatttaaattttcag',
        gamma = 'gtaagtttaaacatgattttactaactaactaatctgatttaaattttcag'
    ),
    PATC = list(
        alpha = 'gtaaggagttgaacggctgaaaaatcgatattttgagcgaaaaaagccggaaaaatggattttatcggataaaatttgattttttgagctgagaaatgcctttatagacgaatttccttgtcaaattgttaaaaactgcaaaatttgccaaaaaaaaagcattttttatatttttttttacaaaaaattccacaaaaatggcaaaatttgactaaaaatgccaattttgtcgttttctccgtgccacagcggccgaaaatcgatttttaagcgattttcgggtgaaaaagtgtaaaaaccgactgaaaatccagctgaaaacgacaaaaacggtaagttttagctaattttcacctttttttcgatatttttttactaaaaaaaaaccgaaaaattgagtttttttcaaatttctgcaaaaattctgcaattttagcaatttccatactattttgacgccgaaaaagcttaaaaatatgatttttagaggtttttaatggaaaattcatggatttttcaaatttttccacgaaaatcattgaaaaatttgaaaaaattgatttcctattcaaagttctagctaaaaactgcaattttagcaatttccatactattttagtactgaaaaagcctaaaaatgtgattttcagaggatttcaatggaaaattcatggatttttccaatttttcaatgaaaaccattgaaaaaccctggaaaattgagtttttcttcaaagtttaggaaatttatgagaatttttgaataaaaaatttttaaatttgaaaaaaattgaaattttaattctaaattttaaagaaagttgattttttaataatttttttttttgaataaaaaaaaatcaactttctttaaaatttagaattaaaatttcaatttttttattcaaaaattctcataaatttcgtaaacttttaataaaaactcaatttttccgatttttttcgatgattttcactaaaaaattggaaaaattcatcaatttcctattgaaaacctctaaaaattatattttttttgcttttccgacgtcaaaatagtatggaaaatgctaaaattgcagaatttttccagaaatttgaagaaaaaactcaattttttccgttttttcaatgattttcatgaaaaaattggaaaattttgtaaattttccattgaaaacctctgaaaatttggaaattttcgaatttaaatgtttaaaaaaaattgaatattttgcgagtttttgaattttttttgagaatttttgaatttttttcacccaaaattttttcaatttttcag',
        beta = 'gtgctgaagctcgaaaatttggagcttttacacgagatttttgaagaaaaagcctgaaaatcgagagattttgagctgtggaattcgttgaaattacataattcgcgcccgtaattctttaaaaaaacgctgaaatttgcagattttgccagaaagttgaagaaaaatctacttttccggcattctctattattttcatggaaaattagaaaaatccatgaataaacagtgaaaattgctgattttacctgaaattttgaaaaaaaaaaaaatctaaaatcaaggttttaagcctaaaaactgcagatttcagccaaaattgtgaaaaaagctgattttttgctattttgagcttttccatggggtggaaattgccaaaaattacggaacattcacacaaatttgctgaataatccaattttccagtgttttctagagtttccgtagaaattttgaaaaaacccagtaaattttcaatcggaaaacctctaaaaacatcgtttcaggcctataaatagtaaaaattaccgattttattcgaaaatttaaggaaaagtcgtgaaaaacgagattttaagcctcaaaactgcagattctatctaaaattaaaaaaaaaaaacataaatatccgaatttttggaggaaaagcctgaaaatcgatattttaagcctcaaaactgaagatttcagccaaaaaaaaaaacagatttttcgctattttatgtgccaaaaaaccacattccgagcttttccagagtggaaattgccaaaaattacagaattttcccagaaattagcaaaaaaaaaacccatttttcaggcgttttcaacgattttcatagcaaatttgaaaaatccatgaattttttaattatagaaaaccctctgaaaattgcagttttaagctattccagcattcaaatagtatggaaattgctaaaaattgaagaattttcccaaaaatttgatgaaaacttatttttctggcgttttcgatgattttcatggaatttcgagaaaattaatgaattttcaattaaaaaacgtctgcaaaatcacattttttaaagctttttcagcaacaaaatagtatggaaattgctttttaaaaaagcggaatttttggaaaaaaggttaaattttcagtcagtttttgcactttttgactgaaaattcactgaaattagggaaaaattccggaaaaatgattttttcgaattgtagggcaaattttgcaatttcaagcaatttccataatattttaatgctggaaaagctcaaatttacgttttaatgggattttagtgaaaaattcatggattttccgaaaaatttgcaggaaaatcatagtaaagacctcaaaaaatcaataaaaaatttaaaaaattggacaatcacatttctgcgtaaaatctgcactttttcagtaaaaaataccgattttccgtgaaaattctcgatttttaatcgaaaatctcgaaatttttacaaatttcagcaccaaaatcgttgaaaattctgaaaatttgaattttttttccttgttttttgagtaaaatttgcactttttcagtaaagaataccgattttccgtgaaaattctcggtttttaatcgaaaatctcgaaatttttacaaatttcagctccgaaatagctgaaaattggacaaaaatttcaatttttgccctgttttttgagtaaaatctgcactttttagttgaaaaaaaacacggattttgtaggaaaatttgggaaaaatctccaaattttcacaattttccagtaaaaacagcaatttttaaaacggtttttaatcaaaaatctttagaattttccaaatttcagcaccaaaaaagctaaaaatcgctgaaattttcgacaaattccaaatttccag',
        gamma = 'gttggtttttccgagagaaaaacgctgaaaaatgccgaaaattttgaatttgcaggctttttaggtgcaaaagtacggaaaaatcggaaaaaaatcaggaaaacatggggaaaatccaattttccagaaaaaatgtttgaaaaaattgaaaacttttgtttttttagtaataaagttttaaaaaatggcaaaaatagctgaaaacagcgaaaaaaaaaaatgtttttttcaggaaaaaatttgcaaaaaaatgaagagcaacaataattcccttttttttctgtgtttttttcggaaaaattgagatcgaaaacgaaaaacagcgaaaattcccaattttcccagtttttaaaacatttttttgtaaaaatttggaaaaaacgagttttttcagaaaaaaatgtgaaaaaaaaggtaaattaccaatttatgcttttttttcgatcgagtaaaaaatcgatttttccaagatttttcgcgaaaaattcaaaaaaaaagaacgaaaattctcgattttctactttttttcgaaaaaaaaaggaaattatagatttttccaagatttttcgcgaaaaaattcgaaaaaaatgtttttttcgaaaatttcagattttctaattttttcagaagaattcgaaaaaaaaaatcaaaaaattcgcaatttttagatttttttaaaatctcaattttctataattattttcctaaaaaaatgtaattaaaaaaccgctaaaaacggtaaattccaaatttttgcattttttcaaaaaaaatttgaaaaaaaaaatcagaaaattctcaaatctattccctttttttaaaatttttcccaaaccaaaaaaaaaaacggtaaattttcaaatttagcatttttccaaaattaaacataaaaaaaaacgcaaatttccaaatttcgtttttttttcaaaaaagttgaaaaatccagaaaataccctcttgtccatgaaaaaatacgaaaattttcaataaaaaatcaatttcttcttaaaaaattaattctcgatttttccatgaaaaaaaatcaaatattaattaaatttgaaaaaaaaaagaatttatctaatagtttcgttttttttcagaggaaaaatttgaaaaaaaaaacagtaaattctctttctttttgaaaaaaaaaattatcgattcttccaagttttttcccgaaaaaatcgacaaaaaaacgagaatttccgattttctattttttttttcaaaaaaatgtgaaaaaaaaaattaaaaaattccaattttgcatttttttttcaaaaaaaatttaaaaacaccgtataattcccgatttttccatgaaaaaatacgaaaaattccaataaaaatcaactattttaaaaatttgccgttttttcag'
    ),
    Pristionchus = list(
        alpha = 'gtgagcatttcttggttgtgaatgggggttgtgaaaacttcatgggattcctaacctatttaatttttcag',
        beta = 'gtaagtcgtatacattagcgggtgcttttacgtgatatccggggtttggttttgagagaggagatatttatttaaataaatataatttcag',
        gamma = 'gtgagtgctgtcaaatattaagtgacatgaaactttttctcag'
    ))
