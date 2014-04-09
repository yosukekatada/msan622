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
get_Bubble<-function(df, x_var, y_var, size_var, col_var, alpha, xlim,ylim, textOn=TRUE, subset_data){
  
  #Get index for taking size of bubble and color
  sort_idx<-which(colnames(df)==size_var)
  color_idx<-which(colnames(df)==col_var) 
  
  #Subsetting data
  df2<-subset(df, df[,color_idx] %in% subset_data)
  
  if(dim(df2)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point")
    p<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=20)+
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank())
  }else{
    #Order data to avoid smaller bubbles are hidden 
    df2<-df[order(df2[,sort_idx],decreasing=TRUE),]
    
    #Create plot
    p<-ggplot(df2,aes_string(x=x_var, y =y_var))+geom_point(aes_string(color=col_var, size =size_var),alpha=1, position="jitter")
    if(textOn){
      p<-p+geom_text(aes(label = Abbrev),col="#3D3535", hjust =0.5, vjust=0)  
    }
    p<-p+scale_size_continuous(range = c(5,30), guide="none")
    p<-p+coord_cartesian(xlim = xlim,ylim=ylim)
    p<-p+theme(plot.title = element_text(size=24),
               axis.title.x = element_text(size=20),
               axis.title.y = element_text(size=20),
               axis.text.y=element_text(size=18),
               axis.text.x=element_text(size=18),
               legend.title = element_text(size=22),
               legend.text = element_text(size=20),
               panel.grid.minor = element_line(linetype = 3)) 
    p<-p+guides(colour = guide_legend(override.aes = list(size = 10)))
    p + scale_colour_discrete(limits = levels(df[,color_idx]))    
  }
  circle_size = paste("The size of a bubble represents",size_var)
  p<-p+annotate("text",x=(xlim[2]+xlim[1])/2,y= ylim[2]*0.95, label = circle_size,size=7)
  return(p)
}


#Scatter Plot
get_ScatterPlot<-function(df,x_var,col_var,sub){
  
  
  dum_len<-length(unique(df$Region))
  dum_x<-rep(0,dum_len)
  dum_y<-seq(0,-(dum_len-1))
  dummydat<-data.frame(x=dum_x,y=dum_y,Region=levels(df$Region))
  dummydat2<-dummydat[dummydat[,3] %in% sub, ]
  
  idx<-1:dim(df)[2]
  col_idx<-idx[colnames(df) == "Region"]  
  var_idx<-idx[colnames(df) %in% x_var]
  df2<-df[df[,col_idx] %in% sub,]

  
  if(dim(df2)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=20)+
      theme(axis.title.x = element_blank(),
            axis.title.y = element_blank())
  }else{
    if(col_var=="Region"){
      g<-ggpairs(df2,columns=var_idx, 
                 color="Region", 
                 upper = "blank",
                 diag = list(continuous = "density"),
                 lower = list(continuous = "points"),
                 axisLabels = "none")
      
      
      
      
    }else{
      g<-ggpairs(df2,columns=var_idx, 
                 upper = "blank",
                 diag = list(continuous = "density"),
                 lower = list(continuous = "points"),
                 axisLabels = "none") 
    }
    for (i in 1:length(var_idx)) {
      for(j in 1:length(var_idx)){
        
        if(i==j){
          inner = getPlot(g, i, j);
          inner = inner + theme(panel.grid = element_blank());
          g <- putPlot(g, inner, i, j)          
        }else if((i==1) && (j==length(var_idx))){
          if(col_var=="Region"){
            dummy_legend <- ggplot(dummydat2)+geom_text(aes(x=x,y=y,label=Region,col=Region),size=4)+
              theme(panel.background = element_rect(fill="WHITE"),
                    panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(),
                    axis.ticks = element_blank(),
                    axis.title = element_blank(),
                    axis.text = element_blank())
          }else{
            dummy_legend <- ggplot(dummydat2)+geom_text(aes(x=x,y=y,label=Region),size=4)+
              theme(panel.background = element_rect(fill="WHITE"),
                    panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(),
                    axis.ticks = element_blank(),
                    axis.title = element_blank(),
                    axis.text = element_blank())
          }          
          g <- putPlot(g, dummy_legend, i, j);
        }else if(i>j){
          inner = getPlot(g, i, j);
          inner = inner + theme(panel.grid.minor = element_blank(),
                                panel.grid.major = element_line(size=0.5, linetype="dotted"))
          g <- putPlot(g, inner, i, j)          
        }  
        }
    }    
  }
  return(g)
}


