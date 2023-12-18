#====================================================================================================================#
#===================================================== Shiny Server =====================================================#
#====================================================================================================================#

# Loading Libraries

library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(DT)
library(knitr)
library(kableExtra)
library(ggthemes)
library(plotly)
library(viridis)
library(hrbrthemes)
library(ggraph)
library(igraph)
library(tidyverse)
library(RColorBrewer) 
require(data.table)
library(rsconnect)
library(shinythemes)
library(datarium)
library(rstatix)
library(ez)
library(effectsize)

# Reading Data

data <- readRDS("immigration_data.rds")
data_long <- readRDS("immigration_data_long.rds")

data_long$No_of_immigrants <- as.integer(data_long$No_of_immigrants)
data_long <- data_long[data_long$Year!="total_immigrants", ]

# Setting data-tables view

opts <- list(
  language = list(url = "//cdn.datatables.net/plug-ins/1.10.19/i18n/English.json"),
  pageLength = 30,
  searchHighlight = TRUE,
  orderClasses = TRUE,
  columnDefs = list(list(
    targets = c(1, 6), searchable = FALSE
  ))
)

# Server

server <- function(session, input, output) {
  
  #======== Main > Summary ========#
  
  #======== Main > Summary > Top Contributors ========#
  
  output$datahead <- renderPrint({
    head(data_long[data_long$Year==input$checkYear, -6]) %>%
      arrange(desc(No_of_immigrants)) %>%
      kable(
        "html",
        col.names = c(
          "Country", "Continent", "Region", "Development Status", "Number of Immigrants"
        )
      ) %>%
      kable_styling(c("striped", "hover"), full_width = T)
    
  })
  
  #======== Main > Summary > Continent-wise Contribution (Pie-Chart) ========#
  
  output$piePlot <- renderPlot({
    
    # Filter Year
    data_long2 <- data_long[data_long$Year==input$checkYear,]
    
    # Aggregate data on selected year
    data_pie <- aggregate(data_long2$No_of_immigrants, by=list(Category=data_long2$Continent), FUN=sum)
    
    data <- data.frame(
      Continents=data_pie$Category,
      value=data_pie$x
    )
    
    # Calculate proportion for each segment in pie-chart
    data <- data %>% 
      arrange(desc(Continents)) %>%
      mutate(prop = value / sum(data$value) *100) %>%
      mutate(ypos = cumsum(prop)- 0.5*prop )
    
    # Pie-plot using ggplot
    ggplot(data, aes(x="", y=prop, fill=Continents)) +
      geom_bar(stat="identity", width=1, color="white") +
      coord_polar("y", start=0) +
      theme_void() + 
      theme(legend.position="right") +
      scale_fill_manual(values=c("skyblue", "blue", "lightgreen","darkgreen","pink", "red"))
    
  })
  
  #======== Main > Summary > Data Overview ========#
  
  # Interactive filter on continents
  ContinentGroup <- reactive({
    input$actionDT
    data_filtered <- data_long[data_long$Continent %in% input$checkContinent, ]
    isolate(return(data_filtered[order(data_filtered$No_of_immigrants, decreasing = TRUE), ]))
  })
  
  # Apply filters to get final data
  filtered_DT <- reactive({
    input$actionDT
    isolate({
      minImmigrants <- input$immigrantsRange[1]
      maxImmigrants <- input$immigrantsRange[2]
      minYear <- input$yearRange[1]
      maxYear <- input$yearRange[2]
    })
    
    ContinentGroup() %>%
      filter(No_of_immigrants >= minImmigrants,
             No_of_immigrants <= maxImmigrants) %>%
      filter(Year >= minYear,
             Year <= maxYear) %>%
      select(6, 1, 2, 3, 4, 5)
  })
  
  # Data-table
  output$myTable <- renderDataTable({
    filtered_DT() %>%
      datatable(
        .,
        rownames = FALSE,
        class = "table",
        options = list(pageLength = 10, scrollX = T),
        colnames = c(
          "Year",
          "Country",
          "Continent",
          "Region",
          "Development Status",
          "Number of Immigrants"
        )
      )
    
  })
  
  #======== Main > Visual Comparison > Line Chart ========#
  
  # Filter on Year
  
  dent <-  reactive({
    data_long2 <- data_long
    data_long2$Year <- as.numeric(data_long2$Year)
    data_long2$No_of_immigrants <- as.numeric(data_long2$No_of_immigrants)
    return(data_long2[data_long2$Country %in% input$checkGroup, ])
  })
  
  # Render Line Chart with plotly
  
  output$lineChart <- renderPlotly({
    
    # Line Chart using ggplot
    ply <- ggplot(dent(), aes(x=Year, y=No_of_immigrants, fill=Country, color = Country)) + 
      geom_line() +
      scale_color_viridis(discrete = TRUE) +
      theme_ipsum() +
      ylab("Number of Immigrants")
    
    ggplotly(ply)
    
  })
  
  #======== Main > Visual Comparison > Dendrogram ========#
  
  # Filter on Continent
  
  dent2 <-  reactive({
  
    data2 <- data[order(data$total_immigrants, decreasing = TRUE), ]  
    data2 <- data2[data2$Continent  %in% input$checkContinent2, ]
    data2 <- data.table(data2, key = "Continent")
    data3 <- data2[ , head(.SD, 5), by = Continent]
    
    d1=data.frame(from="origin", to=unique(data3$Continent))
    d2=data.frame(from=data3$Continent, to=data3$Country)
    edges=rbind(d1, d2)
    
    # creating a vertices dataframe, one row per object of our hierarchy
    vertices = data.frame(
      name = unique(c(as.character(edges$from), as.character(edges$to))) , 
      value = c(sum(data3$total_immigrants),aggregate(data3$total_immigrants, by=list(Category=data3$Continent), FUN=sum)[ ,2], data3$total_immigrants)
    ) 
    vertices$group = edges$from[ match( vertices$name, edges$to ) ]
    
    mygraph_linear <- graph_from_data_frame( edges, vertices=vertices)
    
    return(mygraph_linear)
    
  })
  
  # Render Dendrogram
  
  output$dendogram <- renderPlot({
    
    # Dendrogram using ggplot
    ggraph(dent2(), layout = 'dendrogram') + 
      geom_edge_diagonal() +
      geom_node_text(aes( label=name, filter=leaf, color=group) , angle=90 , hjust=1, nudge_y=-0.1) +
      geom_node_point(aes(filter=leaf, size=value, color=group) , alpha=1.5) +
      ylim(-1.2, NA) +
      theme(legend.position="none")
    
  })
  
  #======== Main > Statistical Analysis ========#
  
  # Filter on Year
  
  dent3 <-  reactive({
    
    final_data <- data
    col_name <- paste0("X", input$checkYear2)
    
    final_data$immigrants <- final_data[, col_name]
    
    # Grouping the data into 2 groups based on Development Status
    final_data.grouping <- group_by(final_data, DevName)
    
    # Summary statistics for total_immigrants across both groups (developing and developed)
    ss <- get_summary_stats(final_data.grouping, immigrants, type = "mean_sd")
    
    ## Step 1: Assumptions
    
    # Checking for extreme outliers in the sample
    final_data.outliers <- identify_outliers(final_data.grouping, immigrants)
    
    # Checking whether both groups are normally distributed using Shapiro-Wilks test
    shapiro_test(final_data.grouping, immigrants)
    
    # Checking for homogeneity of variance
    levene_test(final_data, immigrants ~ DevName)
    
    return(final_data)
    
  })
  
  # Render Output of Analysis
  
  output$test_stat <- renderPrint({ 
    
    test_res <- t_test(dent3(), immigrants ~ DevName, var.equal=TRUE)
    cat("The test statistic is t = ", round(test_res$statistic,2), " and p-value = ",round(test_res$p,2))
  
    })
  
  output$conclusion <- renderPrint({ 
    
    test_res <- t_test(dent3(), immigrants ~ DevName, var.equal=TRUE)
    if(test_res$p < 0.05){
      cat("Since p-value < 0.05, we can conclude that development status of a country had an effect on number of immigrants from that country in ", input$checkYear2, ".")
    }
    else{
      cat("Since p-value > 0.05, we can conclude that development status of a country had no effect on number of immigrants from that country in ", input$checkYear2, ".")
    }
    
  })
  
  
}
