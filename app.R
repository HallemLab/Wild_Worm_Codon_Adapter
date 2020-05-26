# Strongyloides Codon Adapter Shiny App

## --- Libraries ---
library(shiny)
library(seqinr)
library(tidyverse)
library(htmltools)
library(shinydashboard)
source('Server/calc_sequence_stats.R')

## --- end_of_chunk ---

## --- Background ---
source('Static/generate_codon_lut.R', local = TRUE)


## --- end_of_chunk ---

## --- UI ---
ui <- fluidPage(
    tags$head(
        tags$style(HTML("
    #optimizedSequence{
    font-family: monospace;
    }
    
    #intronic_opt{
    font-family: monospace;
    }
                    "))
    ),
    # Application title
    titlePanel("Strongyloides Codon Adapter"),
    
    source('UI/dashboard-ui.R', local = TRUE)$value
    # sidebarLayout(
    #     source('UI/sidebar-ui.R', local = TRUE)$value,
    #     
    #     source('UI/mainPanel-ui.R', local = TRUE)$value
    # )
)

## --- end_of_chunk ---

## --- Server ---
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    vals <- reactiveValues(cds_opt = NULL,
                           og_GC = NULL,
                           og_CAI = NULL,
                           opt_GC = NULL)
    
    # The bits that have to be responsive start here.
    
    
    ## Load example for debugging
    #source('Server/import_fasta.R', local = TRUE)
    
    
    
    ## Parse nucleotide inputs
    optimize_sequence <- eventReactive (input$goButton, {
        req(input$seqtext)  # Don't run unless there is sequence to run on
            
        dat <- input$seqtext %>%
            tolower %>%
            trimSpace %>%
            s2c
        
        ## Determine whether input sequence in nucleotide or amino acid
        source('Server/detect_language.R', local = TRUE)
        
        ## Calculate info for original sequence
        if (lang == "nuc"){
        info_dat <- calc_sequence_stats(dat, w)
        
        ## Translate nucleotides to AA
        source('Server/translate_nucleotides.R', local = TRUE)
        } else if (lang == "AA") {
            AA_dat <- toupper(dat)
            info_dat <- list("GC" = NA, "CAI" = NA)
        } else if (lang == "error") {
            info_dat <- list("GC" = NA, "CAI" = NA)
            vals$cds_opt <- NULL
            return("Error: Input sequence contains unrecognized characters. 
                   Check to make sure it only includes characters representing
                   nucleotides or amino acids.")
        }
        
        ## Codon optimize back to nucleotides
        source('Server/codon_optimize.R', local = TRUE)
        
        ## Calculate info for optimized sequence
        info_opt <- calc_sequence_stats(opt, w)
        
        vals$og_GC <- info_dat$GC
        vals$og_CAI <- info_dat$CAI
        vals$opt_GC <- info_opt$GC
        vals$opt_CAI <- info_opt$CAI
        
        vals$cds_opt <- cds_opt
    })
    
    
    add_introns <- reactive({
        req(vals$cds_opt)
        cds_opt <- vals$cds_opt
        
        ## Detect insertion sites for artificial introns
        source('Server/locate_intron_sites.R', local = TRUE)
       
        ## Insert canonical artificial introns
        if (!is.na(loc_iS[[1]])){
        source('Server/insert_introns.R', local = TRUE)
        } else cds_wintrons <- c("Error: no intron insertion sites are 
                                 avaliable in this sequence")
        return(cds_wintrons)
    })
    
    ## Define Shiny outputs
    output$optimizedSequence <- renderText({
        optimize_sequence()
    })
    
    output$intronic_opt <- renderText({
        if(as.numeric(input$num_Int) > 0){
            optimize_sequence()
            add_introns()
        }
    })
    
    output$info <- renderTable({
        tibble(Sequence = c("Original", "Optimized"),
               `GC (%)` = c(vals$og_GC, vals$opt_GC),
               CAI =c(vals$og_CAI, vals$opt_CAI))
    })
    
    output$tabs <- renderUI({
        req(input$goButton)
        #browser()
        if (as.numeric(input$num_Int) > 0 && !is.null(vals$cds_opt)) {
            tabs <- list(
                tabPanel(title = "With Introns", 
                         textOutput("intronic_opt", 
                                    container = div)),
                tabPanel(title = "Without Introns", 
                         textOutput("optimizedSequence", 
                                    container = div))
                
            )
        } else {
            tabs <- list(
                tabPanel(title = "Without Introns", 
                         textOutput("optimizedSequence", 
                                    container = div)))
        }

        args <- c(tabs, list(id = "box", 
                             title = tagList(shiny::icon("fas fa-dna"), 
                                             "Optimized Sequences"),
                             side = "right",
                             width = NULL))
        

        do.call(tabBox, args)
    })
    
    output$seqinfo <- renderUI({
        req(input$goButton)
        
        args <- list(title = tagList(shiny::icon("fas fa-calculator"),
                                     "Sequence Info"), 
                     width = NULL,
                     status = "success",
                     tableOutput("info"))
        do.call(box,args)
    })
    
    session$onSessionEnded(stopApp)
    
}
## --- end_of_chunk ---

## --- App ---
shinyApp(ui = ui, server = server)
## --- end_of_chunk ---
