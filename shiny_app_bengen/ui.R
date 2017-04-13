
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(
    fluidPage(
        titlePanel("bengen"),        
#         headerPanel("Hello Shiny!")
               
        sidebarPanel(
            conditionalPanel(condition="input.tabs_p=='Plot'",                    
                             uiOutput("db_plot"),
                             uiOutput("method_plot")
            ),
            conditionalPanel(condition="input.tabs_p=='Table'",                    
                             uiOutput("name_score"),
                             uiOutput("method"),
                             uiOutput("database"),
                             uiOutput("family")
            ),
            conditionalPanel(condition="input.tabs_p=='About'",
                             h4("bengen is fucking good!!!") 
            )
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Plot", 
                         fluidRow(                  
                             column(12, plotOutput("bench_results", height=800))                             
                         )
                ),     
                tabPanel("Table",
                         fluidRow(  
                             DT::dataTableOutput("table")
#                             column(12, tableOutput("table"))            
                         )         
                ),         
                tabPanel("About",
                         HTML('<p>bengen</p>')),
                
                id="tabs_p"
                
                )
            )
        )
)