library(ggplot2)
library(reshape2)
library(reshape)
library(scales)
library(grid)
library(plyr)
library(RColorBrewer)


##############################
## Univariate visualization ##
##############################

#Bar chart
get_barchart<-function(data,x_var,decreasing=decreasing){
  
  x_idx<-which(colnames(data)==x_var)
  sortOrder<-order(table(data[,x_idx]),decreasing=decreasing)
  fact_level<-levels(data[,x_idx])
  data[,x_idx]<-factor(data[,x_idx],levels=fact_level[sortOrder])
  make_title<-paste("The number of the customers",x_var,sep="-")
  
  
  colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
  
  p<-ggplot(data)+geom_bar(aes_string(x=x_var,fill="subscribed"))+coord_flip()
  p<-p+labs(title = make_title, y="The number of the customers")
  p<-p+scale_y_continuous(expand = c(0, 0))
  p<-p+scale_fill_manual(values=colourList) 
  p<-p+theme(legend.position = "bottom", legend.justification = c(1, 1))
  p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
             panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
             panel.grid.major.y = element_blank(),
             panel.grid.minor.y = element_blank(),
             plot.title = element_text(size=20),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_blank(),
             axis.text.y=element_text(size=16,colour="black"),
             axis.text.x=element_text(size=12),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 3))) 
  print(p)
}


#100% bar chart
get_hundredbar<-function(data,x_var,decreasing){

  x_idx<-which(colnames(data)==x_var)
  y_idx<-which(colnames(data)=="subscribed")
  
  dat_tmp<-table(data[,x_idx],data[,y_idx])
  dat_tmp<-dat_tmp/apply(dat_tmp,1,sum)
  sortOrder<-order(dat_tmp[,1],decreasing=decreasing)
  dat_tmp<-as.data.frame(dat_tmp)
  fact_level<-levels(dat_tmp[,1])
  dat_tmp[,1]<-factor(dat_tmp[,1],levels=fact_level[sortOrder])
  colnames(dat_tmp)[1:2]<-c(x_var,"subscribed")
  
  colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
  
  make_title<-paste("The number of the customers",x_var,sep="-")
  
  p<-ggplot(dat_tmp)+geom_bar(aes_string(x=x_var,y="Freq",fill="subscribed"),position="fill",stat="identity")+scale_y_continuous(expand = c(0, 0),labels = percent_format())+coord_flip()
  p<-p+labs(title = make_title, y="The number of the customers")
  p<-p+scale_fill_manual(values=colourList) 
  p<-p+theme(legend.position = "bottom", legend.justification = c(1, 1))
  p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
             panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
             panel.grid.major.y = element_blank(),
             panel.grid.minor.y = element_blank(),
             plot.title = element_text(size=20),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_blank(),
             axis.text.y=element_text(size=16,colour="black"),
             axis.text.x=element_text(size=12),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 3))) 
  print(p)  
}



