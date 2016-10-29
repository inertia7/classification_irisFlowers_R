# IRIS FLOWER CLASSIFICATION (R)
# PROJECT DETAILS AND IMAGES CAN BE FOUND AT  http://www.inertia7.com/projects/iris-classification-r

# LOAD PACKAGES
# Here if you haven't installed these packages do so!
# install.packages("data.table")
# install.packages("ggplot2")
# install.packages("ggfortify")
# install.packages("caret")
# install.packages("class")
# install.packages("gridExtra")
# install.packages("scales")
# install.packages("GGally")
# install.packages("RGraphics")
# install.packages("grid")
# install.packages("gmodels")

library(data.table)
library(ggplot2)
library(ggfortify)
library(caret)
library(class)
library(gridExtra)
library(scales)
library(GGally)
library(RGraphics)
library(grid)
library(gmodels)

# GET DATA
attach(iris)
data(iris)
head(iris)

# EXPLORATORY ANALYSIS

# SEPAL PROPERTIES INTERACTIONS
gg1<-ggplot(iris,aes(x=Sepal.Width,y=Sepal.Length, shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) +
  geom_point(size=2) + 
  labs(title = "Sepal Width Vs. Sepal Length")

ggplotly(gg1)

# PETAL PROPERTIES INTERACTIONS
gg2<-ggplot(iris,aes(x=Petal.Width,y=Petal.Length, shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) + 
  geom_point(size=2) + 
  labs(title = "Petal Length Vs. Petal Width")

ggplotly(gg2)

# PAIRWISE MATRIX FOR OUR DATA SET
pairs <- ggpairs(iris,mapping=aes(color=Species),columns=1:4) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) 
pairs
ggplotly(pairs) %>%
  layout(showlegend = FALSE)

 # MODEL ESTIMATION
 # Creating training/test set 
set.seed(123)
samp.size <- floor(nrow(iris) * .75)
samp.size
set.seed(123)

train.ind <- sample(seq_len(nrow(iris)), size = samp.size) 
train.ind 
train <- iris[train.ind, ] 
head(train)

train.set <- subset(train, select = -c(Species))
head(train.set)

test <- iris[-train.ind, ]
head(test)

test.set <- subset(test, select = -c(Species))
head(test.set)

class <- train[,"Species"]

test.class <- test [,"Species"]

# USING CARET PACKAGE TO ESTIMATE OPTIMAL K
set.seed(123)

contrl <- trainControl(method="repeatedcv",repeats = 3)

knn.K <- train(Species ~ ., data = train, method = "knn", trControl = contrl, preProcess = c("center","scale"),tuneLength = 20)

# Here we output the results from knn.K! 
knn.K

# PREDICTION RESULTS  
knn.iris <- knn(train = train.set, test = test.set, cl = class, k = 9, prob = T)

dim(train)
dim(class)
length(class)
table(test.class, knn.iris)

knn.iris

CrossTable(x = test.class, y = knn.iris, prop.chisq=FALSE)
 
# WE CAN ESTIMATE OUR TEST ERROR RATE AS FOLLOWS FROM OUR TABLE:
# > table(test.class, knn.iris)
# knn.iris
# test.class   setosa versicolor virginica
# setosa         11          0         0
# versicolor      0         13         0
# virginica       0          1        13

# Total Number of observations is 38 
# Total Number of observations predicted incorrectly is 1
1 / (11 + 13 + 13 + 1)

# WE RECEIVE A TEST ERROR RATE OF 0.02631579
