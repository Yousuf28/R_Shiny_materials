data <- datasets::mtcars


#https://stackoverflow.com/questions/46555355/passing-data-within-shiny-modules-from-module-1-to-module-2

module_one_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::fluidRow(
        htmltools::br(),
        shiny::column(
            width = 3, offset = 1,
            shiny::uiOutput(ns("filter")),
            shiny::actionButton(ns("update"), "update"),
        )
    )
}

module_one <- function(id, data) {
    shiny::moduleServer(
        id,
        function(input, output, session) {
            ns <- session$ns

            output$filter <- shiny::renderUI({
                data <- data()
                ch <- names(data)
                shiny::selectInput(ns("column"), label = "select column name",
                 choices = ch)
            })

            filter_data <- shiny::eventReactive(input$update,{
                data <- data()
                vec <- data[[input$column]]
                vec
            })

            data_out <- shiny::reactive({
                data <- filter_data()
                data <- head(data)
                data
            })


vals <- reactiveValues()
observe( {vals$x = data_out() })
observe({ vals$y = input$column })
observe({ vals$z = input$update })

# inside observe, { } needed

# observe( vals$z = input$update ) does not work


           return(
			   vals
	
		   )
		 



        }
    )

}



ui <- shiny::fluidPage(
    module_one_ui("one"),

	shiny::verbatimTextOutput("out"),
    shiny::actionButton("check", "click"),
	shiny::verbatimTextOutput("first"),
	shiny::verbatimTextOutput("second")


)

server <- function(input, output, session) {
    data_mtcar <- reactive({
        data <- data
        data
    })


out_from_one <- module_one("one", data=data_mtcar)


	output$out <- renderPrint(out_from_one$x)
	# this case () don't need after x

   use_in_reactive <- shiny::eventReactive(input$check,{
        data <- out_from_one$y
		data

        # data <- data_mtcar
        
    })

	 use_in_reactive_z <- shiny::eventReactive(input$check,{
        data <- out_from_one$z
		data

        # data <- data_mtcar
        
    })

output$first <- renderPrint(use_in_reactive())
output$second<- renderPrint(use_in_reactive_z())

}

shiny::shinyApp(ui, server)