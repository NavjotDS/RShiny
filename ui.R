#====================================================================================================================#
#===================================================== Shiny UI =====================================================#
#====================================================================================================================#

# Loading Libraries

library(shinyWidgets)
library(shiny)
library(plotly)
library(shinythemes)
library(DT)
library(rsconnect)



ui <- navbarPage(
  "Immigration in Canada (1980-2013)",
  
  theme = shinytheme("flatly"),
  
  tabPanel(
    "Main",
    
    titlePanel(div(
      windowTitle = "Canada_Immigration",
      img(src = "imm.jpeg", width = "100%", class = "bg"),
    )),
    
    tags$br(),
    
    #======== Main > Summary ========#
    
    tabsetPanel(
      type = "tabs",
      tabPanel(
        
        "Summary",
       
        #======== Main > Summary > Sidebar - Filter by Year ========#
        
        # Drop Down Menu for Year of Immigration
        sidebarLayout(
          sidebarPanel(
            h3("Filter by Year"),
            tags$br(),
            selectInput(
              "checkYear",
              "Select Year",
              choices = list("1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989",
                             "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999",
                             "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009",
                             "2010", "2011", "2012", "2013"),
              selected = "2013"
            )
          ),
          
          mainPanel(
            tabsetPanel(
              type = "tabs",
              
              # Display Table
              tabPanel("Top Contributors",
                       h5("- The following table displays the top 6 contributors of immigrants to canada during the selected year."),
                       h5("- Year of immigration can be changed using the given panel (Filter by Year)."),
                       tags$br(),
                       tableOutput("datahead")
                       ),
              
              # Display Pie-chart
              tabPanel("Continent-wise Contribution", 
                       h5("- This pie chart shows the continent-wise distribution of immigrants during the selected year."),
                       h5("- Year of immigration can be changed using the given panel (Filter by Year)."),
                       tags$br(),
                       plotOutput(outputId = "piePlot"),
                       h5("Key Insights: "),
                       h5("* Europe was the largest contributor in 1980."),
                       h5("* In 2013, Asia was the largest contributor."),
                       h5("* Immigrants from Europe has decreased over the years.")
                       )
            ),
            tags$br(),
          )
        ),
        
        tags$hr(),
        
        #======== Main > Summary > Sidebar - Data Overview ========#
        
        
        sidebarLayout(
          sidebarPanel(
            
            h3("Data Overview"),
            tags$br(),
            setSliderColor(c("#2c3e50 ", "#2c3e50"), c(1, 2)),
            
            # Filter on Number of Immigrants using slider
            sliderInput(
              "immigrantsRange",
              label = "Number of Immigrants Range",
              min = 0,
              max = 42584,
              value = c(0, 42584)
            ),
            
            # Filter on Year using Slider
            sliderInput(
              "yearRange",
              label = "Year Range",
              min = 1980,
              max = 2013,
              value = c(1980, 2013)
            ),
            
            # Filter on Continent by selecting from given choices
            selectInput(
              "checkContinent",
              "Select Continent",
              choices = list("Africa", "Asia", "Europe", "Latin America and the Caribbean", 
                             "Northern America", "Oceania"),
              selected = "Asia",
              multiple = TRUE
            ),
            
            actionButton("actionDT", "Filter", class = "btn btn-warning"),
          ),
          
          # Display Filtered Data
          mainPanel(
            h3("Browse All"),
            tags$br(),
            h5("- The following table displays the dataset used for our analysis."),
            h5("- Data can be filtered using the data overview panel."),
            h5("- The filtered data can be sorted in increasing or decreasing order of a particular attribute by clicking on the attribute name."),
            h5("- The dataset can be searched for any given keyword using the 'Search' field."),
            tags$br(),
            dataTableOutput("myTable"),
            tags$br(),
            tags$br(),
          )
        ),
        tags$hr(),
        
      ),
      
      #======== Main > Visual Comparison ========#
      
      tabPanel(
        "Visual Comparison",
        
        #======== Main >  Visual Comparison > Line Chart ========#
        
        sidebarLayout(
          sidebarPanel(
            h3("Line Chart Panel"),
            tags$br(),
            
            # Checkbox for Country
            checkboxGroupInput(
              "checkGroup",
              label = "Select Country",
              choices = list(
                "China" = "China",
                "India" = "India",
                "Pakistan" = "Pakistan",
                "Philippines" = "Philippines",
                "United Kingdom" = "United Kingdom",
                "United States of America" = "United States of America"
              ),
              
              # Selection - By default
              selected = list(
                "China" = "China",
                "India" = "India",
                "Pakistan" = "Pakistan",
                "Philippines" = "Philippines",
                "United Kingdom" = "United Kingdom",
                "United States of America" = "United States of America"
              )
            ),
          ),
          
          # Display Line Chart
          mainPanel(
            h4("Line Chart showing the changes in number of immigrants from selected countries during 1980 to 2013"),
            h5("- Countries can be selected or deselected from the given panel"),
            h5("- Data displayed when hovering over the graph"),
            tags$br(),
            plotlyOutput(outputId = "lineChart"),
            h5("Key Insights:"),
            h5("* Immigrants from United Kingdom has significantly decreased after 1994."),
            h5("* Immigrants from United States of America has not changed significantly over the years."),
            h5("* Immigrants from China, India and Philippines has significantly increased over the years."),
            tags$br(),
            tags$br()
          )
        ),
        tags$hr(),
        
        #======== Main > Summary > Visual Comparison > Dendrogram ========#
        
        sidebarLayout(
          sidebarPanel(
            h3("Dendrogram Panel"),
            tags$br(),
            
            # Checkbox for Continent
            checkboxGroupInput(
              "checkContinent2",
              label = "Select Continents",
              choices = list("Africa", "Asia", "Europe", "Latin America and the Caribbean", 
                             "Northern America", "Oceania"),
              # Selection - By default
              selected = list("Africa", "Asia", "Europe", "Latin America and the Caribbean", 
                              "Oceania")
            ),
          ),
          
          # Display Dendrogram
          mainPanel(
            h4("Dendrogram showing the top 5 contributing countries from selected continents."),
            h5("- Continents can be included or excluded using the given panel"),
            plotOutput(outputId = "dendogram"),
            tags$br(),
            tags$br(),
            
          )
        ),
        tags$hr(),
        tags$br(),
        tags$br(),
        tags$hr(),
        
      ),
      
      #======== Main > Statistical Analysis ========#
      
      tabPanel(
        
        "Statistical Analysis - Effect of Development Status",
        
        # Drop Down Menu for Year of Immigration
        sidebarLayout(
          sidebarPanel(
            h3("Filter by Year"),
            tags$br(),
            selectInput(
              "checkYear2",
              "Select Year",
              choices = list("1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989",
                             "1990", "1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999",
                             "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009",
                             "2010", "2011", "2012", "2013"),
              # Year - selected by default
              selected = "2013"
            )
          ),
          
          mainPanel(
            h2("Independent Samples t-Test"),
            h3(""),
            h6("Note: Year of immigration used for this analysis can be changed using the given panel. Results and conclusion change accordingly."),
            h3(""),
            h5("The objective of our analysis is to determine whether the development status of a country had an effect on number of immigrants from that country in Canada during the selected year."),
            h5("For our analysis, we have used the Independent samples test for two means (equal variance t-test). A t-test is used to compare the means of two independent groups. Independent groups indicates that the participants in each group are different. In our analysis, both the groups are independent, as a country has been categorized as either developed or developing."),
            h5("We checked for outliers in the sample and found that the sample contained some extreme outliers. A Shapiro-Wilks test was conducted which demonstrated that both the groups, developed and developing, are not normally distributed. For the purpose of this analysis, we have conducted the t-Test even when the assumptions were not satisfied."),
            h5("The test statistic and p-value from our analysis are given below: "),
            
            # Display Output of Statistical Test
            verbatimTextOutput("test_stat"), 
            h5("Hence, we can make the following conclusion: "),
            textOutput("conclusion"),
            
            tags$br(),
            tags$br(),
          )
        ),
        
        tags$hr(),
        
      )
      
    )
  )
  
)
