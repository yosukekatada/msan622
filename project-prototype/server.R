########################################
## Data visualization : Final Project ##
########################################

library(ggplot2)
library(reshape2)
library(reshape)
library(scales)
library(grid)
library(plyr)
library(RColorBrewer)

loadData<-function(){
  data<-read.csv("bank-full.csv",sep=";")
  data$job<-as.character(data$job)
  data$job[data$job=="blue-collar"]<-"blue_collar"
  data$job<-factor(data$job)
  colnames(data)[17]<-"subscribed"
  data$subscribed<-relevel(data$subscribed,ref="yes")
  return(data)
}


#Read R source
source("get_plots.R")


#Univariate Plot
get_univariate<-function(var_type, data,x_var,facet=FALSE,log_scale=FALSE, hundred=FALSE, decreasing=FALSE){
  if(var_type %in% c("integer","numeric")){
      get_density_and_box(data=data,x_var=x_var,facet=facet,log_scale=log_scale)    
  }else{
    if(hundred){
      get_hundredbar(data=data,x_var=x_var,decreasing=decreasing)
    }else{
      get_barchart(data=data,x_var=x_var,decreasing=decreasing)          
    }
  }
}



# Shared data
globalData <- loadData()


#Shiny Server Side
shinyServer(function(input, output, session){
  
  LocalFrame<-globalData
  
  #######################
  ### Basic Profiling ###
  #######################
  
  #Get which variable is selected
  uni_class<-reactive({
    uni_x_idx<-which(colnames(LocalFrame)==input$uni_var)
    class(LocalFrame[,uni_x_idx])
    })
  
  #When the selected variable is numeric or integer, FACET UI is on.
  #Other than that, Radio button to switch Bar chart type is on 
  output$x_uni_input1<- renderUI({
    if(uni_class() %in% c("integer","numeric")){
      checkboxInput(inputId = "facet",
                    label = "Facet ON",
                    value = FALSE)
    }else{
      radioButtons(inputId="hundred",
                   label ="Bar Plot Type",
                   choices = c("Normal" = FALSE,"100% Stacked Bar" = TRUE),
                   selected = FALSE)
    }
  })

  #When the selected variable is numeric or integer, Log Scaling is on.
  #Other than that, Sorting is on 
  output$x_uni_input2<-renderUI({
    if(uni_class() %in% c("integer","numeric")){
      checkboxInput(inputId = "log_scale",
                    label = "Log_scale",
                    value = FALSE)
    }else{
      radioButtons(inputId="decreasing",
                   label ="Sorting",
                   choices = c("decreasing" = FALSE,"increasing" = TRUE),
                   selected = FALSE)
      }
  })
  
  #Plot
  output$uni_plot<-
    renderPlot({
      get_univariate(var_type=uni_class(),
                     data = LocalFrame,
                     x_var = input$uni_var,
                     facet=input$facet,
                     log_scale=input$log_scale, 
                     decreasing=input$decreasing,
                     hundred = input$hundred
      )
    },width=1000,height=800)
  
 
  
  ################
  ### Heat Map ###
  ################
  
  #Get which variables are selected
  multi_x_class<-reactive({
    multi_x_idx<-which(colnames(LocalFrame)==input$multi_x_var)
    class(LocalFrame[,multi_x_idx])
  })
  
  multi_y_class<-reactive({
    multi_y_idx<-which(colnames(LocalFrame)==input$multi_y_var)
    class(LocalFrame[,multi_y_idx])
  })
  

  #Heat Map
  output$heatmap_prop<-
    renderPlot({
      get_Heatmap(data=LocalFrame,
                  x_var = input$multi_x_var,
                  y_var = input$multi_y_var,
                  breaks_x = input$breaks_x,
                  breaks_y = input$breaks_y,
                  plot_sample_size=FALSE)
    },width=1000,height=800)
      
  
  ####################
  ### Scatter Plot ###
  ####################
  
  #After getting max and min on variables, range slider is on
  output$x_range_slider <- renderUI({
    x_idx<-which(colnames(LocalFrame)==input$scatter_x_var)
    
  
    min_digit<-floor(log10(abs(min(LocalFrame[,x_idx]))+1))
    max_digit<-floor(log10(abs(max(LocalFrame[,x_idx]))+1))
    digit<-10^min(min_digit,max_digit)
    
    xmin<-floor(min(LocalFrame[,x_idx])/digit)*digit
    xmax<-ceiling(max(LocalFrame[,x_idx])/digit)*digit
    
    
    sliderInput(inputId = "x_range",
                label = paste("Limit range"),
                min = xmin, max = xmax, value = c(xmin, xmax))    
  })

  #After getting max and min on variables, range slider is on
  output$y_range_slider <- renderUI({
    y_idx<-which(colnames(LocalFrame)==input$scatter_y_var)
    
    min_digit<-floor(log10(abs(min(LocalFrame[,y_idx]))+1))
    max_digit<-floor(log10(abs(max(LocalFrame[,y_idx]))+1))
    digit<-10^min(min_digit,max_digit)
    
    ymin<-floor(min(LocalFrame[,y_idx])/digit)*digit
    ymax<-ceiling(max(LocalFrame[,y_idx])/digit)*digit
    
    
    sliderInput(inputId = "y_range",
                label = paste("Limit range"),
                min = ymin, max = ymax, value = c(ymin, ymax))
    })
  

  #Scatter Plot
  output$scatterplot<-
    renderPlot({
      parallel_scatterPlot(data=LocalFrame,
                  x_var = input$scatter_x_var,
                  y_var = input$scatter_y_var,
                  sampsize=input$sampsize, 
                  facet=input$facet_scatter, 
                  alpha=input$dotalpha, 
                  size= input$dotsize,
                  x_range = input$x_range,
                  y_range = input$y_range)
    },width=1400,height=900)
  
  ###########################
  ### Logistic Regression ###
  ###########################

  #Execute Logistic Regression
  glm_res<-reactive({
    input$model_run
    logistic_reg(data=LocalFrame,
                 x_var = isolate(input$glm_x_var),
                 train_size= isolate(input$train_size),
                 cut_prob= isolate(input$cut_prob)
    )
  })
    
  #Summary of Logistic Regression  
  output$glm_summary<-renderPrint({
    glm_res()$Result
  })

  #Confusion Matrix
  output$conf_mat<-renderPrint({
    glm_res()$Confusion_mat
  })
  output$acc_repo<-renderTable({
    glm_res()$Accuracy_report
  })

  #Standardized Coef
  output$importance<-renderPlot({
    get_ImportancePlot(importanceData = glm_res()$importanceData,
                       decreasing=input$std_coef_order,
                       title="Standardized Coefficients", 
                       y_lab="Score"
    )},width=1200,height=800
  )

  
  ######################
  ### ROI Simulation ###
  ######################
  
  #Run the simulation  
  sim_table<-reactive({
    input$sim_run
    ROI_simulation(sim_timeline = isolate(input$sim_timeline),
                   precision = isolate(glm_res()$Accuracy_report[,2]),
                   target_customer = isolate(input$target_customer),
                   camp_cost = isolate(input$camp_cost),
                   payout_int_rate = isolate(input$payout_int_rate),
                   ave_balance = isolate(glm_res()$balance) ,
                   balance_rate = isolate(input$balance_rate),
                   inv_int_rate =isolate(input$inv_int_rate),
                   ret_cost = isolate(input$ret_cost) ,
                   churn = isolate(input$churn) ,
                   discount_rate =isolate(input$discount_rate) )
  })
  
  #Plot ROI simulation Plot
  output$roi_plot<-renderPlot({
    input$sim_run  
    get_simulationPlot(
      sim_table=isolate(sim_table()),
      target_customer = isolate(input$target_customer),
      camp_cost = isolate(input$camp_cost))
  }, width=1200, height=900)

  #Show ROI Table
  output$roi_table<-renderTable({
    input$sim_run
    sim_table()    
  })
  
  output$attention<-renderText({
    print("NOTE: Discounted Cash Flow in the last column is the aggregated value in the future")
  })
  
}) #end of shinyserver