#Density and Boxplot
get_density_and_box<-function(data,x_var, facet = TRUE, log_scale=FALSE){
  
  x_idx<-which(colnames(data)==x_var)
  y_idx<-which(colnames(data)=="subscribed")
  
  df<-as.data.frame(data[,c(x_idx,y_idx)])
  
  colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
  make_title<-paste("Distribution of the customers",x_var,sep="-")

  if(log_scale){
    df<-df[df[,1]>0,]
    del_row<-nrow(data)-nrow(df)
    if(del_row>0){
      tmp_text<-paste(del_row,"rows are deleted by Log scaling",sep=" ")
      make_title<-paste(make_title, tmp_text, sep="\n")
    }
    
    df[,1]<-log(df[,1]+1)
    x_var<-paste(x_var,"Log_scale",sep="_")
    colnames(df)<-c(x_var,"subscribed")
  }
  
  
  
  #Density Plot
  a<-ggplot(df)+geom_density(aes_string(x=x_var,y="..density.." ,group="subscribed",fill="subscribed",col="subscribed"),position="dodge",alpha=0.1)
  if(facet){
    a<-a+facet_wrap(~subscribed,ncol=1)    
  }
  
  a<-a+scale_fill_manual(values=colourList)+scale_color_manual(values=colourList) 
  a<-a+scale_x_continuous(expand = c(0, 0))+scale_y_continuous(expand = c(0, 0))    
  
  a<-a+theme(legend.position = "bottom", legend.justification = c(1, 1))
  a<-a+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_blank(),
             panel.grid.minor.x = element_blank(),
             panel.grid.major.y = element_blank(),
             panel.grid.minor.y = element_blank(),
             plot.title = element_text(size=20),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_blank(),
             axis.text.y=element_text(size=12,colour="black"),
             axis.text.x=element_text(size=16,colour="black"),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 0))) 

  #Boxplot
  b<-ggplot(df)+geom_boxplot(aes_string(x="subscribed",y=x_var,fill="subscribed"))
  b<-b+scale_fill_manual(values=colourList) 
  b<-b+theme(legend.position = "bottom", legend.justification = c(1, 1))
  b<-b+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_blank(),
             panel.grid.minor.x = element_blank(),
             panel.grid.major.y = element_blank(),
             panel.grid.minor.y = element_blank(),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_text(size=16,colour="black"),
             axis.text.y=element_text(size=12,colour="black"),
             axis.text.x=element_text(size=16,colour="black"),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 0))) 
  
  
  grid.newpage()
  pushViewport(viewport(layout=grid.layout(2, 2, heights = unit(c(0.5, 5),"null")))) 
  grid.text(make_title, vp = viewport(layout.pos.row = 1, layout.pos.col = 1:2),gp=gpar(fontsize=20))
  print(a, vp=viewport(layout.pos.row=2, layout.pos.col=1))
  print(b, vp=viewport(layout.pos.row=2, layout.pos.col=2))  
}


################################
## Multivariate visualization ##
################################
#Discretize numerical value
discretize<-function(data3,idx,breaks){
  
  min_dat<-min(data3[,idx])
  max_dat<-max(data3[,idx])
  
  if(min_dat==0){
    min_dat<-1
  }
  if(max_dat==0){
    max_dat<-1
  }
  
  min_digit<-floor(log10(abs(min_dat)))
  max_digit<-floor(log10(abs(max_dat)))
  digit<-10^min(min_digit,max_digit)
  min_dat<-floor(min(data3[,idx])/digit)*digit
  max_dat<-ceiling(max(data3[,idx])/digit)*digit
  bin<-(max_dat-min_dat)/breaks
  disc_breaks<-seq(min_dat,max_dat,bin)
  disc_labels<-NULL
  for(i in 2:length(disc_breaks)){
    tmp_lab<-paste(round(disc_breaks[i-1]),round(disc_breaks[i]),sep = "\n to ")
    disc_labels<-c(disc_labels,tmp_lab)
  }  
  
  data3[,idx]<-cut(data3[,idx],breaks=disc_breaks,labels = disc_labels, ordered_result=TRUE, include.lowest=TRUE)
  return(data3)
}


