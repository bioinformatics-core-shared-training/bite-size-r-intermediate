library(tidyverse)

# Patients dataset
# ----------------

# read in patients dataset
patients <- read_tsv("patient-data-cleaned.txt")

# get to know the patients dataset before trying to visualize it

# view in RStudio by clicking on it in Environment tab or
View(patients)

# it is special type of data frame called a tibble
class(patients)

# printing a tibble shows each of the column types
patients

# this dataset required quite a bit of cleaning to get into the state where
# we can do some proper exploratory data analysis and visualization

# we'll look at the issues of real-world datasets and the need for cleaning these
# in the next part of the course and will introduce some of the tools in the
# tidyverse collection of packages that help to do so

# this is also a "tidy" dataset
# - it is in a consistent form that matches the semantics of the dataset
#   with the way it is stored
# - each column is a variable
# - each row is an observation

# what are the variables in the patients dataset?
# what are the observations?

# what types of variables do we have?

# read_tsv has read these in as <chr>, <fct>, <dbl>, <date> and <lgl>
# what do these mean?
class(patients$Sex)
class(patients$Height)
class(patients$Overweight)

# what types should these be?
# - categorical (Sex, Race, Smokes, etc.)
# - continuous (Height, Weight)

# what about Grade?
# - categorial but ordered - ordinal

# what about Age?
# - certainly discrete in this dataset (only whole numbers)
# - again might treat this as ordinal

# we also have some columns read in as logical and date variables
# logical variables are treated by ggplot2 as categorial 

# read functions from the readr package, including read_tsv used above,
# do not automatically convert all strings to factors as the base R
# functions read.delim and read.csv do

# most of the time ggplot2 will treat variables in the way you'd hope,
# e.g. creating a bar plot showing the number of patients in each grade
# even though this is currently an integer
# but sometimes it will cause problems so it's a good idea to sort
# this sort of thing out early on

# some of our columns are categorical variables so should be factors

patients$Sex <- factor(patients$Sex)
levels(patients$Sex)
patients

# or using something we will learn later to do this for several columns in one go
patients <- mutate_at(patients, vars(Race, Sex, Smokes, State, Pet, Grade, Age), funs(factor))
patients


# First ggplot
# ------------

# first plot - a scatter plot of height vs weight
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight))

# explain what we did here

# we've specified 3 things for this plot
# - the data (needs to be a data frame)
# - the plot type (geom)
# - the mapping of variables in the data to visual properties (aesthetics) of the objects
#   in the plot, in this case the position of points on the scatter plot but could also
#   the size, shape and colour of those points

# look up geom_point help in RStudio
?geom_point


# Aesthetics mappings
# -------------------

# scroll down to the aesthetics section to see what aesthetics are
# actually required (x and y)

# what about those other aesthetics?

# colours are usually fun - let's try to use a colour aesthetic

# need to set a mapping of a variable to colour just like we did
# for x and y

ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, colour = Sex))

# what about colouring based on a continuous variable?

ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, colour = BMI))

# let's try the other aesthetics

ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, shape = Sex))

# some aesthetics can only be used with categorical variables
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, shape = BMI))

# not all aesthetics are useful, at least not for this plot
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, size = Sex))

# the warning hints that we should be using a continuous variable for size instead
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, size = BMI))

# transparency
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight, alpha = BMI))

# colours more commonly used than shapes, sizes or transparency

# will learn how to change the colours used later this afternoon


# ggplot2 grammar
# ---------------

# the "gg" in ggplot2 stands for "grammar of graphics"
# coherent system for describing and building graphs

# basic template
#   ggplot(data = <DATA>) +
#      <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# understanding this grammar allows us to create all kinds of graphs


# Other plot types (geoms)
# ------------------------

# look up ggplot2 package help in RStudio to see what other geoms are available

# e.g. bar chart of patient's ages
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age))

# what if we want each bar to be a different colour?
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age, colour = Age))

# oops, colour wasn't quite what we wanted here
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age, fill = Age))

# what happens if we fill with something other than age, e.g. sex?
# we get a stacked bar plot
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age, fill = Sex))
# notice the similarity in what we did here to the scatter plot
# common grammar

