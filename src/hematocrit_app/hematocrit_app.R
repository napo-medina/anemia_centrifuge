library(shiny)

images <- list.files("fotos_hematocrito", full.names = TRUE)
# Randomize image list, except for the last image
images <- c(sample(images[-length(images)]), images[length(images)])

ui <- fluidPage(
  imageOutput("image", width = "auto", height = "auto"),
  numericInput("hematocrit", "Hematocrit value", value = 0),
  actionButton("button_next", "Next image"),
  downloadButton("download", "Save and download the information")
)

server <- function(input, output, session) {
  
  # Show images
  
  output$image <- renderImage({
    list(src = images[input$button_next + 1])
  }, deleteFile = FALSE)
  
  # Create and fill the hematocrit values
  
  hematocrit_values <- vector("character", length(images))
  
  observeEvent(input$button_next, {
    hematocrit_values[input$button_next] <<- input$hematocrit
    updateNumericInput(session, "hematocrit", value = 0)
  })
  
  # Download
  
  output$download <- downloadHandler(
    filename = function() {
      "results_hematocrit.csv"
    },
    content = function(con) {
      res <- data.frame(id = basename(images), hematocrit = hematocrit_values)
      write.csv(res, file = con, row.names = FALSE)
    }
  )
  
}

shinyApp(ui, server)