#Heat Map
get_Heatmap<-function(data,x_var,y_var,breaks_x = 10, breaks_y =10 ,plot_sample_size=FALSE){
  if(x_var==y_var){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "Please use different columns \n for x and y")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=14)+
      theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.8,linetype="dotted"), 
            panel.grid.minor.y = element_line(color="gray",size=0.1,linetype="dotted"),
            axis.title.x = element_blank(),
            axis.title.y = element_blank())
    print(g)
  }else{
    x_idx<-which(colnames(data)==x_var)
    y_idx<-which(colnames(data)==y_var)
    z_idx<-which(colnames(data)=="subscribed")
    
    data3<-as.data.frame(data[,c(x_idx,y_idx,z_idx)])
    
    colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
    
    make_title<-paste("Heat Map",paste(x_var,y_var,sep = " and "),sep=" ")
    
    breaks<-c(breaks_x,breaks_y)
    
    for(i in 1:2){
      if(is.numeric(data3[,i])){
        data3<-discretize(data3=data3,idx=i,breaks=breaks[i]) 
      }    
    }
    
    #if variable is numeric
    data3<-melt(data3,id.vars=c(1,2),measure.vars=c(3))
    formula<-as.formula(paste(x_var,paste(y_var,"~ value"),sep=" + "))
    data3<-cast(data3,formula,length)
    data3$proportion<-data3$yes/(data3$yes+data3$no)
    data3$sample_size<-data3$yes+data3$no
    
    if(!plot_sample_size){
      p<-ggplot(data3)+geom_tile(aes_string(x=x_var,y=y_var,fill="proportion"))
      p<-p+scale_fill_gradient2(low =colourList[2], mid="white", high = colourList[1], midpoint=0.5)
      p<-p+scale_x_discrete(expand = c(0, 0))+scale_y_discrete(expand = c(0, 0))
      p<-p+ggtitle(paste(make_title,"Proportion of the customer who subscribe",sep=" - "))
      p<-p+theme(panel.background = element_rect(fill="#545252",colour="black"),
                 panel.grid.major.x = element_blank(),
                 panel.grid.minor.x = element_blank(),
                 panel.grid.major.y = element_blank(),
                 panel.grid.minor.y = element_blank(),
                 plot.title = element_text(size=20),
                 axis.title.x = element_text(size=16,colour="black"),
                 axis.title.y = element_text(size=16,colour="black"),
                 axis.text.y=element_text(size=14,colour="black"),
                 axis.text.x=element_text(size=14,colour="black"),
                 legend.title = element_text(size=16),
                 legend.text = element_text(size=14),
                 legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size =2)))
      print(p)
    }else{
      g<-ggplot(data3)+geom_tile(aes_string(x=x_var,y=y_var,fill="sample_size"))
      g<-g+scale_x_discrete(expand = c(0, 0))+scale_y_discrete(expand = c(0, 0))    
      g<-g+ggtitle(paste(make_title,"Sample Size",sep=" "))
      g<-g+theme(panel.background = element_rect(fill="white",colour="black"),
                 panel.grid.major.x = element_blank(),
                 panel.grid.minor.x = element_blank(),
                 panel.grid.major.y = element_blank(),
                 panel.grid.minor.y = element_blank(),
                 plot.title = element_text(size=20),
                 axis.title.x = element_text(size=16,colour="black"),
                 axis.title.y = element_text(size=16,colour="black"),
                 axis.text.y=element_text(size=14,colour="black"),
                 axis.text.x=element_text(size=14,colour="black"),
                 legend.title = element_text(size=16),
                 legend.text = element_text(size=14),
                 legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size =2)))
      print(g)
    }
  }
}



#Scatter plot
#Overall
get_scatterPlot1<-function(data, x_var, y_var, sampsize=0.1, facet=TRUE, alpha=alpha, size=size,x_range,y_range){
  
  x_idx<-which(colnames(data)==x_var)
  y_idx<-which(colnames(data)==y_var)
  z_idx<-which(colnames(data)=="subscribed")
  
  df_tmp<-as.data.frame(data[,c(x_idx,y_idx,z_idx)])
  

  #Define Min and Max on X
  min_digit<-floor(log10(abs(min(df_tmp[,1]))+1))
  max_digit<-floor(log10(abs(max(df_tmp[,1]))+1))
  digit<-10^min(min_digit,max_digit)
  xmin<-floor(min(df_tmp[,1])/digit)*digit
  xmax<-ceiling(max(df_tmp[,1])/digit)*digit
  
  #Define Min and Max on Y
  min_digit<-floor(log10(abs(min(df_tmp[,2]))+1))
  max_digit<-floor(log10(abs(max(df_tmp[,2]))+1))
  digit<-10^min(min_digit,max_digit)
  ymin<-floor(min(df_tmp[,2])/digit)*digit
  ymax<-ceiling(max(df_tmp[,2])/digit)*digit
  
  set.seed(1234)
  idx<-sample(1:dim(df_tmp)[1],dim(df_tmp)[1]*sampsize)
  
  df<-df_tmp[idx,]
  tmp_yes<-subset(df,subscribed=="yes")
  tmp_no<-subset(df,subscribed=="no")
  df<-rbind(tmp_no,tmp_yes)
  
  colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
  
  
  p<-ggplot(df)+geom_point(aes_string(x=x_var,y=y_var,col="subscribed"),alpha=alpha,size=size)
  p<-p+scale_x_continuous(limits=c(xmin,xmax))+scale_y_continuous(limits=c(ymin,ymax))
  if(facet){
    p<-p+facet_wrap(~subscribed,,ncol=1)    
  }
  p<-p+scale_color_manual(values=colourList)   
  p<-p+ggtitle("Overall")
  p<-p+theme(legend.position="top")
  p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_line(color="gray",size=0.5,linetype="dotted"),
             panel.grid.minor.x = element_line(color="gray",size=0.2,linetype="dotted"),
             panel.grid.major.y = element_line(color="gray",size=0.5,linetype="dotted"),
             panel.grid.minor.y = element_line(color="gray",size=0.2,linetype="dotted"),
             plot.title = element_text(size=20),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_text(size=16,colour="black"),
             axis.text.y=element_text(size=14,colour="black"),
             axis.text.x=element_text(size=14,colour="black"),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = size)))
  p<- p+annotate("rect", xmin=x_range[1], xmax=x_range[2], ymin=y_range[1], ymax=y_range[2], alpha=0.3, fill="blue")
  return(p)
}

