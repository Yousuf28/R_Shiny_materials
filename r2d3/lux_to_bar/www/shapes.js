


Shiny.addCustomMessageHandler("jsondata1",
function(message){
  
  d3.select("#plot").select("svg").remove();

var dataArray = message;
// var dataArray = [8,11,15]
// console.log(dataArray)

var svg = d3.select("#plot").append("svg").attr("height","100%").attr("width","100%");

svg.selectAll("rect")
      .data(dataArray)
      .enter().append("rect")
                .attr("height",function(d,i){ return d*15; })
                .attr("width","50")
                .attr("fill","pink")
                .attr("x",function(d,i){ return 60*i; })
                .attr("y",function(d,i){ return 200- (d*15); });
                
      
var newX = 200;
svg.selectAll("line")
      .data(dataArray)
      .enter().append("line")
                .attr("x1",newX)
                .attr("stroke", "blue")
                .attr("stroke-width","2")
                .attr("y1",function(d,i){ return 80+(i*20); })
                .attr("x2",function(d){ return newX+(d*15); })
                .attr("y2",function(d,i){ return 80+(i*20); });
                
var textArray = ['start','middle','end'];
svg.append("text").selectAll("tspan")
    .data(textArray)
    .enter().append("tspan")
      .attr("x",newX)
      .attr("y",function(d,i){ return 150 + (i*30); })
      .attr("fill","none")
      .attr("stroke","blue")
      .attr("stroke-width","2")
      .attr("dominant-baseline","middle")
      .attr("text-anchor","start")
      .attr("font-size","30")
      .text(function(d){ return d; });
})

Shiny.addCustomMessageHandler("mtcar",
function(message){

	var data = message;
	// console.log(data)
	// console.log(data[1])
	// console.log(data[2])
	// console.log(typeof data)

	// console.log(data)
	console.log(data)
	// for (var key in data) {
	// 	console.log(data[key].mpg); // logs keys in myObject
	// 	// console.log(data[key]); // logs values in myObject
	//   }


})

var myarray = [{
	"mpg": 21,
	"cyl": 6,
	"disp": 160
}, {
	"mpg": 21,
	"cyl": 6,
	"disp": 160
}, {
	"mpg": 22.8,
	"cyl": 4,
	"disp": 108
}, {
	"mpg": 21.4,
	"cyl": 6,
	"disp": 258
}, {
	"mpg": 18.7,
	"cyl": 8,
	"disp": 360
}]

// console.log(myarray)
// var json_array = JSON.parse(myarray)
// console.log(json_array)