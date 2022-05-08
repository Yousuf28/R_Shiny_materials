library(shiny)
library(tidyverse)
library(shinyjs)


slider_input_ui <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::tagList(
    
    shiny::sliderInput(inputId = ns("bins"),
                       label   = "Number of bins:",
                       min     = 1,
                       max     = 50,
                       value   = 30),
    
    br(),
    
    shiny::actionButton(inputId = ns("click"),
                        label   = "Click Me"),
    
    br()
    
  )
  
}

slider_input_server <- function(id) {
  
  shiny::moduleServer(
    id,
    
    function(input, output, session) {
      
      shinyjs::click(id = "click")
      
      return(
        list(
          bins       = shiny::reactive(input$bins),
          action_btn = shiny::reactive(input$click)
        )
      )
      
    }
    
  )
  
}
dist_ui <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::tagList(
    
    br(),
    shiny::radioButtons(inputId = ns("dist"),
                        label   = "Choose Distribution",
                        choices = c("Normal", "Exponential")
    )
    
  )
  
}

dist_server <- function(id, action_button) {
  
  shiny::moduleServer(
    id,
    
    function(input, output, session) {
      
      distribution <- shiny::eventReactive(action_button(), {
        
        if(input$dist == "Normal") {
          
          dist <- rnorm(n = 10000, mean = 0, sd = 1)
          
        } else {
          
          dist <- rexp(n = 10000, rate = .2)
          
        }
        
        return(dist)
        
      })
      
      return(distribution)
      
    }
    
  )
  
}


histogram_ui <- function(id) {
  
  ns <- shiny::NS(id)
  
  shiny::tagList(
    
    shiny::plotOutput(ns("plot"))
    
    
  )
  
}

histogram_server <- function(id, df, slider_input_bins, action_button) {
  
  shiny::moduleServer(
    id,
    
    function(input, output, session) {
      
      bins <- shiny::eventReactive(action_button(), {
        
        bins <- seq(min(df()), max(df()), length.out = slider_input_bins() + 1)
        
      })
      
      output$plot <- shiny::renderPlot({
        
        # draw the histogram with the specified number of bins
        hist(df(), breaks = bins(), col = 'darkgray', border = 'white')
        
      })
      
    }
    
  )
  
}

ui <- shiny::fluidPage(
    
    shinyjs::useShinyjs(),
    
    # Application title
    titlePanel("Modules Tutorial"),
    
    sidebarLayout(
        sidebarPanel(
            
            slider_input_ui("slider_btn"),
            dist_ui("dist")
            
        ),
        
        mainPanel(
            
            histogram_ui("hist")
            
        )
    )
)

server <- function(input, output, session) {
    
    slider_btn_vals <- slider_input_server(id = "slider_btn")
    
    dist_values <- dist_server(id = "dist",
                               action_button = slider_btn_vals$action_btn)

    histogram_server(id = "hist",
                     df = dist_values,
                     slider_input_bins = slider_btn_vals$bins,
                     action_button = slider_btn_vals$action_btn)
    
}

# Run the application 
shinyApp(ui = ui, server = server)