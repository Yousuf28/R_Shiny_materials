library(shiny)

ui <- fluidPage(
  shiny::verbatimTextOutput("client")
)

server <- function(input, output, session) {
  
  output$client <- shiny::renderPrint({
    protocol <- session$clientData$url_protocol
    hostname <- session$clientData$url_hostname
    port <- session$clientData$url_port
    pathname <- session$clientData$url_pathname
    search <- session$clientData$url_search
    
    
    txt <- paste0("url_protocol: ",protocol, ", " ,
                  "hostname: ", hostname, ", ",
                  "port: ", port, ", ",
                  "pathname: ", pathname, " ",
                  "search: ", search
                  )
    txt
    
  })
  
}

shinyApp(ui, server)