# Strongyloides Codon Adapter Shiny App

## --- Libraries ---
library(shiny)
library(seqinr)
library(tidyverse)
library(htmltools)

## --- end_of_chunk ---

## --- Background ---
source('Static/generate_codon_lut.R', local = TRUE)

## --- end_of_chunk ---

## --- UI ---
ui <- fluidPage(
    tags$head(
    tags$style(HTML("
    #sequence{
    font-family: monospace;
    }
                    "))
    ),
    # Application title
    titlePanel("Strongyloides Codon Adapter"),
    
    fluidRow(
        source('UI/sidebar-ui.R', local = TRUE)$value,
        
        source('UI/mainPanel-ui.R', local = TRUE)$value
    )
)

## --- end_of_chunk ---

## --- Server ---
# Define server logic required to draw a histogram
server <- function(input, output) {
    print_seq <- eventReactive(input$goButton, {
        splitseq(s2c(input$seqtext), word = 3)
    })
    
    output$OG_seq <- renderText(print_seq())
    
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
