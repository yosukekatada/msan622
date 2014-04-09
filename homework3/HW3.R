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

p<-p+theme(plot.title = element_text(size=24),
           axis.title.x = element_text(size=20),
           axis.title.y = element_text(size=20),
           axis.text.y=element_text(size=18),
           axis.text.x=element_text(size=18),
           legend.title = element_text(size=22),
           legend.text = element_text(size=20)
           #panel.grid.minor = element_blank()
           ) 
p<-p+guides(colour = guide_legend(override.aes = list(size = 20)))

#p<-p+scale_size_area(max_size=20, guide="none")
p<-p+geom_text(aes(label = Abbrev),col="#3D3535", hjust =0.5, vjust=0)
p<-p+annotate("text",x=(max(df$Income)+min(df$Income))/2,y= max(df$Life.Exp)+1, label = "Circle is the size of Population")
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


# Load required packages
require(GGally)

# Load datasets
data(iris)

# Create scatterplot matrix
p <- ggpairs(iris, 
             # Columns to include in the matrix
             columns = 1:4,
             
             # What to include above diagonal
             # list(continuous = "points") to mirror
             # "blank" to turn off
             upper = "blank",
             
             # What to include below diagonal
             lower = list(continuous = "points"),
             
             # What to include in the diagonal
             diag = list(continuous = "density"),
             
             # How to label inner plots
             # internal, none, show
             axisLabels = "none",
             
             # Other aes() parameters
             colour = "Species",
             title = "Iris Scatterplot Matrix"
)

# Remove grid from plots along diagonal
for (i in 1:4) {
  for(j in 1:4){
    # Get plot out of matrix
    inner = getPlot(p, i, j);
    
    # Add any ggplot2 settings you want
    inner = inner + theme(panel.grid = element_blank());
    
    # Put it back into the matrix
    p <- putPlot(p, inner, i, j);    
  }
}

}
#Lengend
dummydat<-data.frame(x=c(0,0,0,0),y=c(0,0,0,0),Region=c("hoge","hoge2","hoge3","hoge4"))

dummydat<-data.frame(x=c(0),y=c(0),Region=c("hoge"))
ggplot(dummydat)+geom_point(aes(x=x, y=y,col=Region))+scale_x_continuous(limits = c(-0.1,0.3))+
  theme(legend.position = c(0.1, 0.3), 
        legend.justification = c(0, 0),
        panel.background = element_rect(fill="WHITE"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank()
        )+
  guides(col= guide_legend(
    title.theme = element_text(size=20,angle=0),
    label.theme = element_text(size=20,angle=0),
    direction = "horizontal", 
    title.position = "top",
    label.position="bottom",
    keywidth=8,
    keyheight=12, 
    override.aes = list(size = 40)))
