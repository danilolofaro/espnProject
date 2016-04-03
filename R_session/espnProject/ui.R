library(shiny)
#library(rCharts)


shinyUI(
  (pageWithSidebar(  
      headerPanel("Example plot"),
      sidebarPanel(
        sliderInput('year', 'Year:',min=2006, max=2013, value=2013, format="####")
      ),
            mainPanel(    
                        tabsetPanel(tabPanel('Pediatric RRT Prevalence', column(12,plotOutput("dataProvided"),plotOutput("prevalenceByAge"))))
)

            # tabPanel('Data',dataTableOutput(outputId="table"),downloadButton('downloadData', 'Download'))))),

            #tabPanel("About",mainPanel(includeMarkdown("README.md")))))
)))


# shinyUI(pageWithSidebar(  
#   headerPanel("Example plot"),  
#   sidebarPanel(    
#     sliderInput('year', 'Year:',min=2006, max=2013, value=2013, format="####")
#   ), 
#   mainPanel(    
#     tabsetPanel(tabPanel('Pediatric RRT Prevalence', column(12,plotOutput("dataProvided"),plotOutput("prevalenceByAge"))))
#   )
# ))