# what if want all the bars to be the same colour but not dark grey, e.g. blue?
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age, fill = "blue"))
# that doesn't look right - why not?

# you can set the aesthetics to a fixed value but this needs to be outside
# the mapping
ggplot(data = patients) +
  geom_bar(mapping = aes(x = Age), fill = "blue")


# Multiple layers
# ---------------

# why do we have the ggplot part and geom part joined by a "+" symbol?

# can have multiple geoms in same plot
# each is a different layer

# creating plots with multiple layers
ggplot(data = patients) +
  geom_point(mapping = aes(x = Height, y = Weight)) +
  geom_smooth(mapping = aes(x = Height, y = Weight))

# what is geom_smooth doing? (look up the help)
# note that the shaded area represents the standard error bounds on the fitted model

# some annoying duplication of code here - put mappings in ggplot function
# and these will be treated as global mappings for the plot, applying to
# all geoms
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  geom_smooth()

# still want to colour the points by sex
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  geom_smooth()

# oh, that wasn't what I had in mind, although it's pretty neat
# I only wanted this to apply to the points
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point(mapping = aes(colour = Sex)) +
  geom_smooth()

# or you might have got your scatter plot just right and all you want to do is
# add the geom_smooth without affecting anything else
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  geom_smooth(mapping = aes(x = Height, y = Weight), inherit.aes = FALSE)


# Other plot types (geoms)
# ------------------------

# let's explore some other types of plots

# line plot
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_line()
# doesn't make much sense for this dataset but good for time series data

# use multiple geoms (layering) to have both points and lines
ggplot(data = patients, mapping = aes(x = Birth, y = BMI)) +
  geom_point() +
  geom_line()
# ggplot2 seems to be doing something clever with dates here

# histogram
ggplot(data = patients) +
  geom_histogram(mapping = aes(x = Height))

# the warning message hints at picking a more optimal number of bins
ggplot(data = patients) +
  geom_histogram(mapping = aes(x = Height), binwidth = 2.5)

# or can set the number of bins
ggplot(data = patients) +
  geom_histogram(mapping = aes(x = Height), bins = 15)

# pretty ugly, how about some better aesthetics
ggplot(data = patients) +
  geom_histogram(mapping = aes(x = Height, fill = Sex), bins = 15, colour = "firebrick", fill = "grey70")

# the help page for geom_histogram talks about an alternative called geom_freqpoly
# - when might this be preferred
ggplot(data = patients) +
  geom_freqpoly(mapping = aes(x = Height, colour = Smokes), binwidth = 5)

# box plot
ggplot(data = patients) +
  geom_boxplot(mapping = aes(x = Smokes, y = Weight))

# see ?geom_boxplot to explain how the box and whiskers are constructed

# BMI is perhaps a better thing to compare because the Weight is correlated
# with Height and Sex
ggplot(data = patients) +
  geom_boxplot(mapping = aes(x = Smokes, y = BMI))

# or compare male and female separately
ggplot(data = patients) +
  geom_boxplot(mapping = aes(x = Sex, y = BMI, colour = Smokes))

# can we see the points at the same time?
ggplot(data = patients, mapping = aes(x = Sex, y = BMI)) +
  geom_boxplot() +
  geom_point()

# ?geom_point help points to geom_jitter as more suitable when one of the
# variables is categorical
ggplot(data = patients, mapping = aes(x = Sex, y = BMI)) +
  geom_boxplot() +
  geom_jitter()

# reduce the spread/jitter
ggplot(data = patients, mapping = aes(x = Sex, y = BMI)) +
  geom_boxplot() +
  geom_jitter(width = 0.25)

# violin plot
ggplot(data = patients) +
  geom_violin(mapping = aes(x = Sex, y = Height))

ggplot(data = patients) +
  geom_violin(mapping = aes(x = Sex, y = Height, fill = Smokes))

# won't cover one of the plot types used in the exercises as I want you
# to work it out using the help pages and what you've learned about the
# common grammar for all ggplots


# ggplot object
# -------------

# a little peek under the hood

plot <- ggplot(data = patients)

class(plot)

names(plot)

