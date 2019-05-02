function(input, output) {

  output$chloropleth_ozone <- renderPlot({

    ggplot(state_borders) + 
      geom_polygon(aes(x = long, y = lat, group = group,
                       fill = avg_ozone), color = "black") + 
      scale_fill_gradient2(low = "#2396B9", mid = "lightgrey", 
                           high = "#C70039", midpoint = 0.04) +
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

    if (input$months) {
      facet_wrap(. ~ season)
    }

  })
}