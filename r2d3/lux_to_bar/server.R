


function(input, output, session) {
        
        tojson1 <- eventReactive(input$generate,{
          
          data <-	as.integer(rnorm(n=input$n,mean = 10, 4))
          data <- jsonlite::toJSON(data)
          data
      
        })

        observe({
                session$sendCustomMessage(type='jsondata1', tojson1())
        })                
        
   
        
}