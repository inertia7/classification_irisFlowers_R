#######
#######
#######
#######
#######
#######
#######
####### Kth Nearest Neighbor for Iris
####### Compiled by: Kim Specht and Raul Eulogio
#######
#######
#######
#######
#######
#######

# Data Mining Techniques in R.
# 

# Objective: We are using the data mining technique called Kth Nearest Neighbor on the iris data set to help out current project
# members to grasp basic concepts in R. We used techniques taught at UCSB's PSTAT course 131, although
# not exhaustive, we wanted to present a simple to follow guideline for certain data mining techniques in R!!!

# First we load the necessary packages for our analysis if you don't have these packages
# use the install.packages call to install them if you do then just call them up using library
# install.packages("data.table")
# install.packages("class")
# install.packages("ggplot2")
# install.packages("gridExtra")
# install.packages("MASS")
# install.packages("scales")
# install.packages("GGally")
# install.packages("RGraphics")
# install.packages("grid")
# install.packages("ROCR")
library(data.table)
library(plotly)
library(class)
library(ggplot2)
library(MASS)
library(gridExtra)
library(scales)
library(tree)
library(GGally)
library(RGraphics)
library(grid)
library(ROCR)

# For publishing on plotly
Sys.setenv("plotly_username"="userName") # For plotly credentials and publishing 
Sys.setenv("plotly_api_key"="api_key") # DO NOT POST IN GITHUB


attach(iris)
data(iris) # We call up the data set
head(iris) # Returns the first 6 observations of our data set
summary(iris) #Summary statistics

# Exploratory Data Analysis

# Here we create a visual to see the relationship between the sepal width and sepal length. And also the petal length and petal width
gg1<-ggplot(iris,aes(x=Sepal.Width,y=Sepal.Length, 
                     shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) +
  geom_point(size=2) + 
  labs(title = "Sepal Width Vs. Sepal Length")
ggplotly(gg1)
# This function posts your plotly graph unto your plotly account 
# You can remove these if you do not want to publish them I will comment them out for now
# plotly_POST(gg1, filename = "irisSepWidSepLen")
gg2<-ggplot(iris,aes(x=Petal.Width,y=Petal.Length, 
                     shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) + 
  geom_point(size=2) + 
  labs(title = "Petal Length Vs. Petal Width")
  


ggplotly(gg2)
plotly_POST(gg2, filename = "irisPetLenPetWid")
grid.arrange(gg1, gg2,nrow=1,ncol=2,  top = "Scatter plots")

dev.off() # This function immediately removes all plots from the Rplot so it is advised to run the plot and this function separately!!!!

# More exploratory graphs, Pairwise Plot Matrix
pairs <- ggpairs(iris,mapping=aes(color=Species),columns=1:4) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) 
pairs
v <- ggplotly(pairs) %>%
  layout(showlegend = FALSE)
# plotly_POST(v, filename = "irisPairs")

dev.off()
iris.dat <-iris[, 1:4]
iris.dat
# The next method we decided to use is K-nearest neighbor algorithm.
set.seed(123)
samp.size <- floor(nrow(iris) * .75) # Here we are creating the size for the index we are going to use
# for our training set (75% of the observations)
samp.size #Outputting the result
set.seed(123)
train.ind <- sample(seq_len(nrow(iris.dat)), size = samp.size) # Here we are creating an index of the
# randomized row indices to be included in our training set
train.ind # The output will give a better reference so just run this and see what it outputs to gain
# a better understanding
train <- iris[train.ind, ] # This matches the respective row index created to the actual row of the
# iris data set.  
head(train) # Output the first six observations and see what I mean (the row indices on this should
# match those created by train.ind)
train.set <- subset(train, select = -c(Species)) # We create the training set excluding our class variable (Species)
head(train.set) # Output result should only have four variables not including Species
test <- iris[-train.ind, ] # Same process as train except we're excluding the row indices created by
# train.ind in order to create our test set (the rest of the 25% of the data set)
head(test) # Output the results
test.set <- subset(test, select = -c(Species)) # We create the test set where we exclude the class variable(Species!!!)
head(test.set) # Output the results
class <- train[, "Species"] # Here we create the class index which only has the class variable for
# the original train data frame. IMPORTANT: this class has to be a vector/matrix.
print("Here's the length of the class variable:")
length(class)
# Creating a data frame will give you an error code when running the knn function!!!!
head(class) # Output the results
knn.iris <- knn(train = train.set, test = test.set, cl = class, k = 9, prob = T)
# I can't go into too much detail for the knn algorithm (better explained in person imo). But basically
# we use our training set to run the algorithm, it uses the class vector as a reference
# because those are the actual values its trying to predict. So
# Once R runs that for us (YAY machines doing the dirty work), since we added "prob = T" we are also given
# the probabilities calculated
test.class <- test[, "Species"] # Here we create a class vector/matrix that includes the actual species
# values for the test set. Will be used later!!!
head(test.class) # Output the results

library(caret)
# Run k-NN:
set.seed(123)
ctrl <- trainControl(method="repeatedcv",repeats = 3)
knn.K <- train(Species ~ ., data = train, method = "knn", trControl = ctrl, preProcess = c("center","scale"))
knn.K

# Prediction accuracy
table(test.class, knn.iris) # Here we have the data frame which contains the actual values for the class variable(Species),
# for our test set.

# Therefore we have a total of one species predicted incorrectly so we have
print("Our test error rate is")
1 / (11 + 13 + 13 + 1)
print("Thus we have the error rate as 0.02631579 for our K-nearest neighbor algorithm!")


