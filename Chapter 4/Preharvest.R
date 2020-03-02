#FECES RF MODEL#

#split the data using stratified random sampling

#for feces data
set.seed(987)
fecesinTrain <- createDataPartition(y = feces$Listeria, p = 0.8, list = FALSE)
fecesTrain <- feces[fecesinTrain,] #creates 80% training data set
fecesTest <- feces[-fecesinTrain,] #creates 20% testing data set


#change factor order so that positive is first
fecesTrain$Listeria <- factor(fecesTrain$Listeria, levels = c("Positive", "Negative"))
fecesTest$Listeria <- factor(fecesTest$Listeria, levels = c("Positive", "Negative"))

#specify the training controls so that 10-fold cross validation is run during the training of the model
traincontrol <- trainControl(method = "cv", number = 10, savePredictions = "all", classProbs = TRUE, 
                             summaryFunction = twoClassSummary, sampling = "smote")


#train the training data using 10-fold cross validation training controls
set.seed(654)
fecesRF_Mod <- train(Listeria ~ ., method = "rf", data = fecesTrain, trControl = traincontrol, metric = "ROC")
fecesRF_Mod
fecesRF_Mod$finalModel
plot(fecesRF_Mod, xlab = "Randomly Selected Predictors") #shows the accuracy across multiple mtry values
#most accurate is mtry=44, and caret retrained training data with final model hyper parameters
#optimal model now resides in fecesMod 
#this model should now be tested on the testing data for model performance

#ROC from training set
plot(roc(predictor = fecesRF_Mod$pred$Positive, response = fecesRF_Mod$pred$obs))

#variable importance plot for model
fecesRF_Mod_varImp <- varImp(fecesRF_Mod, scale = TRUE)
#plot(fecesRF_Mod_varImp, top = 15, main = "Feces RF Variable Importance Plot")

#ggplot version - much cleaner for publication use
my_feces_RF_plot <- ggplot(fecesRF_Mod1_varImp, top = 8)
my_feces_RF_plot + xlab("") + ylab("RelativeImportance") + theme(panel.grid.major = element_blank(), 
                                                                 panel.grid.minor = element_blank(), 
                                                                 panel.background = element_blank(), 
                                                                 axis.line = element_line(colour = "black")) 


#pdps
fecesRF_Mod %>%
  partial(pred.var = "DayOfYear", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))

fecesRF_Mod %>%
  partial(pred.var = "FlockAgeWeeks", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))



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
