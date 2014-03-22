#Data Visualization Homework

library(ggplot2) 
data(movies) 
data(EuStockMarkets)

#Filter out any rows that have a budget value less than or equal to 0 in the movies dataset
movies<-subset(movies, budget>0)
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"
movies$genre<-as.factor(genre)

#Transform the EuStockMarkets dataset to a time series as follows
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Adjust font size of x and y axis label, title, legend
th<-theme(plot.title = element_text(size=18),
      axis.title.x = element_text(size=15),
      axis.title.y = element_text(size=15),
      axis.text.y=element_text(size=15),
      axis.text.x=element_text(size=15),
      legend.title = element_text(size=15),
      legend.text = element_text(size=15)) 


#Plot1: Scatter plot
p1<-ggplot(movies)+geom_point(aes(x=budget,y=rating))+
  labs(title = "Budget and Rating", x = "budget", y = "rating") +th
ggsave(file = "hw1-scatter.png", plot = p1, dpi = 100, width = 10, height = 6)


#Plot2: Bar Chart
p2<-ggplot(movies)+geom_bar(aes(x=genre),fill="#004C99")+
  labs(title = "Count of Genre", x = "Genre", y = "Count")+coord_flip()+th
ggsave(file = "hw1-bar.png", plot = p2, dpi = 100, width = 10, height = 6)


#Plot3: Small Multiples
p3<-ggplot(movies)+geom_point(aes(x=budget,y=rating,col=genre))+facet_wrap(~genre,ncol=3)+
  theme(axis.title.x = element_text(size=15),
        axis.title.y = element_text(size=15),
        legend.title = element_text(size=15),
        legend.text = element_text(size=15))
ggsave(file = "hw1-multiples.png", plot = p3, dpi = 100, width = 10, height = 6)


#Plot 4: Multi-Line Chart
#First of all, transform dataset for easily creating multi-line chart by melt function
library(reshape2)
eu2<-melt(eu[,1:4])
time<-rep(eu[,5],4)
eu2<-as.data.frame(cbind(eu2,time))

#Change the column name
colnames(eu2)<-c("Index","Price","Time")

#Finally, ggplot!
eu2$Index<-as.factor(eu2$Index)
p4<-ggplot(eu2)+geom_line(aes(x=Time,y=Price,col=Index))+
  labs(title = "European Stock Indicies Trend", x = "Time", y = "Price")+th
ggsave(file = "hw1-multilines.png", plot = p4, dpi = 100, width = 10, height = 6)
