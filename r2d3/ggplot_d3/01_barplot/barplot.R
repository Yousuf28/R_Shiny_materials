

df <- data.table::fread("7_OneCatOneNum_header.csv")

ui <- fluidPage(
    tags$head(tags$link(
        rel = "stylesheet",
        type = "text/css", href = "stylesheet.css"
    )),
    tags$head(tags$script(src = "d3.min.js")),
    #   tags$head(tags$script(src="barplot.js")),
    tags$head(tags$script(src = "barplot_anim.js")),
    actionButton("generate", "Generate"),
    fluidRow(
        column(
            6,
            tags$div(id = "plot")
        ),
        column(
            6,
            shiny::plotOutput("plot2")
        )
    )
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

    output$plot2 <- shiny::renderPlot({
        data <- df
        ggplot(data, aes(x = Country, y = Value)) +
            geom_bar(stat = "identity", fill = "#69b3a2") +
            scale_x_discrete(limits = rev) +
            ggplot2::theme_classic()
    })
}

shiny::shinyApp(ui = ui, server = server)