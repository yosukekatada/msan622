####################################
## Data visualization : Homework5 ##
####################################

library(ggplot2)
library(shiny)
library(reshape2)


loadData<-function(){
  df<-Seatbelts
  times<-melt(time(df))
  years<-floor(times)
  month<-melt(cycle(df))
  df<-as.data.frame(df)
  df<-cbind(times,years,month,df)
  colnames(df)[1:3]<-c("time","year","month")
  df<-as.data.frame(as.matrix(df))
  df$year<-factor(df$year,ordered=TRUE)
  
  #Transform the number of the people killed or indured into the number of those per 100 km
  df$DriversKilled <-df$DriversKilled / df$kms *100
  df$drivers <-df$drivers / df$kms *100
  df$front <-df$front / df$kms *100
  df$rear <-df$rear / df$kms *100
  df$VanKilled <-df$VanKilled / df$kms *100
  
  return(df)
}


#Line/Stacked Area Plot (Brushing)
get_lineplot<-function(df,y_var,stack=FALSE,x_range){
  #Create dataset
  var_all<-c("time","drivers","front","rear")
  df2<-df[,var_all]
  df2<-melt(df2,"time")
  df3<-subset(df2,variable %in% y_var)
  df3<-subset(df3,time >=x_range[1])
  df3<-subset(df3,time <=x_range[2])

  createPalette<- colorRampPalette(brewer.pal(3,"Set1"))
  colpalette<-createPalette(3)
  colourList<-setNames(colpalette,levels(df2$variable))
  
  
  if(dim(df3)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=20)+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            axis.title.x = element_blank(),
            axis.title.y = element_blank())
  }else{
    if(stack){
      g<-ggplot(df3)+geom_area(aes(x=time, y=value,fill=variable),position="stack")
      g <- g +scale_fill_manual(values=colourList) 
      
    }else{
      g<-ggplot(df3)+geom_line(aes(x=time, y=value,col=variable))
      g <- g + scale_colour_manual(values=colourList)     
      }
    year_range<-paste(x_range[1],x_range[2],sep="-")
    title_lab <- paste("Road Causalities in Great Britain ",year_range,sep="")
    g<-g + labs(title=title_lab, x="Year", y = "The number of people killed or seriously injured \n per 100km drive")
    g<-g+scale_x_continuous(expand = c(0, 0),breaks = seq(x_range[1], x_range[2]))+
      scale_y_continuous(expand = c(0, 0))+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            plot.title = element_text(size=18),
            axis.title.x = element_text(size=14),
            axis.title.y = element_text(size=14),
            axis.text.y=element_text(size=12),
            axis.text.x=element_text(size=12),
            legend.title = element_text(size=16),
            legend.text = element_text(size=14),
            legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 3)))
    }
  
  return(g)
}


#Line/Stacked Area Plot (Whole)
get_lineplot_overall<-function(df,y_var,stack=FALSE,x_range){
  #Create dataset
  var_all<-c("time","drivers","front","rear")
  df2<-df[,var_all]
  df2<-melt(df2,"time")
  df3<-subset(df2,variable %in% y_var)
  
  
  createPalette<- colorRampPalette(brewer.pal(3,"Set1"))
  colpalette<-createPalette(3)
  colourList<-setNames(colpalette,levels(df2$variable))
  
  
  if(dim(df3)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=20)+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            axis.title.x = element_blank(),
            axis.title.y = element_blank())
  }else{
    if(stack){
      g<-ggplot(df3)+geom_area(aes(x=time, y=value,fill=variable),position="stack")
      g <- g + scale_fill_manual(values=colourList)  
      
      
    }else{
      g<-ggplot(df3)+geom_line(aes(x=time, y=value,col=variable))
      g <- g + scale_colour_manual(values=colourList)      
    }
    g<-g + labs(title="Road Causalities in Great Britain 1969–84", x="Year", y = "The number of people killed or seriously injured \n per 100km drive")
    g<-g+scale_x_continuous(expand = c(0, 0))+
      scale_y_continuous(expand = c(0, 0))+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            plot.title = element_text(size=18),
            axis.title.x = element_text(size=14),
            axis.title.y = element_text(size=14),
            axis.text.y=element_text(size=12),
            axis.text.x=element_text(size=12),
            legend.title = element_text(size=16),
            legend.text = element_text(size=14),
            legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 3)))
    g<- g+annotate("rect", xmin=x_range[1], xmax=x_range[2], ymin=0, ymax=Inf, alpha=0.1, fill="blue")
  }
  
  return(g)
}


