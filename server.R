
# Shiny web application for bengen results

## loading libraries
library(shiny)
library(ggplot2)
library (DT)

source("https://raw.githubusercontent.com/cbcrg/phecomp/master/lib/R/plotParamPublication.R")

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

ggplot(bench_tbl, aes(V3, y=V5, fill=V2) ) +
    scale_fill_manual(values=cb_palette) +
    geom_bar(position="dodge", stat="identity") +
    theme(axis.title.x = element_blank(), #strip.background = element_blank(),
          axis.title.y = element_blank(),
          legend.position="none", strip.text.x = element_blank()) #+
#     facet_wrap(~V)
    
# ggplot(selected_data(), aes(V3, y=V5, fill=V2) ) +
#     scale_fill_manual(values=cb_palette) +
#     geom_bar(position="dodge", stat="identity")

shinyServer(function(input, output) {
    ## Plot tab
#     output$score_plot <- renderUI({
#         checkboxGroupInput( "score_plot", label = h4("Score function:"), 
#                             choices = unique(bench_tbl$V3), 
#                             selected = unique(bench_tbl$V3))
#         
#     })
    output$method_plot <- renderUI({
        checkboxGroupInput( "method_plot", label = h4("Method:"), 
                            choices = unique(bench_tbl$V2), 
                            selected = unique(bench_tbl$V2))
        
    })
    output$db_plot <- renderUI({
        checkboxGroupInput( "db_plot", label = h4("Database:"), 
                            choices = unique(bench_tbl$V3), 
                            selected = unique(bench_tbl$V3))
        
    })
    
    # Combine the selected variables into a new data frame
    selected_data <- reactive({
        if(!is.null(input$method_plot)) {
            bench_tbl <- subset(bench_tbl, V2 %in% input$method_plot)
        }
        if(!is.null(input$db_plot)) {
            bench_tbl <- subset(bench_tbl, V3 %in% input$db_plot)
        }      
    })
    output$bench_results <- renderPlot({
        if(!is.null(selected_data())) {
            ggplot(selected_data(), aes(V3, y=V5, fill=V2) ) +
                scale_fill_manual(values=cb_palette) +
                geom_bar(position="dodge", stat="identity") +
                theme(axis.title.x = element_blank(), 
                     axis.title.y = element_blank(),
                     legend.title=element_blank())
        }
    })
    #     output$tbl_res <- renderTable({
    #         as.data.frame(selected_data())    
    #     })
    
    ##############
    ## Table tab
    output$name_score <- renderUI({
        selectInput("name_score", 
                    "Name score:",
                    c("All",
                    unique(as.character(bench_tbl$V1))))                    
    })
    output$method <- renderUI({
        selectInput("method", 
                    "Method:",
                    c("All",
                      unique(as.character(bench_tbl$V2))))                    
    })
    output$database <- renderUI({
        selectInput("database", 
                    "Database:",
                    c("All",
                      unique(as.character(bench_tbl$V3))))                    
    })
    output$family <- renderUI({
        selectInput("family", 
                    "Family:",
                    c("All",
                      unique(as.character(bench_tbl$V4))))                    
    })
    
    output$table <- DT::renderDataTable(DT::datatable({
        data <- bench_tbl
        if (input$name_score != "All") {
            data <- data[data$V1 == input$name_score,]
        }
        if (input$method != "All") {
            data <- data[data$V2 == input$method,]
        }
        if (input$database != "All") {
            data <- data[data$V3 == input$database,]
        }
        if (input$family != "All") {
            data <- data[data$V4 == input$family,]
        }
        data
    }))
})
