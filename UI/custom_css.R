## Custom CSS ----
tags$head(
    tags$style(HTML("
    
    #optimizedSequence{
    font-family: monospace;
    }
    
    #intronic_opt{
    font-family: monospace;
    }
    
    #box li {
    float: right;
    }
    
    h3 {
    font-size: 16px;
    margin: 10.5px 0px;
    }
    
    .navbar-brand {
    height: 60px;
    padding: 10px 15px;
    }
    
    .navbar-nav>li>a{
    height: 60px;
    padding: 10px 15px;
    }
    
    h4 {
    font-size: 13px;
    font-weight: bold;
    }
    
    h5 {
    font-size: 13px;
    font-weight: bold;
    }
    
    h6 {
    font-size: 12px;
    margin: 0px;
    font-weight: 550;
    line-height: 1.4;
    }
    
    strong {
    font-size: 12px;
    font-weight: bold;
    }
    
    p{
    font-size: 12px;
    font-weight: normal;
    }
    
    li{
    font-size: 12px;
    font-weight: normal;
    }
    
    
    .selectize-input {
    word-wrap: break-word;
    font-size: 12px;
    overflow-x: auto;
    }
    
    .selectize-dropdown {
    word-wrap: break-word;
    font-size: 12px;
    }
    
    .form-control {
    font-size: 12px;
    height: 40px;
    }
    
    .btn {
    font-size: 12px;
    height: 40px;
    }
    
    #CPMPlotlydiv {
    text-align: center;
    color: black;
    }
    
    .shiny-output-error-validation {
    font-size: 14px;
    color: #E74C3C
    }
    
    #geneSelection_conditionalPanel .shiny-output-error-validation {
    color: white;
    }
    
    #lifeStageLegend_GW .shiny-html-output{
    font-size: 12px}

                    "))
    
)