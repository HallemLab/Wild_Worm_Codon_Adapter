### CAI (Codon Adaptation Index) 
The primary non-responsive data input to the *Strongyloides* Codon Adapter App is a .csv file containing codon usage rules for highly expressed *S. ratti* transcripts and *C. elegans* genes (`codon_usage_chart.csv`, located in the `Static` subfolder). This multi-species codon usage chart is loaded by the Shiny server function and used to create relative adaptiveness lookup tables.  

For each sequence provided using responsive Shiny inputs, individual codons are scored by calculating their relative adaptivness: (the frequency that codon "i" encodes amino acid "AA") / (the frequency of the codon most often used for encoding amino acid "AA"). Genes are scored by calculating their Codon Adaptation Index: the geometric average of relative adaptiveness of all codons in the gene sequence (3,4). The CAI is calculated via the `seqinr` library. Codon bias in nematode transcripts can vary as a function of gene expression  levels such that highly expressed genes appear to have the greatest degree of codon bias. Therefore, optimization rules used to generate sequences codon optimized for expression in *Strongyloides* species are based on the codon usage weights of highly expressed *S. ratti* transcripts (1).    

### GC Content
The fraction of G+C bases of the nucleic acid sequences. Calculated using the `seqinr` library.  

### Inserting Introns
Including synthetic introns into cDNA sequences can signficiant increase gene expression. Intron mediated enchancement of gene expression can be due to a variety of mechanisms, including by increasing the rate of transcription. Intron mediated enhancement occurs in *C. elegans* (5). Although intron mediated enhancement has to be specifically studied in *Strongyloides spp.* there is evidence that the prescence of introns does not prevent gene expression (e.g. intron-inclusive eGFP)(6). Here, the desired number of introns are inserted within the DNA sequence, up to a maximum of 3 unique introns. Intron sequences and order are taken from the Fire Lab Vector Kit (1995) (7). 

#### Intron Number and Spacing  
The Fire lab established three unique introns, spaced equidistantly within a gene as canon (7); this configuration is thus set as default, and is recommended. In *C. elegans*, the location of the intron site influences the degree of intron mediated enhancement, such that a single 5′-intron is more effective than a single 3′-intron. Therefore when only 1 or 2 introns are desired, 3 possible intron insertion sites are identified, and filled as needed, starting from the 5′ site.

#### Identifying Intron Insertion Sites  
Introns are placed between the 3rd and 4th nucleotide of one of the following sequences: "aagg", "aaga", "cagg", "caga", as in Redemann *et al* (2011) (8). If those sequences are not present, introns are placed between the 2nd and 3rd nucleotide of one of the following minimal *C. elegans* splice site consensus sequences was used: "aga", "agg" (9).