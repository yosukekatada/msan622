Homework3: Multivariate
==============================

| **Name**  | Yosuke Katada  |
|----------:|:-------------|
| **Email** | ykatada@dons.usfca.edu |

## Instructions ##

Use the following code to run this `shiny` app:

```
library(shiny)
runGitHub("msan622", "yosukekatada", subdir = "homework3")
```

## Discussion ##

### Technique 1: Bubble Plot ###

The objective of the plot is explaining the relationship of the four variables: highschool graduate rate, income, population and region. The assumption is that if the state has higher rate of high school graduate, the income should be higher. In addition, I want to know any geographical and demographic features on it. For this objective, I used a bubble plo, instead heatmap, because a bubble plot can show us correlational relationship more easily. 

In terms of layout of the plot, HS.grad should come to X-axis because I suppose that HS.grad influence on the high income. So, Income is Y-axis. Also, another numerical feature, population, was expressed by the size of a bubble. Finally, I used region category for coloring.  


![technique1](technique1.png)

#### Customization ####
- Put the labels on the bubbles
- In order to prevent the large bubbles from overlapping small bubbles, the data set was reordered


### Technique 2: Scatterplot Matrix ###
In this section, my objective is to explore relationship between numerical variables. For this objective, scatter plot matrix is more appopriate than small multiples. So, I put all the numeric values on the axes and colored points by region. Although there is another categorical feature like "Division", DIvision has too many levels to color data points in scatter plot matrix.

![technique2](technique2.png)

#### Customization ####
- Created legend
- X and Y axis lines in histogram on diagonal are deleted for simplicity
- Minor lines are deleted on each scatter plot because the audience does not care the detail of the number
- The style of the major lines on each scatter plot was changed to dotted line for making the plot less dense

### Technique 3: Parallel Coordinates Plot ###

Until this class, I have not used Paralell coordinates plot, but it is useful for exploring the data distribution and relationship as long as the data is not too many. I think that boxplot can be used for the almost same purpose, but boxplot cannot show us the relationship between the variables. 

According to the plots so far, I started to understand that the states in south region have some characteristics. So, to make sure them, I created the following plot to make contrast between south states and others. 

![technique3](technique3.png)

#### Customization ####
- Black for background color to make good contrast
- Deleted everything on Y-axis because those will not give any information
- Reordeed the data to get the highlited data to be on the first layer.

### Interactivity for Bubble Plot ###

In shiny app, you can select a plot among the three plots from the navigation bar. 
In "Bubble chart" tab, you can choose which column is used for X-axis, Y-axis, the size of bubble and coloring. Also, you can use *Zooming* and *Filtering*. In addition, you can check the data behind the plot by clicking table tab. The table tab is connected to the plot, so if you filter the data on the plot tab, the table is also subsetted. Due to this interacticity, you can quickly check your assumptions on the data and get insight. 

![Interactivity1](interactivity1.png)

Next tab, "Scatte Plot Matrix" gives you the interactive scatter plot matrix. In this plot, you can select which variables should be included. Aslo, you can use *Filtering* based on region. 

![Interactivity2](interactivity2.png)

The last plot is Parallel Coordinate plot. Like the other two plots, you can choose the variables. Also, if you select the subsets of the data based on Rigion or Division, the selected data is highlighted (*Brushing*). For this highlight, you can change the color of the background, the line size, and alpha. 

![Interactivity2](interactivity3.png)
