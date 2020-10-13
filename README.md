# Strongyloides Codon Adapter
Web-based Shiny App for automatic codon optimzation and analysis based on *Strongyloides* codon usage.  

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
To access a stable deployment of the *Strongyloides* Codon Adapter Web App, please visit:   [https://asbryant.shinyapps.io/Strongyloides_Codon_Adapter/](https://asbryant.shinyapps.io/Strongyloides_Codon_Adapter/)  

To run the latest version locally from Github, use the following command in R/RStudio:  
`library(shiny)`  
`shiny::runGitHub(repo = 'Strongyloides_Codon_Adapter', username = 'astrasb')`  

To run a specific release locally use the following commands in R/RStudio:  
  * For PCs --  
    `library(shiny)`  
    `shiny::runUrl('https://github.com/astrasb/Strongyloides_RNAseq_Browser/archive/<RELEASE_VERSION>.zip') ` 

  * For Macs --  
    `library(shiny)`  
    `shiny::runUrl('https://github.com/astrasb/Strongyloides_RNAseq_Browser/archive/<RELEASE_VERSION>.tar.gz')`  

Please note: the download step for runURL/runGitHub may take a substantial amount of time. We recommend downloading this archive and running the application locally.

## App Features  
The *Strongyloides* Codon Adapter Shiny App adapts and automates that process of codon adaptation for *Strongyloides* species, and enables users to query codon adaptiveness of select genes of interest. The app has two modes:  

  1. **Optimization Mode:** This tab optimizes genetic sequences for expression in *Strongyloides* species. It accepts either nucleotide or amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of artificial introns. Users may input sequences using the text box provided, or may upload sequences as .fasta/.gb/.txt files. Optimized sequences with or without artificial introns may be downloaded as .txt files.    

  2. **Analysis Mode:** This tab reports the endogenous codon optimization for a given gene relative to the codon usage weights of highly expressed *Strongyloides ratti* transcripts (1) or *C. elegans* genes (2). Stable Gene IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", or "WB" can be provided either through direct input via the provided textbox, or in bulk as a comma separated text file. Users may also provide a *C. elegans* gene name. Finally, users may direcly provide cDNA sequences for analysis, either as a 2-column .csv file listing geneIDs and cDNA sequences, or a .fa file containing named cDNA sequences.   

  Users may download an excel file containing the codon adaptation index and cDNA sequences for the user-provided genes. The app also generates a scatter plot displaying, for each gene, codon adaptiveness values relative to S. ratti vs C. elegans usage weights. Users may download this plot as a PDF file.  

## Analysis Methods
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

## Examples of Shiny App UI  
### User Interface for *Strongyloides* Codon Adapter App in Optimize Sequences Mode
![An example of the User Interface for the Strongyloides Codon Adapter Shiny App in Optimize Mode](/Static/Str_Codon_Adapter_OptimizeMode.png)

### User Interface for *Strongyloides* Codon Adapter App in Analyze Sequences Mode
![An example of the User Interface for the Strongyloides Codon Adapter Shiny App in Analyze Sequences Mode](/Static/Str_Codon_Adapter_AnalyzeMode.png)

## Sources  
* [Shiny](https://shiny.rstudio.com/) - UI framework
* [WormbaseParasite](https://parasite.wormbase.org/index.html) - GeneIDs and cDNA sequences
* [Seqinr](https://www.rdocumentation.org/packages/seqinr/versions/3.6-1) - Utilities for calculating Codon Adaptation Index
* Codon Usage Patterns:  
  - *Strongyloides spp*: [Mitreva *et al* 2006](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/)
  - *C. elegans*: [Sharp and Bradnam, 1997](https://www.ncbi.nlm.nih.gov/books/NBK20194/)
* Artifical Intron Sequences: [Fire Lab Vector Kit 1995](https://media.addgene.org/cms/files/Vec95.pdf)
* Intron/Exon Splice Sites: [Redemann *et al* 2011](https://pubmed.ncbi.nlm.nih.gov/21278743/) and [*Cis-* Splicing in Worms *in* *C. elegans* II (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20075/)

## License  
This project is licensed under the MIT License. 

## Authors  
* [Astra Bryant, PhD](https://github.com/astrasb)
