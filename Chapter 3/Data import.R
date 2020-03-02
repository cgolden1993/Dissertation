setwd("~/Documents/College/Mishra Lab/Poultry Dissertation Project")

#load all necessary packages
pacman::p_load(readxl, caret, rpart, plyr, Zelig, pROC, gbm, randomForest,DMwR, Metrics, pdp, gridExtra, ggplot2)

poul <- read_excel("Copy of Meteorological poultry data.xlsx") #inputs ALL data

listeria <- poul[,-c(1,2,3,6:8)] #deletes indicator variables
listeria <- na.omit(listeria) #guarantee that there are not any NA obs in your DF
listeria$Listeria <- as.factor(listeria$Listeria)

feces <- listeria[(which(listeria$SampleType=='Feces')),] #selects for feces only data
feces <- feces[,-1] #removes sample type (feces) variable
feces$Listeria <- revalue(feces$Listeria, c("+"="Positive","-"="Negative"))
soil <- listeria[(which(poul$SampleType=='Soil')),]
soil <- soil[,-1]
soil$Listeria <- revalue(soil$Listeria, c("+"="Positive","-"="Negative"))



#SHOULDN'T NEED TO INCLUDE THIS BUT HERE'S THE CODE IF SO
feces$Listeria <- revalue(feces$Listeria, c("+"=1)) #change positive character to 1
feces$Listeria <- revalue(feces$Listeria, c("-"=0)) #change negative character to 0
feces$Listeria <- as.numeric(feces$Listeria) 

soil$Listeria <- revalue(soil$Listeria, c("+"=1))
soil$Listeria <- revalue(soil$Listeria, c("-"=0))
soil$Listeria <- as.numeric(soil$Listeria)



