shinyUI(navbarPage("Switch Plot",
                   tabPanel("Bubble Chart",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           wellPanel(
                                           selectInput("bubble_x", "X axis", c("Population",
                                                                               "Income",
                                                                              "Illiteracy",
                                                                              "Life.Exp",
                                                                              "Murder",
                                                                              "HS.Grad",
                                                                              "Frost",
                                                                              "Area"), selected = "Population"),
                                           uiOutput("x_range_slider")),
                                           
                                           
                                           wellPanel(
                                           selectInput("bubble_y", "Y axis", c("Population",
                                                                               "Income",
                                                                               "Illiteracy",
                                                                               "Life.Exp",
                                                                               "Murder",
                                                                               "HS.Grad",
                                                                               "Frost",
                                                                               "Area"), selected = "Income"),
                                           uiOutput("y_range_slider")),
                                           
                                           
                                           radioButtons("bubble_color", "Color by:", c("Region",
                                                                                       "Division"), selected = "Region"),
                                           
                                          selectInput("bubble_size","Bubble Size",c("Population",
                                                                                     "Income",
                                                                                     "Area"), selected = "Area"),
                                          checkboxInput("textOn","Put State Lable",value=TRUE)
               ), #end of sideBar
               mainPanel(
                 tabsetPanel(
                   tabPanel("Bubble Chart", 
                            plotOutput("bubble_chart",width="100%",height="100%")
                   ),
                   tabPanel("Table", dataTableOutput("table"))
                    ) #tabsetPanel end
                 ) #MainPanel end
              ) # sideBarLayout end
                   ), # tabPanel end
              
              #Scatter Plot Matrix
              tabPanel("Scatter Plot Matrix",
                       sidebarLayout(
                         sidebarPanel(width=3,
                                      checkboxGroupInput("sm_var", "Select variables", 
                                                         c("Population",
                                                           "Income",
                                                           "Illiteracy",
                                                           "Life.Exp",
                                                           "Murder",
                                                           "HS.Grad",
                                                           "Frost",
                                                           "Area")
                                                         , selected = c("Population","Income")),
                                      radioButtons("sm_color", "Color by:", c("Region",
                                                                                "Division"), selected = "Region"),
                                      
                                      uiOutput("sm_subset")
                         ),
                         mainPanel(
                           plotOutput("smplot","Scatter Plot Matrix", width="100%",height="100%")
                         )
                       )
              ),
                                      
                                      
              
              #Parallel Coordinate Plot Panel
              tabPanel("Parallel Coordinate Plot",
                       sidebarLayout(
                         sidebarPanel(width=3,
                                      wellPanel(
                                        checkboxGroupInput("para_var", "Select variables", 
                                                           c("Population",
                                                             "Income",
                                                             "Illiteracy",
                                                             "Life.Exp",
                                                             "Murder",
                                                             "HS.Grad",
                                                             "Frost",
                                                             "Area")
                                                           , selected = c("Population","Income")),
                                        radioButtons("para_color", "Color by:", c("Region",
                                                                                    "Division"), selected = "Region"),
                                        
                                        uiOutput("para_groups"),
                                        selectInput("scale","Scaling :", c("std",
                                                                           "robust",
                                                                           "uniminmax",
                                                                           "globalminmax",
                                                                           "center",
                                                                           "centerObs"),selected="std")
                                        
                                        ), #wellPanel end
                          wellPanel(
                            sliderInput("linesize", "Line Size:",
                                        min = 1, max = 10, value = 1, step=1),
                            sliderInput("linealpha", "Line Alpha:",
                                        min = 0.1, max = 1, value = 1,step=0.1)
                            ) # wellPanel end
                                      ),
                         mainPanel(
                           tabsetPanel(
                             tabPanel("Parallel Coordinates Plot", 
                                      plotOutput("paraplot",width="100%",height="100%")
                             ),
                             tabPanel("Table", dataTableOutput("table2")),
                             tabPanel("Debug", textOutput("debug"))
                           ) #tabsetPanel end
                         ) #MainPanel end
                       ) # sideBarLayout end
              ) # tabPanel end
    
              
              
              
              
) #navBar end
) #shinyUI end