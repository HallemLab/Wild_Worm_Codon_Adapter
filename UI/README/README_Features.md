The Wild Worm Codon Adapter Web Tool adapts and automates the process of codon adaptation for a selection of non-*Caenorhabditis* nematode species, including: *Strongyloides* species, *Nippostrongylus brasiliensis*, *Brugia malayi*, *Pristionchus pacificus*, as well as *Caenorhabditis elegans*. It also permits codon optimization via user-provided custom optimal codon sets. Furthermore, this tool enables users to perform bulk calculations of codon adaptiveness relative to species-specific codon usage rules. 

The app has two usage modes:  

### Optimize Sequences Mode  
This tab optimizes genetic sequences for expression in *Strongyloides* species, *N. brasiliensis*, *B. malayi*, *P. pacificus*, and *C. elegans*, as well as user-provided optimal codon sets. 

It accepts either nucleotide or single-letter amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of introns. Users may choose between using canonical Fire lab synthetic introns, PATC-rich introns, *P. pacificus* native introns, or a custom set of user-provided introns. Users may input sequences for optimization using the text box provided, or may upload sequences as .fasta/.gb/.txt files.  
Optimized sequences with or without artificial introns may be downloaded as .txt files.    

### Analyze Sequences Mode  
For user-provided genes/sequences, this tab reports the fractional GC content, coding sequence, and codon optimization relative to the codon usage weights of: 

* highly expressed *S. ratti* transcripts [(Mitreva *et al* 2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/) 
* highly expressed *C. elegans* genes [(Sharp and Bradnam, 1997)](https://www.ncbi.nlm.nih.gov/books/NBK20194/) 
* highly expressed *N. brasiliensis* genes [(Eccles *et al* 2018)](https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-017-0473-4) 
* highly expressed *B. malayi* genes [(Han *et al*, 2020)](https://www.genetics.org/content/216/4/947)
* highly expressed *P. pacificus* genes [(Han *et al*, 2020)](https://www.genetics.org/content/216/4/947) 

To analyze transgenes, coding sequences can be provided via a text box. To analyze native genes, stable gene or transcript IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", "NBR", "Bma", "Ppa", or "WB" can be provided either through direct input via the appropriate textbox, or in bulk as a comma separated text file. Users may also provide a *C. elegans* gene name, provided it is prefaced with the string "Ce-", or *C. elegans* stable transcript IDs as is. Finally, users may direcly provide coding sequences for analysis, either as a 2-column .csv file listing sequence names and coding sequences, or a .fasta file containing named coding sequences.   

Users may download an excel file containing fractional GC content values, codon adaptation indeces, and coding sequences for the user-provided genes.

  