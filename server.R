library(shiny)
library(ggplot2)
library(dendextend)
library(tidyverse)
library(plotly)

function(input, output) {
  
  ozone <- read_csv("daily_44201_2018.csv")
  
  output$dend_plot <- renderPlot({
    
    ozone_states <- subset(ozone, `State Name` == input$state)
    
    ozone_cont <- dplyr::select(ozone_states, "Date Local", "Arithmetic Mean", "1st Max Value", AQI)
    
    ozone_cont <- mutate(ozone_cont, month = substr(ozone_cont$`Date Local`, 6, 7))
    
    ozone_grp_date <- aggregate(ozone_cont[, 2:4], list(ozone_cont$month), mean)
    
    dend <- ozone_grp_date[2:4] %>% scale %>% dist %>% hclust %>% as.dendrogram
    
    g <- dend %>% set("branches_k_color", k = 4, 
                      value = c("red", "blue","violet","orange")) %>% 
          ggplot(horiz=T) + labs(title = "Dendrogram of Ozone Air Quality by Month")
    
    #ggplotly(g)
    g
    #plotly_build(g)
    #plot_dendro(dend)
    
  })
  
  output$scatter_plot <- renderPlotly({
    
    ozone_states <- subset(ozone, `State Name` == input$state)
    
    ozone_cont <- dplyr::select(ozone_states, "Date Local", "Arithmetic Mean", AQI)
    
    ozone_cont <- mutate(ozone_cont, month = substr(ozone_cont$`Date Local`, 6, 7))
    
    # g <- ggplot(ozone_cont) + 
    #   geom_density(aes(x = `Arithmetic Mean`, fill=month), alpha = 0.7) +
    #   theme_bw()
    g <- ggplot(ozone_cont) + 
      geom_density(aes(x = AQI, fill=month), alpha = 0.7) +
      theme_bw()
    ggplotly(g)
    
  })
  
  output$scatter_plot2 <- renderPlotly({
    
    ozone_states <- subset(ozone, `State Name` == input$state)
    
    ozone_cont <- dplyr::select(ozone_states, "Date Local", "Arithmetic Mean", AQI)
    
    ozone_cont <- mutate(ozone_cont, month = substr(ozone_cont$`Date Local`, 6, 7))
    
    g <- ggplot(ozone_cont) +
      geom_density(aes(x = `Arithmetic Mean`, fill=month), alpha = 0.7) +
      theme_bw()

    ggplotly(g)
    
  })
  
  output$chloropleth_ozone <- renderPlot({
    
    oz <- ggplot(state_borders) + 
      geom_polygon(aes(x = long, y = lat, group = `State Code`,
                       fill = avg_ozone), color = "black") + 
      scale_fill_gradient2(low = "#2396B9", mid = "lightgrey", 
                           high = "#C70039", midpoint = 0.03) +
      theme_void() +
      coord_map("polyconic") + 
      labs(
        title = "Average Ozone Level in 2018 by State",
        #subtitle = "Percent of Population in State",
        #caption = "Zillow rental data",
        fill = "Average Ozone"
      ) + 
      theme(legend.position = "bottom") +
      jwzhu_315_theme
    
    if (input$months_oz) {
      oz + facet_wrap(. ~ season.x)
    }
    
    else {
      oz
    }
  })
  
  output$chloropleth_pm25 <- renderPlot({
    
    pm25 <- ggplot(state_borders) + 
      geom_polygon(aes(x = long, y = lat, group = `State Code`,
                       fill = avg_pm25), color = "black") + 
      scale_fill_gradient2(low = "#2396B9", mid = "lightgrey", 
                           high = "#C70039", midpoint = 15) +
      theme_void() +
      coord_map("polyconic") + 
      labs(
        title = "Average Ozone Level in 2018 by State",
        #subtitle = "Percent of Population in State",
        #caption = "Zillow rental data",
        fill = "Average Ozone"
      ) + 
      theme(legend.position = "bottom") +
      jwzhu_315_theme
    
    if (input$months_pm) {
      pm25 + facet_wrap(. ~ season.x)
    }
    
    else {
      pm25
    }
  })
  
  output$network <- renderPlot({
    if (input$region_nodes) {
      qgraph(dst_i, layout='spring', groups=states_air$region, vsize=3, labels=states_air$Group.1, overlay=TRUE)
    }
    
    else {
      qgraph(dst_i, layout='spring', vsize=3, labels=states_air$Group.1, overlay=TRUE)
    }
  
  })
  
}