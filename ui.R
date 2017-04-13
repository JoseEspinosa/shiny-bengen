
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
#                              uiOutput("bedGraphRange_tab"),                    
                             uiOutput("groups_tab")
            ),
            conditionalPanel(condition="input.tabs_p=='About'",
                             h4("Introduction") 
            )
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel("Plot",
                         fluidRow(                  
                             column(12,
                                    plotOutput("bench_results", height=800),
                                    plotOutput("legend_track", height=50),
                                    plotOutput("envInfo", height=20))#,
                             #                            textOutput("text1")
                         )#,
                         #column(3, downloadButton("all_plot_tiff", "Download snapshot"))#,
                ),            
                tabPanel("About",
                         HTML('<p>bengen</p>')),
                
                id="tabs_p"
                
                )
            )
        )
)