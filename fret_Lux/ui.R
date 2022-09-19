shinyUI(
        fluidPage(  
                titlePanel(HTML(paste("Type of fuel by category of vehicles in Luxembourg,", "1997-2017", sep="<br/>"))),
                h5("Integration of d3.js in Shiny"),
                #First we add the selectInput that will be displayed on interface 
                column(width=6, align="center", selectInput("category1", "Choose a category:",
                                                            choices = list("Cycles with auxiliary motors", "Motorcycles", "Cars", "Cars for mixed use", 
                                                                           "Utility vehicles",  "Buses", "Vans","Trucks", "Road Tractors", "Special Vehicles"), 
                                                            selected = "Cars")),
                column(width=6, align="center", selectInput("category2", "Choose a category:",
                                                            choices = list("Cycles with auxiliary motors", "Motorcycles", "Cars", "Cars for mixed use", 
                                                                           "Utility vehicles",  "Buses", "Vans","Trucks", "Road Tractors", "Special Vehicles"), 
                                                            selected = "Motorcycles")),
                
                #Here we add the .css and .js files that we need for this webpage
                fluidRow(
                        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css")),
                        tags$head(tags$script(src="d3.min.js")),
                        tags$head(tags$script(src="d3-tip.js")),
                #We specify where the graph should be displayed. "div_boad1" is the div id where the d3.js graph is.
                        column(width=6,align="center", 
                               tags$script(src="fretjs1.js"), tags$div(id="div_board1")),
                #Same thing here
                        column(width=6, align="center",
                               tags$script(src="fretjs2.js"), tags$div(id="div_board2"))
                        
                ),
                
                h6( a("Data sources", href="http://www.statistiques.public.lu/stat/TableViewer/tableView.aspx?ReportId=13502&IF_Language=eng&MainTheme=4&FldrName=7&RFPath=7049%2c13898"))
                
        )
        
        
) 