# we've so far constructed ggplots from data, layers (geoms) and aesthetic mappings
# we'll be looking at customizing plots (labels, theme, scales) later this afternoon

# no layers or mapping yet
plot
plot$layers
plot$mapping

plot <- ggplot(data = patients, mapping = aes(x = Height, y = Weight))
plot
plot$mapping
# still no layers
plot$layers

plot <- plot + geom_point()
plot
plot$layers

# note the '+' operator is actually a special operator in the ggplot2 package
# used to add layers, labels, themes and other components to a plot


# Facets
# ------

# one useful feature of ggplot2 is faceting

# this allows you to split your plot into subplots, or facets, based on
# one or more categorical variables

# each subplot displays a subset of the data

# there are two faceting functions, facet_grid and facet_wrap

# facet_wrap

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Grade)) +
  geom_point()

ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Smokes)

# the ~ Smokes is known as a formula in R
# formulas are used to build models in R

# note that in some cases it is easier to see the data in separate subplots
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Grade)) +
  geom_point()
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Grade)
# note the wrapping across several rows

# to fit onto a single row
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Grade, nrow = 1)
# or to force 3 columns
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Grade, ncol = 3)

# can facet on more than one variable
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Sex + Smokes)

# facet_grid

# faceting on two variables can also be done as a grid using facet_grid
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_grid(Sex ~ Smokes)

# compare this with using a single plot and aesthetics
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Smokes, shape = Sex)) +
  geom_point()

# it is possible to only facet on one variable in either the rows
# or columns dimension using facet_grid
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_grid(. ~ Sex)
# note same as using facet_wrap with nrow = 1 so not terribly useful
# but if you want the plots to stacked in a single column with labels
# down the side
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_grid(Sex ~ .)

# it is also possible to facet on more more than two variables with facet_wrap
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point() +
  facet_wrap(~ Sex + Race + Smokes)
# although usually this leads to very cluttered plots, better to stick
# to using one or two variables for faceting

# we can use other aesthetic mappings for grouping data alongside faceting
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  facet_wrap(~ Smokes)



# Customizing the plots

# Labels
# ------

# adding labels
ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point(mapping = aes(colour = Sex)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Patients from ECSA12 study",
    subtitle = "Linear relationship between height and weight",
    x = "Height (cm)",
    y = "Weight (kg)"
  )

# Scales
# ------

# take a look at the x and y scales in the above plot
# ggplot has chosen the x and y scales, where to put breaks and ticks

plot <- ggplot(data = patients, mapping = aes(x = Height, y = Weight)) +
  geom_point(mapping = aes(colour = Sex))
names(plot)

# one of the components of the plot is called "scales"

# ggplot2 automatically adds default scales behind the scenes
# equivalent to the following
plot <- ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_color_discrete()

# note that we have three aesthetics and ggplot2 adds a scale for each
plot$mapping

# the x and y variables are continuous hence ggplot2 adds a continuous scale for each
# colour is a discrete variable in this case so ggplot2 adds a discrete scale for colour

# to generalize then, the scales needed follow the naming scheme:
# scale_<name_of_aesthetic>_<name_of_scale>

# let's see what we can change about the y axis
?scale_y_continuous

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous()

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous(breaks = seq(60, 100, by = 5))

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(60, 100))

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(60, 100), minor_breaks = NULL)

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous(limits = c(60, 100), minor_breaks = seq(60, 100, by = 1))

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_y_continuous(breaks = NULL)

# by default the scales are expanded by 5% of the range on either side
# to add some more space round the edges
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_x_continuous(expand = expand_scale(mult = 0.1)) +
  scale_y_continuous(expand = expand_scale(mult = 0.1))

# not sure why you'd want to do this but with ggplot2 just about anything
# is possible
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_x_continuous(position = "top")

# Controlling colours
# -------------------

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_colour_manual(values = c("green", "purple"))

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Race)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1")

# see what other colour palettes are available and try some
?scale_colour_brewer

# interestingly you can set other attributes other than just the colours
# at the same time
# what you are doing is setting your own set of mappings from levels in the
# data to aesthetic values
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1", name = NULL, labels = c("women", "men"))

