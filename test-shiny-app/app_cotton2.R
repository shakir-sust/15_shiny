
library(tidyverse)
library(shiny)

weather <- read_csv("weather_monthsum.csv")

ui <- fluidPage(
  # Title
  titlePanel("Cotton EDA"),
  # Sidebar with a slider
  sidebarLayout(
    sidebarPanel(
      varSelectInput("variable",
                     "Variable:", #Text that will show in the dashboard
                     weather #specifying the data that the user will make a selection from
                     )
    ),
    mainPanel(
      plotOutput("Plot")
    )
  )
)


server <- function(input, output) {
  output$Plot <- renderPlot({
    #Inside this curly bracket, we can use regular R code e.g., ggplot() to create a graph
    ggplot(data = weather,
           aes(x = !!sym(input$variable))
           ) +
      geom_density()
  })
}


shinyApp(ui, server)
