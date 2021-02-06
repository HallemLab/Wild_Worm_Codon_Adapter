# Wild Worm Codon Adapter
Web-based Shiny App for automatic codon optimization and analysis based on codon usage rules in non-*Caenorhabditis* nematode species, including: *Strongyloides* species, *Pristionchus* species, *Nippostrongylus brasiliensis*, *Brugia malayi*, as well as any other species of interest via custom codon usage rules provided by users.  

## Table of Contents  
1. [General Information](#general-information)
2. [App Setup & Deployment](#app-setup-&-deployment)
3. [App Features](#app-features)
4. [App Methods](#app-methods)
5. [References](#references)
6. [Examples of App Use](#examples-of-shiny-app-ui)
7. [Sources](#sources)
8. [License](#license)
9. [Authors](#authors)

## General Information
This repository contains the infrastructure for generating a Shiny web application. The app is deployed via Shinyapps.io but can also be run locally. See App Setup and App Features sections below for additional details.  

## App Setup & Development
To access a stable deployment of the Wild Worm Codon Adapter Web App, please visit:   [https://asbryant.shinyapps.io/Wild_Worm_Codon_Adapter/](https://asbryant.shinyapps.io/Strongyloides_Codon_Adapter/)  

To run the latest version locally from GitHub, use the following command in R/RStudio:  
`library(shiny)`  
`shiny::runGitHub(repo = 'Wild_Worm_Codon_Adapter', username = 'HallemLab')`  

To run a specific release locally use the following commands in R/RStudio:  
  * For PCs --  
    `library(shiny)`  
    `shiny::runUrl('https://github.com/HallemLab/Wild_Worm_Codon_Adapter/archive/<RELEASE_VERSION>.zip') ` 

  * For Macs --  
    `library(shiny)`  
    `shiny::runUrl('https://github.com/HallemLab/Wild_Worm_Codon_Adapter/archive/<RELEASE_VERSION>.tar.gz')`  

Please note: the download step for runURL/runGitHub may take a substantial amount of time. We recommend downloading this archive and running the application locally.

## App Features  
The Wild Worm Codon Adapter Web Tool adapts and automates that process of codon adaptation for a selection of "wild" worm species, including: *Strongyloides* species, *Pristionchus* species, *N. brasiliensis*, *B. malayi*, as well as custom codon usage rules provided by users. Furthermore, this tool enables users to perform bulk calculations of codon adaptiveness relative to codon usage rules for the built-in species listed above plus *Caenorhabditis elegans*. 

The app has two usage modes:  

  1. **Optimization Mode:** This tab optimizes genetic sequences for expression in *Strongyloides* species, *Pristionchus* species, *N. brasiliensis*, and *B. malayi*, as well as user-provided optimal codon sets. It accepts either nucleotide or amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of introns. Users may choose between using canonical *C. elegans* synthetic introns, PATC-rich introns, or *Pristionchus pacificus* native introns. Users may input sequences using the text box provided, or may upload sequences as .fasta/.gb/.txt files. Optimized sequences with or without introns may be downloaded as .txt files.    

  2. **Analysis Mode:** For user-provided genes or sequences, this tab reports the fractional GC content, cDNA sequence, and codon optimization relative to the codon usage weights of highly expressed *Strongyloides ratti* transcripts (1), *C. elegans* genes (2), *N. brasiliensis* coding sequences, and *B. malayi* coding sequences. To analyze transgenes, cDNA sequences can be provided via a text box. To analyze native genes, stable gene or transcript IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", or "WB" can be provided either through direct input via the provided textbox, or in bulk as a comma separated text file. Users may also provide a *C. elegans* gene name, provided it is prefaced with the string "Ce-", or *C. elegans* stable transcript IDs as is. Finally, users may direcly provide cDNA sequences for analysis, either as a 2-column .csv file listing geneIDs and cDNA sequences, or a .fa file containing named cDNA sequences.   

  Users may download an excel file containing fractional GC content values, codon adaptation indeces, and cDNA sequences for the user-provided genes.

## Analysis Methods
### Inputs
The primary non-responsive data inputs to the Wild Worm Codon Adapter App are two .csv files containing the following information:  
1. Codon frequency rates and relative adaptiveness values for *S. ratti*, *C. elegans*, *N. brasiliensis* and *B. malayi*  
2. Optimal codon lookup table for *Strongyloides spp*, *Pristionchus spp* , *B. malayi*, *N. brasiliensis*, and *C. elegans*
3. <OPTIONAL> Custom optimal codon lookup table (2 columns: single-letter amino acid symbols and corresponding 3-letter optimal codon sequences; one optimal codon per amino acid)

These tables are loaded by the Shiny server function and used to calculate CAI values and optimize sequences.  

### Codon Usage Rules
Codon bias in nematode transcripts can vary as a function of gene expression levels such that highly expressed genes appear to have the greatest degree of codon bias. Thus, codon frequency rates from highly expressed genes are used, whenever possible. Codon frequency rates for *Strongyloides* species are based on highly expressed *S. ratti* transcripts (50 most abundant expressed sequence tag clusters, 1). Codon frequency rates for *C. elegans* were based on highly expressed *C. elegans* gene count data. Codon frequency rates for *N. brasiliensis* and *B. malayi* are based on count data from [Nematode.net](http://www.nematode.net/NN3_frontpage.cgi?navbar_selection=nemagene&subnav_selection=codon_usage_tables).    

### Relative Adaptiveness, Optimal Codons, and Optimization
For *S. ratti*, *C. elegans*, *N. brasiliensis*, and *B. malayi*: The relative adaptiveness values of every possible codon was generated as follows: individual codons were scored by calculating their relative adaptivness: (the frequency that codon "i" encodes amino acid "AA") / (the frequency of the codon most often used for encoding amino acid "AA"). Optimal codons for these species were defined as the codon with the highest relative adaptiveness value for each amino acid.

For *Pristionchus* species: Optimal codons were defined by codon usage bias calculations based on the top 10% highly expressed *P. pacificus* genes [(Han *et al*, 2020)](https://www.genetics.org/content/216/4/947).

User-provided custom optimization rules: In addition to the optimization rules provided by the application, users may also provide a custom set of optimal codons. In this case, users may upload a .csv file containing 2 columns listing single-letter amino acid symbols and the corresponding 3-letter optimal codon sequence, using the provided UI interface. Only one optimal codon should be provided per amino acid; stop codons should be designated using the '*' symbol. This custom optimal codon lookup table will be applied during codon optimization; CAI values will not be calculated. 

In all cases, codon optimzation is performed by replacing non-optimal codons with optimal codons.  

### Codon Adaptation Index Values
In the case of optimization for *Strongyloides* species, *N. brasiliensis*, or *B. malayi*: sequences (both original and optimized) are scored by calculating the Codon Adaptation Index: the geometric average of relative adaptiveness of all codons in the gene sequence (3,4). In Analysis mode, CAI values for user-inputted sequences are calculated relative to *Strongyloides*, *B. mayali*, *N. brasiliensis*, and *C. elegans* codon adaptiveness charts. The CAI is calculated via the `seqinr` library. 

CAI values are not calculated when optimizing for *Pristionchus* species or when using a user-provided custom optimization rule.

### GC Content
The fraction of G+C bases of the nucleic acid sequences. Calculated using the `seqinr` library.  

### Inserting Introns
Including introns into cDNA sequences can signficiant increase gene expression. Intron mediated enchancement of gene expression can be due to a variety of mechanisms, including by increasing the rate of transcription. Intron mediated enhancement occurs in *C. elegans* and *P. pacificus* (5,6), and is at least compatible with expression in *Strongyloides spp.* (7). Here, the desired number of introns are inserted within the DNA sequence, up to a maximum of 3 unique introns. Intron sequences and order are either canonical Fire lab synthetic introns (8), *P. pacificus* native introns (5), or PATC-rich introns (*smu-2* introns 3-5) that enhance germline expression of transgenes in *C. elegans* (9).

#### Intron Number and Spacing  
The Fire lab established three unique introns, spaced equidistantly within a gene as canon (8); this configuration is thus set as default, and is recommended. In *C. elegans*, the location of the intron site influences the degree of intron mediated enhancement, such that a single 5′-intron is more effective than a single 3′-intron [6,9]. Therefore when only 1 or 2 introns are desired, 3 possible intron insertion sites are identified and filled as needed, starting from the 5′ site.

#### Identifying Intron Insertion Sites  
Introns are placed between the 3rd and 4th nucleotide of one of the following sequences: "aagg", "aaga", "cagg", "caga", as in Redemann *et al* (2011) (10). If those sequences are not present, introns are placed between the 2nd and 3rd nucleotide of one of the following minimal *C. elegans* splice site consensus sequences was used: "aga", "agg" (11).
            
## References
1. [Mitreva *et al* (2006). Codon usage patterns in Nematoda: analysis based on over 25 million codons in thirty-two species. *Genome Biology* 7: R75](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/). 
2. [Sharp and Bradnam (1997). Appendix 3: Codon Usage in *C. elegans*. In: *C. elegans* II. 2nd edition; Eds: Riddle, Blumenthal, Meyer *et al*. Cold Spring Harbor Laboratory Press.](https://www.ncbi.nlm.nih.gov/books/NBK20194/).
3. [Sharp and Li (1987). The Codon Adaptation Index: a measure of directional synonymous codon usage bias, and its potential applications. *Nucleic Acids Research* 15: 1281-95](https://pubmed.ncbi.nlm.nih.gov/3547335/). 
4. [Jansen *et al* (2003). Revisiting the codon adaptation index from a whole-genome perspective: analyzing the relationship between gene expression and codon occurrence in yeast using a variety of models. *Nucleic Acids Research* 31: 2242-51](http://www.ncbi.nlm.nih.gov/pubmed/12682375).
5. [Han *et al* (2020). Improving transgenesis efficiency and CRISPR-associated tools through codon optimization and native intron addition in *Pristionchus* nematodes. *GENETICS* 216: 947-56](https://www.genetics.org/content/216/4/947)
6. [Crane *et al* (2019). *In vivo* measurements reveal a single 5′-intron is sufficient to increase protein expression level in *C. elegans*. *Scientific Reports* 9: 9192](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6591249/). 
7. [Junio *et al* (2008). *Strongyloides stercoralis* cell- and tissue-specific transgene expression and co-transformation with vector constructs incorporating a common multifunctional 3′ UTR'. *Experimental Parasitology* 118: 253-265](https://pubmed.ncbi.nlm.nih.gov/17945217/). 
8. [Fire Lab Vector Kit (1995)](https://media.addgene.org/cms/files/Vec95.pdf)
9. [Aljohani *et al* (2020). Engineering rules that minimize germline silencing of transgenes in simple extrachromosomal arrays in *C. elegans*. *Nature Communications* 11: 6300](https://www.nature.com/articles/s41467-020-19898-0).
10. [Redemann *et al* (2011). Codon adaptation-based control of protein expression in *C. elegans*. *Nature Methods* 8: 250-252](https://pubmed.ncbi.nlm.nih.gov/21278743/). 
11. [*Cis-* Splicing in Worms *in* *C. elegans* II (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20075/)

## Examples of Shiny App UI  
### User Interface for the Wild Worm Codon Adapter in Optimize Sequences Mode
![An example of the User Interface for the Wild Worm Codon Adapter in Optimize Sequences Mode](/Static/WWCA_OptimizeMode.png)

### User Interface for the Wild Worm Codon Adapter App in Analyze Sequences Mode
![An example of the User Interface for the Wild Worm Codon Adapter in Analyze Sequences Mode](/Static/WWCA_AnalyzeMode.png)

## Sources  
* [Shiny](https://shiny.rstudio.com/) - UI framework
* [WormbaseParasite](https://parasite.wormbase.org/index.html) - GeneIDs and cDNA sequences
* [Seqinr](https://www.rdocumentation.org/packages/seqinr/versions/3.6-1) - Utilities for calculating Codon Adaptation Index
* Codon Usage Patterns:  
  - *Strongyloides spp*: [Mitreva *et al* 2006](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/)
  - *Pristionchus spp*: [Han *et al* (2020)](https://www.genetics.org/content/216/4/947)
  - *Brugia malayi*: [Nematode.net](http://www.nematode.net/NN3_frontpage.cgi?navbar_selection=nemagene&subnav_selection=codon_usage_tables)
  - *Nippostrongylus brasiliensis*: [Nematode.net](http://www.nematode.net/NN3_frontpage.cgi?navbar_selection=nemagene&subnav_selection=codon_usage_tables)
  - *C. elegans*: [Sharp and Bradnam, 1997](https://www.ncbi.nlm.nih.gov/books/NBK20194/)
* Intron Sequences:  
  - Canonical Fire lab artificial introns: [Fire Lab Vector Kit 1995](https://media.addgene.org/cms/files/Vec95.pdf)
  - PATC-rich introns: [Aljohani *et al* (2020)](https://www.nature.com/articles/s41467-020-19898-0)
  - *P. pacificus* native introns: [Han *et al* (2020)](https://www.genetics.org/content/216/4/947)
* Intron/Exon Splice Sites: [Redemann *et al* 2011](https://pubmed.ncbi.nlm.nih.gov/21278743/) and [*Cis-* Splicing in Worms *in* *C. elegans* II (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20075/)

## License  
This project is licensed under the MIT License. 

## Authors  
* [Astra Bryant, PhD](https://github.com/astrasb)
* [Elissa Hallem, PhD](https://github.com/ehallem)
