# Strongyloides_Codon_Adapter
Shiny app for automatic codon optimzation based on *Strongyloides* codon usage. Codon bias in nematode transcripts can vary as a function of gene expression  levels such that highly expressed genes appear to have the greatest degree of codon bias. Therefore, optimization rules are based on the codon usage weights of highly expressed *Stronyloides ratti* transcripts (1). 
This app can also be used in an analysis mode that reports the endogenous codon optimization for a given gene. Stable Gene IDs with prefixes "SSTP", "SRAE", or "WB" can be provided either through direct input via the provided textbox, or in bulk as a comma separated text file. The analysis mode additionally reports the codon adaptation index for given genes relative to the codon usage weights of highly expressed *C. elegans* genes (2).

## CAI (Codon Adaptation Index) 
Individual codons are scored by calculating their relative adaptivness: (the frequency that codon "i" encodes amino acid "AA") / (the frequency of the codon most often used for encoding amino acid "AA"). Genes are scored by calculating their Codon Adaptation Index: the geometric average of relative adaptiveness of all codons in the gene sequence (3,4). The CAI is calculated via the seqinr library.  

## GC Content
The fraction of G+C bases of the nucleic acid sequences. Calculated using the seqinr library.  

## Inserting Introns
Including synthetic introns into cDNA sequences can signficiant increase gene expression. Intron mediated enchancement of gene expression can be due to a variety of mechanisms, including by increasing the rate of transcription. Intron mediated enhancement occurs in *C. elegans* (5). Although intron mediated enhancement has to be specifically studied in *Strongyloides spp.* there is evidence that the prescence of introns does not prevent gene expression (e.g. intron-inclusive eGFP)(6). Here, the desired number of introns are inserted within in DNA sequence, up to a maximum of 3 unique introns. Intron sequences and order are taken from the Fire Lab Vector Kit (1995) (7). 

*Intron Number and Spacing:* The Fire lab established three unique introns, spaced equidistantly within a gene as canon (7); this configuration is thus set as default, and is recommended. In *C. elegans*, the location of the intron site influences the degree of intron mediated enhancement, such that a single 5′-intron is more effective than a single 3′-intron. Therefore when only 1 or 2 introns are desired, 3 possible intron insertion sites are identified, and filled as needed, starting from the 5′ site.

*Identifying Intron Insertion Sites:* Introns are placed between the 3rd and 4th nucleotide of one of the following sequences: "aagg", "aaga", "cagg", "caga", as in Redemann *et al* (2011) (8). If those sequences are not present, introns are placed between the 2nd and 3rd nucleotide of one of the following minimal *C. elegans* splice site consensus sequences was used: "aga", "agg" (9).
            
## References
1. [Mitreva *et al* (2006). Codon usage patterns in Nematoda: analysis based on over 25 million codons in thirty-two species. *Genome Biology* 7: R75](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/). 
2. [Sharp and Bradnam (1997). Appendix 3: Codon Usage in *C. elegans*. In: *C. elegans* II. 2nd edition; Eds: Riddle, Blumenthal, Meyer *et al*. Cold Spring Harbor Laboratory Press.](https://www.ncbi.nlm.nih.gov/books/NBK20194/).
3. [Sharp and Li (1987). The Codon Adaptation Index: a measure of directional synonymous codon usage bias, and its potential applications. *Nucleic Acids Research* 15: 1281-95](https://pubmed.ncbi.nlm.nih.gov/3547335/). 
4. [Jansen *et al* (2003). Revisiting the codon adaptation index from a whole-genome perspective: analyzing the relationship between gene expression and codon occurrence in yeast using a variety of models. *Nucleic Acids Research* 31: 2242-51](http://www.ncbi.nlm.nih.gov/pubmed/12682375). 
5. [Crane *et al* (2019). *In vivo* measurements reveal a single 5′-intron is sufficient to increase protein expression level in *C. elegans*. *Scientific Reports* 9: 9192](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6591249/). 
6. [Junio *et al* (2008). *Strongyloides stercoralis* cell- and tissue-specific transgene expression and co-transformation with vector constructs incorporating a common multifunctional 3′ UTR'. *Experimental Parasitology* 118: 253-265](https://pubmed.ncbi.nlm.nih.gov/17945217/). 
7. [Fire Lab Vector Kit (1995)](https://media.addgene.org/cms/files/Vec95.pdf)
8. [Redemann *et al* (2011). Codon adaptation-based control of protein expression in *C. elegans*. *Nature Methods* 8: 250-252](https://pubmed.ncbi.nlm.nih.gov/21278743/). 
9. [*Cis-* Splicing in Worms *in* *C. elegans* II (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20075/)

## Example: Shiny App UI Load Screen
![](https://github.com/astrasb/Strongyloides_Codon_Adapter/blob/master/Static/LoadScreenExample.png)

## Example: Shiny App UI Optimization Mode Results Screen
![](https://github.com/astrasb/Strongyloides_Codon_Adapter/blob/master/Static/ResultExample.png)

## Example: Shiny App UI Analysis Mode Results Screen

