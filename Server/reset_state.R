## Optimization Mode: Generate/Reset Sequence File Upload ----
output$optimization_file_upload <- renderUI({
    input$resetOptimization
    fileInput('loadseq',
              h6('Sequence file (.gb, .fasta, .txt)'),
              multiple = FALSE)
})

## Optimization Mode: Generate/Reset Sequence File Upload ----
observeEvent(input$resetOptimization,{
    updateTextAreaInput(session,"seqtext",value = "")
})

## Analysis Mode: Generate/Reset Gene File Upload ----
output$analysis_file_upload <- renderUI({
    input$resetAnalysis
    fileInput('loadfile',
              h6('List of Gene IDs or cDNA sequences (.csv, .fa)'),
              multiple = FALSE)
})

## Analysis Mode: Generate/Reset Gene File Upload ----
observeEvent(input$resetAnalysis,{
    updateTextAreaInput(session,"idtext",value = "")
})