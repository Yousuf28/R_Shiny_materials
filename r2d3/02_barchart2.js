// var dataArray = [5,11,18];

// var svg = d3.select("body").append("svg").attr("height","100%").attr("width","100%");

var bars = r2d3.svg.selectAll('rect')
    .data(r2d3.data);

bars.enter()
.append("rect")
.attr("height",function(d,i){ return d*15; })
.attr("width","50")
.attr("fill","steelblue")
.attr("x",function(d,i){ return 60*i; })
.attr("y",function(d,i){ return 300-(d*15); });

bars.exit().remove()

