library(ggplot2)
library(shiny)
library(RColorBrewer)
data(movies)

#Data setup
loadData <- function() {
  data("movies", package = "ggplot2")
  
  movies<-subset(movies,budget>0)
  movies$mpaa<-as.character(movies$mpaa)
  movies<-subset(movies,mpaa !="")
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
  movies$genre<-genre
  movies<-movies[,c("title","year","length","budget","rating","votes","mpaa","genre")]
  return(movies)
}


# Shared data
globalData <- loadData()


#Create plot
x_format<-function(x){y<-round(x/1000000);return(sprintf("%dM",y))}
getPlot<-function(dat,col,dotsize,dotalpha,facet=FALSE,palette,bw){
  #localFrame should be whole movies dataset
  
  #When data set is empty, returns just background in ggplot
  if(dim(dat)[1]==0){
    dummy<-data.frame(budget=-10,rating=-20)
    p<-ggplot(dummy)+geom_point(aes(x=budget,y=rating))
  }else{
    if(col=="MPAA"){
      p<-ggplot(dat)+geom_point(aes(x=budget,y=rating,col=mpaa),size=dotsize,alpha=dotalpha)      
      if(palette!="Default"){
        createPalette<- colorRampPalette(brewer.pal(8,palette))
        num_factor<-length(unique(dat$mpaa))
        p<-p+scale_color_manual(values=createPalette(num_factor))              
      }    
      if(facet){
        p<-p+facet_wrap(~mpaa)
      }
    }else{
      p<-ggplot(dat)+geom_point(aes(x=budget,y=rating,col=genre),size=dotsize,alpha=dotalpha)
      if(palette!="Default"){
        createPalette<- colorRampPalette(brewer.pal(8,palette))
        num_factor<-length(unique(dat$genre))
        p<-p+scale_color_manual(values=createPalette(num_factor))               
      }
      if(facet){
        p<-p+facet_wrap(~genre)
      }
    }
  }
    p<-p+labs(title="Budget and Rating",xlab="Budget",ylab="Rating")
    p<-p+theme(plot.title = element_text(size=24),
               axis.title.x = element_text(size=20),
               axis.title.y = element_text(size=20),
               axis.text.y=element_text(size=18),
               axis.text.x=element_text(size=18),
               legend.title = element_text(size=22),
               legend.text = element_text(size=20)) 
    if(bw=="White"){
      p<-p+theme(panel.background=element_rect(fill="White"),
                 panel.grid.major = element_line(color = "gray"),
                 panel.grid.minor = element_line(color = "gray"))
    }else if(bw=="Black"){
      p<-p+theme(panel.background=element_rect(fill="Black"),
                 panel.grid.major = element_line(color = "white"),
                 panel.grid.minor = element_line(color = "white"))
              }
      
  p<-p+scale_x_continuous(limits = c(0,200000000),label=x_format)+scale_y_continuous(limits=c(0,10))
  return(p)
  }

shinyServer(function(input,output){
  localFrame<-globalData
  
  dat<-reactive({
    if(length(input$genre)==0){genre_list<-c("Action","Animation",  
                                             "Comedy","Documentary",
                                             "Drama","Mixed",
                                             "Romance","Short",
                                             "None")}
    else{
      genre_list<-input$genre
    }
    
    if(input$mpaa_rating=="All"){
          subset(localFrame,genre %in% genre_list)     
    }else{
        subset(localFrame,(mpaa == input$mpaa_rating)&(genre %in% genre_list))
          }
    })
  
  
  output$table<-renderDataTable({
    dat()
  }, options=list(iDisplayLength=10))
    
  output$scatterPlot<-renderPlot({
    scatterPlot<-getPlot(dat(),
                         col=input$color_by,
                         dotsize=input$dotsize, 
                         dotalpha=input$dotalpha,
                         facet=input$facet,
                         palette=input$palette,
                         bw=input$bw)
    print(scatterPlot)
  },width=1200,height=800
    )
  
  })


