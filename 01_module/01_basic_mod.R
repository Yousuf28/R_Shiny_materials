
library(shiny)

# module UI part
mod_test_UI <- function(id) {
    ns <- shiny::NS(id)

	shiny::tagList(
    shiny::actionButton(ns("test"), "click"),
	shiny::verbatimTextOutput(ns("out")))
}

# module server part
mod_test <- function(id) {

	shiny::moduleServer(id, function(input, output, session) {

	result <- shiny::eventReactive(input$test, {
    df <- datasets::mtcars
	index <- sample(1:nrow(df), 5)
    df[index, 1:4]
    })

	output$out <- shiny::renderPrint(
		result())
	})
}

# app ui
ui <- shiny::fluidPage(

    mod_test_UI("unq_id")
)
# app server
server <- function(input, output, session) {


    mod_test("unq_id")
}

#run app
shiny::shinyApp(ui = ui, server = server)
