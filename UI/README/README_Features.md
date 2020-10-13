   
The *Strongyloides* Codon Adapter Shiny App adapts and automates that process of codon adaptation for *Strongyloides* species, and enables users to query codon adaptiveness of select genes of interest. The app has two modes:  

### Optimize Sequences Mode  
This tab optimizes genetic sequences for expression in *Strongyloides* species.  

It accepts either nucleotide or amino acid sequences, and will generate an optimized nucleotide sequence with and without the desired number of artificial introns. Users may input sequences using the text box provided, or may upload sequences as .fasta/.gb/.txt files.  
Optimized sequences with or without artificial introns may be downloaded as .txt files.    

### Analyze Sequences Mode  
This tab reports the endogenous codon optimization for a given gene relative to the codon usage weights of highly expressed *Strongyloides ratti* transcripts [(Mitreva *et al* 2006)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/) or highly expressed *C. elegans* genes [(Sharp and Bradnam, 1997)](https://www.ncbi.nlm.nih.gov/books/NBK20194/). 

Stable Gene IDs with prefixes "SSTP", "SRAE", "SPAL", "SVE", or "WB" can be provided either through direct input via the provided textbox, or in bulk as a comma separated text file. Users may also provide a *C. elegans* gene name. Finally, users may direcly provide cDNA sequences for analysis, either as a 2-column .csv file listing geneIDs and cDNA sequences, or a .fa file containing named cDNA sequences.   

Users may download an excel file containing the codon adaptation index and cDNA sequences for the user-provided genes. The app also generates a scatter plot displaying, for each gene, codon adaptiveness values relative to S. ratti vs C. elegans usage weights. Users may download this plot as a PDF file.
  