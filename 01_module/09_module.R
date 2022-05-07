# https://thatdatatho.com/communicating-shiny-modules-simple-example/

library(shiny)

doc <- c(
  "This small app demonstrates how to pass dynamic values between modules."
  ,"A server module can return a reactive object by `reactive(expr)`,"
  ,"where `expr` is an expression that dynamically generate a value."
  ,"A challenge is that we create input UIs dynamically by `renderUI`."
  ,"If we name it by a plain string id, it won't be recognized since"
  ,"the operation searches for the id under the session namespace."
  ,"The trick is to find the namespace by `session$ns` in the module,"
  ,"and name objects as `ns('objectid')` as we do in the modularized UI."
)

setUnitUI <- function(id) {
  ns <- NS(id)
  selectInput(ns('unit'), 'unit', c('km', 'mile'))
}

setValueUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns('dynamicSlider'))
}

showValueUI <- function(id) {
  ns <- NS(id)
  textOutput(ns('value'))
}

ui <- fluidPage(sidebarLayout(
  sidebarPanel(p(paste(doc, collapse='\n'))),
  mainPanel(setUnitUI('unit'), 
            setValueUI('value'),
            showValueUI('show'))
))


setUnitModule <- function(input, output, session) {
  reactive(input$unit)
}

setValueModule <- function(input, output, session, unitGetter) {
  output$dynamicSlider <- renderUI({
    ns <- session$ns
    unit <- unitGetter()
    if (unit == 'km') {
      sliderInput(ns('pickValue'), paste('Pick value in', unit), 
                  min=0, max=150, value=0)
    } else {
      sliderInput(ns('pickValue'), paste('Pick value in', unit), 
                  min=0, max=100, value=0)
    }
  })
  
  reactive(input$pickValue)
}

showValueModule <- function(input, output, session, unitGetter, valueGetter) {
  output$value <- renderText(paste('You chose', valueGetter(), unitGetter()))
}

server <- function(input, output, session) {
  unitGetter <- callModule(setUnitModule, 'unit')
  valueGetter <- callModule(setValueModule, 'value', unitGetter)
  callModule(showValueModule, 'show', unitGetter, valueGetter)
}


shinyApp(ui, server, options=list(launch.browser=TRUE))