#Filtering
get_scatterPlot2<-function(data, x_var, y_var, sampsize=0.1, facet=TRUE, alpha=alpha, size=size, x_range,y_range){
  
  x_idx<-which(colnames(data)==x_var)
  y_idx<-which(colnames(data)==y_var)
  z_idx<-which(colnames(data)=="subscribed")
  
  df_tmp<-as.data.frame(data[,c(x_idx,y_idx,z_idx)])

  
  set.seed(1234)
  idx<-sample(1:dim(df_tmp)[1],dim(df_tmp)[1]*sampsize)
  df_tmp<-df_tmp[idx,]
  tmp_yes<-subset(df_tmp,subscribed=="yes")
  tmp_no<-subset(df_tmp,subscribed=="no")
  df_tmp<-rbind(tmp_no,tmp_yes)
  
  #Subsetting
  df<-df_tmp[((df_tmp[,1] >=x_range[1])&(df_tmp[,1] <=x_range[2])),]
  df<-df[((df[,2] >=y_range[1])&(df[,2] <=y_range[2])),]
  
  colourList<-setNames(c("#E41A1C", "#377EB8"),levels(data$subscribed))
  
  if(dim(df)[1]==0){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "There is no data point \n Please select different area")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=13)
    g<-g+ggtitle("Detail")
    g<-g+theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_line(color="gray",size=0.5,linetype="dotted"),
            panel.grid.minor.x = element_line(color="gray",size=0.2,linetype="dotted"),
            panel.grid.major.y = element_line(color="gray",size=0.5,linetype="dotted"),
            panel.grid.minor.y = element_line(color="gray",size=0.2,linetype="dotted"),
            plot.title = element_text(size=20),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_blank(),
            axis.text.x = element_blank()
            )
    return(g)
  }else{
    p<-ggplot(df)+geom_point(aes_string(x=x_var,y=y_var,col="subscribed"),alpha=alpha,size=size)
    if(facet){
      p<-p+facet_wrap(~subscribed,ncol=1)    
    }
    p<-p+ggtitle("Detail")
    p<-p+scale_color_manual(values=colourList)
    p<-p+theme(legend.position="top")
    p<-p+scale_x_continuous(limits=c(x_range[1],x_range[2]))+scale_y_continuous(limits=c(y_range[1],y_range[2]))
    p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
               panel.grid.major.x = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.x = element_line(color="gray",size=0.2,linetype="dotted"),
               panel.grid.major.y = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.y = element_line(color="gray",size=0.2,linetype="dotted"),
               plot.title = element_text(size=20),
               axis.title.x = element_text(size=16,colour="black"),
               axis.title.y = element_text(size=16,colour="black"),
               axis.text.y=element_text(size=14,colour="black"),
               axis.text.x=element_text(size=14,colour="black"),
               legend.title = element_text(size=16),
               legend.text = element_text(size=14),
               legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = size)))
    
    return(p)    
  }
}

