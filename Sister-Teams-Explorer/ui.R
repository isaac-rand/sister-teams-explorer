#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(leaflet)




# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("KBO Sister Teams Explorer for MLB Fans"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            uiOutput("teamSelect"),
            selectInput(inputId = "comp",
                        label = "Choose a Criteria for Comparison:",
                        choices = c("Number of Championships Won",
                                    "Age of Team",
                                    "Home City GDP",
                                    "Home City Average Annual Temperature",
                                    "Home City Population",
                                    "All of the Above")
            ),
            tableOutput("table")
            
        ),

    
        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("map"),
            br(),
            textOutput("disclaimer")
        )
    )
))
