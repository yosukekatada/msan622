library(tm)
library(SnowballC)
library(wordcloud)
library(ggplot2)
library(reshape2)
library(downloader)


##########################
### Download the data ####
##########################
original_wd<-getwd()
dat_directory<-paste(original_wd,"/dataset",sep="")
dir.create(dat_directory)
setwd(dat_directory)
url1<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2009.txt"
download(url1,"Barack_Obama_2009.txt",mode="wb")
url2<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2010.txt"
download(url2,"Barack_Obama_2010.txt",mode="wb")
url3<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2011.txt"
download(url3,"Barack_Obama_2011.txt",mode="wb")
url4<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2012.txt"
download(url4,"Barack_Obama_2012.txt",mode="wb")
url5<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2013.txt"
download(url4,"Barack_Obama_2013.txt",mode="wb")
url6<-"https://raw.githubusercontent.com/yosukekatada/msan622/master/homework4/dataset/Barack_Obama_2014.txt"
download(url4,"Barack_Obama_2014.txt",mode="wb")
setwd(original_wd)

###########################
###   Text Processing   ###
###########################


#Read the dataset under sub directory
text_source<- DirSource(
  directory = "dataset",
  encoding = "UTF-8",
  pattern = "*.txt",
  recursive = FALSE,
  ignore.case = TRUE  
  )

#Create corpus
text_corpus <- Corpus(
  text_source,
  readerControl= list(
    reader = readPlain,
    language = "en"
    )
  )

#Transformation to data frame

#First of all, it change the words into lower case
speech_data<-tm_map(text_corpus, tolower)

#Apply remove words
speech_data <- tm_map(speech_data, removeWords, stopwords("english"))

#remove Punchtuation
speech_data<-tm_map(speech_data,removePunctuation,
                    preserve_intra_word_dashes = TRUE)

#speech_data <- tm_map(speech_data,stemDocument,lang = "porter")

#Delete white spaces
speech_data <- tm_map(speech_data,stripWhitespace)

#Exclude the words other than noun and the TF is greater than 30 
#(To get the candaites of the words, use nltk package in Python)
speech_data<-tm_map(speech_data,removeWords,c("already","also","back","better","can","clean","even",
                                              "every","financial","first","future","give","good","hard",
                                              "just","keep","know","last","like","made","make","many","must",
                                              "need","never","new","next","now","one","put","right","still",
                                              "take","together","two","united","will","working"))


#Delete the less interesting words
speech_data<-tm_map(speech_data,removeWords,c("america","american","americans","americas","come","country",
                                              "day","done","get","states","time","today","want","way","world",
                                              "tonight","year","years","people"))


#After processing text data, create doc matrix
text_mat<-DocumentTermMatrix(speech_data)

#Convert it into data frame
speech_data<-as.data.frame((inspect(text_mat)))
speech_data<-as.data.frame(t(speech_data))
colnames(speech_data)<-c("YEAR2009","YEAR2010","YEAR2011","YEAR2012","YEAR2013","YEAR2014")


#####################
###   Freq Plot   ###
#####################


# Filter the words sum of TF is greater than 50 and less than 100
df<-speech_data[apply(speech_data,1,sum) >50,]


#Frequency Plot YEAR2009 vs 2014
g<-ggplot(df)+geom_text(aes(x=YEAR2009,
                            y=YEAR2014,
                            label=row.names(df)),
                        size=7,
                        position = position_jitter(width = 2,height = 2))

g<-g+geom_abline(intercept=0,slope=1,colour="red")
g<-g+annotate("text",x=2,y=1, label = "X=Y",size=8, color="red")+labs(title="Frequency Plot 2009 vs 2014")
g<-g+theme(panel.grid.minor = element_blank())+
  scale_x_continuous(expand = c(0, 0))+
  scale_y_continuous(expand = c(0, 0))+
  coord_fixed(ratio = 4/6, xlim = c(0, 35),ylim = c(0, 35))+
  theme(plot.title = element_text(size=24),
        axis.title.x = element_text(size=20),
        axis.title.y = element_text(size=20),
        axis.text.y=element_text(size=18),
        axis.text.x=element_text(size=18)) 
print(g)
ggsave(file = "freqplot.png", plot = g, dpi = 100, width = 14.4, height = 10.4)



###################
###   Heatmap   ###
###################

#Reorder words by 2014 frequency
df2<-speech_data[apply(speech_data,1,sum) >40,]
words<-as.character(row.names(df2))
df2$id<-factor(x=words,row.names(df2)[order(df2[,6],decreasing=FALSE)])

#Prepare dataset
df2<-melt(df2,"id",ordered = TRUE)

#Create plot
p<-ggplot(df2)+geom_tile(aes(x=id,y=variable,fill=value),colour = "white")
p<-p+theme_minimal()
p<-p+ggtitle("SOTU Word Frequency from 2009 to 2014 \n(it covers only words whose sum of term frequency from 2009 to 2014 > 40)")
p<-p+coord_flip()
p<-p+theme(plot.title = element_text(size=24),
           axis.text.x = element_text(size=17),
           axis.text.y = element_text(size=17),
           axis.title.x =element_blank(),
           axis.title.y =element_blank())
p<-p+theme(legend.position = "none")  
palette <- c("#f1eef6", "#d7b5d8", "#df65b0" ,"#ce1256")
p <- p + scale_fill_gradientn(colours = palette, values = c(0, 0.3, 0.6, 1))
print(p)
ggsave(file = "heatmap.png", plot = p, dpi = 100, width = 14.4, height = 10.4)


######################
###   word cloud   ###
######################
#Comparision Word Cloud
colnames(speech_data)<-c("2009","2010","2011","2012","2013","2014")
mat2<-speech_data[apply(speech_data,1,sum) >10,]
mat2<-as.matrix(mat2)
max_words<-as.integer(dim(mat2)[1]*0.35) #To fit the word cloud into one page
comparison.cloud(mat2,colors = brewer.pal(6,"Dark2"),max.words=max_words,random.order=FALSE)

