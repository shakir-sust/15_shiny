# app.R

library(shiny)
library(ggplot2)
library(maps)
library(dplyr)
library(readr)

# ─── Load the data ─────────────────────────────────────────────────────────────
data <- read_csv("training_wrangled.csv",
                 col_types = cols(.default = col_guess()))

# Identify numeric columns for the selector
numeric_vars <- data %>%
  select(where(is.numeric)) %>%
  names()

# ─── UI ────────────────────────────────────────────────────────────────────────
ui <- fluidPage(
  titlePanel("Corn Trial EDA"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId  = "variable",
        label    = "Select a numeric variable:",
        choices  = numeric_vars,
        selected = numeric_vars[1]
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Density", plotOutput("densityPlot")),
        tabPanel("Georgia Map", plotOutput("mapPlot")),
        tabPanel("Panel 3", plotOutput("plot3")),
        tabPanel("Panel 4", plotOutput("plot4"))
      )
    )
  )
)

# ─── Server ─────────────────────────────────────────────────────────────────────
server <- function(input, output, session) {
  
  # 1. Density plot of chosen variable
  output$densityPlot <- renderPlot({
    req(input$variable)
    ggplot(data, aes_string(x = input$variable)) +
      geom_density(fill = "steelblue", alpha = 0.5) +
      labs(
        x = input$variable,
        y = "Density",
        title = paste("Density of", input$variable)
      ) +
      theme_minimal()
  })
  
  # 2. Map of Georgia, USA (counties only)
  output$mapPlot <- renderPlot({
    # load and filter county outlines for GA
    ga_counties <- map_data("county") %>%
      filter(region == "georgia")
    
    ggplot(ga_counties, aes(long, lat, group = group)) +
      geom_polygon(color = "black", fill = "gray90") +
      coord_quickmap() +
      labs(
        title = "Map of Georgia Counties",
        x = "Longitude",
        y = "Latitude"
      ) +
      theme_void()
  })
  
  # 3. Placeholder
  output$plot3 <- renderPlot({
    plot.new()
    text(0.5, 0.5, "Panel 3: (to be added)", cex = 1.4)
  })
  
  # 4. Placeholder
  output$plot4 <- renderPlot({
    plot.new()
    text(0.5, 0.5, "Panel 4: (to be added)", cex = 1.4)
  })
}

# ─── Run App ────────────────────────────────────────────────────────────────────
shinyApp(ui, server)
