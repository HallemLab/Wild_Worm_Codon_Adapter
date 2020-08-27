# Strongyloides Codon Adapter Shiny App

## --- Libraries ---
suppressPackageStartupMessages({
    library(shiny)
    library(seqinr)
    library(htmltools)
    library(shinyWidgets)
    library(shinythemes)
    library(shinycssloaders)
    library(magrittr)
    library(tidyverse)
    library(openxlsx)
    source('Server/calc_sequence_stats.R')
    library(BiocManager)
    library(biomaRt)
    library(read.gb)
    library(tools)
    
})

## --- end_of_chunk ---

## --- Background ---
source('Static/generate_codon_lut.R', local = TRUE)


## --- end_of_chunk ---

## ---- UI ----
ui <- fluidPage(
    
    source('UI/navbar-ui.R', local = TRUE)$value,
    
    source('UI/custom_css.R', local = T)$value
)

## --- end_of_chunk ---

## ---- Server ----
# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    vals <- reactiveValues(cds_opt = NULL,
                           og_GC = NULL,
                           og_CAI = NULL,
                           opt_GC = NULL,
                           og_CeCAI = NULL,
                           geneIDs = NULL,
                           analysisType = NULL)
    
    # The bits that have to be responsive start here.
    
    
    ## Load example for debugging
    #source('Server/import_fasta.R', local = TRUE)
    
    ## Codon Optimization Mode ----
    
    ## Parse nucleotide inputs
    optimize_sequence <- eventReactive (input$goButton, {
        validate(
            need({isTruthy(input$seqtext) | isTruthy(input$loadseq)}, "Please input sequence for optimization")
        )
        
        if (isTruthy(input$seqtext)) {
            dat <- input$seqtext %>%
                tolower %>%
                trimSpace %>%
                s2c
        } else if (isTruthy(input$loadseq)){
            if (file_ext(input$loadseq$name) == "gb") {
                dat <- suppressMessages(read.gb(input$loadseq$name, Type = "nfnr")) 
                dat <- dat[[1]]$ORIGIN %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else if (file_ext(input$loadseq$name) == "fasta") {
                dat <- suppressMessages(read.fasta(input$loadseq$name,
                                                   seqonly = T)) 
                dat <- dat[[1]] %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else if (file_ext(input$loadseq$name) == "txt") {
                dat <- suppressWarnings(read.table(input$loadseq$name,
                                                   colClasses = "character",
                                                   sep = "")) 
                dat <- dat[[1]] %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else {
                validate(need({file_ext(input$loadseq$name) == "txt" | 
                                    file_ext(input$loadseq$name) == "fasta" |
                                    file_ext(input$loadseq$name) == "gb"}, "File type not recognized. Please try again."))
                }
        }
        ## Determine whether input sequence in nucleotide or amino acid
        source('Server/detect_language.R', local = TRUE)
        
        ## Calculate info for original sequence
        if (lang == "nuc"){
            info_dat <- calc_sequence_stats(dat, w)
            Ce_info_dat <- calc_sequence_stats(dat,Ce.w)
            
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
        vals$og_CeCAI <- Ce_info_dat$CAI
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
    
    ## Outputs: Optimization Mode ----
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
        tibble(Sequence = c("Original", "Original_Ce","Optimized"),
               `GC (%)` = c(vals$og_GC, NA, vals$opt_GC),
               CAI =c(vals$og_CAI, vals$og_CeCAI, vals$opt_CAI))
    })
    
    output$tabs <- renderUI({
        req(input$goButton)
        
        if (isTruthy(input$loadseq$name)) { 
            name <- file_path_sans_ext(input$loadseq$name)
        } else { name <- "SubmittedGene"}
        
        if (as.numeric(input$num_Int) > 0 && !is.null(vals$cds_opt)) {
            output$download_opt <- downloadHandler(
                filename = paste0(name,"_Optimized_NoIntrons.txt"),
                content = function(file){
                    write.table(paste0(vals$cds_opt,
                                       collapse = "")[[1]], 
                                file = file,
                                quote = FALSE,
                                row.names = FALSE,
                                col.names = FALSE)
                })
            
            output$download_intronic_opt <- downloadHandler(
                filename = paste0(name,"_Optimized_WithIntrons.txt"),
                content = function(file){
                    optimize_sequence()
                    tbl <- add_introns()
                    write.table(paste0(tbl, 
                                       collapse = ""), 
                                file = file,
                                quote = FALSE,
                                row.names = FALSE,
                                col.names = FALSE)
                })
            
            tabs <- list(
                tabPanel(title = h6("With Introns"), 
                         textOutput("intronic_opt", 
                                    container = div),
                         downloadButton("download_intronic_opt",
                                        "Download Sequence",
                                        class = "btn-primary")),
                tabPanel(title = h6("Without Introns"), 
                         textOutput("optimizedSequence", 
                                    container = div),
                         downloadButton("download_opt",
                                        "Download Sequence",
                                        class = "btn-primary"))
                
            )
        } else {
            output$download_opt <- downloadHandler(
                filename = paste0(name,"_Optimized_NoIntrons.txt"),
                content = function(file){
                    write.table(paste0(vals$cds_opt,
                                       collapse = ""), 
                                file = file,
                                quote = FALSE,
                                row.names = FALSE,
                                col.names = FALSE)
                })
            tabs <- list(
                tabPanel(title = h6("Without Introns"), 
                         textOutput("optimizedSequence", 
                                    container = div),
                         downloadButton("download_opt",
                                        "Download Sequence",
                                        class = "btn-primary")))
        }
        
        args <- c(tabs, list(id = "box", 
                             # title = tagList(shiny::icon("fas fa-dna"), 
                             #                 "Optimized Sequences"),
                             # side = "right",
                             # width = NULL
                             type = "tabs"
        ))
        
        
        do.call(tabsetPanel, args)
    })
    
    output$seqinfo <- renderUI({
        req(input$goButton)
        
        args <- list(heading = tagList(h5(shiny::icon("fas fa-calculator"),
                                          "Sequence Info")), 
                     status = "primary",
                     tableOutput("info"))
        do.call(panel,args)
    })
    
    
    ## Analysis Mode ----
    source("Server/reset_state.R", local = TRUE)
    
    analyze_sequence <- eventReactive(input$goAnalyze, {
        validate(
            need({isTruthy(input$idtext) | isTruthy(input$loadfile)}, "Please input genes for analysis")
        )
        
        isolate({
            if (isTruthy(input$idtext)){
                genelist <- input$idtext %>%
                    gsub(" ", "", ., fixed = TRUE) %>%
                    str_split(pattern = ",") %>%
                    unlist() %>%
                    as_tibble_col(column_name = "geneID")
                source("Server/analyze_geneID_list.R", local = TRUE)
            } else if (isTruthy(input$loadfile)){
                file <- input$loadfile
                ext <- tools::file_ext(file$datapath)
                validate(need(ext == "csv", "Please upload a csv file"))
                genelist <- read.csv(file$datapath, 
                                     header = FALSE, 
                                     colClasses = "character", 
                                     strip.white = T) %>%
                    as_tibble() %>%
                    pivot_longer(cols = everything(), values_to = "geneID") %>%
                    dplyr::select(geneID)
                source("Server/analyze_geneID_list.R", local = TRUE)
            } 
            
        })
    })
    
    
    ## Outputs: Analysis Mode ----
    output$info_analysis <- renderTable({
        tbl<-analyze_sequence()
        tbl$value},
        striped = T,
        bordered = T
    )
    
    # Generate and Download report
    source("Server/excel_srv.R", local = TRUE)
    
    output$analysisinfo <- renderUI({
        req(input$goAnalyze)
        args <- list(heading = tagList(h5(shiny::icon("fas fa-calculator"),
                                          "Sequence Info")), 
                     status = "primary",
                     withSpinner(tableOutput("info_analysis"),
                                 color = "#2C3E50"),
                     downloadButton(
                         "generate_excel_report",
                         "Create Excel Report"
                     ))
        do.call(panel,args)
    })
    
    
    
    session$onSessionEnded(stopApp)
    
}
## --- end_of_chunk ---

## --- App ---
shinyApp(ui = ui, server = server)
## --- end_of_chunk ---
