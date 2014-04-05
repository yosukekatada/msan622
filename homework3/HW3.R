library(ggplot2)
library(grid)
library(reshape)
library(reshape2)

df <- data.frame(state.x77,
                 State = state.name,
                 Abbrev = state.abb,
                 Region = state.region,
                 Division = state.division)

df$Region <- as.factor(df$Region)
df$Abbrev <- as.factor(df$Abbrev)
df$Division <- as.factor(df$Division)


#bublechart
df<-df[order(df$Income,decreasing=TRUE),]
p<-ggplot(df,aes(x=Population, y =Life.Exp))+geom_point(aes(color= Region, size = Income),alpha=1, position="jitter")
p<-p+scale_size_continuous(range = c(2,20), guide="none")

#p<-p+scale_size_area(max_size=20, guide="none")
p<-p+geom_text(aes(label = Abbrev),col="#3D3535", hjust =0.5, vjust=0)
#p<-p+annotate("text",x=(max(df$Income)+min(df$Income))/2,y= max(df$Life.Exp)+1, label = "Circle is the size of Population")
p

#scatteplot
ggpairs(df[,1:8])


#heatmap
processData<-function(dat){
  dat2<-dat
  colnames(dat2)<-gsub("\\."," ", colnames(dat2))
  dat2<-dat2[sapply(dat2, is.numeric)]
  dat2<-rescaler(dat2,type="range")
  dat2$id<-1:nrow(dat)
  dat2<-melt(dat2,"id")
  dat2$id<-factor(dat2$id, levels=1:nrow(dat),ordered=TRUE)
  return(dat2)  
}
df2<-processData(df)
levels(df2$variable)
p<-ggplot(df2)+geom_tile(aes(x=id,y=variable,fill=value))
pallet<-c("#008837","#f7f7f7","#f7f7f7","#7b3294")
p<-p + scale_fill_gradient2(low=pallet[1],mid=pallet[3],high=pallet[4])

#Paralell Coordinate Plot
s=3

colours <- c("#D92121", "#D92121", "#D92121", "#21D921")
ggparcoord(df,columns = c(1,2,3,4,5),groupColumn=11, mapping=aes(size=1))+ geom_line(alpha=0,show_guide=FALSE)+scale_colour_manual(values = colours)


#Scatter Plot Matrix
g<-ggpairs(df,columns=1:5,color="Region")
