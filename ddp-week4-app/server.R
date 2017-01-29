#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


cpi_ppi <- read.csv("data/cpi_ppi.csv")
model1 <- lm(CPI_all_food ~ PPI_Crude_foodstuffs_feedstuffs, data = cpi_ppi)
model2 <- lm(CPI_all_food ~ PPI_Crude_foodstuffs_feedstuffs + PPI_Intermediate_foods_feeds + PPI_Finished_consumer_foods, data = cpi_ppi)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  inputs <- reactive({
    yearInput <- input$sliderYear
    subset(cpi_ppi, Year == yearInput)
  })
  
  model1Pred <- reactive({
    predict(model1, newdata = inputs())
  })
  
  model2Pred <- reactive({
    predict(model2, newdata = inputs())
  })
  
  model1Resid <- reactive({
    inputs()$CPI_all_food - model1Pred()
  })
  
  model2Resid <- reactive({
    inputs()$CPI_all_food - model2Pred()
  })
  
  output$plotCPI <- renderPlot({
    yearInput <- input$sliderYear
    plot(cpi_ppi$Year, cpi_ppi$CPI_all_food, xlab = "", ylab = "Consumer Price Index variation (%)", col = "green", pch = 16)
    abline(v = yearInput, lty = 3)
    points(yearInput, inputs()$CPI_all_food, col = "green", pch = 16, cex = 2)
    if (input$showModel1) {
      points(y = fitted(model1), x = cpi_ppi$Year, col = "red", pch = 3)
      points(yearInput, model1Pred(), col = "red", pch = 3, lwd = 4)
    }
    if (input$showModel2) {
      points(y = fitted(model2), x = cpi_ppi$Year, col = "blue", pch = 4)
      points(yearInput, model2Pred(), col = "blue", pch = 4, lwd = 4)
    }
    legend(2005, 14, c("Actual", "Model 1 prediction", "Model 2 prediction"), col = c("green", "red", "blue"), pch = c(16, 3, 4), pt.lwd = c(1, 4, 4), pt.cex = c(2, 1, 1))
  })
  
  output$pred1 <- renderText({
    model1Pred()
  })
  
  output$resid1 <- renderText({
    model1Resid()
  })
  
  output$pred2 <- renderText({
    model2Pred()
  })
  
  output$resid2 <- renderText({
    model2Resid()
  })
  
  output$actual <- renderText({
    inputs()$CPI_all_food
  })
  
  output$year <- renderText({
    input$sliderYear
  })
})
