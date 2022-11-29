library(shiny)


ui <- shiny::fluidPage(
    htmltools::includeScript("from_shiny.js"),
    shiny::titlePanel("title"),
    shiny::sidebarLayout(
        shiny::sidebarPanel(
            width = 2,
            selectInput(
                inputId = "which_data", label = "select R data type",
                choices = c("vector", "list", "dataframe"),
                selected = "vector"
            ),
            shiny::actionButton("submit", "print R data"),
            shiny::actionButton("submit_02", "print tojson data"),
            shiny::selectInput(
                inputId = "which_js_data", label = "select JS data type",
                choices = c("Array", "Object", "Array_of_objects"),
                selected = "Array"
            ),
            shiny::actionButton("js_data", "print js data to R console")
        ),
        shiny::mainPanel(
            shiny::verbatimTextOutput("r_data_out"),
            htmltools::tags$h4("from JS"),
            shiny::verbatimTextOutput("js_out")
        )
    )
)


server  <- function(input, output, session) {

	r_data <- shiny::reactive({
        r_vec <- c(1, 2, 3, 4, 5)
        r_list <- list(a = c(1,2,3), b = c("A", "B", "C"))
        r_df <- data.table::as.data.table(datasets::mtcars[1:6, 1:4])
        if(input$which_data == "vector"){
            data <- r_vec
        } else if (input$which_data == "list") {
           data <- r_list
        } else {
           data <- r_df
        }
        data

        # df <- jsonlite::toJSON(data)
        # df
		
	})

    output$r_data_out <- shiny::renderPrint({
        r_data()
    })

    shiny::observeEvent(input$submit, {
        print(r_data())
        session$sendCustomMessage(type = "rtojs", r_data())
    })

       shiny::observeEvent(input$submit_02, {
        data <- r_data()
        data <- jsonlite::toJSON(data, dataframe = "rows")
        print(data)
        session$sendCustomMessage(type = "jsondata", data)
    })
   
shiny::observeEvent(input$js_data, {
    session$sendCustomMessage(type = "send_console", input$which_js_data)
    
})

shiny::observe({
    req(input$from_js_data)
    print(input$from_js_data)
})

output$js_out  <- shiny::renderPrint({
    req(input$from_js_data)
    df <- jsonlite::fromJSON(input$from_js_data)
    # df <- input$from_js_data
    df

})

}

shiny::shinyApp(ui,server)