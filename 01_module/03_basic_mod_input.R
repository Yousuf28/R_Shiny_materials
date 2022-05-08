
library(shiny)

# module UI part
mod_test_UI <- function(id) {
    ns <- shiny::NS(id)

	shiny::tagList(
    shiny::actionButton(ns("test"), "click"),
	shiny::verbatimTextOutput(ns("out")))
}

# module server part
mod_test <- function(id, data) {

	shiny::moduleServer(id, function(input, output, session) {

	result <- shiny::eventReactive(input$test, {
		df <- data()
		df
		
		})

	output$out <- shiny::renderPrint(
		
		result()
		)
	})
}


# app ui
ui <- shiny::fluidPage(
	shiny::selectInput( "column_name",
	 label = "select column name", choices = c("A", "B", "C")),

    mod_test_UI("unq_id")
)
# app server
server <- function(input, output, session) {




    mod_test("unq_id", data = reactive({input$column_name}))
}

#run app
shiny::shinyApp(ui = ui, server = server)