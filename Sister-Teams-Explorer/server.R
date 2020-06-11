#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(leaflet)
library(dplyr)

kbodata <- st_read("data/kbodata.shp") 
kbodata <- arrange(kbodata, team_nm)
kbodata$point = st_centroid(kbodata$geometry)
kbodata[kbodata$team_nm == "LG Twins", ]$point <- kbodata[kbodata$team_nm == "LG Twins", ]$point + c(-0.1, 0.5)
kbodata[kbodata$team_nm == "Doosan Bears", ]$point <- kbodata[kbodata$team_nm == "Doosan Bears", ]$point + c(0.25, 0.25)
kbodata[kbodata$team_nm == "Kiwoom Heroes", ]$point <- kbodata[kbodata$team_nm == "Kiwoom Heroes", ]$point + c(0.4, 0)

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
kbodata$link <- link
mlbdata <- st_read("data/mlbdata.shp")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    mlbNames <- as.list(mlbdata$team_nm)
    
    output$teamSelect <- renderUI({
        selectInput("mlbteam", "Pick Your Favorite MLB Team:", (mlbNames)) 
    })
    

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


    output$table <- renderTable({rankedTeams()}, caption=paste("Sister Teams"),
                                caption.placement = getOption("xtable.caption.placement", "top"))
    leafIcons <- reactive({
         icons(
                iconUrl = ifelse(kbodata$team_nm == "Doosan Bears",
                                 "imgs/doosan_bears.png",
                            ifelse(kbodata$team_nm == "NC Dinos", 
                                   "imgs/nc_dinos.png", 
                            ifelse(kbodata$team_nm == "Hanwha Eagles", 
                                   "imgs/hanwha_eagles.png",
                            ifelse(kbodata$team_nm == "Samsung Lions", 
                                   "imgs/samsung_lions.png",
                            ifelse(kbodata$team_nm == "Kiwoom Heroes",
                                   "imgs/kiwoom_heroes.png",
                            ifelse(kbodata$team_nm == "SK Wyverns",
                                   "imgs/sk_wyverns.png",
                            ifelse(kbodata$team_nm == "LG Twins",
                                   "imgs/lg_twins.png",
                            ifelse(kbodata$team_nm == "KT Wiz",
                                   "imgs/kt_wiz.png",
                            ifelse(kbodata$team_nm == "Kia Tigers",
                                   "imgs/kia_tigers.png",
                                   "imgs/lotte_giants.png"))))))))),
                iconWidth = 45 - 15 * (((arrange(rankedTeams(), Team)$Difference) - mean(rankedTeams()$Difference)) / sd(rankedTeams()$Difference)),
                iconHeight = 45 - 15 * (((arrange(rankedTeams(), Team)$Difference) - mean(rankedTeams()$Difference)) / sd(rankedTeams()$Difference))
                )
    })
    
    #iconWidth = 10 * filter(rankedTeams(), KBOTeamName == kbodata$team_nm)$Difference, 
    #iconHeight = 10 * filter(rankedTeams(), KBOTeamName == kbodata$team_nm)$Difference
    leafMap <- reactive({
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addMarkers(data = kbodata$point, 
                       icon = leafIcons(),
                       popup = kbodata$link)
        })
    
    output$map <- renderLeaflet({leafMap()})
    
    output$disclaimer <- renderText("DISCLAIMER: All of the comparisons above are provied for entertainment purposes only. You should root for the NC Dinos regardless of the results. #StrongerTogether")
})
