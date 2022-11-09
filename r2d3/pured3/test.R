library(shiny)

ui <- fluidPage(
	titlePanel("title"),
	sidebarLayout(
		sidebarPanel(),
		mainPanel()
	)
)

server <- function(input, output, session) {

}

shinyApp(ui, server)