#
library(shiny)
library(tidyverse)
library(lubridate)
date_updated <- as.character(paste(with_tz(now(), "America/Los_Angeles"), "PT", sep = " "))

# Define server logic
shinyServer(function(input, output) {
    
    output$date_updated <- renderText({
        date_updated
    })

    epl_table <- read_csv("epl_table.csv")
    epl_table = epl_table[,-c(1)]
    
    owner_table <- read_csv("owner_table.csv")
    owner_table = owner_table[,-c(1)]
    
    library(DT)
    output$epl_table = DT::renderDataTable({datatable(epl_table, rownames = F, options = list(
        paging = FALSE, searching = FALSE
    ))})
    
    output$owner_table = DT::renderDataTable({datatable(owner_table, rownames=F, options = list(
        paging = FALSE, searching = FALSE, ordering = FALSE
    ))})
    
})