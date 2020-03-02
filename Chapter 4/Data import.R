####LISTERIA FARM PRACTICE DATA IMPORT####

setwd("~/Documents/College/Mishra Lab/Poultry Dissertation Project/Listeria Farm Practice Paper")

pacman::p_load(readxl, caret, rpart, plyr, Zelig, pROC, gbm, randomForest,DMwR, Metrics, pdp, gridExtra, ggplot2,
               tidyverse)

#FECES DATA#

#read in feces data
feces <- read_excel("FinalData.xlsx", sheet = "Feces")

#remove indicator variables and chemical variables
feces <- subset(feces, select = -c(pH:Zn, SampleID, SampleType, ListeriaSpecies, Farm, FlockAgeDays))

#make all character variables factors
feces[sapply(feces, is.character)] <- lapply(feces[sapply(feces, is.character)], as.factor)
#make listeria text change
feces$Listeria <- revalue(feces$Listeria, c("+" = "Positive", "-" = "Negative"))

#check which columns within the data set contain NAs
#we want to make sure that none of the categorical variables contain NAs or that will make model fitting tough
colnames(feces)[colSums(is.na(feces)) > 0]
#quantitative variables listed here can be imputed in data pre processing if we would like

# SOIL DATA

soil <- read_excel("FinalData.xlsx", sheet = "Soil")

soil[sapply(soil, is.character)] <- lapply(soil[sapply(soil, is.character)], as.factor)

soil$Listeria <- revalue(soil$Listeria, c("+" = "Positive", "-" = "Negative"))

#now we are going to only select columns from soil that are the same as feces
#this helps us streamline this process with just a few lines of code
common_names <- intersect(names(feces), names(soil))

#now select columns with these names from soil data
soil <- select(soil, common_names)

#combine two sets
combine <- rbind(feces, soil)

#we are going to use 'feces' as the keyword in our modeling, so we will assign the df to the 'feces' tag
feces <- combine

#change names of levels for factors egg source and feed to keep anonymous
levels(feces$EggSource) <- c('C','A', 'F', 'E', 'D', 'B')
levels(feces$PastureFeed) <- c('BWO', 'CMW', 'W', 'W', 'CSW', 'CSW', 'WC', 'CSW', 'CSO', 'PCO', 'WC')
levels(feces$BroodFeed) <- c('BWO', 'CSW', 'CSW', 'CSW', 'CSW', 'WC', 'W', 'CSO', 'PCO', 'WC')
levels(feces$Breed) <- c('CC', 'FR', 'FR')

#one final check to see if there are any NAs
colnames(feces)[colSums(is.na(feces)) > 0]


#WCR-P Data
WCRP <- read_excel("FinalData.xlsx", sheet = "WCR-P")
#new way to drop vars
WCRP <- subset(WCRP, select = -c(SampleID, ListeriaSpecies, ScalderTempC))

#make all character variables factors
WCRP[sapply(WCRP, is.character)] <- lapply(WCRP[sapply(WCRP, is.character)], as.factor)
WCRP$Listeria <- revalue(WCRP$Listeria, c("+" = "Positive", "-" = "Negative"))
colnames(WCRP)[colSums(is.na(WCRP)) > 0]
str(WCRP)

#WCR-F Data
WCRF <- read_excel("FinalData.xlsx", sheet = "WCR-F")
#new way to drop vars
WCRF <- subset(WCRF, select = -c(SampleID, Farm, PaMedicated))

#make all character variables factors
WCRF[sapply(WCRF, is.character)] <- lapply(WCRF[sapply(WCRF, is.character)], as.factor)
WCRF$Listeria <- revalue(WCRF$Listeria, c("+" = "Positive", "-" = "Negative"))
colnames(WCRF)[colSums(is.na(WCRF)) > 0]
str(WCRF)
levels(WCRF$EggSource) <- c('C', 'A', 'F', 'E', 'D', 'B')
