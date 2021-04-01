## Optimization Mode: Generate/Reset Sequence File Upload ----
output$optimization_file_upload <- renderUI({
    input$resetOptimization
    fileInput('loadseq',
              h6('Upload sequence file (.gb, .fasta, .txt)'),
              multiple = FALSE)
})

## Optimization Mode: Generate/Reset Custom Optimal Codon Lookup Table File Upload ----
output$custom_lut_upload <- renderUI({
    input$resetOptimization
    fileInput('loadlut',
              h6('Upload custom optimal codon rule (.csv)'),
              multiple = FALSE)
})

## Optimization Mode: Generate/Reset Custom Optimal Codon Lookup Table File Upload ----
output$custom_intron_upload <- renderUI({
    input$resetOptimization
    fileInput('loadintron',
              h6('Upload custom intron sequence(s) (.fasta)'),
              multiple = FALSE)
})

## Optimization Mode: Reset Sequence Text Box ----
observeEvent(input$resetOptimization,{
    updateTextAreaInput(session,"seqtext",value = "")
    updateSelectInput(session, "sp_Opt", selected = "Strongyloides")
    updateSelectInput(session, "type_Int", selected = "Canonical (Fire)")
})

## Analysis Mode: Generate/Reset Gene File Upload ----
output$analysis_file_upload <- renderUI({
    input$resetAnalysis
    fileInput('loadfile',
              h6('Upload file (.csv, .fasta)'),
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