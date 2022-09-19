library(shiny)
library(r2d3)

# ui <- fluidPage(
# #   inputPanel(
# #     sliderInput("bar_max", label = "Max:",
# #       min = 0, max = 1, value = 1, step = 0.05)
# #   ),
#   d3Output("d3")
# )

# server <- function(input, output) {
#   output$d3 <- renderD3({
   
# r2d3(data = read.csv("flare.csv"), d3_version = 4, script = "bubbles.js")
    
#   })
# }

# shinyApp(ui = ui, server = server)



# df <- datasets::mtcars
# head(df)
# js <- jsonlite::toJSON(df)
# jsonlite::prettify(js)

library(shiny)
library(r2d3)

ui <- fluidPage(
	# tags$head(tags$script("www/shinybar.js")),
#   inputPanel(
    sliderInput("bar_max", label = "Max:",
      min = 1, max = 20, value = 5, step = 1),
# shiny::actionButton("generate", "Generate"),
  d3Output("d3")
)

server <- function(input, output) {

# data_d3 <- eventReactive(input$generate,{
# 	data <- as.integer(rnorm(n=3,mean = 7, 1))
# 	data
# 	print(data)
# })

  output$d3 <- renderD3({
	# data <- data_d3()
	# data %>% 
    r2d3(
		# data_d3(),
		as.integer(rnorm(n=input$bar_max,mean = 10, 4)),
    #   runif(5, 0, input$bar_max),
	
	script = "02_barchart2.js"
    )
  })
}

shinyApp(ui = ui, server = server)