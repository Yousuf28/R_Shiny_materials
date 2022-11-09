ui <- fluidPage(
  tags$script(
    "alert('Click on the Hello World text!');
     // change text color
     function changeColor(color){
       document.getElementById('hello').style.color = color;
     }
    "
  ),
  p(id = "hello", onclick="changeColor('green')", "Hello World")
)

server <- function(input, output, session) {}

shinyApp(ui, server)

############

# create the tag
myTag <- div(
  class = "divclass", 
  id = "first",
  h1("My first child!"),
  span(class = "child", id = "baby", "Crying")
)
# access its name
# myTag$name
# access its attributes (id and class)
# myTag$attribs
# access children (returns a list of 2 elements)
# myTag$children
# access its class
str(myTag)