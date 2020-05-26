# Automatic detection of language used to encode input string.
# Options include: nucleotide sequence, amino acid sequence, 
# something else (which will trigger an error)

## Are there any characters that aren't code for a nucleotide?
## Will return TRUE if all values of dat are [atgc]
if (!str_detect(dat,"[atgc]", negate = TRUE)%>%
    any()) {
    lang <- "nuc"
} else if (
## Are there any characters that aren't code for an amino acid?
## Will return TRUE is all values of dat are some kind of amino acid    
!str_detect(dat, AAs, negate = TRUE)%>%
    any()) {
    lang <- "AA"
} else {
    lang <- "error"
}
