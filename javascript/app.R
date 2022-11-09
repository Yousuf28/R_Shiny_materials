library(shiny)

ui <- shiny::fluidPage(
    shiny::titlePanel("eventListener"),
    shiny::sidebarLayout(
        shiny::sidebarPanel(
            shiny::selectInput(
                inputId = "test", label = "select_input",
                choices = c("A", "B"), selected = NULL
            ),
            shiny::textInput(inputId = "free_text", "text_input"),
            shiny::textInput(inputId = "free_text_2", "text_input"),
            shiny::actionButton(inputId = "submit", "submit")
        ),
        shiny::mainPanel(
			htmltools::includeScript("www/comm.js"),
			htmltools::includeCSS("www/style.css"),
            shiny::verbatimTextOutput("out_text")
        )
    )
)

server <- function(input, output, session) {

get_text <- shiny::eventReactive(input$submit,{
	text  <- paste0(input$test, ": ", input$free_text)
	text
	


})

output$out_text <- shiny::renderText({
	get_text()
})

# shiny::observe({
# 	input$click_event
# 	print(input$click_event)
# })

}

shiny::shinyApp(ui, server)