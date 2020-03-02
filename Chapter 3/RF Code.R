# production of RF models using the caret package

#split the data using stratified random sampling

#for feces data
set.seed(120)
fecesinTrain <- createDataPartition(y = feces$Listeria, p = 0.8, list = FALSE)
fecesTrain <- feces[fecesinTrain,] #creates 80% training data set
fecesTest <- feces[-fecesinTrain,] #creates 20% testing data set
#dim(fecesTrain) 
#dim(fecesTest)
#for soil data
set.seed(1293)
soilinTrain <- createDataPartition(y = soil$Listeria, p = 0.8, list = FALSE)
soilTrain <- soil[soilinTrain,] #creates 80% training data set
soilTest <- soil[-fecesinTrain,] #creates 20% testing data set
#dim(soilTrain) 
#dim(soilTest)

#change factor order so that positive is first
fecesTrain$Listeria <- factor(fecesTrain$Listeria, levels = c("Positive", "Negative"))
#change factor order so that positive is first
soilTrain$Listeria <- factor(soilTrain$Listeria, levels = c("Positive", "Negative"))
#change factor order so that positive is first
fecesTest$Listeria <- factor(fecesTest$Listeria, levels = c("Positive", "Negative"))
#change factor order so that positive is first
soilTest$Listeria <- factor(soilTest$Listeria, levels = c("Positive", "Negative"))


#specify the training controls so that 10-fold cross validation is run during the training of the model
traincontrol <- trainControl(method = "cv", number = 10, savePredictions = "all", classProbs = TRUE, 
                            summaryFunction = twoClassSummary, sampling = "smote")
#smote uses a hybrid of up sampling and down sampling to attempt to correct for the imbalance in the
#data distribution


#FECES RF
#train the training data using 10-fold cross validation training controls
set.seed(12093)
fecesRF_Mod <- train(Listeria ~ ., method = "rf", data = fecesTrain, trControl = traincontrol, metric = "ROC")
fecesRF_Mod
fecesRF_Mod$finalModel
plot(fecesRF_Mod, xlab = "Randomly Selected Predictors") #shows the accuracy across multiple mtry values
#most accurate is mtry=51, and caret retrained training data with final model hyper parameters
#optimal model now resides in fecesMod 
#this model should now be tested on the testing data for model performance

#ROC from training set
plot(roc(predictor = fecesRF_Mod$pred$Positive, response = fecesRF_Mod$pred$obs))

#variable importance plot for model
fecesRF_Mod_varImp <- varImp(fecesRF_Mod, scale = TRUE)
#plot(fecesRF_Mod_varImp, top = 15, main = "Feces RF Variable Importance Plot")

#ggplot version - much cleaner for publication use
my_feces_RF_plot <- ggplot(fecesRF_Mod_varImp, top = 15)
my_feces_RF_plot + xlab("") + ylab("Mean Decrease Gini") + theme(panel.grid.major = element_blank(), 
                                                     panel.grid.minor = element_blank(), 
                                                     panel.background = element_blank(), 
                                                     axis.line = element_line(colour = "black")) 


#partial dependence plot for most important vars
fecesRF_Mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.4", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))

fecesRF_Mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of", italic("Listeria"), "spp. isolation")))


#make predictions from this model on the testing set
feces_pred_class <- predict(fecesRF_Mod, fecesTest)
feces_pred_prob <- predict(fecesRF_Mod, fecesTest, type = "prob")

#confusion matrix
fecescm <- confusionMatrix(feces_pred_class, fecesTest$Listeria, positive = "Positive")
fecescm

#AUC from predictions
feces_RF_AUC <- auc(actual = ifelse(fecesTest$Listeria == "Positive", 1, 0), 
                    predicted = feces_pred_prob[,"Positive"])
feces_RF_AUC

#ROC from predictions
plot(roc(fecesTest$Listeria, feces_pred_prob$Positive, smooth = FALSE), main = "Feces RF Model Prediction ROC")
mtext(paste0("AUC=", round(feces_RF_AUC, digits = 3)), side = 1)

#SOIL RF
set.seed(1312)
soilRF_Mod <- train(Listeria ~ ., method = "rf", data = fecesTrain, trControl = traincontrol, metric="ROC")
soilRF_Mod
soilRF_Mod$finalModel
plot(soilRF_Mod) #shows the accuracy across multiple mtry values

#ROC from training set
plot(roc(predictor = soilRF_Mod$pred$Positive, response = soilRF_Mod$pred$obs))

#variable importance plot for model
soilRF_Mod_varImp <- varImp(soilRF_Mod, scale = TRUE)
#plot(soilRF_Mod_varImp, top = 15, main = "Soil RF Variable Importance Plot")

#ggplot version - much cleaner for publication use
my_soil_RF_plot <- ggplot(soilRF_Mod_varImp, top = 15)
my_soil_RF_plot + xlab("") + ylab("Mean Decrease Gini") + theme(panel.grid.major = element_blank(), 
                                                       panel.grid.minor = element_blank(), 
                                                       panel.background = element_blank(), 
                                                       axis.line = element_line(colour = "black")) 

#partial dependence plots for top 2 vars
soilRF_Mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))

soilRF_Mod %>%
  partial(pred.var = "MinTemperatureTwoDay", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of", italic("Listeria"), "spp. isolation")))


#make predictions from this model on the testing set
soil_pred_class <- predict(soilRF_Mod, soilTest)
soil_pred_prob <- predict(soilRF_Mod, soilTest, type = "prob")

#confusion matrix
soilcm <- confusionMatrix(soil_pred_class, soilTest$Listeria, positive = "Positive")
soilcm

#AUC from predictions
soil_RF_AUC <- auc(actual = ifelse(soilTest$Listeria == "Positive", 1, 0), predicted = soil_pred_prob[,"Positive"])
soil_RF_AUC


#ROC from predictions
plot(roc(soilTest$Listeria, soil_pred_prob$Positive, smooth = FALSE), main="Soil RF Predicition ROC")
mtext(paste0("AUC=", round(soil_RF_AUC, digits = 3)), side = 1)



