library(shiny)
data <- datasets::mtcars

# module UI
module_one_ui <- function(id) {
    ns <- shiny::NS(id)
    shiny::fluidRow(
        htmltools::br(),
        shiny::column(
            width = 3, offset = 1,
            shiny::uiOutput(ns("filter")),
            shiny::actionButton(ns("update"), "update"),
			shiny::verbatimTextOutput(ns("out"))
        )
    )
}

# module server
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

			output$out <- shiny::renderPrint(data_out())

           



        }
    )

}


##### UI
ui <- shiny::fluidPage(
    module_one_ui("one")
)

# server
server <- function(input, output, session) {

    data_mtcar <- reactive({
        data <- data
        data
    })

## module use
 module_one("one", data=data_mtcar)

}

# run app

shiny::shinyApp(ui, server)