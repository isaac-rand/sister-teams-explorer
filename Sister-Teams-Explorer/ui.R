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




# Define UI for the application
shinyUI(fluidPage(

    # Application title
    titlePanel("KBO Sister Teams Explorer for MLB Fans"),

    # This defines the information displayed on the side bar (computer) or at the top of the page (mobile)
    sidebarLayout(
        sidebarPanel( 
            
            # this creates/draws the MLB team dropdown, defined in server
            uiOutput("teamSelect"),   
            
            # this defines and creates the comparison criteria selector
            selectInput(#sets ID for access in server
                        inputId = "comp", 
                        #sets display title
                        label = "Choose a Criteria for Comparison:",
                        #sets choices in dropdown menu
                        choices = c("Number of Championships Won",
                                    "Age of Team",
                                    "Home City GDP",
                                    "Home City Average Annual Temperature",
                                    "Home City Population",
                                    "All of the Above"),
                        #sets defaut selection to NUmber of Championships Won
                        selected = "Number of Championships Won"
            ),
            #this creates/draws the table output of the results defined in the server
            tableOutput("table")
            
        ),

    
        # This defines the output on the right (computer) or bottom (mobile)
        mainPanel(
            #this draws the map output defined in the server
            leafletOutput("map"),
            
            #this puts a new line between the map output and the text below
            br(),
            
            #this draws HTML formatted text.
            #If you are familiar with html, wrapping something in tags$x is equivalent to wrapping it in <x> </x>
            #If you are unfamiliar -- h4 is the tag for smaller header, p is for body text, and a is for links
            #Empty p tags are included for new lines, br() is supposed to do this, but it was not working
            #Check here for a full tag glossary if you're interested https://shiny.rstudio.com/articles/tag-glossary.html
            tags$div(class="header", checked=NA,
                     tags$h4("What does all of this mean?"),
                     tags$p("Every comparison metric used here is internally standardized within the leagues, for more meaningful results. This standardization converts the original data about the teams/cities from both leagues to a new scale, where 0 is mean for the league, and all values represent how many standard deviations the original data was from the mean for the league."),
                     tags$a(href = "https://www.statisticshowto.com/standardized-variables/#:~:text=In%20statistics%2C%20standardized%20variables%20are,were%20measured%20on%20different%20scales", "For more on standardization, click here"),
                     tags$p(""),
                     tags$p("The app as it stands allows users to select one MLB team and one comparison criteria at a time and see what KBO teams are most similar to it using that criteria. The results are output as a table and as a map. The table shows all the KBO teams, their home city, and a field called `Difference`. `Difference` is the absolute value of the difference between the standardized value of the comparison criteria for the MLB team/city selected and the standardized value of the comparison criteria for each KBO team/city. The map output shows each team represented by a point which is shown by its team logo, and sized in inverse proportion to the team's `Difference`."),
                     tags$strong("If that didn't make any sense, what's key is that bigger logos = more similar, smaller logos = more different! And KBO teams are listed from most to least similar on the left!"),
                     tags$p(""),
                     tags$p("When \"All the Above\" is chosen as the comparison criteria, the `Difference` field is equal to the sum of the `Difference` field  as calculated for all of the other comparison criteria."),
                     tags$a(href = "https://github.com/isaac-rand/sister-teams-explorer", "Check out the project github for more information on data sources and methods :)"),
                     tags$p(""),
                     tags$p("DISCLAIMER: All of the comparisons above are provied for entertainment purposes only. You should root for the NC Dinos regardless of the results. #StrongerTogether")
            )
        )
    )
))
