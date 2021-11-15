## Install packages required for local instance of the Wild Worm Codon Adapter
# Note, if you're on a Windows computer, you may need to change the folder your R packages are stored in from Read-only.
setRepositories(ind = c(1,2,3,4,5,6))
if (!requireNamespace("pacman", quietly = TRUE))
    install.packages("pacman")
library(pacman)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
library(BiocManager)
BiocManager::install(version = "3.14")

if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")

BiocManager::install("biomaRt")

pacman::p_load(shiny,shinyjs,seqinr,htmltools,shinyWidgets,shinythemes,magrittr,tidyverse,openxlsx,read.gb,tools,DT,ggplot2,markdown)
