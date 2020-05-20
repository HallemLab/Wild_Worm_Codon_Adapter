# Strongyloides Codon Adapter Shiny App

## --- Libraries ---
library(shiny)
library(seqinr)
library(tidyverse)

## --- end_of_chunk ---

## --- Background ---
source('Static/generate_codon_lut.R', local = TRUE)

## --- end_of_chunk ---

## --- UI ---
ui <- fluidPage(
    
    # Application title
    titlePanel("Strongyloides Codon Adapter"),
    
    sidebarLayout(
        
        ## Options
        sidebarPanel(
            ### Codon usage threshold (pulldown?)
            ### Option to add introns (pulldown)
        ),
        
        ## Sequence
        mainPanel(
            ### Name (optional, text input)
            ### Sequence (text box)
            ### Option to upload .fasta sequence?
        ),
        
        ## Results
        mainPanel(
            ### Optimized sequence
            ### Optimization details
            #### GC content of Original vs Optimized
            #### Some kind of interactive mode that allows user to click on a codon and see alternatives, and update results?
        )
    )
)

## --- end_of_chunk ---

## --- Server ---
# Define server logic required to draw a histogram
server <- function(input, output) {
    
    # The bits that have to be responsive start here.
    ## Load example for debugging
    source('Server/import_fasta.R', local = TRUE)
    
    ## Calculate info for original sequence
    GC_dat <- GC(dat[[1]])
    CAI_dat <- sapply(dat,cai, w = w)
    
    ## Translate nucleotides to AA
    source('Server/translate_nucleotides.R', local = TRUE)
    
    ## Codon optimize back to nucleotides
    source('Server/codon_optimize.R', local = TRUE)
    
}
## --- end_of_chunk ---

## --- App ---
shinyApp(ui = ui, server = server)
## --- end_of_chunk ---
