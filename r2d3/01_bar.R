library(r2d3)

# r2d3(data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20), script = "r2d3/barchart.js")
r2d3(data=c(5,11,18), script = "r2d3/02_barchart2.js")
r2d3(data=c(5,11,18), script = "r2d3/03_barchart3.js")
##########

r2d3(data = read.csv("r2d3/flare.csv"), d3_version = 4, script = "r2d3/bubbles.js")
