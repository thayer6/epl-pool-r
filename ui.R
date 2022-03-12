
library(shiny)
library(DT)

ui <- basicPage(
    
    h2("EPL Table"),
    strong("Updated:"),
    textOutput("date_updated"),
    br(),
    DT::dataTableOutput("epl_table"),
    
    h2("Points Pool Table"),
    DT::dataTableOutput("owner_table")
)


