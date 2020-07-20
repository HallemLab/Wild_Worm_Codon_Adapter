output$generate_excel_report <- downloadHandler(
    
    filename = function(){
        paste("Codon_Usage_Report_",Sys.Date(),".xlsx",sep = "")
    },
    
    content = function(file){
        removeModal() 
        
        # Workbook
        to_download <<- createWorkbook()
        addWorksheet(wb = to_download, sheetName = 'Results')
        
        # Write Data
        ## Sheet header
        writeData(
            to_download,
            sheet = 1,
            x = c(
                paste0("S. stercoralis Codon Usage Report"),
                paste0("Report generated on ", format(Sys.Date(), "%B %d, %Y"))
            )
        )
        
        ## Results of codon usage analysis
        writeData(
            to_download,
            sheet = 1,
            x = vals$geneIDs,
            startRow = 4,
            startCol = 1,
            headerStyle = createStyle(
                textDecoration = "Bold",
                halign = "center",
                border = "bottom"
            )
        )
        
        
        # Styling
        ## Styling the title row
        addStyle(
            to_download,
            sheet = 1,
            rows = 1,
            cols = 1:10,
            style = createStyle(
                fontSize = "14",
                textDecoration = "bold"
            )
        )
        
        withProgress(
            saveWorkbook(to_download, file),
            message = "Generating Excel Report")
    }
)