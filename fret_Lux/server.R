if(!require('dplyr'))install.packages("dplyr")
library(dplyr)

if(!require('tidyr'))install.packages("tidyr")
library(tidyr)

#Put your full path to read fret_en.csv
fret = read.table("fret_en.csv", sep=",") 

#transpose data
tfret=t(fret) 
#1st line is the column name, so we save it 
names.col=tfret[1,] 

#Now we transform tfret in a data frame without the column names
tfret=as.data.frame(tfret[-1,], row.names = NULL) 

#Trim data names, put them to lower and then affign it to the data frame tfret
names.col = trimws(names.col) 
names.col[1] = tolower(names.col[1]) 
colnames(tfret) = names.col 

#We know that each type of vehicles begin with "gasoline" and end with "others"
gasoline = grep( "1",match(names.col, "Gasoline")) #Essence
others = grep( "Others",names.col) #Autres
label = gasoline -1

#write a function that extracts data from one type of vehicles.
extract_fret=function(label, others){
        data=tfret[,c(1,(label+1):others)]
        data$category = rep(names.col[label],nrow(tfret))
        return(data)
}

#We apply this function to all data, to seperate data from each type of vehicles
data = mapply( extract_fret, label, others)


#Assign names to each data extracted
data_names = c( "auxcycles", "mocycles", "cars", "mixcars", "util", "buses", "vans", "trucks", "tractors", "spe" )

for(i in 1:length(label)){
        assign(data_names[i], data[[i]])
}

#shiny server part begins trully here
function(input, output, session) {
        
        #data associated to names in selector parts
        df1 <- reactive({switch(input$category1, "Cycles with auxiliary motors" = auxcycles, "Motorcycles" = mocycles, "Cars" = cars, "Cars for mixed use" = mixcars, 
                                "Utility vehicles" = util,  "Buses"= buses, "Vans"= vans, "Trucks" =trucks, "Road Tractors" =tractors, "Special Vehicles"= spe)
        })
        
        df2 <- reactive({switch(input$category2, "Cycles with auxiliary motors" = auxcycles, "Motorcycles" = mocycles, "Cars" = cars, "Cars for mixed use" = mixcars, 
                                "Utility vehicles" = util,  "Buses"= buses, "Vans"= vans, "Trucks" =trucks, "Road Tractors" =tractors, "Special Vehicles"= spe)
        })
        #reactive function that will transform R data to json data for d3.js. 
        #We need to put it in a special format.
        tojson1 <- reactive({
                df = df1()
                df$year =as.factor(df$year)
                df = df %>%
                        select(-category)%>%
                        nest(-c(year)) %>%
                        dplyr::rename( fuel = data) %>%
                        dplyr::select(fuel, year) %>%
                        dplyr::tbl_df()
                print("data")
                print(df)
                
                df = jsonlite::toJSON(df)
                print("tojson")
                print(df)
                df = gsub("],", ",", df)
                df = gsub(":\\[", ":",df)
                df = gsub("[[:space:]]", "", df)
                
                print("json")
                print(df)
                df
        })
        
        #same thing here
        tojson2 <- reactive({
                df = df2()
                df$year =as.factor(df$year)
                df = df %>%
                        select(-category)%>%
                        nest(-c(year)) %>%
                        dplyr::rename( fuel = data) %>%
                        dplyr::select(fuel, year) %>%
                        dplyr::tbl_df()
                
                df = jsonlite::toJSON(df)
                df = gsub("],", ",", df)
                df = gsub(":\\[", ":",df)
                df = gsub("[[:space:]]", "", df)
                df
        })
        
        #here we send the data in the json format to d3.js
        
        observe({
                session$sendCustomMessage(type='jsondata1', tojson1())
        })                
        
        observe({
                var_json = tojson2()
                session$sendCustomMessage(type='jsondata2',var_json)
        })
        
}