#Scatter Plot (Overall and Detail)
parallel_scatterPlot<-function(data, x_var, y_var, sampsize, facet, alpha, size, x_range,y_range){
   #Overall
    a<-get_scatterPlot1(data=data, x_var=x_var, y_var =y_var, sampsize=sampsize, facet=facet, alpha=alpha, size=size, x_range=x_range,y_range=y_range)
    #Detail
    b<-get_scatterPlot2(data=data, x_var=x_var, y_var =y_var, sampsize=sampsize, facet=facet, alpha=alpha, size=size, x_range=x_range,y_range=y_range)
    
    grid.newpage()
    pushViewport(viewport(layout=grid.layout(2, 2, heights = unit(c(0.5, 5),"null")))) 
    grid.text("Scatter Plot (Detail and Overall)", vp = viewport(layout.pos.row = 1, layout.pos.col = 1:2),gp=gpar(fontsize=20))
    print(b, vp=viewport(layout.pos.row=2, layout.pos.col=1))
    print(a, vp=viewport(layout.pos.row=2, layout.pos.col=2))  
    
}


#Modeling Part
#Logistic Regression
logistic_reg<-function(data,x_var,train_size=0.8,cut_prob=0.5){

  #Refactor
  data$subscribed<-relevel(data$subscribed,ref="no")
  
  #Samping
  idx<-sample(1:dim(data)[1],dim(data)[1]*train_size)
  
  #Prepare dataset
  y_var<-"subscribed"
  x_idx<-which(colnames(data) %in% x_var)
  y_idx<-which(colnames(data) == y_var)
  x<-as.data.frame(data[,x_idx])
  colnames(x)<-x_var
  y<-as.data.frame(data[,y_idx])
  colnames(y)<-y_var  
  df<-cbind(y,x)
  
  train<-as.data.frame(df[idx,])
  
  
  #Fitted GLM (normal)
  data_glm<-glm(subscribed~.,data=train,family="binomial")
  data_glm_summary<-summary(data_glm)
  coef<-data_glm_summary$coef
  
  #Scale dataset
  data_mm<-model.matrix(data_glm)
  df_scale<-as.data.frame(cbind(y[idx,],as.data.frame(scale(data_mm[,-1]))))
  colnames(df_scale)[1]<-"subscribed"
  colnames(df_scale)[2:length(colnames(df_scale))]<-colnames(data_mm)[2:length(colnames(data_mm))]
  
  #Fitted GLM (standardized)
  data_glm_scale<-glm(subscribed~.,data=df_scale,family="binomial")
  data_glm_scale_summary<-summary(data_glm_scale)

  if(length(x_var)==1){
    coef_scale<-data_glm_scale_summary$coef[-1,]
    significance_scale<-ifelse(coef_scale[4]<0.001,"p-value < 0.1%", 
                               ifelse((coef_scale[4] < 0.01) & (coef_scale[4]>=0.001), "p-value < 1%", 
                                      ifelse((coef_scale[4] < 0.05) & (coef_scale[4]>=0.01),"p-value < 5%", "p-value >=5%")))
    
    
    imp_scale<-data.frame(Importance = coef_scale[1],p_value=coef_scale[4])
    row.names(imp_scale)<-x_var
    
    
  }else{
    coef_scale<-data_glm_scale_summary$coef[-1,]
    significance_scale<-ifelse(coef_scale[,4]<0.001,"p-value < 0.1%", 
                               ifelse((coef_scale[,4] < 0.01) & (coef_scale[,4]>=0.001), "p-value < 1%", 
                                      ifelse((coef_scale[,4] < 0.05) & (coef_scale[,4]>=0.01),"p-value < 5%", "p-value >=5%")))
    
    
    imp_scale<-data.frame(Importance = coef_scale[,1],p_value=coef_scale[,4])
    
  }
  
  importanceData_scale<-data.frame(variable_name = factor(row.names(imp_scale),levels=row.names(imp_scale)),
                             Importance = as.numeric(imp_scale[,1]), 
                             p_value = imp_scale[,2],
                             significance = factor(as.character(significance_scale), level = c("p-value < 0.1%","p-value < 1%","p-value < 5%","p-value >=5%")))
  
  

  #Predict
  y_pred<-ifelse(predict(data_glm,newdata=df[-idx,],type="response")>cut_prob,"yes","no")
  data_mm_test<-model.matrix(data_glm$formula,data=df[-idx,])
  y_actual<-y[-idx,]
  confusion_mat<-table(y_actual,y_pred)
  acc<-sum(y_pred==y_actual)/length(y_actual)
  precision<-confusion_mat[4]/sum(y_pred=="yes")
  recall<-confusion_mat[4]/sum(y_actual=="yes")
  f1_score<-2*precision*recall/(precision+recall)
  acc_report<-data.frame(Accuracy=acc,Precision=precision,Recall=recall, F1_Score = f1_score)
  
  #Simulation
  predTable<-cbind(y_pred,data[-idx,])
  predTable<-subset(predTable, (y_pred=="yes") & (subscribed=="yes"))
  ave_balance<-mean(predTable$balance)
  ave_age<-mean(predTable$age)
  
  return(list(Result=data_glm_summary,
              Confusion_mat = confusion_mat,
              Accuracy_report = acc_report,
              data_mm=data_mm_test,
              y = y_actual,
              importanceData=importanceData_scale, 
              coef=coef,
              balance = ave_balance,
              age = ave_age))  
}


