library(shiny)

shinyUI(navbarPage("Bank Marketing Data Analysis",
                   tabPanel("Basic Profiling",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           selectInput("uni_var",
                                                       "Choose your variable: ",
                                                       c("age",
                                                         "job",
                                                         "marital",
                                                         "education",
                                                         "default",
                                                         "balance",
                                                         "housing",
                                                         "loan",
                                                         "contact",
                                                         "day",
                                                         "month",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous",
                                                         "poutcome"
                                                       ),
                                                       selected="age"),
                                           uiOutput("x_uni_input1"),
                                           uiOutput("x_uni_input2")
                              ), #end of sidebarPanel
                              mainPanel(
                                plotOutput("uni_plot",width="100%",height="100%")
                                ) # end of main panel
                            ) # end of sidebarLayout 
                   ), # end of tabpanel               
                   tabPanel("Heat Map",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           selectInput("multi_x_var",
                                                       "Variable on X-axis: ",
                                                       c("age",
                                                         "job",
                                                         "marital",
                                                         "education",
                                                         "default",
                                                         "balance",
                                                         "housing",
                                                         "loan",
                                                         "contact",
                                                         "day",
                                                         "month",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous",
                                                         "poutcome"
                                                       ),
                                                       selected="age"),
                                           selectInput("multi_y_var",
                                                       "Variable on Y-axis: ",
                                                       c("age",
                                                         "job",
                                                         "marital",
                                                         "education",
                                                         "default",
                                                         "balance",
                                                         "housing",
                                                         "loan",
                                                         "contact",
                                                         "day",
                                                         "month",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous",
                                                         "poutcome"
                                                       ),
                                                       selected="job"),
                                           
                                           sliderInput("breaks_x","Breaks on X variable",
                                                       min = 2, 
                                                       max = 20, 
                                                       value = 10, 
                                                       step = 1),
                                           
                                           sliderInput("breaks_y","Breaks on Y variable",
                                                       min = 2, 
                                                       max = 20, 
                                                       value = 10, 
                                                       step = 1)
                                           
                              ), #end of sidebarPanel
                              mainPanel(
                                plotOutput("heatmap_prop",width="100%",height="100%")
                              ) # end of main panel
                            ) # end of sidebarLayout 
                   ), # end of tabpanel
                   tabPanel("Scatter Plot",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           selectInput("scatter_x_var",
                                                       "Variable on X-axis: ",
                                                       c("age",
                                                         "balance",
                                                         "day",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous"
                                                         ),
                                                       selected="age"),
                                           uiOutput("x_range_slider"),
                                           selectInput("scatter_y_var",
                                                       "Variable on Y-axis: ",
                                                       c("age",
                                                         "balance",
                                                         "day",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous"
                                                       ),
                                                       selected="balance"),
                                           uiOutput("y_range_slider"),
                                           checkboxInput(inputId = "facet_scatter",
                                                         label = "Facet ON",
                                                         value = FALSE),
                                           numericInput("sampsize", 
                                                        "Sample Size", 
                                                        value = 0.1, 
                                                        min = 0.1, 
                                                        max = 1, 
                                                        step = 0.1),
                                           wellPanel(
                                           sliderInput("dotsize", "Dot size:",
                                                       min = 1, max = 10, value = 3, step=1),
                                           sliderInput("dotalpha", "Dot Alpha:",
                                                       min = 0.1, max = 1, value = 1,step=0.1)
                                           )
                              ), #end of sidebarPanel
                              mainPanel(
                                plotOutput("scatterplot",width="100%",height="100%")
                              ) # end of main panel
                            ) # end of sidebarLayout 
                   ), # end of tabpanel
                   tabPanel("Logistic Regression",
                            sidebarLayout(
                              sidebarPanel(width=3,
                                           checkboxGroupInput("glm_x_var",
                                                       "Independent Variable: ",
                                                       c("age",
                                                         "job",
                                                         "marital",
                                                         "education",
                                                         "default",
                                                         "balance",
                                                         "housing",
                                                         "loan",
                                                         "contact",
                                                         "day",
                                                         "month",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous",
                                                         "poutcome"
                                                       ),
                                                       selected=c(
                                                         "age",
                                                         "job",
                                                         "marital",
                                                         "education",
                                                         "default",
                                                         "balance",
                                                         "housing",
                                                         "loan",
                                                         "contact",
                                                         "day",
                                                         "month",
                                                         "duration",
                                                         "campaign",
                                                         "pdays",
                                                         "previous",
                                                         "poutcome"
                                                         )),
                                           numericInput("train_size", 
                                                        "Training Size", 
                                                        value = 0.8, 
                                                        min = 0.1, 
                                                        max = 1, 
                                                        step = 0.1),
                                           numericInput("cut_prob", 
                                                        "Probability threshold", 
                                                        value = 0.50, 
                                                        min = 0, 
                                                        max = 1, 
                                                        step = 0.01),
                                           selectInput(inputId="sort_key",
                                                       label = "Sort Key:",
                                                       choices=c("Coefficient", "P-value"),
                                                       selected ="Coefficient"
                                                       ),
                                           radioButtons(inputId="std_coef_order",
                                                        label ="Sorting",
                                                        choices = c("decreasing" = FALSE,"increasing" = TRUE),
                                                        selected = FALSE),
                                             actionButton("model_run","Run")
                              ), #end of sidebarPanel
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Model", 
                                      div(class="row",
                                        div(class="span1"),
                                        div(class="span6",                                
                                          h4("Logistic Regression"),
                                            verbatimTextOutput("glm_summary")),
                                        div(class="span5", 
                                          h4("Confusion Matrix"),
                                              verbatimTextOutput("conf_mat"),
                                          h4("Accuracy Report"),
                                            tableOutput("acc_repo")
                                      )
                                    )
                                  ), # end of tabPanel
                                  tabPanel("Standardized Coeffcients",
                                           plotOutput("importance",width="100%",height="100%")
                                           )#end of tabPanel
                                ) #end of tabsetPanel
                            ) # end of main panel
                          ) # end of sidebarLayout 
                   ), # end of tabpanel
      tabPanel("ROI Simulation",
            sidebarLayout(
                sidebarPanel(width=3,
                    HTML("<strong><p>Parameters</p></strong>"),
                    numericInput("sim_timeline", 
                                          "Simulation Timeline", 
                                          value = 20, 
                                          min = 10, 
                                          max = NA, 
                                          step = 1),
                    numericInput("target_customer", 
                                 "Num. of target customer", 
                                 value = 10000, 
                                 min = 0, 
                                 max = NA, 
                                 step = 1),
                    numericInput("camp_cost", 
                                 "Camp. Cost per person", 
                                 value = 50, 
                                 min = 0, 
                                 max = NA, 
                                 step = 1),
                    numericInput("payout_int_rate",
                                 "Payout Interest Rate",
                                 value=0.01,
                                 min=0,
                                 max=NA,
                                 step=NA),
                    numericInput("balance_rate",
                                 "% of the existing balance to term deposit",
                                 value = 0.1,
                                 min = 0,
                                 max = 1,
                                 step = NA),
                    numericInput("inv_int_rate",
                                 "Invest Rate of balance",
                                 value = 0.05,
                                 min = 0,
                                 max = 1,
                                 step = NA),
                    numericInput("ret_cost",
                                 "Retetion Cost per person",
                                 value = 100,
                                 min = 0,
                                 max = NA,
                                 step = NA),
                    numericInput("churn",
                                 "Churn Rate",
                                 value = 0.02,
                                 min = 0,
                                 max = 1,
                                 step = NA),
                    numericInput("discount_rate",
                                 "Discount Rate",
                                 value = 0.1,
                                 min = 0,
                                 max = 1,
                                 step = NA),
                    actionButton("sim_run","Refelect parameters")
                  ), #end of sidebarPanel
        mainPanel(
          tabsetPanel(
            tabPanel("ROI Plot", 
                     plotOutput("roi_plot",width="100%",height="100%")
            ),
            tabPanel("Table",
                     tableOutput("roi_table"),
                     textOutput("attention")
                     )
                    ) # end of tabsetPanel
                ) #end of mainPanel
            ) # end of sidebarLayout 
      ) # end of tabPanel             
  )#End of navbar page
) #end of shiny UI
