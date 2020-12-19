# Header ----
navbarPage(h3(em("Strongyloides"), "Codon Adapter"),
           windowTitle = "Str Codon Adapter",
           theme = shinytheme("flatly"),
           collapsible = TRUE,
           id = "tab",
           
           
           # Optimize Sequence Mode Tab ----
           tabPanel(h4("Optimize Sequences"),
                    value = "optimization",
                    fluidRow(
                        column(width = 3,
                               panel(
                                   heading = tagList(h5(shiny::icon("fas fa-sliders-h"),"Inputs & Options")),
                                   
                                   status = "primary",
                                   
                                   h5('Add Sequence', class = 'text-danger', style = "margin: 0px 0px 5px 0px"),
                                   p(tags$em('Please input a cDNA or amino acid sequence for optimization. Alternatively, upload a gene sequence file (.gb, .fasta, or .txt files accepted).', style = "color: #7b8a8b")),
                                   p(tags$em(tags$b('Note: Please hit the Clear button if switching between typing and uploading inputs.', style = "color: #F39C12"))),
                                   
                                   ### Sequence (text box)
                                   textAreaInput('seqtext',
                                                 h6('Sequence (DNA or AA)'),
                                                 rows = 10,
                                                 resize = "vertical"),
                                   
                                   ### Upload list of sequences
                                   uiOutput('optimization_file_upload'),
                                   
                                   ### Option to add introns (pulldown)
                                   selectInput('num_Int',
                                               h6('Introns'),
                                               choices = 0:3,
                                               selected = 3,
                                               width = '40%'),
                                   
                                   actionButton('goButton',
                                                'Submit',
                                                #width = '40%',
                                                class = "btn-primary",
                                                icon = icon("fas fa-share")),
                                   
                                   actionButton('resetOptimization', 'Clear',
                                                icon = icon("far fa-trash-alt"))
                               )
                               
                               
                        ),
                        
                        column(width = 4,
                               uiOutput("seqinfo")
                        ),
                        
                        column(width = 9,
                               conditionalPanel(condition = "input.goButton",
                                                panel(heading = tagList(h5(shiny::icon("fas fa-dna"),
                                                                           "Optimized Sequences")),
                                                      status = "primary",
                                                      uiOutput("tabs"))
                               ))
                        
                        
                    )
           ),
           # Analysis Mode Tab ---- 
           tabPanel(h4("Analyze Sequences"),
                    value = "analysis",
                    fluidRow(
                        column(width = 3,
                               panel(heading = tagList(h5(shiny::icon("fas fa-sliders-h"),"Inputs & Options")),
                                     width = NULL,
                                     status = "primary",
                                     ## GeneID Upload
                                     h5('Pick Genes', class = 'text-danger', style = "margin: 0px 0px 5px 0px"),
                                     p(tags$em('Gene stable IDs starting with SSTP, SRAE, SPAL, or SVEN; WB gene IDs for S. ratti and C. elegans genes; or C. elegans gene names with a "Ce-" prefix (e.g. Ce-ttx-1) can be provided either through direct input via the textbox below, or in bulk as a .csv file of gene IDs. If using the text box, please separate search terms by a comma.', style = "color: #7b8a8b")),
                                     p(tags$em('Alternatively, users may directly provide cDNA sequences for analysis, either as a 2-column .csv file listing geneIDs and cDNA sequences, or a .fa file containing named cDNA sequences.', style = "color: #7b8a8b")),
                                     p(tags$em('Example .csv files can be downloaded using the Data Availability panel in the About tab', style = "color: #7b8a8b")),
                                     p(tags$em(tags$b('Note: Please hit the Clear button if switching between typing and uploading inputs.', style = "color: #F39C12"))),
                                     
                                     ### GeneID (text box)
                                     textAreaInput('idtext',
                                                   h6('Gene Stable IDs'),
                                                   rows = 5, 
                                                   resize = "vertical"),
                                     
                                     uiOutput('analysis_file_upload'),
                                     
                                     actionButton('goAnalyze',
                                                  'Submit',
                                                  # width = '40%',
                                                  class = "btn-primary",
                                                  icon = icon("fas fa-share")),
                                     
                                     actionButton('resetAnalysis', 'Clear',
                                                  icon = icon("far fa-trash-alt"))
                                     
                               )
                        ),
                        column(width = 7, 
                               uiOutput("analysisinfo")
                        )
                        
                        
                    )
           ),
           ## About Tab ----
           tabPanel(h4("About"),
                    value = "about",
                    fluidRow(
                        column(12,
                               panel(heading =  tagList(h5(shiny::icon("fas fa-question-circle"),
                                                           "App Overview")),
                                     status = "primary",
                                     id = "About_Overview",
                                     includeMarkdown('UI/README/README_Features.md')
                               )
                        )),
                    fluidRow(
                        column(8,
                               panel(heading =  tagList(h5(shiny::icon("fas fa-chart-line"),
                                                           "Optimization Methods")),
                                     status = "primary",
                                     id = "About_Analysis_Methods",
                                     tabsetPanel(
                                         type = "pills",
                                         
                                         tabPanel(
                                             title = "Codon Adaptation Index",
                                             includeMarkdown('UI/README/README_Methods_CAI.md')
                                         ),
                                         tabPanel(
                                             title = "GC Ratio",
                                             includeMarkdown('UI/README/README_Methods_GC.md')
                                         ),
                                         tabPanel(
                                             title = "Artificial Introns",
                                             includeMarkdown('UI/README/README_Methods_Introns.md')
                                         )
                                     )
                               )
                        ),
                        column(4,
                               panel(heading =  tagList(h5(shiny::icon("fas fa-cloud-download-alt"),
                                                           "Data Availability")),
                                     status = "primary",
                                     p('The following datasets used can be
        downloaded using the dropdown menu and download button below:',
                                       tags$ol(
                                           tags$li(tags$em('C. elegans'), 'codon usage counts (.csv)'),
                                           tags$li(tags$em('S. ratti'), 'codon usage counts (.csv)'),
                                           tags$li('Multi-species codon frequency chart (.csv)'),
                                           tags$li('Example geneID List (.csv)'),
                                           tags$li('Example 2-column geneID/cDNA List (.csv)')
                                       )),
                                     
                                     pickerInput("which.Info.About",
                                                 NULL, 
                                                 choices =  c('Ce codon usage counts',
                                                              'Sr codon usage counts',
                                                              "Multi-species codon frequency chart",
                                                              "Example geneID List",
                                                              "Example 2-column geneID/cDNA List"),
                                                 options = list(style = 'btn btn-primary',
                                                                title = "Select a file to download")),
                                     uiOutput("StudyInfo.panel.About")
                                     
                               )
                        ),
                        column(4,
                               ## App Credits ----
                               panel( heading =  tagList(h5(shiny::icon("fas fa-drafting-compass"),
                                                            "Authors")),
                                      
                                      status = "primary",
                                      p('This app was created by', 
                                        tags$a(
                                            href = "https://scholar.google.com/citations?user=uSGqqakAAAAJ&hl=en", 
                                            'Astra S. Bryant, PhD'),'for the', 
                                        tags$a(href="http://www.hallemlab.com/",'Hallem Lab'), 'at UCLA.', 
                                        tags$br(),
                                        tags$br(),
                                        'The underlying code is avaliable on Github:', 
                                        tags$a(
                                            href = "https://github.com/astrasb/Strongyloides_Codon_Adapter", 
                                            'https://github.com/astrasb/Strongyloides_Codon_Adapter', target = "blank")
                                      ))
                        )
                    )
           )
           
)



