shinyUI(
        fluidPage(  
          tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")),
      
          tags$head(tags$script(src="d3.min.js")),
          tags$head(tags$script(src="shapes.js")),
          
          sliderInput(inputId = "n", "how many number", min = 3, max = 10, value = 4, step = 1),
          actionButton("generate", "Generate"),
                
               fluidRow(
                 column(12,
                        
                        tags$div(id = "plot"))
                 
               )
                
        )
        
        
) 




