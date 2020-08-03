navbarPage(h4(em("Strongyloides"), "Codon Adapter"),
           windowTitle = "Strongyloides Codon Adapter",
           theme = shinytheme("flatly"),
           collapsible = TRUE,
           id = "tab",
           # Body: Optimize Sequence Mode ----
           tabPanel(h5("Optimize Sequences"),
                    value = "optimization",
                    fluidRow(
                      column(width = 3,
                             panel(
                               heading = tagList(strong(shiny::icon("fas fa-sliders-h"),"Inputs & Options")),
                               width = NULL,
                               status = "primary",
                               
                               ### Sequence (text box)
                               textAreaInput('seqtext',
                                             'Sequence (Nucleotide or Amino Acid)',
                                             rows = 10,
                                             resize = "vertical"),
                               
                               ### Option to add introns (pulldown)
                               selectInput('num_Int',
                                           'Introns',
                                           choices = 0:3,
                                           selected = 3,
                                           width = '40%'),
                               
                               actionButton('goButton',
                                            'Submit',
                                            width = '40%',
                                            class = "btn-primary",
                                            icon = icon("fas fa-share"))
                             ),
                             
                             uiOutput("seqinfo")
                             
                             
                      ),
                      
                      column(width = 9,
                             conditionalPanel(condition = "input.goButton",
                             panel(heading = tagList(strong(shiny::icon("fas fa-dna"),
                                                    "Optimized Sequences")),
                                   status = "primary",
                             uiOutput("tabs"))
                      ))
                      
                                   
                    )
           ),
           # Body: Analysis Mode ---- 
           tabPanel(h5("Analyze Sequences"),
                    value = "analysis",
                    fluidRow(
                      column(width = 3,
                             panel(heading = tagList(strong(shiny::icon("fas fa-sliders-h"),"Inputs & Options")),
                                   width = NULL,
                                   status = "primary",
                                   ## GeneID Upload
                                   
                                   ### GeneID (text box)
                                   textAreaInput('idtext',
                                                 'Gene Stable IDs (comma separated)',
                                                 rows = 10, 
                                                 resize = "vertical"),
                                   
                                   
                                   ### Upload list of GeneIDs
                                   fileInput('loadfile',
                                             'Gene Stable ID List (.csv)',
                                             multiple = FALSE),
                                   
                                   actionButton('goAnalyze',
                                                'Submit',
                                                width = '40%',
                                                class = "btn-primary",
                                                icon = icon("paper-plane"))
                                   
                             )
                      ),
                      column(width = 4,
                             
                             uiOutput("analysisinfo")
                             
                             #conditionalPanel(condition = "output.analysisinfo")
                      )
                      
                      
                    )
           ),
           ## About this app ----
           tabPanel(h5("About"),
                    value = "about",
                    fluidRow(
                      column(12,
                             panel(heading =  tagList(strong(shiny::icon("fas fa-question-circle"),
                                                      "About this App")),
                                   
                                   status = "primary",
                                   
                                   p('This Shiny app codon optimizes genetic sequences for 
            expression in',em('Strongyloides'), 'species. It accepts either 
            nucleotide or amino acid sequences, and will generate an optimized
            nucleotide sequence with and without the desired number of 
            synthetic introns.', br(),
                                     'Codon bias in nematode transcripts can vary as a function of gene 
            expression  levels such that highly expressed genes appear to 
            have the greatest degree of codon bias. Therefore, optimization 
              rules are based on the codon usage weights of highly expressed', 
                                     em('Stronyloides ratti'), 
                                     'transcripts [1].', br(),
                                     'This app can also be used in an analysis mode that reports the 
        endogenous codon optimization for a given gene. Stable Gene IDs with 
        prefixes "SSTP", "SRAE", or "WB" can be provided either through direct input 
        via the provided textbox, or in bulk as a comma separated text file.
        The analysis mode additionally reports the codon adaptation index for given 
        genes relative to the codon usage weights of highly expressed ', 
                                     em('C. elegans'), 'genes [2].'),
                                   tags$h4('Methods', class = 'text-danger'),
                                   p(tags$b('CAI (Codon Adaptation Index):'),
                                     ' Individual codons are scored by calculating their relative 
              adaptivness: (the frequency that codon "i" encodes amino acid 
              "AA") / (the frequency of the codon most often used for encoding 
              amino acid "AA"). Genes are scored by calculating their Codon 
              Adaptation Index: the geometric average of relative adaptiveness 
              of all codons in the gene sequence [3,4]. The CAI is calculated 
              via the seqinr library.'),
                                   p(tags$b('GC:'),' The fraction of G+C bases of the nucleic acid 
              sequences. Calculated using the seqinr library.'),
                                   p(tags$b('Inserting Introns:'),' Including synthetic introns into 
              cDNA sequences can significantly increase gene expression. Intron 
              mediated enchancement of gene expression can be due to a variety 
              of mechanisms, including by increasing the rate of transcription. 
              Intron mediated enhancement occurs in', 
                                     em('C. elegans'), 
                                     '[5]. Although intron mediated enhancement has to be specifically 
              studied in ', 
                                     em('Strongyloides spp.'), 
                                     ', there is evidence that the prescence of introns does not 
              prevent gene expression (e.g. intron-inclusive eGFP) [6].
              Here, the desired number of introns are inserted 
              within in DNA sequence, up to a maximum
              of 3 unique introns. Intron sequences and order are taken from the 
              Fire Lab Vector Kit (1995) [7].',
                                     tags$br(),
                                     em('Intron Number and Spacing:'),
                                     'The Fire lab established three unique introns, spaced
              equidistantly within a gene as canon [7]; this configuration is 
              thus set as default, and is recommended. In', em('C. elegans'), 
                                     'the location of the intron site influences the degree of 
              intron mediated enhancement, such that a single 5′-intron is more 
              effective than a single 3′-intron. Therefore when only 1 or 2
              introns are desired, 3 possible intron insertion sites are 
              identified, and filled as needed, starting from the 5′ site.',
                                     tags$br(),
                                     em('Identifying Intron Insertion Sites:'), 'Introns are 
              placed between the 3rd and 4th nucleotide of one of the following 
              sequences: "aagg", "aaga", "cagg", "caga", as in Redemann', 
                                     em('et al'),' (2011) [8]. If those sequences are not present, 
              introns are placed between the 2nd and 3rd nucleotide of one of 
              the following minimal ', em('C. elegans'), 
                                     'splice site consensus sequences was used: "aga", "agg" [9].'),
                                   ## References ----        
                                   tags$h4('References', class = 'text-danger'),
                                   tags$ol(
                                     tags$li(tags$a(
                                       href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/", 
                                       'Mitreva', em('et al'),
                                       ' (2006). Codon usage patterns in Nematoda: analysis based 
                    on over 25 million codons in thirty-two species.', 
                                       em('Genome Biology'),'7: R75.')),
                                     tags$li(tags$a(
                                       href = "https://www.ncbi.nlm.nih.gov/books/NBK20194/", 
                                       'Sharp and Bradnam (1997). Appendix 3: Codon Usage in',
                                       em('C. elegans,'),'In:',em('C. elegans'),'II. 2nd edition;
            Eds: Riddle, Blumenthal, Meyer', em('et al.'), 'Cold Spring
            Harbor Laboratory Press.')),
                                     tags$li(tags$a(
                                       href = "https://pubmed.ncbi.nlm.nih.gov/3547335/",
                                       'Sharp and Li (1987). The Codon Adaptation Index: a 
                    measure of directional synonymous codon usage bias, and its 
                    potential applications.', 
                                       em('Nucleic Acids Research'),'15: 1281-95.')),
                                     tags$li(tags$a(
                                       href = "http://www.ncbi.nlm.nih.gov/pubmed/12682375",
                                       'Jansen', em('et al'),' (2003). Revisiting the codon 
                    adaptation index from a whole-genome perspective: analyzing 
                    the relationship between gene expression and codon 
                    occurrence in yeast using a variety of models.', 
                                       em('Nucleic Acids Research'),'31: 2242-51.')),
                                     tags$li(tags$a(
                                       href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6591249/",
                                       'Crane', em('et al'),' (2019).',em('In vivo'),
                                       'measurements reveal a single 5′-intron is sufficient to 
                    increase protein expression level in', 
                                       em('Caenorhabditis elegans'),'.', 
                                       em('Scientific Reports'), '9: 9192.')),
                                     tags$li(tags$a(
                                       href = "https://pubmed.ncbi.nlm.nih.gov/17945217/",
                                       'Junio', em('et al'),' (2008).',
                                       em('Strongyloides stercoralis'),'cell- and tissue-specific 
                    transgene expression and co-transformation with vector 
                    constructs incorporating a common multifunctional 3′ UTR', 
                                       em('Experimental Parasitology'),'118: 253-265.')),
                                     tags$li(tags$a(
                                       href = "https://media.addgene.org/cms/files/Vec95.pdf", 
                                       'Fire Lab Vector Kit (1995).')),
                                     tags$li(tags$a(
                                       href = "https://pubmed.ncbi.nlm.nih.gov/21278743/",
                                       'Redemann', em('et al'),' (2011). Codon adaptation-based 
                    control of protein expression in',em('C. elegans'),'.', 
                                       em('Nature Methods'),'8: 250-252.')),
                                     tags$li(tags$a(
                                       href = "https://www.ncbi.nlm.nih.gov/books/NBK20075/",
                                       em('Cis-'),'Splicing in Worms in',
                                       em('C. elegans'), 'II (1997).'))
                                   )
                             ),
                             
                             ## App Credits ----
                             panel( heading =  tagList(strong(shiny::icon("fas fa-poop"),
                                                       "Who is responsibe for this?")),
                                    
                                    status = "primary",
                                    
                                    'This app was created by', 
                                    tags$a(
                                      href = "https://scholar.google.com/citations?user=uSGqqakAAAAJ&hl=en", 
                                      'Astra S. Bryant, PhD'),'for the', 
                                    tags$a(href="http://www.hallemlab.com/",'Hallem Lab'), 'at UCLA.', 
                                    tags$br(),
                                    'The underlying code is avaliable on Github:', 
                                    tags$a(
                                      href = "https://github.com/astrasb/Strongyloides_Codon_Adapter", 
                                      'https://github.com/astrasb/Strongyloides_Codon_Adapter')
                             )
                      )
                    )
           )
           
)



