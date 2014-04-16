Homework4: Text Visualization
==============================

| **Name**  | Yosuke Katada  |
|----------:|:-------------|
| **Email** | ykatada@dons.usfca.edu |

## Instructions ##

Before you start to run my code, please make sure that you install `tm`,`SnowballC`, `wordcloud`,`ggplot2` and `reshape2`packages. 
After that, use the following code to run this `shiny` app:

```
library(devtools)
source_url("https://raw.githubusercontent.com/msan622/msan622/master/homework0/anscombe.r")
```

## Discussion ##

### Data ###
Text data that I used is SOTU addresses from 2009 to 2014.Please see the folder called `dataset` in github repository.

| **File Name**  | **Word Count**  |
|----------:|:-------------|
|  Barack_Obama_2009.txt | 6053 |
|  Barack_Obama_2010.txt | 7221 |
|  Barack_Obama_2011.txt | 6874 |
|  Barack_Obama_2012.txt | 7026 |
|  Barack_Obama_2013.txt | 6783 |
|  Barack_Obama_2014.txt | 6987 |
|----------:|:-------------|
|  Total | 40944 |


### 1: Frequency Plot (ggplot) ###

First plot is a frequency plot.
![frequency plot](freqplot.png)


### 2: Heatmap (ggplot) ###

![heatmap](heatmap.png)


### 3: Comparison Cloud (wordcloud) ###

![comparison cloud](wordcloud.png)
