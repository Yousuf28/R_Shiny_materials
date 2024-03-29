library(shiny)
library(dplyr)
library(r2d3)
library(forcats)
library(DT)
library(rlang)

r2d3_script <- "
// !preview r2d3 data= data.frame(y = 0.1, ylabel = '1%', fill = '#E69F00', mouseover = 'green', label = 'one', id = 1)
function svg_height() {return parseInt(svg.style('height'))}
function svg_width()  {return parseInt(svg.style('width'))}
function col_top()  {return svg_height() * 0.05; }
function col_left() {return svg_width()  * 0.20; }
function actual_max() {return d3.max(data, function (d) {return d.y; }); }
function col_width()  {return (svg_width() / actual_max()) * 0.55; }
function col_heigth() {return svg_height() / data.length * 0.95; }

var bars = svg.selectAll('rect').data(data);
bars.enter().append('rect')
    .attr('x',      col_left())
    .attr('y',      function(d, i) { return i * col_heigth() + col_top(); })
    .attr('width',  function(d) { return d.y * col_width(); })
    .attr('height', col_heigth() * 0.9)
    .attr('fill',   function(d) {return d.fill; })
    .attr('id',     function(d) {return (d.label); })
    .on('click', function(){
      Shiny.setInputValue('bar_clicked', d3.select(this).attr('id'), {priority: 'event'});
    })
    .on('mouseover', function(){
      d3.select(this).attr('fill', function(d) {return d.mouseover; });
    })
    .on('mouseout', function(){
      d3.select(this).attr('fill', function(d) {return d.fill; });
    });
bars.transition()
  .duration(500)
    .attr('x',      col_left())
    .attr('y',      function(d, i) { return i * col_heigth() + col_top(); })
    .attr('width',  function(d) { return d.y * col_width(); })
    .attr('height', col_heigth() * 0.9)
    .attr('fill',   function(d) {return d.fill; })
    .attr('id',     function(d) {return d.label; });
bars.exit().remove();

// Identity labels
var txt = svg.selectAll('text').data(data);
txt.enter().append('text')
    .attr('x', width * 0.01)
    .attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
    .text(function(d) {return d.label; })
    .style('font-family', 'sans-serif');
txt.transition()
    .duration(1000)
    .attr('x', width * 0.01)
    .attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
    .text(function(d) {return d.label; });
txt.exit().remove();

// Numeric labels
var totals = svg.selectAll().data(data);
totals.enter().append('text')
    .attr('x', function(d) { return ((d.y * col_width()) + col_left()) * 1.01; })
    .attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
    .style('font-family', 'sans-serif')
    .text(function(d) {return d.ylabel; });
totals.transition()
    .duration(1000)
    .attr('x', function(d) { return ((d.y * col_width()) + col_left()) * 1.01; })
    .attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
    .attr('d', function(d) { return d.x; })
    .text(function(d) {return d.ylabel; });
totals.exit().remove();
"
r2d3_file <- tempfile()
writeLines(r2d3_script, r2d3_file)

ui <- fluidPage(
  selectInput("var", "Variable",
              list("marital", "rincome", "partyid", "relig", "denom"),
              selected = "marital"),
  d3Output("d3"),
  DT::dataTableOutput("table"),
  textInput("val", "Value", "Married")
)

server <- function(input, output, session) {
  output$d3 <- renderD3({
    gss_cat %>%
      mutate(label = !!sym(input$var)) %>%
      group_by(label) %>%
      tally() %>%
      arrange(desc(n)) %>%
      mutate(
        y = n,
        ylabel = prettyNum(n, big.mark = ","),
        fill = ifelse(label != input$val, "#E69F00", "red"),
        mouseover = "#0072B2"
      ) %>%
      r2d3(r2d3_file)
  })
  observeEvent(input$bar_clicked, {
      updateTextInput(session, "val", value = input$bar_clicked)
  })
  output$table <- renderDataTable({
    gss_cat %>%
      filter(!!sym(input$var) == input$val) %>%
      datatable()
  })
}

shinyApp(ui = ui, server = server)