#Multiline plot and star plot
get_mlplot<-function(df,y_var,year_selected,star=FALSE,facet=FALSE){
  month_label<-month.abb
  
  createPalette<- colorRampPalette(brewer.pal(9,"Set1"))
  colpalette<-createPalette(length(levels(df$year)))
  colourList<-setNames(colpalette,levels(df$year))
  
  
  df2<-subset(df,year %in% year_selected)
  
  
  if(dim(df2)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=20)+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            axis.title.x = element_blank(),
            axis.title.y = element_blank())
  }else{
    if(star){
      g<-ggplot(df2)+geom_line(aes_string(x="month",y=y_var, col="year"))+scale_x_continuous(breaks=1:12,labels=month_label) + coord_polar(theta="x",start=0)    
    }else{
      g<-ggplot(df2)+geom_line(aes_string(x="month",y=y_var, col="year"))+scale_x_discrete(labels=month_label)    
    }
    if(facet){
      g<-g+facet_wrap(~year)+theme(legend.position = "none",
                                   panel.background = element_rect(fill="white",colour="black"),
                                   panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
                                   panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
                                   panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
                                   panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
                                   plot.title = element_text(size=24),
                                   axis.title.x = element_text(size=20),
                                   axis.title.y = element_text(size=20),
                                   axis.text.y=element_text(size=11),
                                   axis.text.x=element_text(size=11)
      )
    }else{
      g <- g + scale_color_manual(values=colourList)     
      g<-g+theme(legend.title = element_text(size=18),
                 legend.text = element_text(size=16),
                 legend.key = element_rect(fill = "White"))+
        guides(colour = guide_legend(override.aes = list(size = 3)))
      g<-g+theme(panel.background = element_rect(fill="white",colour="black"),
                 panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
                 panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
                 panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"),
                 panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
                 plot.title = element_text(size=24),
                 axis.title.x = element_text(size=20),
                 axis.title.y = element_text(size=20),
                 axis.text.y=element_text(size=20),
                 axis.text.x=element_text(size=20))
    }
    g<-g + labs(title="Monthly Road Causalities in Great Britain 1969–84", x="Month", y = "The number of people killed or seriously injured \n per 100km drive")
}
      
return(g)
}


# Shared data
globalData <- loadData()


#Shiny Server Side
shinyServer(function(input, output, session){
  
  LocalFrame<-globalData  
  
  ###################################
  ### Line Plot/Stacked Area Plot ###
  ###################################
  
  #Plot above (brushing)
  output$line_plot1<-
    renderPlot({
      p<-get_lineplot(df=LocalFrame,
                      y_var=input$y_var,
                      stack=input$stack,
                      x_range = input$x_range)
      print(p)
    },width=1200,height=400)

  
  #Plot below (Whole time series)
  output$line_whole<-
    renderPlot({
      p<-get_lineplot_overall(df=LocalFrame,
                      y_var=input$y_var,
                      stack=input$stack,
                      x_range = input$x_range)
      print(p)
    },width=1200,height=400)
  
  
  ################################
  ### MultiLine Plot/Star Plot ###
  ################################
  
  
  output$line_plot2<-
    renderPlot({
      g<-get_mlplot(df=LocalFrame,
                    y_var=input$var_seclected, 
                    year_selected = input$year_selected, 
                    star=input$star, 
                    facet=input$facet)
      print(g)
    },width=1200,height=800)
  
})