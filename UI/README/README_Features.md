   
The Wild Worm Codon Adapter Web Tool adapts and automates the process of codon adaptation for a selection of non-*C. elegans* nematode species, including: *Strongyloididae* species, *Pristionchus* species, and *Brugia malayai*. It also permits codon optimization via user-provided custom optimal codon sets. Furthermore, this tool enables users to perform bulk calculations of codon adaptiveness relative to *Strongyloididae* and *C. elegans* codon usage rules. 

The app has two usage modes:  

### Optimize Sequences Mode  
This tab optimizes genetic sequences for expression in *Strongyloididae* species, *Pristionchus* species, and *Brugia malayai*, as well as user-provided optimal codon sets. 

It accepts either nucleotide or single-letter amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of introns. Users may choose between using canonical *C. elegans* synthetic introns, PATC-rich introns, or *P. pacificus* native introns. Users may input sequences using the text box provided, or may upload sequences as .fasta/.gb/.txt files.  
Optimized sequences with or without artificial introns may be downloaded as .txt files.    

### Analyze Sequences Mode  
For user-provided genes, this tab reports the fractional GC content, cDNA sequence, and codon optimization relative to the codon usage weights of highly expressed *S. ratti* transcripts [(Mitreva *et al* 2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/) or highly expressed *C. elegans* genes [(Sharp and Bradnam, 1997)](https://www.ncbi.nlm.nih.gov/books/NBK20194/). 

Stable Gene or Transcript IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", "PTRK", or "WB" can be provided either through direct input via the provided textbox, or in bulk as a comma separated text file. Users may also provide a *C. elegans* gene name, provided it is prefaced with the string "Ce-", or *C. elegans* stable transcript IDs as is. Finally, users may direcly provide cDNA sequences for analysis, either as a 2-column .csv file listing geneIDs and cDNA sequences, or a .fa file containing named cDNA sequences.   

Users may download an excel file containing fractional GC content values, codon adaptation indeces, and cDNA sequences for the user-provided genes.
  