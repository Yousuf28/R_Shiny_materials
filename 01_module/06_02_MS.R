selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL) 
}
find_vars <- function(data, filter) {
  names(data)[vapply(data, filter, logical(1))]
}

selectVarServer <- function(id, data, filter = is.numeric) {
  moduleServer(id, function(input, output, session) {
	  ######
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    ######
    reactive(data()[[input$var]])
####

  })
}

selectVarApp <- function(filter = is.numeric) {
  ui <- fluidPage(
    datasetInput("data", is.data.frame),
    selectVarInput("var"),
    verbatimTextOutput("out")
  )
  server <- function(input, output, session) {
    data <- datasetServer("data")
    var <- selectVarServer("var", data, filter = filter)
    output$out <- renderPrint(var())
  }
  
  shinyApp(ui, server)
}

selectVarApp()