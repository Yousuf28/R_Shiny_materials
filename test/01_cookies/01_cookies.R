#dir.create("www")
#file.create("www/script.js")
library(shiny)

addResourcePath("www", "www")

ui <- fluidPage(
  tags$head(
    tags$script(
      src = paste0(
        "https://cdn.jsdelivr.net/npm/js-cookie@rc/",
        "dist/js.cookie.min.js"
      )
    ),
    tags$script(src = "www/script.js")
  ),
  textInput("name_set", "What is your name?"),
  actionButton("save", "Save cookie"),
  actionButton("remove", "remove cookie"),
  uiOutput("name_get")
)

server <- function(input, output, session){
  
  # save
  observeEvent(input$save, {
    msg <- list(
      name = "name", value = input$name_set
    )
    
    if(input$name_set != "")
      session$sendCustomMessage("cookie-set", msg)
  })
  
  # delete
  observeEvent(input$remove, {
    msg <- list(name = "name")
    session$sendCustomMessage("cookie-remove", msg)
  })
  
  # output if cookie is specified
  output$name_get <- renderUI({
    if(!is.null(input$cookies$name))
      h3("Hello,", input$cookies$name)
    else
      h3("Who are you?")
  })
  
}

shinyApp(ui, server)