## Optimization Mode: Generate/Reset Sequence File Upload ----
output$optimization_file_upload <- renderUI({
    input$resetOptimization
    fileInput('loadseq',
              h6('Sequence file (.gb, .fasta, .txt)'),
              multiple = FALSE)
})

## Optimization Mode: Generate/Reset Custom Optimal Codon Lookup Table File Upload ----
output$custom_lut_upload <- renderUI({
    input$resetOptimization
    fileInput('loadlut',
              h6('Custom Optimal Codon Rule (.csv)'),
              multiple = FALSE)
})

## Optimization Mode: Reset Sequence Text Box ----
observeEvent(input$resetOptimization,{
    updateTextAreaInput(session,"seqtext",value = "")
})

## Analysis Mode: Generate/Reset Gene File Upload ----
output$analysis_file_upload <- renderUI({
    input$resetAnalysis
    fileInput('loadfile',
              h6('Upload file (.csv, .fa)'),
              multiple = FALSE)
})

## Analysis Mode: Generate/Reset Gene Text Box ----
observeEvent(input$resetAnalysis,{
    updateTextAreaInput(session,"idtext",value = "")
})

## Analysis Mode: Generate/Reset cDNA sequence Text Box ----
observeEvent(input$resetAnalysis,{
    updateTextAreaInput(session,"cDNAtext",value = "")
})