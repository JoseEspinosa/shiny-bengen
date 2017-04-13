
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

source ("/Users/jespinosa/git/phecomp/lib/R/plotParamPublication.R")

## Reading data
csv_file <- "https://raw.githubusercontent.com/cbcrg/bengen/master/CACHE/cache.csv"
n_fields <- max(count.fields(csv_file, sep = ','))
bench_tbl <- read.table(csv_file, header = FALSE, sep = ",", col.names = paste0("V",seq_len(n_fields)), fill = TRUE)
bench_tbl$V1 <-  gsub ("bengen/", "", bench_tbl$V1, ignore.case = TRUE)
bench_tbl$V2 <-  gsub ("bengen/", "", bench_tbl$V2, ignore.case = TRUE)

## aes
## colorblind friendly palette
cb_palette <- c("#999999", "#E69F00", "#56B4E9",
                "#009E73", "#F0E442", "#0072B2", 
                "#D55E00", "#CC79A7", "#000000", 
                "#00009B")

## Avoid problems if too many groups
cb_palette <- rep (cb_palette, 10)

# ggplot(bench_tbl, aes(V1, y=V5, fill=V2) ) +
#     geom_bar(position="dodge", stat="identity")

shinyServer(function(input, output) {
#     output$bedGraphRange_tab <- renderUI({
#         sliderInput("bedGraphRange", label = h4("Data range:"), 
#                     min = 0, max = 1000, 
#                     value = c(10, 100), 
#                     step= 1)
#     })
    output$groups_tab <- renderUI({
        checkboxGroupInput( "groups", label = h4("Groups to render:"), 
                            choices = unique(bench_tbl$V3), 
                            selected = unique(bench_tbl$V3))
        
    })
    # Combine the selected variables into a new data frame
    selected_data <- reactive({
        if(!is.null(input$groups)) {
            bench_tbl <- subset(bench_tbl, V3 %in% input$groups)
        }        
    })
    output$bench_results <- renderPlot({
        if(!is.null(input$groups)) {
            ggplot(selected_data(), aes(V3, y=V5, fill=V2) ) +
                   scale_fill_manual(values=cb_palette) +
                   geom_bar(position="dodge", stat="identity")
        }
    })
#   output$tbl_res <- renderTable({
    #     as.data.frame(dfFileEnv_range())
    #     as.data.frame(dfFilePhases_range())
#     as.data.frame(dfFilePhases_range()$ranges_p)    
#   })

})