#Parallel Coordinate Plot
get_paraPlot<-function(df,x_var,col_var,scale,highlight,size, alpha, bw){
  
  idx<-1:dim(df)[2]
  var_idx<-idx[colnames(df) %in% x_var]
  col_idx<-idx[colnames(df) == col_var]
  
  
  #If user select subset of data, it goes to highlight mode 
  if(length(levels(df[,col_idx]))==length(highlight)){
    q<-ggparcoord(df,columns = var_idx,groupColumn=col_idx,scale=scale,mapping=aes_string(size=size, alpha=alpha))
    q<-q+geom_line(alpha=alpha,show_guide=FALSE)+scale_colour_discrete(limits = levels(df[,col_idx]))
    
  }else{
    
    #Reorder data
    df1<-subset(df, df[,col_idx] %in% highlight)
    df2<-subset(df, !df[,col_idx] %in% highlight)
    df3<-rbind(df2,df1)
    
    colours<-brewer.pal(length(unique(df[,col_idx])),"Spectral")
    colours[!levels(df[,col_idx]) %in% highlight] <-"gray"
    
    q<-ggparcoord(df3,columns = var_idx,groupColumn=col_idx,scale=scale, mapping=aes_string(size=size)) 
    q<-q+geom_line(alpha=alpha,show_guide=FALSE)+scale_colour_manual(values = colours)
  }
    
  #Change the bagground color
  if(bw=="White"){
    q<-q+theme(panel.background=element_rect(fill="White"),
               panel.grid.major.x = element_line(color = "black",size=1))
    q <-q+theme(legend.key = element_rect(fill = "White"))
    
  }else if(bw=="Black"){
    q<-q+theme(panel.background=element_rect(fill="Black"),
               panel.grid.major.x = element_line(color = "white",size=1))
    q <-q+theme(legend.key = element_rect(fill = "Black"))
  }else{
    q<-q+theme(panel.grid.major.x = element_line(color = "black",size=1))
    
  }
  
  #Delete y axis major and minor lines
  q<-q+theme(axis.title.x = element_text(size=20),
        axis.title.y = element_blank(),
        axis.text.y= element_blank(),
        axis.text.x=element_text(size=18),
        legend.title = element_text(size=22),
        legend.text = element_text(size=20),
        axis.ticks = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()) 
  
  
  return(q)
}



#Shiny Server Side
shinyServer(function(input, output,session) {
  LocalFrame<-globalData
  
  ##################
  ## Bubble Chart ##
  ##################
  
  #Output UI for x axis slide bar
  output$x_range_slider <- renderUI({
    x_idx<-which(colnames(LocalFrame)==input$bubble_x)
    xmin <- max(max(LocalFrame[,x_idx]))*-0.05
    xmax <- ceiling(max(LocalFrame[,x_idx])*1.2)
    
    sliderInput(inputId = "x_range",
                label = paste("Limit range"),
                min = xmin, max = xmax, value = c(xmin, xmax))
  })

  #Output UI for y axis slide bar
  output$y_range_slider <- renderUI({
    y_idx<-which(colnames(LocalFrame)==input$bubble_y)
    ymin <- max(max(LocalFrame[,y_idx]))*-0.05
    ymax <- ceiling(max(LocalFrame[,y_idx])*1.2)
    
    sliderInput(inputId = "y_range",
                label = paste("Limit range"),
                min = ymin, max = ymax, value = c(ymin, ymax))
  })
  
  
  #Table
  dat<-reactive({
    x_idx<-which(colnames(LocalFrame)==input$bubble_x)
    y_idx<-which(colnames(LocalFrame)==input$bubble_y)
    col_idx<-which(colnames(LocalFrame)==input$bubble_color)
  
    tmp<-subset(LocalFrame,(LocalFrame[,x_idx] >= input$x_range[1] & 
                              LocalFrame[,x_idx] <= input$x_range[2] &
                              LocalFrame[,y_idx] >= input$y_range[1] &
                              LocalFrame[,y_idx] <= input$y_range[2]))
    tmp<-subset(tmp, tmp[,col_idx] %in% input$bubble_subsetGroup)
  })
  
  output$table<-renderDataTable({
    dat()
  }, options=list(iDisplayLength=15))
  
    
  #Subsetting data
  output$subset_data<-renderUI({
    colIdx<-which(colnames(LocalFrame)==input$bubble_color)
    buble_Group<-unique(LocalFrame[,colIdx])
    checkboxGroupInput(inputId = "bubble_subsetGroup",
                       label = paste("Filtering"),
                       choices=buble_Group, selected = buble_Group)
  })
  
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
                  textOn=input$textOn,
                  subset_data = input$bubble_subsetGroup)
    print(p)
    },width=1200,height=800)
  

  
  ##################
  ## Scatter Plot ##
  ##################
  
  
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
                    alpha = input$linealpha,
                    bw = input$bw_para)
    print(q)
    },height=800)
  
  output$debug<-renderText({paste(input$sm_color)})
})