# colour gradients
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = BMI)) +
  geom_point() +
  scale_color_gradient(low = "black", high = "blue")
  
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = BMI)) +
  geom_point() +
  scale_color_gradient2(low = "red", mid = "grey60", high = "blue", midpoint = median(patients$BMI))

ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = BMI)) +
  geom_point() +
  scale_color_gradient2(low = "red", mid = "grey60", high = "blue", midpoint = median(patients$BMI))

# again we can override the default labels and other aspects of the BMI scale
# within the scale function
ggplot(data = patients, mapping = aes(x = Height, y = Weight, colour = BMI)) +
  geom_point() +
  scale_color_gradient(
    low = "lightblue", high = "darkblue",
    name = "Body mass index",
    breaks = seq(20, 30, by = 2.5)
  )


# Order of categories
# -------------------

ggplot(data = patients, mapping = aes(x = Sex, y = BMI, colour = Sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.25, alpha = 0.4) +
  scale_colour_brewer(palette = "Set1")
# two things wrong with this plot - prefer to have Male then Female and the legend is

patients$Sex
factor(patients$Sex, levels = c("Male", "Female"))

patients %>%
  mutate(Sex = factor(Sex, levels = c("Male", "Female"))) %>%
  ggplot(mapping = aes(x = Sex, y = BMI, colour = Sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.25, alpha = 0.4) +
  scale_colour_brewer(palette = "Set1")

# similarly for changing the order of categories in legends in scatter plots
patients %>%
  mutate(Sex = factor(Sex, levels = c("Male", "Female"))) %>%
  ggplot(mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1")


# Themes
# ------

# themes can be used to customize non-data elements of your plot
patients %>%
  mutate(Sex = factor(Sex, levels = c("Male", "Female"))) %>%
  ggplot(mapping = aes(x = Sex, y = BMI, colour = Sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.25, alpha = 0.4) +
  scale_colour_brewer(palette = "Set1") +
  theme_bw()

# what other themes are there? (use RStudio auto-complete)

# the theme function can be used to modify individual components of a theme

# to turn off the legend
ggplot(patients, mapping = aes(x = Sex, y = BMI, colour = Sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.25, alpha = 0.4) +
  scale_colour_brewer(palette = "Set1") +
  theme_minimal() +
  theme(legend.position = "none")

# or place it somewhere else
ggplot(patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1") +
  theme_minimal() +
  theme(legend.position = "bottom")

# what else can be changed
?theme

ggplot(patients, mapping = aes(x = Height, y = Weight, colour = Sex)) +
  geom_point() +
  scale_colour_brewer(palette = "Set1") +
  theme(
    axis.title = element_text(size = 10, colour = "darkblue"),
    axis.text = element_text(size = 8),
    legend.title = element_blank()
  )


# Statistical transformations
# ---------------------------

# many graphs, like scatterplots, plot the raw values from your dataset
# other graphs, like bar charts, calculate new values to plot

# bar charts and histograms bin your data and then plot bin counts
# smoothers fit a model to your data and then plot predictions from the model
# box plots compute a robust summary of the distribution and display a specially formatted box

# the algorithm used to calculate new values for a graph is called a stat

?geom_bar

# note that it uses a "count" stat

# sometimes you might want to override a stat, e.g. when you already have
# counts
count(patients, Pet)
patients %>%
  count(Pet) %>%
  ggplot(mapping = aes(x = Pet, y = n)) +
  geom_bar(stat = "identity")

# compare with
patients %>%
  ggplot(mapping = aes(x = Pet)) +
  geom_bar(stat = "count")


# Position adjustments
# --------------------



# Saving plots
# ------------

# ggsave saves the last plot you displayed
ggsave("myplot.png")

# or you can pass it a plot object

plot <- ggplot(data = patients, mapping = aes(x = Smokes, y = BMI, colour = Smokes)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.4, width = 0.25) +
  facet_wrap(~ Sex) +
  scale_colour_brewer(palette = "Set1") +
  theme(legend.position = "none")

ggsave("myplot.png", plot)

# can specify different types of output (pdf, svg, png, etc.) and the dimensions
ggsave("myplot.pdf", width = 8, height = 6)


