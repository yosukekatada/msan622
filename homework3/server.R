library(ggplot2)
library(shiny)
library(RColorBrewer)
library(GGally)

loadData<-function(){
  df <- data.frame(state.x77,
                   State = state.name,
                   Abbrev = state.abb,
                   Region = state.region,
                   Division = state.division)
  df$Region <- as.factor(df$Region)
  df$Abbrev <- as.factor(df$Abbrev)
  df$Division <- as.factor(df$Division)
  return(df)
}

# Shared data
globalData <- loadData()

#Bubble Chart
get_Bubble<-function(df, x_var, y_var, size_var, col_var, alpha, xlim,ylim, textOn=TRUE){
  sort_idx<-which(colnames(df)==size_var)
  df<-df[order(df[,sort_idx],decreasing=TRUE),]
  p<-ggplot(df,aes_string(x=x_var, y =y_var))+geom_point(aes_string(color=col_var, size =size_var),alpha=1, position="jitter")
  if(textOn){
    p<-p+geom_text(aes(label = Abbrev),col="#3D3535", hjust =0.5, vjust=0)  
  }
  p<-p+scale_size_continuous(range = c(5,30), guide="none")
  
  p<-p+coord_cartesian(xlim = xlim,ylim=ylim)
  return(p)
}


#Scatter Plot
get_ScatterPlot<-function(df,x_var,col_var,sub){
  
  idx<-1:dim(df)[2]
  col_idx<-idx[colnames(df) == col_var]
  var_idx<-idx[colnames(df) %in% x_var]
  
  df2<-df[df[,11] %in% sub,]
  g<-ggpairs(df2,columns=var_idx,color=col_var)
  return(g)
}


#Parallel Coordinate Plot
get_paraPlot<-function(df,x_var,col_var,scale,highlight,size, alpha){
  
  idx<-1:dim(df)[2]
  var_idx<-idx[colnames(df) %in% x_var]
  col_idx<-idx[colnames(df) == col_var]
  
  #If user select subset of data, it goes to highlight mode 
  if(length(levels(df[,col_idx]))==length(highlight)){
    q<-ggparcoord(df,columns = var_idx,groupColumn=col_idx,scale=scale,mapping=aes_string(size=size, alpha=alpha))
    q<-q+geom_line(alpha=alpha,show_guide=FALSE)
  }else{
    
    #Reorder data
    df1<-subset(df, df[,col_idx] %in% highlight)
    df2<-subset(df, !df[,col_idx] %in% highlight)
    df<-rbind(df2,df1)
    
    colours<-brewer.pal(length(unique(df[,col_idx])),"Spectral")
    colours[!levels(df[,col_idx]) %in% highlight] <-"gray"
    
    q<-ggparcoord(df,columns = var_idx,groupColumn=col_idx,scale=scale, mapping=aes_string(size=size)) 
    q<-q+geom_line(alpha=alpha,show_guide=FALSE)+scale_colour_manual(values = colours)
  }
  
  return(q)
}




shinyServer(function(input, output,session) {
  LocalFrame<-globalData
  
  ##################
  ## Bubble Chart ##
  ##################
  
  #Output UI for x axis slide bar
  output$x_range_slider <- renderUI({
    x_idx<-which(colnames(LocalFrame)==input$bubble_x)
    xmin <- 0
    xmax <- ceiling(max(LocalFrame[,x_idx])*1.2)
    
    sliderInput(inputId = "x_range",
                label = paste("Limit range"),
                min = xmin, max = xmax, value = c(xmin, xmax))
  })

  #Output UI for y axis slide bar
  output$y_range_slider <- renderUI({
    y_idx<-which(colnames(LocalFrame)==input$bubble_y)
    xmin <- 0
    xmax <- ceiling(max(LocalFrame[,y_idx])*1.2)
    
    sliderInput(inputId = "y_range",
                label = paste("Limit range"),
                min = xmin, max = xmax, value = c(xmin, xmax))
  })
  
  
  #Table
  dat<-reactive({
    x_idx<-which(colnames(LocalFrame)==input$bubble_x)
    y_idx<-which(colnames(LocalFrame)==input$bubble_y)
  
    tmp<-subset(LocalFrame,(LocalFrame[,x_idx] >= input$x_range[1] & 
                              LocalFrame[,x_idx] <= input$x_range[2] &
                              LocalFrame[,y_idx] >= input$y_range[1] &
                              LocalFrame[,y_idx] <= input$y_range[2]
                              ))
  })
  
  output$table<-renderDataTable({
    dat()
  }, options=list(iDisplayLength=15))
  
    
  #Bubble chart
  output$bubble_chart<-
    renderPlot({
    p<-get_Bubble(df=LocalFrame,x_var=input$bubble_x,
                  y_var=input$bubble_y,
                  size_var=input$bubble_size, 
                  col_var=input$bubble_color, 
                  alpha=1, 
                  xlim=input$x_range, 
                  ylim=input$y_range,
                  textOn=input$textOn)
    print(p)
    },width=1000,height=800)
  

  
  ##################
  ## Scatter Plot ##
  ##################
  
  output$sm_subset<- renderUI({
    colIdx<-which(colnames(LocalFrame)==input$sm_color)
    subsetGroup<-unique(LocalFrame[,colIdx])
    checkboxGroupInput(inputId = "sm_subsetGroup",
                       label = paste("Filtering"),
                       choices=subsetGroup, selected = subsetGroup)
  })
  
  
  output$smplot<-renderPlot({
    g<-get_ScatterPlot(df = LocalFrame,
                       x_var = input$sm_var,
                       col_var = input$sm_color,
                       sub = input$sm_subsetGroup)
    print(g)
  },height=800,width=1200)
  
  
  ##############################
  ## Paralell Coordinate Plot ##
  #############################
  
  #Paralell cordinate plot
  #Output UI for y axis slide bar
  output$para_groups <- renderUI({
    colIdx<-which(colnames(LocalFrame)==input$para_color)
    hightlightGroup<-unique(LocalFrame[,colIdx])
    checkboxGroupInput(inputId = "highlight",
                label = paste("Highlight Groups"),
                choices=hightlightGroup, selected = hightlightGroup)
  })
  
  
  
  output$paraplot<- renderPlot({
    q<-get_paraPlot(df=LocalFrame,
                    x_var = input$para_var,
                    col_var = input$para_color,
                    scale=input$scale,
                    highlight = input$highlight,
                    size = input$linesize,
                    alpha = input$linealpha)
    print(q)
    },height=600)
  
  output$debug<-renderText({paste(input$sm_subset,input$sm_color)})
})