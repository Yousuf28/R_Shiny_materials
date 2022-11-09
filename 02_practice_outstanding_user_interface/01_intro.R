remotes::install_github("DivadNojnarg/OSUICode")
library(OSUICode)
library(shiny)

h1("hello", style = "color: green;")
## RUN ### 
OSUICode::run_example( 
 "intro/dj-system", 
  package = "OSUICode" 
) 

ui <- fluidPage(p("Hello World"))

server <- function(input, output, session) {}

shinyApp(ui, server)