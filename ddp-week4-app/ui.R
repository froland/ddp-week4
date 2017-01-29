#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict Consumer Price Index from Producer Price Indexes"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderYear", "Which year do you want to predict", 1974, 2016, value = 1990, sep = ""),
      p("The model 1 includes a single Producer Price Index:"),
      tags$ul(tags$li("Crude foodstuffs and feedstuffs")),
      checkboxInput("showModel1", "Show/Hide model 1", value = TRUE),
      p("The model 2 includes multiple Producer Price Indexes:"),
      tags$ul(
        tags$li("Crude foodstuffs and feedstuffs"),
        tags$li("Intermediate foods and feeds"),
        tags$li("Finished consumer foods")
      ),
      checkboxInput("showModel2", "Show/Hide model 2", value = TRUE)
    ),
    
    mainPanel(
      plotOutput("plotCPI"),
      tags$table(class = "table table-bordered",
        tags$thead(
          tags$tr(
            tags$th(),
            tags$th("Value in ", textOutput("year", inline = TRUE))
          )
        ),
        tags$tbody(
          tags$tr(
            tags$th("Actual Consumer Price Index variation"),
            tags$td(textOutput("actual", inline = TRUE), '%')
          ),
          tags$tr(
            tags$th("Model 1 prediction (residual)"),
            tags$td(textOutput("pred1", inline = TRUE), '% (', textOutput("resid1", inline = TRUE), '% )')
          ),
          tags$tr(
            tags$th("Model 2 prediction (residual)"),
            tags$td(textOutput("pred2", inline = TRUE), '% (', textOutput("resid2", inline = TRUE), '% )')
          )
        )
      ),
      h4("Sources"),
      p("These data come from the USA Bureau of Labor Statistics. They represent the difference from year to year of the Consumer Price Index (CPI)."),
      p("We developped two models to predict the CPI variation based on different combinations from the Producer Price Indexes data from the same source.")
    )
  )
))
