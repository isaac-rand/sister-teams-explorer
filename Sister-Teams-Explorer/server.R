#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Loading the libraries the app is dependent on
library(shiny)      #server - ui interaction, drawing
library(sf)         #spatial data handling
library(leaflet)    #creating interactive maps
library(dplyr)      #data handling

#reading kbodata shapefile
kbodata <- st_read("data/kbodata.shp") 

#sorting kbodata alphabetically
#this ends up being pretty important, only change this if you're ready to change a bunch else
#(mostly for assigning rankedTeams() and icon values to the right team)
kbodata <- arrange(kbodata, team_nm)

#defining points at centroids of cities teams are in
kbodata$point = st_centroid(kbodata$geometry)

#spreading out the three teams from Seoul so that they do not occupy the same point
kbodata[kbodata$team_nm == "LG Twins", ]$point <- kbodata[kbodata$team_nm == "LG Twins", ]$point + c(-0.1, 0.5)
kbodata[kbodata$team_nm == "Doosan Bears", ]$point <- kbodata[kbodata$team_nm == "Doosan Bears", ]$point + c(0.25, 0.25)
kbodata[kbodata$team_nm == "Kiwoom Heroes", ]$point <- kbodata[kbodata$team_nm == "Kiwoom Heroes", ]$point + c(0.4, 0)

