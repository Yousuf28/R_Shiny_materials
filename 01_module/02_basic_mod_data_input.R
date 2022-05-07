
library(shiny)

mod_test_UI <- function(id) {
    ns <- shiny::NS(id)
	shiny::tagList(
    shiny::actionButton(ns("test"), "click to print random rows"),
	shiny::verbatimTextOutput(ns("out")))
}

# reactive data argument
mod_test <- function(id, data) {

	shiny::moduleServer(id, function(input, output, session) {

	result <- shiny::eventReactive(input$test, {
    df <- data()
	df
	
    })

	output$out <- shiny::renderPrint(result())

	})
}


ui <- shiny::fluidPage(
	shiny::fluidRow(
	shiny::actionButton("random_row", "select random row"),
	shiny::br(),
	shiny::br(),
    mod_test_UI("unq_id")
	)
)

server <- function(input, output, session) {

	df_reactive <- shiny::eventReactive(input$random_row, {
		df <- datasets::mtcars
		index <- sample(1:nrow(df), 5)
       df[index, 1:4]
	})

    mod_test("unq_id", data = df_reactive)
}

# app
shiny::shinyApp(ui = ui, server = server)