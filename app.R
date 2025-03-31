# Wild Worm Codon Adapter Shiny App

## --- Libraries ---
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(seqinr)
    library(htmltools)
    library(shinyWidgets)
    library(shinythemes)
    library(magrittr)
    library(tidyverse)
    library(openxlsx)
    library(BiocManager)
    library(biomaRt)
    library(read.gb)
    library(tools)
    library(DT)
    library(ggplot2)
    library(markdown)
    library(cubar)
    library(Biostrings)
    source('Server/calc_sequence_stats.R')
    source('Server/detect_language.R',local = TRUE)
    source("Server/analyze_geneID_list.R", local = TRUE)
    source("Server/analyze_cDNA_list.R", local = TRUE)
    source("Server/generate_usage_table.R", local = TRUE) 
})

## Increase the maximum file upload size to 30 MB
options(shiny.maxRequestSize = 45*1024^2)

## --- end_of_chunk ---

## --- Background ---
## Load optimal codon usage charts for species
## For all species: 
## Generate table of relative adaptiveness for each codon that are readible by the seqinr::cai function
## Generate lookup table for codon optimization
source('Static/load_preprocess_data.R', local = TRUE)

## --- end_of_chunk ---

## ---- UI ----
ui <- fluidPage(
    
    useShinyjs(),
    tags$head(
        HTML('<base target="_blank">')
    ),
    
    source('UI/WW_Codon_Adapter_ui.R', local = TRUE)$value,
    
    source('UI/custom_css.R', local = T)$value
)

## --- end_of_chunk ---

