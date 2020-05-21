# Main panel for displaying outputs
column(8,
       ## Results
       #mainPanel(
       
       div(textOutput("OG_seq", container = div), id = "sequence")
       
       
       ### Optimized sequence
       ### Optimization details
       #### GC content of Original vs Optimized
       #### Some kind of interactive mode that allows user to click on a codon and see alternatives, and update results?
       #)
    
)