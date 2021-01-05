generate_excel_report <- function(data){

temp<- downloadHandler(
    
    filename = function(){
        paste("Codon_Usage_Report_",Sys.Date(),".xlsx",sep = "")
    },
    
    content = function(file){
        withProgress({
            removeModal() 
            
            # Workbook
            to_download <<- createWorkbook()
            addWorksheet(wb = to_download, sheetName = 'Results')
            
            setProgress(.25)
            
            # Write Data
            ## Sheet header
            writeData(
                to_download,
                sheet = 1,
                x = c(
                    paste0("Strongyloides Codon Usage Report"),
                    paste0("Report generated on ", format(Sys.Date(), "%B %d, %Y"))
                )
            )
            
            ## Results of codon usage analysis
            writeData(
                to_download,
                sheet = 1,
                x = data,
                startRow = 4,
                startCol = 1,
                headerStyle = createStyle(
                    textDecoration = "Bold",
                    halign = "center",
                    border = "bottom"
                )
            )
            setProgress(.5)
            
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
            setProgress(.75)
            
            saveWorkbook(to_download, file)
            setProgress(1)
        }, message = "Generating Excel Report"
        )
    }  
)
}