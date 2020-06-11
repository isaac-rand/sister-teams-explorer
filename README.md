# Sister Teams Explorer

## Overview

With most of the United States under some level of lockdown and the Major League Baseball (MLB) season completely stalled out due to the COVID-19 pandemic and owner/player disputes, many American baseball fans are turning to Korean Baseball Organization (KBO) games in South Korea for some much needed entertainment. KBO games have been airing live on ESPN since late April, and will continue to air for at least the rest of the 2020 season. While many American fans are content to pick a team to support at near random or just casually follow the league as a whole, this project was designed for people who are still looking for a team to support but don't know how to choose. 

The code here is for an RShiny app, hosted [here](https://isaacrand.shinyapps.io/Sister-Teams-Explorer/), which would allow users to pick a KBO team to support based on similarity to an MLB team which they already cheer for.

## Goals & Objectives

 The general layout should require the user to choose their favorite MLB team and some metric by which to compare them for similarity to other teams. They should be able to choose from some sports specific measurements (like historic win percentage, total championship wins, etc.) as well as some city specific measurements (like population, average temperature, etc.). This will allow users to choose their new KBO team based on what they found important about their old MLB team.

 I think that most people are originally tied to a baseball team by geography; the team from their city usually becomes their favorite team. Because of this, I would like to allow people to compare their own cities to the cities of South Korea for similarity. Additionally, I think that people become attached to what they see as the personality of their own team, often tied up in historic winning levels or length of team history, so I would like to allow people to compare some metrics of the teams as well. 
 	
  The app will appear with some textual input and output on the left, and a map output of South Korea on the right. The input consists of two drop down menus, allowing users to select their favorite team and the metric they want to use to compare for similarity. Once selected, the text output of all 10 KBO teams in order of similarity would appear on the bottom left. The right side of the application will be a map of South Korea, with all 10 teams mapped. Each team will be represented in their home city by an image of their logo, sized relative to its similarity to the user’s input favorite team (bigger for more similar teams, smaller for less). 

## Data Description

### Data Collection

This project will rely on several data sources representing cities in three different countries: South Korea, the United States, and Canada. In an attempt to maintain consistency of measurement accuracy across cities and countries, the data about each city (population, GDP, temperature) will come from global rasters of that data. Those rasters will be spatially subset by the boundaries of each city in R, in order to get city level data. Administrative boundary data on South Korean Cities will come from the Database of Global Administrative Areas. The boundary data on US Cities comes from the US Center for Disease Control and Prevention. Finally, the boundary data for Toronto (the one Canadian city with representation in the MLB) comes from the city’s website. Data about each team’s history comes from sources individual to each league. 

Information on the data used here (sources, spatial and temporal resolution, definition) is included below. Full sources are at the end of the readme.

![Data on Teams Metadata]("readme_imgs/sis_teams_data.png")

![Data on Teams Dictionary]("readme_imgs/sis_teams_data_dict.png")

![Raster Data Metadata]("readme_imgs/sis_rasts_data.png")


### Data Standardization

Every comparison metric used here will be internally standardized within the leagues, for more meaningful results. This standardization converts the original data from both leagues to a new scale, where 0 is mean for the league, and all values represent how many standard deviations the original data was from the mean for the league. For more on standardization, click [here](https://www.statisticshowto.com/standardized-variables/#:~:text=In%20statistics%2C%20standardized%20variables%20are,were%20measured%20on%20different%20scales.). 
 
The question which the app is designed to answer is "who is the mlb team x of the kbo?." So, instead of just comparing, for example, the year an MLB team was founded to the year a KBO team was founded, the standardization of the data means we are comparing how old an MLB team is for an MLB team to how old a KBO team is for a KBO team. This is important. The oldest KBO team was founded in 1982, whereas some MLB teams go all the way back to the late 1800s. If raw numbers were compared, even the oldest KBO teams would be most similar to relatively new MLB teams. By comparing standardized data, the teams which are oldest for the league they are in are the most similar. The same is principle is true for the other variables (the city's which have the highest/lowest/most average characteristics for the US are most similar to the city's in Korea which have the highest/lowest/most average characteristics).

## Current State of the Project


## Future Work?

## Authorship Details

## Full Data Source Citations