get_ImportancePlot<-function(importanceData,sort_key, decreasing=FALSE,title=NULL, y_lab=NULL){
  
  if(sort_key=="P-value"){
    sortOrder<-order(importanceData$p_value,decreasing=decreasing)        
  }else{
    sortOrder<-order(importanceData$Importance,decreasing=decreasing)    
  }

  fact_level<-levels(importanceData$variable_name)
  importanceData$variable_name<-factor(importanceData$variable_name,levels=fact_level[sortOrder])
  p<-ggplot(importanceData)+geom_bar(aes(x=variable_name,y=Importance, fill = significance),stat="identity")+coord_flip()
  p<-p+labs(title = title, y=y_lab)
  p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
             panel.grid.major.x = element_line(color="gray",size=0.8,linetype="dotted"),
             panel.grid.minor.x = element_line(color="gray",size=0.1,linetype="dotted"),
             panel.grid.major.y = element_blank(),
             panel.grid.minor.y = element_blank(),
             plot.title = element_text(size=20),
             axis.title.x = element_text(size=16,colour="black"),
             axis.title.y = element_blank(),
             axis.text.y=element_text(size=16,colour="black"),
             axis.text.x=element_text(size=14,colour="black"),
             legend.title = element_text(size=16),
             legend.text = element_text(size=14),
             legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 3))) 
  print(p)
}

#Decision Boundary
get_DecisionBoundary<-function(data_mm, x_var, y, coef, x1_var,x2_var,cut_prob=0.5){
  
  if(length(x_var)==1){
    dummy<-data.frame(dummy1=0,dummy2=0, labels = "The number of independent variable is one.")
    g<-ggplot(dummy)+geom_text(aes(x=dummy1,y=dummy2, label = labels),size=13)
    g<-g+ggtitle("Detail")
    g<-g+theme(panel.background = element_rect(fill="white",colour="black"),
               panel.grid.major.x = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.x = element_line(color="gray",size=0.2,linetype="dotted"),
               panel.grid.major.y = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.y = element_line(color="gray",size=0.2,linetype="dotted"),
               plot.title = element_text(size=20),
               axis.title.x = element_blank(),
               axis.title.y = element_blank(),
               axis.text.y = element_blank(),
               axis.text.x = element_blank()
    )
    print(g)
  }else{
    x1_idx<-which(colnames(data_mm) == x1_var)
    x2_idx<-which(colnames(data_mm) == x2_var)
    dummy_vect<-apply(data_mm,2,FUN=median)
    dummy_vect[x1_idx]<-0
    dummy_vect[x2_idx]<-0
    
    data4<-data_mm[,c(x1_idx,x2_idx)]
    data4<-as.data.frame(cbind(data.frame(subscribed=y),data4))
    colnames(data4)<-c("subscribed",x1_var,x2_var)
    log_odds<-log((1-cut_prob)/cut_prob)
    sim_x1<-seq(min(data4[,2]),max(data4[,2]))
    sim_x2<-(-coef[,1] %*% dummy_vect - sim_x1*coef[x1_idx,1] - log_odds) / coef[x2_idx,1]
    
    data5<-data.frame(sim_x1=sim_x1,sim_x2 = sim_x2)
    
    p<-ggplot()+geom_point(data=data4, aes_string(x=x1_var,y=x2_var,col="subscribed"),alpha=0.4,size=3)
    p<-p+geom_line(data=data5,aes(x=sim_x1,y=sim_x2),size=5,col="red")
    p<-p+theme(panel.background = element_rect(fill="white",colour="black"),
               panel.grid.major.x = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.x = element_line(color="gray",size=0.2,linetype="dotted"),
               panel.grid.major.y = element_line(color="gray",size=0.5,linetype="dotted"),
               panel.grid.minor.y = element_line(color="gray",size=0.2,linetype="dotted"),
               plot.title = element_text(size=20),
               axis.title.x = element_text(size=16,colour="black"),
               axis.title.y = element_text(size=16,colour="black"),
               axis.text.y=element_text(size=14,colour="black"),
               axis.text.x=element_text(size=14,colour="black"),
               legend.title = element_text(size=16),
               legend.text = element_text(size=14),
               legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 2)))
    print(p)
  }
  }
  



