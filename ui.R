bootstrapPage(

  checkboxInput(inputId = "months",
      label = strong("View by warm or cold months"),
      value = FALSE),

  plotOutput(outputId = "chloropleth_ozone", height = "300px"),
  
  plotOutput(outputId = "network", height = "300px")
)
