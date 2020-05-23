#sidebar-ui
sidebarPanel(
       wellPanel(
           ## Sequence Upload
           div(h4('Sequence')),
           ### Name (optional, text input)
           textInput('seqname',
                     'Name',
                     placeholder = c('optional')),
           
           ### Sequence (text box)
           textAreaInput('seqtext',
                         'Sequence',
                         rows = 6, 
                         resize = "vertical"),
           
           ### Option to upload .fasta sequence?
           # fileInput('loadfile',
           #           'Load a .fasta file',
           #           multiple = FALSE),
           
           ## Options
           div(h4('Options')),
           ### Codon usage threshold (pulldown?)
           
           ### Option to add introns (pulldown)
           selectInput('num_Int',
                       'Introns',
                       choices = 0:3,
                       selected = 3,
                       width = '25%'),
           
           actionButton('goButton',
                        'Optimize!',
                        width = '25%')
       )
    
)
