library(shiny)

shinyUI(navbarPage("Time Series Plots",
                   tabPanel("Line/Stacked Area Plot",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           radioButtons("stack","Line Plot or Stacked Area Plot: ",c("Line Plot"="FALSE","Stacked Area Plot"="TRUE"),selected="FALSE"),
                                           wellPanel(
                                             HTML("<strong>Select Variable and Range of Year</strong><br>"),
                                             HTML("<br>"),
                                             checkboxGroupInput("y_var", "Select Variables", c("drivers",
                                                                                          "front",
                                                                                          "rear"), 
                                                                selected = c("drivers",
                                                                             "front",
                                                                             "rear")
                                             ), # end of checkGroupInput
                                             HTML("<br>"),
                                              sliderInput(inputId = "x_range",
                                                           label = paste("Select Range of Year"),
                                                           min = 1969, 
                                                          max = 1985, 
                                                          value = c(1969, 1985),
                                                          step=1
                                                          )) # end of wellPanel
                                             
                              ), #end of sidebarPanel
                            mainPanel(
                              plotOutput("line_plot1",width="100%",height="100%"),
                              plotOutput("line_whole",width="100%",height="100%")
                            ) # end of main panel
                            ) # end of sidebarLayout 
                  ), # end of tabpanel
                  
        tabPanel("Multi-Line Chart/Star Plot",
                 sidebarLayout(
                   sidebarPanel(width=3,
                                radioButtons("star",
                                             "Multi-Line Plot or Star Plot: ",
                                             c("Multi-Line Plot"="FALSE","Star Plot"="TRUE"),selected="FALSE"
                                ),
                                checkboxInput("facet",
                                              "Facet ON",
                                              value = FALSE),
                                wellPanel(
                                  HTML("<strong>Select Variable and Year</strong><br>"),
                                  HTML("<br>"),
                                  radioButtons("var_seclected", "Variable", c("drivers",
                                                                               "front",
                                                                               "rear"), 
                                                     selected = "drivers"
                                  ), # end of checkGroupInput
                                  HTML("<br>"),
                                  checkboxGroupInput("year_selected", "Year",c("1969",
                                                                               "1970",
                                                                               "1971",
                                                                               "1972",
                                                                               "1973",
                                                                               "1974",
                                                                               "1975",
                                                                               "1976",
                                                                               "1977",
                                                                               "1978",
                                                                               "1979",
                                                                               "1980",
                                                                               "1981",
                                                                               "1982",
                                                                               "1983",
                                                                               "1984"),
                                                     selected = c("1969",
                                                                  "1970",
                                                                  "1971",
                                                                  "1972",
                                                                  "1973",
                                                                  "1974",
                                                                  "1975",
                                                                  "1976",
                                                                  "1977",
                                                                  "1978",
                                                                  "1979",
                                                                  "1980",
                                                                  "1981",
                                                                  "1982",
                                                                  "1983",
                                                                  "1984")
                                                     ))# end of wellPanel
                                  ), #end of sidebarPanel
                   mainPanel(
                     plotOutput("line_plot2",width="100%",height="100%")
                      ) # end of main panel
                 ) # end of sidebarLayout 
        ) # end of tabpanel
      )#End of navbar page
) #end of shiny UI

