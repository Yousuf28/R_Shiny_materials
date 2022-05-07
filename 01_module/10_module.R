library(shiny)

firstUI <- function(id) { uiOutput(NS(id, "first")) }

firstServer <- function(input, output, session, a) {

  output$first <- renderUI({
    selectInput(session$ns("select"), h4("Select"), paste0(isolate(a()),letters[1:4]))
  })
}

removeFirstUI <- function(id) {
  removeUI(selector = paste0('#', NS(id, "first")))
}

addRmBtnUI <- function(id) {
  ns <- NS(id)

  tags$div(
    actionButton(inputId = ns('insertParamBtn'), label = "Add"),
    actionButton(ns('removeParamBtn'), label = "Remove"),
    hr(),
    tags$div(id = ns('placeholder'))
  )
}

addRmBtnServer <- function(input, output, session, moduleToReplicate,...) {
  ns = session$ns

  params <- reactiveValues(btn = 0)

  observeEvent(input$insertParamBtn, {
    params$btn <- params$btn + 1

    callModule(moduleToReplicate$server, id = params$btn, ...)
    insertUI(
      selector = paste0('#', ns('placeholder')),
      ui = moduleToReplicate$ui(ns(params$btn))
    )
  })

  observeEvent(input$removeParamBtn, {
    moduleToReplicate$remover(ns(params$btn))
    params$btn <- params$btn - 1
  })
}

ui <- fluidPage(
  addRmBtnUI("addRm"),
  textInput("a", label = "a", value = 1, width = '150px') )

server <- function(input, output, session) {


  a <- reactive({ input$a })
  callModule(
    addRmBtnServer, id = "addRm",
    moduleToReplicate = list(
      ui = firstUI,
      server = firstServer,
      remover = removeFirstUI
    ), 
    a = a
  )
}

shinyApp(ui, server, options=list(launch.browser=TRUE))