## ---- Server ----
# Define server logic
server <- function(input, output, session) {
    
    vals <- reactiveValues()
    
    # The bits that have to be responsive start here.
    source("Server/reset_state.R", local = TRUE)
    
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
            if (tools::file_ext(input$loadseq$name) == "gb") {
                dat <- suppressMessages(read.gb(input$loadseq$datapath, Type = "nfnr")) 
                dat <- dat[[1]]$ORIGIN %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else if (tools::file_ext(input$loadseq$name) == "fasta" |
                       tools::file_ext(input$loadseq$name) == "fa") {
                dat <- suppressMessages(read.fasta(input$loadseq$datapath,
                                                   seqonly = T)) 
                dat <- dat[[1]] %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else if (file_ext(input$loadseq$name) == "txt") {
                dat <- suppressWarnings(read.table(input$loadseq$datapath,
                                                   colClasses = "character",
                                                   sep = "")) 
                dat <- dat[[1]] %>%
                    tolower %>%
                    trimSpace %>%
                    s2c
            } else {
                validate(need({file_ext(input$loadseq$name) == "txt" | 
                        file_ext(input$loadseq$name) == "fasta" |
                        file_ext(input$loadseq$name) == "fa" |
                        file_ext(input$loadseq$name) == "gb"}, "File type not recognized. Please try again."))
            }
        }
        
        # Save original sequence
        vals$og_sequence <- dat %>%
            toupper() %>%
            seqinr::splitseq()
        
        ## Parse which codon optimization rule to apply
        species_sel <- switch(input$sp_Opt,
                              "Strongyloides" = "Sr",
                              "Pristionchus" = "Pp",
                              "Nippostrongylus" = "Nb",
                              "Parastrongyloides" = "Pt",
                              "Brugia" = "Bm",
                              "C. elegans" = "Ce",
                              "None" = "none",
                              "Custom" = "custom")
        
        ### User-provided optimal codon list or a FASTA file of coding sequences to generate an optimal codon list
        if (species_sel == "custom") {
            validate(need(input$loadlut, "Please use the file upload control to upload either a custom optimal codon list or a .fasta file of coding sequences that can be used to estimate optimal codons."))
            validate(need({file_ext(input$loadlut$name) == "csv" | file_ext(input$loadlut$name) == "fasta" | file_ext(input$loadlut$name) == "fa"}, 
                          "Please provide either a .csv file or a .fasta file."))
            # If users have provided a 2 column matrix with AA and Codon sequence
            if (file_ext(input$loadlut$name) == "csv"){
          
            custom.codons <- suppressWarnings(read.csv(input$loadlut$datapath, 
                                                       header = FALSE, 
                                                       colClasses = "character", 
                                                       strip.white = T)) %>%
                as_tibble() %>%
                dplyr::filter(!grepl('codon|aa', V1, ignore.case = T))
            validate(need({ncol(custom.codons) == 2},
                          "Please provide a 2-column file."))
            
            # Rename columns based on length of strings
            col.lengths <- summarize_each(custom.codons, str_length) %>%
                summarize_each(dplyr::first)
            
            flag.1 <- which(col.lengths$V1 ==1 && col.lengths$V2 == 3)
            flag.2 <- which(col.lengths$V1 ==3 && col.lengths$V2 == 1)
            
            validate(need({isTruthy(flag.1) | isTruthy(flag.2)},
                          "Column values appear to have incorrect character lengths.
                     Please ensure that one column contains 1-letter amino acid codes,
                     and another column contains 3-letter codon sequences."))
            
            lut <- custom.codons %>% rename_with( ~ case_when(
                col.lengths[.x] == 3 ~ "Codon",
                col.lengths[.x] == 1 ~ "AA")
            ) %>%
                dplyr::arrange(AA)
           
            } else{
                withProgress({
                opt_codons <- generate_usage_table(input$loadlut$datapath) %>%
                    as_tibble()
                }, message = "Calculating Codon Usage...")
            }
            
        ### Built-in optimal codons         
        } else {
            lut <- lut.tbl %>%
                dplyr::select(AA, contains(species_sel)) %>%
                dplyr::rename(Codon = contains(species_sel))
        }
        
        w <- w.tbl %>%
            dplyr::select(starts_with(species_sel)) %>%
            pull()
        
        ## Determine whether input sequence in nucleotide or amino acid
        lang <- detect_language(dat)
        
        ## Calculate info for original sequence
        if (species_sel == "none"){
            info_dat <- list("GC" = NA, "CAI" = NA)
        } else {
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
        }}
        
        ## Codon optimize back to nucleotides
        if (species_sel != "none"){
            source('Server/codon_optimize.R', local = TRUE)
            ## Calculate info for optimized sequence
            info_opt <- calc_sequence_stats(opt, w)
        } else {
            cds_opt <- seqinr::splitseq(dat) %>% toupper()
            info_opt <- list("GC" = NA, "CAI" = NA)
            }
        
        vals$og_GC <- info_dat$GC
        vals$og_CAI <- info_dat$CAI
        vals$opt_GC <- info_opt$GC
        vals$opt_CAI <- info_opt$CAI
        vals$cds_opt <- cds_opt
    })
    
    add_introns <- eventReactive (input$goButton, {
        req(vals$cds_opt)
        cds_opt <- vals$cds_opt
        ## Parse which intron set to insert
        intron_sel <- switch(input$type_Int,
                             "Canonical (Fire)" = "Canon",
                             "PATC-rich" = "PATC",
                             "Pristionchus" = "Pristionchus",
                             "Custom" = "custom"
        )
        ### Custom user-provided intron set
        if (intron_sel == "custom") {
            validate(need(input$loadintron, "Please upload a custom optimal codon list using the file upload control."))
            
            file <- input$loadintron
            ext <- tools::file_ext(file$datapath)
            validate(need(ext == "fa" | ext == "fasta", 
                          "Please upload a fasta file"))
            
            syntrons <- suppressMessages(read.fasta(input$loadintron$datapath,
                                                    as.string = T,
                                                    set.attributes = F))
        ### Built-in intron set 
        } else {
            syntrons <- syntrons.list[[intron_sel]]
        }
        ## Detect insertion sites for artificial introns
        source('Server/locate_intron_sites.R', local = TRUE)
        
        ## Insert canonical artificial introns
        if (!is.na(loc_iS[[1]])){
            source('Server/insert_introns.R', local = TRUE)
        } else cds_wintrons <- c("Error: no intron insertion sites are 
                                 avaliable in this sequence.")
        
        return(cds_wintrons)
    })
    
    ## Outputs: Optimization Mode ----
    
    ## Reactive run of function that generates optimized sequence without added artificial introns
    ## Can be assigned to an output
    output$optimizedSequence <- renderText({
        optimize_sequence()
    })
    
    ## Reactive run of function that generates optimized sequence without added artificial introns
    ## Can be assigned to an output
    output$originalSequence <- renderText({
        optimize_sequence()
        vals$og_sequence
    })
    
    ## Reactive run of function that generates optimized sequence with added artificial introns
    ## Can be assigned to an output
    output$intronic_opt <- renderText({
        if(as.numeric(input$num_Int) > 0){
            optimize_sequence()
            add_introns()
        }
    })
    
    ## Display optimized sequence with and without added artificial introns in a tabbed panel
    ## Also display original non-optimized sequence in a panel
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
                                        class = "btn-primary")),
                tabPanel(title = h6("Original"), 
                         textOutput("originalSequence", 
                                    container = div))
                
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
                                        class = "btn-primary")),
                tabPanel(title = h6("Original"), 
                         textOutput("originalSequence", 
                                    container = div)))
        }
        
        args <- c(tabs, list(id = "box", 
                             type = "tabs"
        ))
        
        
        do.call(tabsetPanel, args)
    })
    
    ## Make a reactive table containing calculated GC content and CAI values that can be assigned to an output slot
    output$info <- renderTable({
        tibble(Sequence = c("Original", "Optimized"),
               GC = c(vals$og_GC, vals$opt_GC),
               CAI =c(vals$og_CAI, vals$opt_CAI))
    },
    caption = paste(
        "GC = fractional G+C content", tags$br(),
        "CAI = Codon adaptation index score relative to",
        "user-selected codon usage rules"
    ),
    striped = T,
    bordered = T)
    
    # Display Calculated Sequence Values (e.g. GC content, CAI indeces)
    output$seqinfo <- renderUI({
        req(input$goButton)
        
        args <- list(heading = tagList(h5(shiny::icon("fas fa-calculator"),
                                          "Sequence Info")), 
                     status = "primary",
                     tableOutput("info")
                     
        )
        do.call(panel,args)
    })
    
    
    ## Analysis Mode ----
    
    # Primary reactive element in the Analysis Mode
    analyze_sequence <- eventReactive(input$goAnalyze, {
        validate(
            need({isTruthy(input$idtext) | isTruthy(input$loadfile) | isTruthy(input$cDNAtext)}, "Please input stable gene/transcript IDs or sequences for analysis")
        )
        vals$geneIDs <- NULL
        isolate({
            if (isTruthy(input$idtext)){
                # If user provides input using the gene/transcript ID textbox, 
                # assume they provided a list of gene/transcript IDs
                genelist <- input$idtext %>%
                    gsub(" ", "", ., fixed = TRUE) %>%
                    str_split(pattern = ",") %>%
                    unlist() %>%
                    as_tibble_col(column_name = "queryID")
                
                info.gene.seq<-analyze_geneID_list(genelist, vals)
                
            } else if (isTruthy(input$cDNAtext)){
                # If user provides input using the coding sequence textbox, 
                # assume they provided a transgene coding sequence 
                
                genelist <- input$cDNAtext %>%
                    gsub(" ", "", ., fixed = TRUE) %>%
                    as_tibble_col(column_name = "coding") %>%
                    dplyr::mutate(geneID = "submittedGene",
                                  .before = coding)
                
                info.gene.seq <- analyze_cDNA_list(genelist, vals)
                
            } else if (isTruthy(input$loadfile)){
                file <- input$loadfile
                ext <- tools::file_ext(file$datapath)
                validate(need(ext == "csv" | ext == "fa" | ext == "fasta", 
                              "Please upload a csv or fasta file"))
                
                if (ext == "fa" | ext == "fasta") {
                    # If user provides input using the file upload, &
                    # if it's a .fa file assume they are providing
                    # named coding sequences
                    dat <- suppressMessages(read.fasta(input$loadfile$datapath,
                                                       as.string = T,
                                                       set.attributes = F))
                    genelist <- dat %>%
                        as_tibble() %>%
                        pivot_longer(cols = everything(),
                                     names_to = "geneID", 
                                     values_to = "coding")
                    
                    info.gene.seq <- analyze_cDNA_list(genelist, vals)
                    
                } else if (tools::file_ext(input$loadfile$name) == "csv") {
                    # If user provides input using the file upload, &
                    # if it's a .csv file assume they either provided 
                    # a list of geneIDs, or 
                    # a 2 column matrix with geneID and coding sequence
                    
                    genelist <- suppressWarnings(read.csv(file$datapath, 
                                                          header = FALSE, 
                                                          colClasses = "character", 
                                                          strip.white = T)) %>%
                        as_tibble() 
                    
                    # Remove input rows where the geneID includes the word "gene" or "transcript" - we are assuming
                    # that such rows will be header rows.
                    genelist <- dplyr::filter(genelist, !grepl('gene|transcript', V1))
                    # Assume that an input with two columns and more than one 
                    # row is a list of geneID/coding pairs
                    if (ncol(genelist) > 1 & nrow(genelist) > 1) {
                        genelist <- genelist %>%
                            dplyr::rename(geneID = V1, coding = V2)
                        info.gene.seq <- analyze_cDNA_list(genelist,vals)
                        
                        #Assume every other input structure is a list of geneIDs 
                    } else {
                        genelist <- genelist %>%
                            pivot_longer(cols = everything(), values_to = "queryID") %>%
                            dplyr::select(queryID)
                        info.gene.seq<-analyze_geneID_list(genelist, vals)
                    }
                } 
            }
            
        })
    })
    
    # Datatable of analysis values
    output$info_analysis <- renderDT({
        tbl<-analyze_sequence()
        info_analysis.DT <- tbl %>%
            DT::datatable(rownames = FALSE,
                          caption = tags$caption(
                              style = 'caption-side: bottom; text-align: left;',
                              "GC = fractional G-C content", tags$br(),
                              "Sr_CAI = CAI score relative to",
                              "codon usage in highly expressed",
                              htmltools::tags$em("S. ratti"),
                              "sequences", tags$br(),
                              "Ce_CAI = CAI score relative to",
                              "codon usage in highly expressed",
                              tags$em("C. elegans"),"genes", tags$br(),
                              "Bm_CAI = CAI score relative to",
                              "codon usage in highly expressed",
                              tags$em("B. malayi"), "genes", tags$br(),
                              "Nb_CAI = CAI score relative to",
                              "codon usage in highly expressed",
                              tags$em("N. brasiliensis"), "genes", tags$br(),
                              "Pp_CAI = CAI score relative to",
                              "codon usage in highly expressed",
                              tags$em("P. pacificus"), "genes", tags$br(),
                              "Pt_CAI = CAI score relative to",
                              "codon usage in",
                              tags$em("P. trichosuri"), "genes"),
                          
                          options = list(scrollX = TRUE,
                                         scrollY = '400px',
                                         scrollCollapse = TRUE,
                                         
                                         pageLength = 10,
                                         lengthMenu = c("5",
                                                        "10",
                                                        "25",
                                                        "50")))
        
        info_analysis.DT <- info_analysis.DT %>%
            DT::formatRound(columns = (ncol(tbl)-5):ncol(tbl), digits = 2)
        
        info_analysis.DT
        
    })
    
    
    # Generate Downloadable Report
    source("Server/generate_excel_report.R")
    
    #Shiny output for analysis datatable
    output$downloadbutton_AM <- renderUI({
        req(input$goAnalyze, vals$geneIDs)
       
        # Select data columns to download, depending on user inputs
        download.tbl <- vals$geneIDs %>% dplyr::select(any_of(c("geneID", 
                                                                "transcriptID",
                                                                input$download_options)))
        
        output$generate_excel_report <- generate_excel_report(download.tbl)
        downloadButton(
            "generate_excel_report",
            "Download",
            class = "btn-primary"
        )
    })
    ## Estimation Mode ----
    # Primary reactive element in the Estimation Mode
    estimate_usage <- eventReactive (input$goCalculate, {
        file <- input$loadCDS
        ext <- tools::file_ext(file$datapath)
        validate(need(input$loadCDS, "Please upload a CDS fasta file using the file upload control."))
        validate(need(ext == "fa" | ext == "fasta", 
                      "Please upload a fasta file."))
       
        opt_codons <- generate_usage_table(file$datapath)

    })
    
    ## Reactive run of function that uses CDS list to estimate optimal codons
    ## Can be assigned to an output
    output$estimated_usage <- renderDT({
        req(input$goCalculate)
        withProgress({
        opt_codons<-estimate_usage()
        vals$opt_codons <- opt_codons
        
        opt_codons.DT <- opt_codons %>%
            DT::datatable(rownames = FALSE,
                          options = list(pageLength = 24))
        }, message = "Calculating Codon Usage...")
    })
    
    #Shiny output for estimation datatable
    output$downloadbutton_EM <- renderUI({
        req(input$goCalculate, vals$opt_codons)
        
        name <- file_path_sans_ext(input$loadCDS$name)
        
        output$download_usage_tbl <- downloadHandler(
        filename = paste0(name,"_customCodonLUT.csv"),
        content = function(file){
            write_csv(vals$opt_codons, file)
        })
        
        downloadButton(
            "download_usage_tbl",
            "Download",
            class = "btn-primary"
        )
    
    })
    
    # About Tab: Download codon usage charts ----
    StudyInfo.filename.About <- reactive({
        Info.file <- switch(input$which.Info.About,
                            `Multi-species codon frequency table` = "./www/rel_adaptiveness_chart.csv",
                            `Multi-species optimal codon table` = "./www/codon_lut.csv",
                            `Example custom preferred codon table`= "./www/example_custom_lut.csv",
                            `Example geneID list` = "./www/example_geneList.csv",
                            `Example 2-column geneID/sequence list` = "./www/example_2col_sequenceList.csv",
                            `Example custon intron list` = "./www/example_custom_intron_file.fasta")
        
        Info.file
        
    })
    
    output$StudyInfo.panel.About <- renderUI({
        output$StudyInfo.file.About <- downloadHandler(
            filename = function() {
                Info.file <- StudyInfo.filename.About()
                str_remove(Info.file, './www/')
            },
            content = function(file){
                Info.file <- StudyInfo.filename.About()
                file.copy(Info.file, file)
            }
        )
        
        downloadButton("StudyInfo.file.About","Download",
                       class = "btn-primary")
    })
    
    session$onSessionEnded(stopApp)
    
}
## --- end_of_chunk ---

## --- App ---
shinyApp(ui = ui, server = server)
## --- end_of_chunk ---
