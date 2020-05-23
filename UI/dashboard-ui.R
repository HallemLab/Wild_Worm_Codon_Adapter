
header <- dashboardHeader(title =  "",
                          disable = T)

sidebar <- dashboardSidebar(
    disable = T
)

body <- dashboardBody(
    
    fluidRow(
        column(width = 3,
        box(
            title = tagList(shiny::icon("fas fa-sliders-h"),"Inputs & Options"),
            width = NULL,
            status = "warning",
            ## Sequence Upload
            
            ### Name (optional, text input)
            # textInput('seqname',
            #           'Name',
            #           placeholder = c('optional')),
            # 
            
            ### Sequence (text box)
            textAreaInput('seqtext',
                          'Sequence',
                          rows = 10, 
                          resize = "vertical"),
            
            ## Options
            
            ### Option to upload .fasta sequence?
            # fileInput('loadfile',
            #           'Load a .fasta file',
            #           multiple = FALSE),
            
            ### Codon usage threshold (pulldown?)
            
            ### Option to add introns (pulldown)
            selectInput('num_Int',
                        'Introns',
                        choices = 0:3,
                        selected = 3,
                        width = '50%'),
            
            actionButton('goButton',
                         'Optimize!',
                         width = '50%')
        ),
        
        uiOutput("seqinfo")
        
        ),
  
    column(width = 9,
        uiOutput("tabs"))
        
        
    ),
    fluidRow(
        box(title =  tagList(shiny::icon("fas fa-question-circle"),
                             "About this App"),
            width = 12,
            status = "primary",
            
            p('This Shiny app codon optimizes genetic sequences for 
            expression in',em('Strongyloides'), 'species. 
            Codon bias in nematode transcripts can vary as a function of gene 
            expression  levels such that highly expressed genes appeart ot 
            have the greatest degree of codon bias. Therefore, optimization 
              rules are based on the codon usage weights of highly expressed', 
              em('Stronyloides ratti'), 
              'transcripts [1].'),
            
            tags$h4('Methods', class = 'text-success'),
            p(tags$b('CAI (Codon Adaptation Index):'),
              ' Individual codons are scored by calculating their relative 
              adaptivness: (the frequency that codon "i" encodes amino acid 
              "AA") / (the frequency of the codon most often used for encoding 
              amino acid "AA"). Genes are scored by calculating their Codon 
              Adaptation Index: the geometric average of relative adaptiveness 
              of all codons in the gene sequence [2,3]. The CAI is calculated 
              via the seqinr library.'),
            p(tags$b('GC:'),' The fraction of G+C bases of the nucleic acid 
              sequences. Calculated using the seqinr library.'),
            p(tags$b('Inserting Introns:'),' Including synthetic introns into 
              cDNA sequences can signficiant increase gene expression. Intron 
              mediated enchancement of gene expression can be due to a variety 
              of mechanisms, including by increasing the rate of transcription. 
              Intron mediated enhancement occurs in', 
              em('C. elegans'), 
              '[4]. Although intron mediated enhancement has to be specifically 
              studied in ', 
              em('Strongyloides spp.'), 
              ', there is evidence that the prescence of introns does not 
              prevent gene expression (e.g. intron-inclusive eGFP) [5].', 
              tags$br(), 
              tags$br(),
              'Here, the desired number of introns are distributed 
              approximately equidistantly within in DNA sequence. Introns are 
              placed between the 3rd and 4th nucleotide of one of the following 
              sequences: "aagg", "aaga", "cagg", "caga", as in Redemann', 
              em('et al'),' (2011) [6]. If those sequences are not present, 
              introns are placed between the 2nd and 3rd nucleotide of one of 
              the following minimal ', em('C. elegans'), 
              'splice site consensus sequences was used: "aga", "agg" [7]. 
              A maximum of 3 unique introns can be included; intron sequences 
              and order are taken from the Fire Lab Vector Kit (1995) [8].'),
            
            tags$h4('References', class = 'text-success'),
            tags$ol(
                tags$li(tags$a(
                    href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1779591/", 
                    'Mitreva', em('et al'),
                    ' (2006). Codon usage patterns in Nematoda: analysis based 
                    on over 25 million codons in thirty-two species.', 
                    em('Genome Biology'),'7: R75.')),
                tags$li(tags$a(
                    href = "https://pubmed.ncbi.nlm.nih.gov/3547335/",
                    'Sharp and Li, (1987). The Codon Adaptation Index: a 
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
                    href = "https://pubmed.ncbi.nlm.nih.gov/21278743/",
                    'Redemann', em('et al'),' (2011). Codon adaptation-based 
                    control of protein expression in',em('C. elegans'),'.', 
                    em('Nature Methods'),'8: 250-252.')),
                tags$li(tags$a(
                    href = "https://www.ncbi.nlm.nih.gov/books/NBK20075/",
                    em('Cis-'),'Splicing in Worms in',
                    em('C. elegans'), 'II (1997).')),
                tags$li(tags$a(
                    href = "https://media.addgene.org/cms/files/Vec95.pdf", 
                    'Fire Lab Vector Kit (1995).'))
            )
            ),
            box( title =  tagList(shiny::icon("fas fa-poop"),
                                  "Who's responsibe for this"),
                 width = 12,
                 status = "danger",
            
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

ui <- dashboardPage(header, sidebar, body)