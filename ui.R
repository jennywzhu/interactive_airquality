library(shiny)
library(ggplot2)
library(shinydashboard)
library(maps)

dashboardPage(
  dashboardHeader(title = "36315 Group 10"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Part (A)", tabName = "PartA", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "PartA",
              selectInput(inputId = "state",
                          label = "State:",
                          #choices = c("New York", "California", "Alabama", "Colorado"),
                          choices = state.name,
                          selected = "New York"),
              
              
              tabsetPanel(type = "tabs",
                          tabPanel("Dendrogram",
                                   plotOutput(outputId = "dend_plot", height="400px", width="600px")
                                  ),
                          tabPanel("Scatter Plot AQI",
                                   plotlyOutput(outputId = "scatter_plot", height="400px", width="600px")
                                  ),
                          tabPanel("Scatter Plot Ozone",
                                   plotlyOutput(outputId = "scatter_plot2", height="400px", width="600px")
                                  ),
                          tabPanel("Chloropleth Ozone",
                                   checkboxInput(inputId = "months_oz",
                                        label = strong("View by warm or cold months"),
                                        value = FALSE),
                                   plotOutput(outputId = "chloropleth_ozone", height = "300px")),
                          tabPanel("Chloropleth PM 2.5",
                                   checkboxInput(inputId = "months_pm",
                                                 label = strong("View by warm or cold months"),
                                                 value = FALSE),
                                   plotOutput(outputId = "chloropleth_pm25", height = "300px")),
                          tabPanel("Network of States",
                                   checkboxInput(inputId = "region_nodes",
                                                 label = strong("Color the nodes by region"),
                                                 value = FALSE),
                                   plotOutput(outputId = "network", height = "300px"))
                          )
            )
    )
  )
)