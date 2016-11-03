# Iris Flower Classification 
## Knn Analysis of Iris Flowers with R
(Project can be found at: http://www.inertia7.com/projects/iris-classification-r)

# Abstract
This project focuses on the classification of iris flowers into their respective species by using the K-Nearest Neighbors machine-learning algorithm. The three species in this classification problem include setosa, versicolor, and virginica. The explanatory variables include sepal length, sepal width, pedal length, petal width. See sepal wiki. See petal wiki. We are essentially trying to predict the species of the iris flower based on physical features!

The K-Nearest Neighbor algorithm is interesting because it is a simple yet powerful a machine learning method used for classification. It predicts based on majority votes, measuring a certain number of neighboring observation points (k) and classifies based on attribute prevalence using Euclidean distance.

## Contributors 
- Raul Eulogio
- Kim Specht 
- David A. Campos

## Packages Required
Here are the required packages which will ensure all the code will run properly. 

	data.table
	ggplot2
	ggfortify
	caret
	class
	gridExtra
	GGally 
	RGraphics
	gmodels


To make sure you have the packages we use in this project use the command(you will only have to use this once): 

	install.packages("packageName") 

You will have now downloaded the package so within your script you run: 

	require(packageName)

This must be done before each **Rstudio** session, and written at the start of every script to ensure your code will be easily reproducible!

## Steps Required
If you would like to publish the plots you created through this project please refer to the **Forecasting the Stock Market** repository (found here: https://github.com/inertia7/timeSeries_sp500_R/blob/master/README.md#steps-required)

