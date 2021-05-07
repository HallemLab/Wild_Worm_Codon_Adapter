# Wild Worm Codon Adapter
Web-based Shiny App for automatic codon optimization and analysis based on codon usage rules in non-*Caenorhabditis* nematode species, including: *Strongyloides* species, *Pristionchus pacificus*, *Nippostrongylus brasiliensis*, *Brugia malayi*, as well as any other species of interest via custom codon usage rules provided by users.  

## Table of Contents  
1. [General Information](#general-information)
2. [App Setup & Deployment](#app-setup-&-deployment)
3. [App Features](#app-features)
4. [App Methods](#app-methods)
5. [Examples of App Use](#examples-of-shiny-app-ui)
6. [Sources](#sources)
7. [License](#license)
8. [Authors](#authors)

## General Information
This repository contains the infrastructure for generating a Shiny web application. The app is deployed via Shinyapps.io but can also be run locally. See App Setup and App Features sections below for additional details.  

## App Setup & Development
To access a stable deployment of the Wild Worm Codon Adapter Web App, please visit:   [https://hallemlab.shinyapps.io/Wild_Worm_Codon_Adapter/](https://hallemlab.shinyapps.io/Wild_Worm_Codon_Adapter/)  

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
The Wild Worm Codon Adapter Web Tool adapts and automates the process of codon adaptation for a selection of non-*Caenorhabditis* nematode species, including: *Strongyloides* species, *Nippostrongylus brasiliensis*, *Brugia malayi*, *Pristionchus pacificus*, as well as *Caenorhabditis elegans*. It also permits codon optimization via user-provided custom optimal codon sets. Furthermore, this tool enables users to perform bulk calculations of codon adaptiveness relative to species-specific codon usage rules. 

The app has two usage modes:  

  1. **Optimization Mode:** This tab optimizes genetic sequences for expression in *Strongyloides* species, *N. brasiliensis*, *B. malayi*, *P. pacificus*, and *C. elegans*, as well as user-provided optimal codon sets. 

It accepts either nucleotide or single-letter amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of introns. Users may choose between using canonical Fire lab synthetic introns, PATC-rich introns, *P. pacificus* native introns, or a custom set of user-provided introns. Users may input sequences for optimization using the text box provided, or may upload sequences as .fasta/.gb/.txt files.  

Optimized sequences with or without artificial introns may be downloaded as plain text (.txt) files.   

  2. **Analysis Mode:** For user-provided genes/sequences, this tab reports the fractional GC content, coding sequence, and codon optimization relative to the codon usage weights of: 

* highly expressed *S. ratti* transcripts [(Mitreva *et al* 2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/) 
* highly expressed *C. elegans* genes [(Sharp and Bradnam, 1997)](https://www.ncbi.nlm.nih.gov/books/NBK20194/) 
* highly expressed *N. brasiliensis* genes [(Eccles *et al* 2018)](https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-017-0473-4)
* highly expressed *B. malayi* genes [(Han *et al*, 2020)](https://www.genetics.org/content/216/4/947)
* highly expressed *P. pacificus* genes [(Han *et al*, 2020)](https://www.genetics.org/content/216/4/947) 

To analyze transgenes, coding sequences can be provided via a text box. To analyze native genes, stable gene or transcript IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", "NBR", "Bma", "Ppa", or "WB" can be provided either through direct input via the appropriate textbox, or in bulk as a comma separated (CSV) text file. Users may also provide a *C. elegans* gene name, provided it is prefaced with the string "Ce-", or *C. elegans* stable transcript IDs as is. Finally, users may direcly provide coding sequences for analysis, either as a 2-column CSV file listing sequence names and coding sequences, or a FASTA file containing named coding sequences.   

Users may download an excel file containing fractional GC content values, codon adaptation indeces, and coding sequences for the user-provided genes.

## Analysis Methods
### Inputs
The primary non-responsive data inputs to the Wild Worm Codon Adapter App are CSV files containing the following information:  
  1. Codon frequency rates and relative adaptiveness values for *S. ratti*, *N. brasiliensis*, *B. malayi*, *P. pacificus*, and *C. elegans* 
  2. Optimal codon lookup table for *Strongyloides spp*, *N. brasiliensis*, *B. malayi*, *P. pacificus*, and *C. elegans* 
  3. <OPTIONAL> Custom optimal codon lookup table (2 columns: single-letter amino acid symbols and corresponding 3-letter optimal codon sequences; one optimal codon per amino acid) 
  4. <OPTIONAL> Custom intron list (fasta file containing a maximum of 3 introns; intron sequences should begin/end with canonical 5'-GT<intron>AG-3' splice recognition sequences)

These data are loaded by the Shiny server function and used to calculate CAI values and optimize sequences.  

### Codon Usage Rules
The codon usage patterns of highly expressed genes are thought to correlate with higher protein expression ( [Sharp and Li, 1987](https://pubmed.ncbi.nlm.nih.gov/3547335/) , [Plotkin and Kudla, 2011](http://www.nature.com/articles/nrg2899) ). Thus, codon frequency rates from highly expressed genes are used. 

Codon frequency rates for *Strongyloides* species are based on highly expressed *S. ratti* transcripts (50 most abundant expressed sequence tag clusters). Specifically, codon usage rules were generated by calculating the frequency for each codon from count data published in [Mitreva *et al* (2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/); frequency values were manually checked against published frequency values. 

Codon frequency rates for *C. elegans* were based on highly expressed *C. elegans* gene count data published in [Sharp and Bradnam (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20194/). 

Codon frequency rates for *N. brasiliensis* were calculated from coding sequences of highly expressed *N. brasiliensis* genes (10% highest RNA-seq expression values across all samples); RNA-seq data was downloaded from WormBase ParaSite, based on data originally published in [Eccles *et al* (2018)](https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-017-0473-4), and [Chandler *et al* (2017)](https://pubmed.ncbi.nlm.nih.gov/28491281/). 
Codon frequency rates for highly expressed *B. malayi* and *P. pacificus* genes (average frequency bins 8-11, ~10% highest expressing genes) are from [Han *et al* (2020)](https://www.genetics.org/content/216/4/947); raw codon frequency data were graciously provided by Dr. Wen-Sui Lo and Dr. Ralf Sommer. 

### Relative Adaptiveness, Optimal Codons, and Optimization
The relative adaptiveness values for every possible codon were generated as follows. Individual codons were scored by calculating their relative adaptivness: (the frequency that codon "i" encodes amino acid "AA") / (the frequency of the codon most often used for encoding amino acid "AA"). Optimal codons for these species were defined as the codon with the highest relative adaptiveness value for each amino acid.

User-provided custom optimization rules: In addition to the optimization rules provided by the application, users may also provide a custom set of optimal codons. In this case, users may upload a CSV file containing 2 columns listing single-letter amino acid symbols and the corresponding 3-letter optimal codon sequence, using the provided UI interface. Only one optimal codon should be provided per amino acid; stop codons should be designated using the '*' symbol. This custom optimal codon lookup table will be applied during codon optimization; CAI values will not be calculated. 

In all cases, codon optimzation is performed by replacing non-optimal codons with optimal codons.  

### Codon Adaptation Index Values
Sequences (both original and optimized) are scored by calculating the Codon Adaptation Index: the geometric average of relative adaptiveness of all codons in the gene sequence ( [Sharp and Li 1987](https://pubmed.ncbi.nlm.nih.gov/3547335/), [Jansen *et al* 2003](http://www.ncbi.nlm.nih.gov/pubmed/12682375)). The CAI is calculated via the `seqinr` library using a multi-species relative adaptiveness table (see above).

### GC Content
The fraction of G+C bases of the nucleic acid sequences. Calculated using the `seqinr` library.  

### Inserting Introns
Incorporating introns into cDNA sequences can signficiantly increase gene expression in nematode species [(Crane *et al* 2019](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6591249/), [Han *et al* 2020](https://www.genetics.org/content/216/4/947), [Junio *et al* 2008](https://pubmed.ncbi.nlm.nih.gov/17945217/), [Li *et al* 2011)](https://pubmed.ncbi.nlm.nih.gov/21723330/).  

In Optimize Sequences mode, users may input a desired number of introns, up to a maximum of three unique introns. The Fire lab established three unique introns, spaced equidistantly within a gene, as canon [(Fire Lab Vector Kit 1995)](https://media.addgene.org/cms/files/Vec95.pdf); this configuration is thus set as default, and is recommended.  

Intron sequences and insertion order are either the three canonical Fire lab synthetic introns established by the Fire lab, *P. pacificus* native introns, PATC-rich introns (*smu-2* introns 3-5) that enhance germine expression of transgenes in *C. elegans*, or custom user-provided intron sequences [(Fire Lab Vector Kit 1995](https://media.addgene.org/cms/files/Vec95.pdf), [Han *et al* 2020](https://www.genetics.org/content/216/4/947), [Aljohani *et al* 2020)](https://www.nature.com/articles/s41467-020-19898-0). All built-in introns sequences are bracketed with canonical GT...AG splice recognition sequences [(Shapiro and Senapathy 1987](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC306199/), [Blumenthal and Stewart 1997](https://www.ncbi.nlm.nih.gov/books/NBK20075/), [Wheeler *et al* 2020)](https://journals.plos.org/plosntds/article?id=10.1371/journal.pntd.0008869). Users may either select the desired built-in intron sequence source using the dropdown menu provided, or upload a fasta file containing up to three custom intron sequences.  

#### Identifying Intron Insertion Sites  
This app first divides the optimized cDNA sequence at 3 predicted intron insertion sites spaced approximately equidistantly. Users may choose to further refine the insertion site locations by identifying the closest conserved invertebrate exon splice sites (‘AG\^G’, ‘AG\^A’)( [Shapiro and Senapathy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC306199/), [Blumenthal and Stewart)](https://www.ncbi.nlm.nih.gov/books/NBK20075/). For all insertion sites, '\^' symbol indicates the exact insertion site.  

#### Intron Spacing  
Once hypothetical intron insertion sites have been identified, the application inserts the user-specified number of introns, using the 5’ insertion site first and continuing in the 3’ direction. In *C. elegans*, the location of the intron site influences the degree of intron-mediated enhancement, such that a single 5′-intron is more effective than a single 3′-intron [(Crane *et al* 2019](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6591249/), [Aljohani *et al* 2020)](https://www.nature.com/articles/s41467-020-19898-0). Therefore when only 1 or 2 introns are desired, 3 possible intron insertion sites are identified and filled as needed, starting from the 5′ site.  

## Examples of Shiny App UI  
### User Interface for the Wild Worm Codon Adapter in Optimize Sequences Mode
![An example of the User Interface for the Wild Worm Codon Adapter in Optimize Sequences Mode](/Static/WWCA_OptimizeMode.png)

### User Interface for the Wild Worm Codon Adapter App in Analyze Sequences Mode
![An example of the User Interface for the Wild Worm Codon Adapter in Analyze Sequences Mode](/Static/WWCA_AnalyzeMode.png)

## Sources  
* [Shiny](https://shiny.rstudio.com/) - UI framework
* [Wormbase ParaSite](https://parasite.wormbase.org/index.html) - GeneIDs and coding sequences
* [Seqinr](https://www.rdocumentation.org/packages/seqinr/versions/3.6-1) - Utilities for calculating Codon Adaptation Index
* Codon Usage Patterns:  
  - *Strongyloides spp*: [Mitreva *et al* (2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/)
  - *Pristionchus pacificus*: [Han *et al* (2020)](https://www.genetics.org/content/216/4/947)
  - *Brugia malayi*: [Han *et al* (2020)](https://www.genetics.org/content/216/4/947)
  - *Nippostrongylus brasiliensis*: [WormBase ParaSite](https://parasite.wormbase.org/expression/nippostrongylus_brasiliensis_prjeb511/index.html), [Eccles *et al* (2018)](https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-017-0473-4)
  - *C. elegans*: [Sharp and Bradnam, 1997](https://www.ncbi.nlm.nih.gov/books/NBK20194/)
* Intron Sequences:  
  - Canonical Fire lab artificial introns: [Fire Lab Vector Kit 1995](https://media.addgene.org/cms/files/Vec95.pdf)
  - PATC-rich introns: [Aljohani *et al* (2020)](https://www.nature.com/articles/s41467-020-19898-0)
  - *P. pacificus* native introns: [Han *et al* (2020)](https://www.genetics.org/content/216/4/947)
* Intron/Exon Splice Sites: [Shaprio and Senapathy (1987)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC306199/) and [Blumenthal and Stewart (1997)](https://www.ncbi.nlm.nih.gov/books/NBK20075/)

## License  
This project is licensed under the MIT License. 

## Authors  
* [Astra Bryant, PhD](https://github.com/astrasb)
* [Elissa Hallem, PhD](https://github.com/ehallem)
