
Shiny.addCustomMessageHandler("jsondata1",
function(message){
  
  d3.select("#plot").select("svg").remove();

var dataArray = message;

var svg = d3.select("#plot").append("svg").attr("height","100%").attr("width","100%");

svg.selectAll("rect")
      .data(dataArray)
      .enter().append("rect")
                .attr("height",function(d,i){ return d*15; })
                .attr("width","50")
                .attr("fill","pink")
                .attr("x",function(d,i){ return 60*i; })
                .attr("y",function(d,i){ return 300-(d*15); });
})