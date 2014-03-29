library(shiny)


shinyUI(pageWithSidebar(
  headerPanel("MSAN622 Homework2"),
  sidebarPanel(
    
    #MPAA radio buttons
    radioButtons(
      "mpaa_rating",
      strong("MPAA_Rating"),c("All","PG-13","PG","R", "NC-17"),selected = "All"),
    
    HTML("</br>"),
    
    #Genre Checkbox 
    checkboxGroupInput(
      "genre",
      strong("Genre"),c("Action",
                "Animation",  
                "Comedy",
                "Documentary",         
                "Drama",
                "Mixed",
                "Romance",
                "Short",
                "None"),
      selected=c("Action",
                "Animation",  
                "Comedy",
                "Documentary",
                "Drama",
                "Mixed",
                "Romance",
                "Short",
                "None")),
    
    HTML("<br>"),
    HTML("<strong><p>Scatter Plot by Facet</p></strong>"),
    checkboxInput("facet","ON",value=FALSE),
    
    #Color by
    HTML("<br>"),
    selectInput(inputId ="color_by", 
                label = strong("Color by"), 
                choices = c("MPAA","Genre"),
                selected = "MPAA"),

    #Xlim and Ylim
    wellPanel(
      HTML("<strong><p>Plot setting(does not change table)</p></strong>"),
      selectInput("palette", "Color Scheme",
                  choices = c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"),
                  selected = "Default"),
      selectInput("bw", "BackGround Color",
                  choices = c("Default", "Black","White"),
                  selected = "Default"),
      sliderInput("dotsize", "Dot size:",
                min = 1, max = 10, value = 3, step=1),
      sliderInput("dotalpha", "Dot Alpha:",
                min = 0.1, max = 1, value = 1,step=0.1)
        )
    
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Scatter Plot", 
               plotOutput("scatterPlot",width="100%",height="100%")
               ),
      tabPanel("Table", dataTableOutput("table"))
        )
      )
  )
)