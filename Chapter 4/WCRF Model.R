#WCRF RF MODEL#

#for feces data
set.seed(20131)
WCRFinTrain <- createDataPartition(y = WCRF$Listeria, p = 0.8, list = FALSE)
WCRFTrain <- WCRF[WCRFinTrain,] #creates 80% training data set
WCRFTest <- WCRF[-WCRFinTrain,] #creates 20% testing data set


#change factor order so that positive is first
WCRFTrain$Listeria <- factor(WCRFTrain$Listeria, levels = c("Positive", "Negative"))
WCRFTest$Listeria <- factor(WCRFTest$Listeria, levels = c("Positive", "Negative"))

#specify the training controls so that 10-fold cross validation is run during the training of the model
traincontrol <- trainControl(method = "cv", number = 10, savePredictions = "all", classProbs = TRUE, 
                             summaryFunction = twoClassSummary, sampling = "smote")


#train the training data using 10-fold cross validation training controls
set.seed(12)
WCRF_RF_Mod <- train(Listeria ~ ., method = "rf", data = WCRFTrain, trControl = traincontrol, metric = "ROC")
WCRF_RF_Mod
WCRF_RF_Mod$finalModel
plot(WCRF_RF_Mod, xlab = "Randomly Selected Predictors") #shows the accuracy across multiple mtry values
#most accurate is mtry=44, and caret retrained training data with final model hyper parameters
#optimal model now resides in fecesMod 
#this model should now be tested on the testing data for model performance

#ROC from training set
plot(roc(predictor = WCRF_RF_Mod$pred$Positive, response = WCRF_RF_Mod$pred$obs))

#variable importance plot for model
WCRF_RF_Mod_varImp <- varImp(WCRF_RF_Mod, scale = TRUE)
#plot(fecesRF_Mod_varImp, top = 15, main = "Feces RF Variable Importance Plot")

#ggplot version - much cleaner for publication use
my_WCRF_RF_plot <- ggplot(WCRF_RF_Mod_varImp, top = 7)
my_WCRF_RF_plot + xlab("") + ylab("RelativeImportance") + theme(panel.grid.major = element_blank(), 
                                                                 panel.grid.minor = element_blank(), 
                                                                 panel.background = element_blank(), 
                                                                 axis.line = element_line(colour = "black")) 


#pdps
WCRF_RF_Mod %>%
  partial(pred.var = "LengthFeedRestrixProcess", prob = TRUE) %>%
  autoplot(rug = FALSE, train = WCRFTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))


#make predictions from this model on the testing set
WCRF_pred_class <- predict(WCRF_RF_Mod, WCRFTest)
WCRF_pred_prob <- predict(WCRF_RF_Mod, WCRFTest, type = "prob")

#confusion matrix
WCRFcm <- confusionMatrix(WCRF_pred_class, WCRFTest$Listeria, positive = "Positive")
WCRFcm

#AUC from predictions
WCRF_RF_AUC <- auc(actual = ifelse(WCRFTest$Listeria == "Positive", 1, 0), 
                    predicted = WCRF_pred_prob[,"Positive"])
WCRF_RF_AUC

#ROC from predictions
plot(roc(WCRFTest$Listeria, WCRF_pred_prob$Positive, smooth = FALSE), main = "WCRF RF Model Prediction ROC")
mtext(paste0("AUC=", round(WCRF_RF_AUC, digits = 3)), side = 1)