#Simulation
ROI_simulation<-function(sim_timeline,
                         precision,
                         target_customer,
                         camp_cost,
                         payout_int_rate,
                         ave_balance,
                         balance_rate,
                         inv_int_rate,
                         ret_cost,
                         churn,
                         discount_rate){

  timeline<- paste("YR",1:sim_timeline,sep="")
  after_timeline<-paste("After_YR",sim_timeline+1,sep="")
  timeline<-c(timeline,after_timeline)
  
  customer<-rep(0,length(timeline))
  customer[1]<-precision*target_customer
  op_cost<-rep(0,length(timeline))
  op_cost[1]<-customer[1]*ret_cost
  
  principal<-rep(0,length(timeline))
  principal[1]<-customer[1]*ave_balance*balance_rate
  
  gain<-rep(0,length(timeline))
  gain[1]<-principal[1]*inv_int_rate
  
  payout<-rep(0,length(timeline))
  payout[1]<-principal[1]*payout_int_rate
  
  
  total_cost<-rep(0,length(timeline))
  total_cost[1]<-op_cost[1]+payout[1]
  
  profit_raw<-rep(0,length(timeline))
  profit_raw[1]<-gain[1]-total_cost[1]
  
  
  profit_disc<-rep(0,length(timeline))
  profit_disc[1]<-profit_raw[1]/(1+discount_rate)
  
  for(i in 2:(length(timeline))){
    if(i==length(timeline)){
      profit_disc[i]<-profit_raw[i-1]/discount_rate
      customer[i]<-customer[i-1]
      op_cost[i]<-op_cost[i-1]
      principal[i]<-principal[i-1]
      gain[i]<-gain[i-1]
      payout[i]<-payout[i-1]
      total_cost[i]<-total_cost[i-1]
      profit_raw[i]<-profit_raw[i-1]
    }else{
      customer[i]<-customer[i-1]*(1-churn)
      op_cost[i]<-customer[i]*ret_cost
      principal[i]<-principal[i-1]+gain[i-1]
      gain[i]<-principal[i]*inv_int_rate
      payout[i]<-principal[i]*payout_int_rate
      total_cost[i]<-op_cost[i]+payout[i]
      profit_raw[i]<-gain[i]-total_cost[i]
      profit_disc[i]<-profit_raw[i]/(1+discount_rate)^i    
    }
  }
  
  sim_table<-as.data.frame(t(cbind(customer,principal,gain,payout,op_cost,total_cost,profit_raw,profit_disc)))
  colnames(sim_table)<-timeline
  row.names(sim_table)<-c("# of Customer","Principal","Revenue","Interest Expense","Retention Cost","Total Cost","Cash Flow","Discounted Cash Flow")
  return(sim_table)
}


