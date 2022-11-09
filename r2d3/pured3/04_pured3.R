library(shiny)


# 

ui <- fluidPage(

 
  

    fluidRow(
		sliderInput("bar_max", label = "Max:",
                min = 10, max = 30, value = 15, step = 1),
    actionButton("generate", "Generate"),
    
      tags$head(tags$script(src="d3.min.js")),
    
      column(width=12,align="center", 
             tags$script(src="02_barchart2.js"),
             tags$div(id="d3_plot")
             )

    
      
    )
    
    


)

server <- function(input, output,session) {
  
  data_d3 <- eventReactive(input$generate,{
  	data <- as.integer(rnorm(n=6,mean = 7, 1))
  	print(data)
  	data
  	
  })
  
  to_array <- reactive({
    data <- data_d3()
   
    data <- jsonlite::toJSON(data)
    # print(data)
    data
    
  })

  
  
  observe({
	input$generate
	print(to_array())
    session$sendCustomMessage(type = "array_to_js", to_array())
    # session$sendCustomMessage(type='jsondata1', tojson1())
  }) 
  
 
}

shinyApp(ui = ui, server = server)