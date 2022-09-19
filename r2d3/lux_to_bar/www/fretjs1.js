// Message to make it "readable" by shiny.
// jsondata1 is the message name 
Shiny.addCustomMessageHandler("jsondata1",
function(message){
// div_boad1 is the id name
var id = '#div_board1';
var fData =  message;
d3.select("#div_board1").selectAll("svg").remove();
d3.select("#div_board1").selectAll("table").remove();
d3.select("#div_board1").selectAll(".d3-tip").remove();
var barColor = "Tomato";
    //function segColor(c){ return {but:"DodgerBlue", cadres:"seaGreen", "non cadres":"crimson"}[c]; } //CHANGE COLORS

	var color = d3.scaleOrdinal().domain(d3.keys(fData[0].fuel))
    .range(["dodgerBlue", "seaGreen", "crimson", "khaki", "tan","slategray","mediumpurple","lightsteelblue","chocolate", "paleVioletRed"]);
    // compute total for each state.
    fData.forEach(function(d){
	//
	d.total= d3.sum(d3.values(d.fuel), function (t){return t;} )//d.perf.but + d.perf.cadres + d.perf[ 'non cadres' ]; //CHANGE FOR R
    
	});
    
    // function to handle histogram.
    function histoGram(fD){
        var hG={},    hGDim = {t: 10, r:0 , b: 35, l: 0};
        hGDim.w = 380 - hGDim.l - hGDim.r, 
        hGDim.h = 200 - hGDim.t - hGDim.b;
		
        //create svg for histogram.
        var hGsvg = d3.select(id).append("svg")
            .attr("width", hGDim.w + hGDim.l + hGDim.r)
            .attr("height", hGDim.h + hGDim.t + hGDim.b).append("g")
            .attr("transform", "translate(" + hGDim.l + "," + hGDim.t + ")");

        // create function for x-axis mapping.
        var x = d3.scaleBand().range([0, hGDim.w]).padding(0.1)
                .domain(fD.map(function(d) { return d[0]; }));

        // Add x-axis to the histogram svg.
        hGsvg.append("g").attr("class", "x axis")
            .attr("transform", "translate(0," + hGDim.h + ")")
            .call(d3.axisBottom(x));
			
		//Add x-axis Label
		hGsvg.append("g")
			.append("text")
			.attr("transform", "translate(" + (hGDim.w/4) + "," + (hGDim.h + 30) + ")")
			    .attr("class", "labelx")
				/*.attr("fill", "navy")*/
				.text("number of vehicules per year");
				/*.style("font-size", "16px")*/
				

				
				
        // Create function for y-axis map.
        var y = d3.scaleLinear().range([hGDim.h, 0])
                .domain([0, d3.max(fD, function(d) { return d[1]; })]);

        // Create bars for histogram to contain rectangles and freq labels.
        var bars = hGsvg.selectAll(".bar").data(fD).enter()
                .append("g").attr("class", "bar");
				
        
        // utility function to be called on mouseover.
        // filter for selected state.

        var tip = d3.tip()
                    .attr('class', 'd3-tip')
                    .offset([-10, 0])
					
                    .html(function(d) {	
					    var tooltipText ="";
						//Tooltip automatique avec le label et la valeur associée
					    for(i=0; i<d3.keys(fData[0].fuel).length; i++){
                             tooltipText += d3.keys(fData[0].fuel)[i] + " : " + d3.values(fData.filter(function(j){ return j.year == d[0];})[0].fuel)[i] + "<br>";
						    }
						//tooltipText = tooltipText + "Vs : " + fData.filter(function(j){ return j.journee == d[0]})[0].adversaire ; 
                        return  tooltipText;
		                });
				  
        
		// Call it on the garph
		hGsvg.call(tip);
		
        //create the rectangles.
        bars.append("rect")
            .attr("x", function(d) { return x(d[0]); })
            .attr("y", function(d) { return y(d[1]); })
            .attr("width", x.bandwidth())
            .attr("height", function(d) { return hGDim.h - y(d[1]); })
            .attr('fill',barColor)
                .on("mouseover",function(d){ tip.show(d); mouseover(d); //d3.select(".labely").style("opacity", 0)
			    })// mouseover is defined below.
				.on("mouseout",function(d){ 
				tip.hide(d); mouseout(d); //d3.select(".labely").style("opacity", 0).transition().duration(30).style("opacity", 0.8); 
				});// mouseout is defined below.
            

		
		

        function mouseover(d){  // utility function to be called on mouseover.
            // filter for selected state.
            var jn = fData.filter(function(j){ return j.year == d[0];})[0],
                nD = d3.keys(jn.fuel).map(function(j){ return {type:j, fuel: jn.fuel[j]};});
             
            pC.update(nD);
            leg.update(nD);
        }
        
        function mouseout(d){    // utility function to be called on mouseout.
            // reset the pie-chart and legend.
                      
            pC.update(tF);
            leg.update(tF);
        }
        
        // create function to update the bars. This will be used by pie-chart.
        hG.update = function(nD, color){
            // update the domain of the y-axis map to reflect change in frequencies.
            y.domain([0, d3.max(nD, function(d) { return d[1]; })]);
            
            // Attach the new data to the bars.
            var bars = hGsvg.selectAll(".bar").data(nD);
            
            // transition the height and color of rectangles.
            bars.select("rect").transition().duration(500)
                .attr("y", function(d) {return y(d[1]); })
                .attr("height", function(d) { return hGDim.h - y(d[1]); })
                .attr("fill", color);

            // transition the frequency labels location and change value.
            bars.select("text").transition().duration(500)
                .text(function(d){ return d3.format(",")(d[1])})
                .attr("y", function(d) {return y(d[1])-5; });            
        }        
        return hG;
    }
    
    // function to handle pieChart.
    function pieChart(pD){
        var pC ={},    pieDim ={w:200, h: 190};
        pieDim.r = (Math.min(pieDim.w, pieDim.h)-20) / 2;
                
        // create svg for pie chart.
        var piesvg = d3.select(id).append("svg")
            .attr("width", pieDim.w).attr("height", pieDim.h).append("g")
            .attr("transform", "translate("+(pieDim.w/2 +8)+","+(pieDim.h/2)+")");
        
        // create function to draw the arcs of the pie slices.
        var arc = d3.arc().outerRadius(pieDim.r - 10).innerRadius(0);

        // create a function to compute the pie slice angles.
        var pie = d3.pie().sort(null).value(function(d) { return d.fuel; });

        // Draw the pie slices.
        piesvg.selectAll("path").data(pie(pD)).enter().append("path").attr("d", arc)
            .each(function(d) { this._current = d; })
            .style("fill", function(d) { return color(d.data.type); })
            .on("mouseover",mouseover).on("mouseout",mouseout);

        // create function to update pie-chart. This will be used by histogram.
        pC.update = function(nD){
            piesvg.selectAll("path").data(pie(nD)).transition().duration(500)
                .attrTween("d", arcTween);
        }        
        // Utility function to be called on mouseover a pie slice.
        function mouseover(d){
            // call the update function of histogram with new data.
            hG.update(fData.map(function(v){ 
                return [v.year,v.fuel[d.data.type]];}),color(d.data.type));
        }
        //Utility function to be called on mouseout a pie slice.
        function mouseout(d){
            // call the update function of histogram with all data.
            hG.update(fData.map(function(v){
                return [v.year,v.total];}), barColor);
        }
        // Animating the pie-slice requiring a custom function which specifies
        // how the intermediate paths should be drawn.
        function arcTween(a) {
            var i = d3.interpolate(this._current, a);
            this._current = i(0);
            return function(t) { return arc(i(t));    };
        }    
        return pC;
    }
    
    // function to handle legend.
    function legend(lD){
        var leg = {};
            
        // create table for legend.
        var legend = d3.select(id).append("table").attr('class','legend')
		                /*.append("g")
						.attr("transform", "translate(5, )")*/;
        
        // create one row per segment.
        var tr = legend.append("tbody").selectAll("tr").data(lD).enter().append("tr");
            
        // create the first column for each segment.
        tr.append("td").append("svg").attr("width", '16').attr("height", '16').append("rect")
            .attr("width", '16').attr("height", '16')
            .each(function(d) { this._current = d; })
			.attr("fill",function(d){ return color(d.type); })
            .on("mouseover",mouseover).on("mouseout",mouseout);
		
		function mouseover(d){
            // call the update function of histogram with new data.
            hG.update(fData.map(function(v){ 
                return [v.year,v.fuel[d.type]];}),color(d.type));
        }
        //Utility function to be called on mouseout a pie slice.
        function mouseout(d){
            // call the update function of histogram with all data.
            hG.update(fData.map(function(v){
                return [v.year,v.total];}), barColor);
        }
            
        // create the second column for each segment.
        tr.append("td").text(function(d){ return d.type;});

        // create the third column for each segment.
        tr.append("td").attr("class",'legendFreq')
            .text(function(d){ return d3.format(",")(d.fuel);});

        // create the fourth column for each segment.
        tr.append("td").attr("class",'legendPerc')
            .text(function(d){ return getLegend(d,lD);});
            

        // Utility function to be used to update the legend.
        leg.update = function(nD){
            // update the data attached to the row elements.
            var l = legend.select("tbody").selectAll("tr").data(nD);

            // update the frequencies.
            l.select(".legendFreq").text(function(d){ return d3.format(",")(d.fuel);});

            // update the percentage column.
            l.select(".legendPerc").text(function(d){ return getLegend(d,nD);});        
        }
        
        function getLegend(d,aD){ // Utility function to compute percentage.
            return d3.format(",.2%")(d.fuel/d3.sum(aD.map(function(v){ return v.fuel; })));
        }

        return leg;
    }
    
    // calculate total frequency by segment for all state.
    var tF = d3.keys(fData[0].fuel).map(function(d){  // pour avoir le nom des perfs : but cadres et non cadres ["but","cadres","non cadres"]
        return {type:d, fuel: d3.sum(fData.map(function(t){ return t.fuel[d];}))}; 
    });    
  
    // calculate total frequency by state for all segment.
    var sF = fData.map(function(d){return [d.year,d.total];});

    var hG = histoGram(sF), // create the histogram.
        pC = pieChart(tF), // create the pie-chart.
        leg= legend(tF);  // create the legend.


});