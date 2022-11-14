
Shiny.addCustomMessageHandler("array_to_js",
  function(message){
	// var kk = Math.random()
	// console.log(kk)
	var dataArray = message;
	// console.log(dataArray)
	d3.select("#d3_plot").selectAll("svg").remove();

var svg = d3.select("#d3_plot").append("svg").attr("height","1000px").attr("width","1000px");

svg.selectAll("rect")
      .data(dataArray)
      .enter().append("rect")
                .attr("height",function(d,i){ return d*15; })
                .attr("width","50")
                .attr("fill","pink")
                .attr("x",function(d,i){ return 60*i; })
                .attr("y",function(d,i){ return 300-(d*15); })

svg.append('text').selectAll('tspan')
	.data(dataArray)
	.enter().append('tspan')
	.attr("x",function(d,i){ return 60*i+25; })
    .attr("y",function(d,i){ return 300-(d*15); })
	.attr("stroke", "blue")
	.text(function(d) {return d;})




  })

//   test