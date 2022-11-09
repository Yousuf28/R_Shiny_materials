

# df <- data.table::fread("alphabet.csv")
df <- data.table::fread("aapl.csv")
df <- df[1:10,]

ui <- fluidPage(
    tags$head(tags$link(
        rel = "stylesheet",
        type = "text/css", href = "stylesheet.css"
    )),
    # tags$head(tags$script(src = "d3.min.js")),
    tags$head(tags$script(src = "d3.v5.min.js")),
    tags$head(tags$script(src = "d3-array.v2.min.js")),
    #   tags$head(tags$script(src="barplot.js")),
    # tags$head(tags$script(src = "bar_obs.js")),
    tags$head(tags$script(src = "area_obs.js")),
    actionButton("generate", "Generate"),
	tags$div(id = "plot")

    # fluidRow(
    #     column(
    #         12,
    #         tags$div(id = "plot")
    #     )
    #     # column(
    #     #     6,
    #     #     shiny::plotOutput("plot2")
    #     # )
    # )
)

server <- function(input, output, session) {
    tojson1 <- eventReactive(input$generate, {
        data <- df
        print(data)
        data <- jsonlite::toJSON(data)
        print(data)
        data
    })

    observe({
        session$sendCustomMessage(type = "jsondata1", tojson1())
    })

    # output$plot2 <- shiny::renderPlot({
    #     data <- df
    #     ggplot(data, aes(x = Country, y = Value)) +
    #         geom_bar(stat = "identity", fill = "#69b3a2") +
    #         scale_x_discrete(limits = rev) +
    #         ggplot2::theme_classic()
    # })
}

shiny::shinyApp(ui = ui, server = server)