#This defines the links shown in the map popups. The first link is to the team wiki, the second is to the team's city's wiki.
#html is used to turn the links from strings into real links
link <- c("<a href = https://en.wikipedia.org/wiki/Doosan_Bears> Learn More about the Doosan Bears</a><br>
          <a href = https://en.wikipedia.org/wiki/Seoul> Learn More about Seoul</a>",
           "<a href = https://en.wikipedia.org/wiki/Hanwha_Eagles> Learn More about the Hanwha Eagles</a><br>
          <a href = https://en.wikipedia.org/wiki/Daejeon> Learn More about Daejeon</a>",
           "<a href = https://en.wikipedia.org/wiki/Kia_Tigers> Learn More about the Kia Tigers</a><br>
          <a href = https://en.wikipedia.org/wiki/Gwangju> Learn More about Gwangju</a>",
           "<a href = https://en.wikipedia.org/wiki/Kiwoom_Heroes> Learn More about the Kiwoom Heroes</a><br>
          <a href = https://en.wikipedia.org/wiki/Seoul> Learn More about Seoul</a>",
           "<a href = https://en.wikipedia.org/wiki/KT_Wiz> Learn More about the KT Wiz</a><br>
          <a href = https://en.wikipedia.org/wiki/Suwon> Learn More about Suwon</a>",
           "<a href = https://en.wikipedia.org/wiki/LG_Twins> Learn More about the LG Twins</a><br>
          <a href = https://en.wikipedia.org/wiki/Seoul> Learn More about Seoul</a>",
           "<a href = https://en.wikipedia.org/wiki/Lotte_Giants> Learn More about the Lotte Giants</a><br>
          <a href = https://en.wikipedia.org/wiki/Busan> Learn More about Busan</a>",
           "<a href = https://en.wikipedia.org/wiki/NC_Dinos> Learn More about the NC Dinos</a><br>
          <a href = https://en.wikipedia.org/wiki/Changwon> Learn More about Changwon</a>",
           "<a href = https://en.wikipedia.org/wiki/Samsung_Lions> Learn More about the Samsung Lions</a><br>
          <a href = https://en.wikipedia.org/wiki/Daegu> Learn More about Daegu</a>",
           "<a href = https://en.wikipedia.org/wiki/SK_Wyverns> Learn More about the SK Wyverns</a><br>
          <a href = https://en.wikipedia.org/wiki/Incheon> Learn More about Incheon</a>")
#links were laid out in alphabetical order, matching the data's order so a simple join works like this
kbodata$link <- link

#reading in the data on mlb teams/cities
mlbdata <- st_read("data/mlbdata.shp")


# Define server logic required to draw app
shinyServer(function(input, output) {
    
    #creates a list of the mlb names
    mlbNames <- as.list(mlbdata$team_nm)
    
    #defines input which allows users to select their mlb team from that list
    #selects Arizona Diamondbacks (alphabetically first) as the default
    output$teamSelect <- renderUI({
        selectInput("mlbteam", "Pick Your Favorite MLB Team:", (mlbNames), selected = "Arizona Diamondbacks") 
    })
    
    #defines the data frame which is eventually output beneath the input drop downs
    #includes team name, home city, and calculated Difference from MLB team for all KBO Teams for a given comparison factor
        # first checks what the comparison factor is
        # then binds into a data frame the team, the city, and the difference (calculated in line)
        # then renames all columns
        # then sorts rows by how different KBO teams are from MLB teams
    rankedTeams <- reactive({
        if(input$comp == "Number of Championships Won"){
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$chmp_st - kbodata$chmp_st),
                             stringsAsFactors = FALSE) %>%
                rename("Team" = 1, 
                       "Home City" = 2, 
                       "Difference" = 3) %>%
                arrange(Difference)
        }
        else if(input$comp == "Age of Team"){
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$yr_std - kbodata$yr_std),
                             stringsAsFactors = FALSE) %>%
                rename("Team" = 1, 
                       "Home City" = 2, 
                       "Difference" = 3) %>%
                arrange(Difference)
        }
        else if(input$comp == "Home City GDP"){
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$gdp_std - kbodata$gdp_std),
                             stringsAsFactors = FALSE) %>%
                rename("Team" = 1, "Home City" = 2, "Difference" = 3) %>%
                arrange(Difference)
        }
        else if(input$comp == "Home City Average Annual Temperature"){
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$tmp_std - kbodata$tmp_st),
                             stringsAsFactors = FALSE) %>%
                rename("Team" = 1, "Home City" = 2, "Difference" = 3) %>%
                arrange(Difference)
        }
        else if(input$comp == "Home City Population"){
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$pop_std - kbodata$pop_std),
                             stringsAsFactors = FALSE) %>%
                rename("Team" = 1, "Home City" = 2, "Difference" = 3) %>%
                arrange(Difference)
        }
        else{
            #difference for "All the Above" defined here
            #difference = sum of difference for all other comparison criteria
            cbind.data.frame(kbodata$team_nm, 
                             kbodata$city_nm, 
                             abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$pop_std - kbodata$pop_std) +
                                abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$gdp_std - kbodata$gdp_std) +
                                abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$tmp_std - kbodata$tmp_st) +
                                abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$yr_std - kbodata$yr_std) +
                                abs(mlbdata[mlbdata$team_nm == input$mlbteam,]$chmp_st - kbodata$chmp_st),
                             stringsAsFactors = FALSE)  %>%
                rename("Team" = 1, "Home City" = 2, "Difference" = 3) %>%
                arrange(Difference)
        }
        
    })

    #defines the actual table to be drawn using the rankedTeams() dataframe generated above
    #Set caption "Sister Teams" to be drawn above table
    output$table <- renderTable({rankedTeams()}, caption=paste("Sister Teams"),
                                caption.placement = getOption("xtable.caption.placement", "top"))
    
    #defines the icons to be displayed on the map for each time
    #sets both the image and the size
    leafIcons <- reactive({
         icons(
                #sets the right image for the right team depending on team name
                #the icons are set in alphabetical order (the order of the data set as imposed above)
                #since they are in alphabetical order here, they are each assigned to the right team
                #this saves a long switch or many nested ifelse statements
                iconUrl = (c("imgs/doosan_bears.png", 
                            "imgs/hanwha_eagles.png",
                            "imgs/kia_tigers.png",
                            "imgs/kiwoom_heroes.png",
                            "imgs/kt_wiz.png",
                            "imgs/lg_twins.png",
                            "imgs/lotte_giants.png",
                            "imgs/nc_dinos.png", 
                            "imgs/samsung_lions.png",
                            "imgs/sk_wyverns.png")),
                
               
                #sets the icon dimensions to 45 - 15 * the standardized Difference
                #standardized difference = how much more or less different this team is from the MLB team compared to the others
                #standardizing the difference ends up being important because one team, is unfortunately unparalleled.
                #The New York Yankees have just one too many championships, their difference scores end up really high
                #all teams differences end up standardized basically to avoid this
                #but there is an added bonus! without standardizing all the greater differences would end up making the icons smaller when 'all the above' is selected without it
                #once again, the right team is assigned the right data because of the consistent order of the teams in the data
                iconWidth = 45 - 15 * (((arrange(rankedTeams(), Team)$Difference) - mean(rankedTeams()$Difference)) / sd(rankedTeams()$Difference)),
                iconHeight = 45 - 15 * (((arrange(rankedTeams(), Team)$Difference) - mean(rankedTeams()$Difference)) / sd(rankedTeams()$Difference))
                )
    })
    
    #defines the leaflet output map
    leafMap <- reactive({
        leaflet() %>%
            #adds basemap from Stamen
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            #adds the icons defined above to the map at the point stored in kbodata
            addMarkers(data = kbodata$point, 
                       icon = leafIcons(),
                       #sets up popup. If you click on the icon in the app. it will allow you to navigate to team or city wikis.
                       popup = kbodata$link)
        })
    
    #defines the actual map to be drawn in UI as the map above. Names it map.
    output$map <- renderLeaflet({leafMap()})
    
})
