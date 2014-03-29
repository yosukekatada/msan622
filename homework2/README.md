Homework 2: Interactivity
==============================

| **Name**  | Yosuke Katada  |
|----------:|:-------------|
| **Email** | ykatada@dons.usfca.edu |

## Instructions ##

The following packages must be installed prior to running this code:

- `ggplot2`
- `shiny`
- `RColorBrewer`

To run this code, please enter the following commands in R:

```
library(shiny)
shiny::runGitHub('msan622', 'yosukekatada', subdir='homework2')
```

This will start the `shiny` app. See below for details on how to interact with the visualization.
Also, if the `shiny` app is grether than your screen, please adjust zoom ratio on your browser.

## Discussion ##

My shinyapp has two tabs such as scatter plot and table. In ths "Scatter plot" tab, you can slice MAPP rating as well as genre. Also, you can change the color by either MPAA rating or genre. Furtheremore, I set a click button called "Scatter Plot by Facet" to expand a single scatter plot to multiple scatter plots. This function would help you to compare the distributions by genre or MAPP rating. In addition to the functions that I explained so far, I added a plot setting panel for the apperance. You can change color scheme and background panel's color. If the data points are less recognizable, you can change background color. Also, you can change dot size and dot alpha.

![IMAGE](shinyapp_1.png)



For the users who want to check the detail such as title, length and so on, you can see the raw data behind the scatter plot at the "table" tab.

![IMAGE](shinyapp_2.png)


### Customization ###
In addtion to the requirement, I customized the following functions.

- Table tab: you can see the raw data behind the scatter plot.
- "Scatter Plot by Facet" button: you can see the multiple scatter plot.
- "Color by" list: you can specify MPAA rating or genre for color.
- "Background Color" list: you can change the background color on the plot.
