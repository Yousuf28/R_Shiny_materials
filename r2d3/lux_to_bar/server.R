


function(input, output, session) {
        
        tojson1 <- eventReactive(input$generate,{
          
          data <-	as.integer(rnorm(n=input$n, mean = 15, 4))
          print(data)
        #   data <- c(1,2,3)
          data <- jsonlite::toJSON(data)
          print(data)
          data
      
        })

        observe({
                session$sendCustomMessage(type='jsondata1', tojson1())
        })  

  observe({
      df <- mtcars[1:5, 1:3]
      dt <- data.table::as.data.table(df)
	#   df_ls <- list(mpg=dt$mpg,cyl=df$cyl,disp=df$disp )
    #   dt_js <- shiny:::toJSON(dt)
      dt_js <- jsonlite::toJSON(dt)
	  session$sendCustomMessage(type = "mtcar", dt_js)

  })
        
   
        
}