library(shiny)
library(ggplot2)
library(raster)
library(tmap)

data(Europe)
Europe@data <- Europe@data[,1:2]
Europe@data$sort <- 1:NROW(Europe@data)

load(file="esp.rda")
esp@data <- esp@data[,c("HASC_1","NAME_1")]
esp@data$sort <- 1:NROW(esp@data)
names(esp@data) <- names(Europe@data)

ds <- read.csv("data/espn_prevalence_06-13.csv",sep=";")


shinyServer(function(input, output) 
  {
  ds.year.EU <- reactive({
    tmp <- subset(ds,year==input$year)
    tmp <- merge(x = Europe@data,tmp,by="iso_a3",all.x=T)
    tmp <- tmp[order(tmp$sort),]
    tmp
  })
  
  ds.year.ESP <- reactive({
    tmp <- subset(ds,year==input$year)
    tmp <- merge(x = esp@data,tmp,by="iso_a3",all.x=T)
    tmp <- tmp[order(tmp$sort),]
    tmp
  })
  
      output$dataProvided <- renderPlot(
    {
      
      Europe@data$data <- ds.year.EU()$data
      Europe@data$data <- factor(Europe@data$data,levels(Europe@data$data)[c(1,2,4,3)])
      
      esp@data$data <- ds.year.ESP()$data
      esp@data$data <- factor(esp@data$data,levels(esp@data$data)[c(1,2,4,3)])
      
      col1 <- rgb(4,110,88, maxColorValue = 255)
      col2 <- rgb(28,226,71, maxColorValue = 255)
      col3 <- rgb(92,255,45, maxColorValue = 255)
      col4 <- rgb(218,255,171, maxColorValue = 255)
      espn_palette <- c(col4,col3,col2,col1)
      
      title <- paste("ESPN data contribution", input$year)
      
      g <- tm_shape(Europe) + 
        tm_fill("data", textNA="no data provided", title=title,palette = espn_palette, colorNA="white") +  
        tm_borders(lwd=2) + 
        tm_format_Europe_wide() +
        tm_layout(legend.title.size = 1.5, legend.text.size = 1.1) +
        tm_style_natural()
      
      if(input$year < 2008) {
        g <- g + tm_shape(esp) +
        tm_fill("data", palette = espn_palette, colorNA="white",legend.show = F) + 
          tm_format_Europe_wide() +
          tm_borders(lwd=2)
      }
      
      print(g)
    
    })
      
      
      output$prevalenceByAge <- renderPlot(
        {
          
          Europe@data$infants <- ds.year.EU()$infants
          Europe@data$children <- ds.year.EU()$children
          Europe@data$adolescents <- ds.year.EU()$adolescents
          
          esp@data$infants <- ds.year.ESP()$infants
          esp@data$children <- ds.year.ESP()$children
          esp@data$adolescents <- ds.year.ESP()$adolescents
        
          
          g <- tm_shape(Europe) + 
            tm_polygons(c("infants", "children","adolescents"), style="kmeans",
title=c("Prevalence of RRT 0-4 years", "Prevalence of RRT 5-9 years","Prevalence of RRT 10-14 years")) + 
            tm_format_Europe_wide() +
            tm_layout(legend.title.size = 1.5, legend.text.size = 1.1) +
            tm_style_grey()

          
          if(input$year < 2008) {
            g <- g + tm_shape(esp) +
              tm_polygons(c("infants", "children","adolescents"), style="kmeans", legend.show = F) + 
              tm_style_grey()
          }
          
          print(g)
          
        })
      
    
    #   output$downloadData <- downloadHandler(filename = 'data.csv',
    #                                          content = function(file) 
    #                                          {
    #                                            write.csv(dataTable(), file, row.names=FALSE)
    #                                          }
    #   )
    # })
  })