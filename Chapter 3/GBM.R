#GBM for Listeria feces and soil

#split the data using startified random sampling

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

#GBM grid to indicate tuning parameter options
gbmGrid <- expand.grid(interaction.depth = c(1, 3, 6, 9, 10),
                       n.trees = (1:50) * 5,
                       shrinkage = c(0.001, 0.005, 0.01, 0.05, 0.1),
                       n.minobsinnode = 10)

#Feces GBM
set.seed(12093)
fecesGBM_mod <- train(Listeria ~ ., method = "gbm", data = fecesTrain, trControl = traincontrol, metric = "ROC",
                      verbose = FALSE, tuneGrid = gbmGrid)
fecesGBM_mod
plot(fecesGBM_mod)
#hyper parameters were chosen based on ROC metrics and optimal values were n.trees = 220, 
#interaction.depth = 10, shrinkage = 0.1 and n.minobsinnode = 10

#ROC from training set
plot(roc(predictor = fecesGBM_mod$pred$Positive, response = fecesGBM_mod$pred$obs))

#variable importance plot
fecesGBM_mod_varImp <- varImp(fecesGBM_mod, scale = TRUE)

#ggplot version - much cleaner for publication use
my_feces_GBM_plot <- ggplot(fecesGBM_mod_varImp, top = 15)
my_feces_GBM_plot + xlab("") + ylab("Mean Decrease Gini") + theme(panel.grid.major = element_blank(), 
                                                     panel.grid.minor = element_blank(), 
                                                     panel.background = element_blank(), 
                                                     axis.line = element_line(colour = "black"))
#partial dependence plots for top 2 vars
fecesGBM_mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.4", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of", italic("Listeria"), "spp. isolation")))

fecesGBM_mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of", italic("Listeria"), "spp. isolation")))


#make predictions from this model on the testing set
feces_pred_GBM_class <- predict(fecesGBM_mod, fecesTest)
feces_pred_GBM_prob <- predict(fecesGBM_mod, fecesTest, type = "prob")

#confusion matrix
feces_GBM_cm <- confusionMatrix(feces_pred_GBM_class, fecesTest$Listeria, positive = "Positive")
feces_GBM_cm

#AUC from predictions
feces_GBM_AUC <- auc(actual = ifelse(fecesTest$Listeria == "Positive", 1, 0), 
                     predicted = feces_pred_GBM_prob[,"Positive"])
feces_GBM_AUC

#ROC from predictions
plot(roc(fecesTest$Listeria, feces_pred_GBM_prob$Positive, smooth = FALSE), main = "Feces GBM Model Prediction ROC")
mtext(paste0("AUC=", round(feces_GBM_AUC, digits = 3)), side = 1)

#Soil GBM
set.seed(1312)
soilGBM_mod <- train(Listeria ~ ., method = "gbm", data = soilTrain, trControl = traincontrol, metric = "ROC",
                      verbose = FALSE, tuneGrid = gbmGrid)
soilGBM_mod
plot(soilGBM_mod)
#optimal values were n.trees = 70, interaction.depth = 10, shrinkage = 0.1 
#and n.minobsinnode = 10

#ROC from training set
plot(roc(predictor = soilGBM_mod$pred$Positive, response = soilGBM_mod$pred$obs))

#variable imp plot
soilGBM_mod_varImp <- varImp(soilGBM_mod, scale = TRUE)
#plot(soilGBM_mod_varImp, top = 15, main = "Soil GBM Variable Importance Plot")

#ggplot version - much cleaner for publication use
my_soil_GBM_plot <- ggplot(soilGBM_mod_varImp, top = 15)
my_soil_GBM_plot + ylab("Mean Decrease Gini") + xlab("") + theme(panel.grid.major = element_blank(), 
                                                     panel.grid.minor = element_blank(), 
                                                     panel.background = element_blank(), 
                                                     axis.line = element_line(colour = "black"))

#partial dependence plots for top 2 vars
soilGBM_mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation")))

soilGBM_mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.2", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of", italic("Listeria"), "spp. isolation")))


#make predictions from this model on the testing set
soil_pred_GBM_class <- predict(soilGBM_mod, soilTest)
soil_pred_GBM_prob <- predict(soilGBM_mod, soilTest, type = "prob")

#confusion matrix
soil_GBM_cm <- confusionMatrix(soil_pred_GBM_class, soilTest$Listeria, positive = "Positive")
soil_GBM_cm

#AUC from predictions
soil_GBM_AUC <- auc(actual = ifelse(soilTest$Listeria == "Positive", 1, 0), 
                     predicted = soil_pred_GBM_prob[,"Positive"])
soil_GBM_AUC

#ROC from predictions
plot(roc(soilTest$Listeria, soil_pred_GBM_prob$Positive, smooth = FALSE), main = "Soil GBM Model Prediction ROC")
mtext(paste0("AUC=", round(soil_GBM_AUC, digits = 3)), side = 1)
