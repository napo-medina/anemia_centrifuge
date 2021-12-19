library(shiny)

images <- list.files("images", full.names = TRUE)
results <- vector("character", length(images))


ui <- fluidPage(
  imageOutput("image"),
  numericInput("hematocrit", "Hematocrit value", min = 2, max = 99, value = 0),
  actionButton("button_next", "Next image"),
  downloadButton("download", "Save and download the information")
)

server <- function(input, output, session) {
  
  output$image <- renderImage({
    list(src = images[input$button_next + 1])
  }, deleteFile = FALSE)
  
  observeEvent(input$button_next, {
    results[input$button_next] <<- input$hematocrit
    updateNumericInput(session, "hematocrit", value = 0)
  })
  
  output$download <- downloadHandler(
    filename = function() {
      "results_hematocrit.csv"
    },
    content = function(con) {
      res <- data.frame(id = basename(images), hematocrit = results)
      write.csv(res, file = con, row.names = FALSE)
    }
  )
  
}

shinyApp(ui, server)