get_simulationPlot<-function(sim_table, target_customer, camp_cost){
  Year<-colnames(sim_table)
  Year<-Year[-length(Year)]
  
  sim_table<-as.data.frame(t(sim_table))
  sim_table$Year<-1:dim(sim_table)[1]
  
  df1<-sim_table[-dim(sim_table)[1],]
  gain_cost<-melt(df1,id.vars="Year",measure.vars=c("Revenue","Total Cost"))
  profit<-melt(df1,id.vars="Year",measure.vars="Cash Flow")
  profit$positive<-ifelse(profit$value>0,"positive","negative")
  profit$positive<-factor(profit$positive, levels = c("positive", "negative"))
  df2<-data.frame(Return= sum(sim_table$"Discounted Cash Flow"), Marketing_Cost = target_customer*camp_cost)
  df2<-melt(df2)
  
  #Format
  thousand_formatter <- function(x) {
    return(round(x / 1000))
  }
  
  #Gain vs Cost
  p1<-ggplot(gain_cost)+geom_line(aes(x=Year,y=value, col=variable),size=2)
  p1<-p1+scale_x_discrete(labels=Year)+scale_y_continuous(label = thousand_formatter)
  p1<-p1+labs(title="Revenue and Cost", x="YEAR",y="Revenue/Cost in Euro (K)")
  p1<-p1+labs(colour = "")
  p1<-p1+theme(panel.background = element_rect(fill="white",colour="black"),
               panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank(),
               panel.grid.major.y = element_line(color="gray",size=0.5),
               panel.grid.minor.y = element_blank(),
               plot.title = element_text(size=20),
               axis.title.x = element_text(size=16,colour="black"),
               axis.title.y = element_text(size=16,colour="black"),
               axis.text.y=element_text(size=14,colour="black"),
               axis.text.x=element_text(size=14,colour="black"),
               legend.position = "bottom",
               legend.title = element_text(size=16),
               legend.text = element_text(size=14),
               legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 2)))
    
    
  colourList<-setNames(c("blue", "red"),levels(profit$positive))
  
  #Profit
  p2<-ggplot(profit)+geom_bar(aes(x=as.factor(Year), y=value,fill=positive),size=3,stat="identity")
  p2<-p2+scale_x_discrete(labels=Year)+scale_y_continuous(label = thousand_formatter)
  p2<-p2+scale_fill_manual(values=colourList)
  p2<-p2+labs(title="Profit/Loss", x="YEAR",y="Profit in Euro (K)")
  p2<-p2+theme(panel.background = element_rect(fill="white",colour="black"),
               panel.grid.major.x = element_blank(),
               panel.grid.minor.x = element_blank(),
               panel.grid.major.y = element_line(color="gray",size=0.5),
               panel.grid.minor.y = element_blank(),
               plot.title = element_text(size=20),
               axis.title.x = element_text(size=16,colour="black"),
               axis.title.y = element_text(size=16,colour="black"),
               axis.text.y=element_text(size=14,colour="black"),
               axis.text.x=element_text(size=14,colour="black"),
               legend.position = "none",
               legend.title = element_text(size=16),
               legend.text = element_text(size=14),
               legend.key = element_rect(fill = "White"))+guides(colour = guide_legend(override.aes = list(size = 2)))
  
  
  #ROI
  p3<-ggplot(df2)+geom_bar(aes(x=variable,y=value,fill=variable),stat="identity",width=.4)
  p3<-p3+scale_y_continuous(label = thousand_formatter)
  p3<-p3+labs(title="ROI\n(PV vs Campaign Cost)", x="",y="Present Value in Euro (K)")
  p3<-p3+theme(panel.background = element_rect(fill="white",colour="black"),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.x = element_blank(),
            panel.grid.major.y = element_line(color="gray",size=0.5),
            panel.grid.minor.y = element_blank(),
            plot.title = element_text(size=20),
            axis.title.x = element_text(size=16,colour="black"),
            axis.title.y = element_text(size=16,colour="black"),
            axis.text.y=element_text(size=14,colour="black"),
            axis.text.x=element_text(size=14,colour="black"),
            legend.position = "none",
            legend.title = element_text(size=16),
            legend.text = element_text(size=14),
            legend.key = element_rect(fill = "White"))
  
  
  
  #Plot on grid
  grid.newpage()
  pushViewport(viewport(layout=grid.layout(3, 2, heights = unit(c(0.5,10,10),"null"), widths=unit(c(5, 2),"null")))) 
  grid.text("ROI Simulation", vp = viewport(layout.pos.row = 1, layout.pos.col = 1:2),gp=gpar(fontsize=20))
  print(p1, vp=viewport(layout.pos.row=2, layout.pos.col=1:2))
  print(p2, vp=viewport(layout.pos.row=3, layout.pos.col=1))  
  print(p3, vp=viewport(layout.pos.row=3, layout.pos.col=2))  
}
