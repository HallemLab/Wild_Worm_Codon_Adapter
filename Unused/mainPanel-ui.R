# Main panel for displaying outputs
mainPanel(
       ## Results
       #mainPanel(
       #
       uiOutput("tabs"),
       # tabsetPanel(type = 'tabs',
       # #conditionalPanel(condition = "output.optimizedSequence",
       #                  tabPanel(
       #                     ("Optimized Sequence"),
       #                      div(textOutput("optimizedSequence", container = div), id = "sequence")
       #                      
       #                  ),
       # #),
       # 
       # #conditionalPanel(condition = "output.intronic_opt",
       #                  tabPanel(
       #                      
       #                      ("Optimized Sequence with Introns"),
       #                      div(textOutput("intronic_opt", container = div), id = "sequence")
       #                      
       #                  )
       #                 # )
       # 
       # )
       ### Optimized sequence
       ### Optimization details
       #### GC content of Original vs Optimized
       #### Some kind of interactive mode that allows user to click on a codon and see alternatives, and update results?
       #)
       
)