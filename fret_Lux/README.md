### Introduction
This shiny application is a dashboard that displays the evolution of fuel categories per vehicles in Luxembourg between 1997 and 2017.
This application is composed of an interface file (**ui.R**) and a server file (**server.R**).

**fret_en.csv** is the data file and the www folder regroups all files that are related to the d3js graph:

 - **d3.min.js** is the library used
 
 - **d3-tip.js** is the tooltip used for the graphics
 
 - **fretjs1.js** & **fretjs2.js** are the graphics
 
 - **stylessheet.css** is the css file for the style associated to the graphics.

You can see the shiny application in action [here](http://wozametrics.com/visualization/fret)




### Before running the code

You have to provide the complete path were you put your d6152.csv file. You have to insert the path at the line 8 of server.R

<!-- -->

    7   #Put your full path to read fret_en.csv
    8   fret = read.table("yourPath/fret_en.csv", sep=",") 
    

Enjoy this application and if you have any issues to make it work correctly, you can always watch my [tutorial video](https://youtu.be/GHRZaiYh2Ac) or [contact me](mailto:kevinrosamont@ymail.com).
