library(shiny)

addRmBtnUI <- function(id) {
    ns <- NS(id)

    tags$div(
    actionButton(inputId = ns('insertParamBtn'), label = "Add"),
    actionButton(ns('removeParamBtn'), label = "Remove"),
    hr(),
    tags$div(id = ns('placeholder'))
  )
}

addRmBtnServer <- function(input, output, session, moduleToReplicate, ...) {
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

  return(reactive({params$btn}))
}




ui <- fluidPage(
  addRmBtnUI("addRm"),
  verbatimTextOutput("view", placeholder = TRUE)
)

server <- function(input, output, session) {
  a <- reactive({input$a})

  pars <- callModule(
    addRmBtnServer, id = "addRm",
    moduleToReplicate = list(
      ui = function(...){},
      server = function(...){},
      remover = function(...){}
    )
  )
  output$view <- renderText({ pars() })
}

shinyApp(ui = ui, server = server)