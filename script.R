# IRIS FLOWER CLASSIFICATION (R)
# PROJECT DETAILS AND IMAGES CAN BE FOUND AT  http://www.inertia7.com/projects/iris-classification-r

# LOAD PACKAGES
# Here if you haven't installed these packages do so!
# install.packages("ggplot2")
# install.packages("ggfortify")
# install.packages("caret")
# install.packages("class")
# install.packages("gridExtra")
# install.packages("GGally")
# install.packages("RGraphics")
# install.packages("plotly")
# install.packages("gmodels")

library(ggplot2)
library(ggfortify)
library(caret)
library(e1071)
library(here)
library(tibble)
#library(class)
library(gridExtra)
library(plotly)
library(GGally)
library(plotly)
library(gmodels)

here()

# GET DATA
attach(iris)
data(iris)
iris_tb <- as_tibble(iris)
head(iris_tb)
colnames(iris_tb) <- c('sepal_length', 'sepal_width',
                       'petal_length', 'petal_width', 
                       'species')
# EXPLORATORY ANALYSIS

# SEPAL PROPERTIES INTERACTIONS
gg1<-ggplot(iris_tb,
            aes(x=sepal_width,y=sepal_length, 
                shape=species, 
                color=species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) +
  geom_point(size=2) + 
  labs(title = "Sepal Width Vs. Sepal Length")

ggplotly(gg1)

# PETAL PROPERTIES INTERACTIONS
gg2<-ggplot(iris_tb,
            aes(x=petal_width,y=petal_length, 
                shape=species, 
                color=species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) + 
  geom_point(size=2) + 
  labs(title = "Petal Length Vs. Petal Width")

ggplotly(gg2)

# PAIRWISE MATRIX FOR OUR DATA SET
pairs <- ggpairs(iris_tb,
                 mapping=aes(color=species),
                 columns=1:4) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) 
pairs
ggplotly(pairs) %>%
  layout(showlegend = FALSE)

 # MODEL ESTIMATION
 # Creating training/test set 
set.seed(88)
trainIndex <- createDataPartition(iris_tb$species, 
                                  p = .8, 
                                  list = FALSE, 
                                  times = 1)
# Creating 80 20 split 
training_set <- iris_tb[ trainIndex,]

test_set  <- iris_tb[-trainIndex,]

# USING CARET PACKAGE TO ESTIMATE OPTIMAL K

fit <- train(species ~ ., 
             data = training_set, 
             method = "knn")

# Here we output the results from fit! 
fit

# PREDICTION RESULTS  
# Predict
predict_test_set <- predict(fit,
                            newdata = test_set)

CrossTable(x = test_set$species, 
           y = predict_test_set, 
           prop.chisq=FALSE)
 
# WE CAN ESTIMATE OUR TEST ERROR RATE AS FOLLOWS FROM OUR TABLE:
# > table(test_set$species, predict_test_set)
# predict_test_set
# setosa versicolor virginica
# setosa         10          0         0
# versicolor      0          8         2
# virginica       0          0        10

# Total Number of observations is 30 
# Total Number of observations predicted incorrectly is 2

print(round(1 - fit$results$Accuracy[1], 4))
# WE RECEIVE A TEST ERROR RATE OF 0.0334
