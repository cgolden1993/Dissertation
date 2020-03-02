setwd("~/Documents/College/Mishra Lab/Poultry Dissertation Project/Listeria Meteorological Paper/Figures")
#FIGURE 1 - Feces Var Importance plots
#RF
my_groba <- grobTree(textGrob("a", x=0.9,  y=0.05, hjust=0,
                             gp=gpar(col="black", fontsize=12)))

my_feces_RF_plot + xlab("") + ylab("Relative Importance") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  annotation_custom(my_groba)
ggsave("Figure1a.jpg")

#GBM
my_grobb <- grobTree(textGrob("b", x=0.9,  y=0.05, hjust=0,
                              gp=gpar(col="black", fontsize=12)))

my_feces_GBM_plot + xlab("") + ylab("Relative Importance") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  annotation_custom(my_grobb)
  
ggsave("Figure1b.jpg")

#FIGURE 2 - Partial dependency plots of top 2 important variable
#RF
amy_grob <- grobTree(textGrob("a", x=0.865,  y=0.95, hjust=0,
                                          gp=gpar(col="black", fontsize=12)))
fecesRF_Mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.4", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(amy_grob)
ggsave("Figure2a.jpg", width = 4, height = 4, units = "in")

bmy_grob <- grobTree(textGrob("b", x=0.865,  y=0.95, hjust=0,
                              gp=gpar(col="black", fontsize=12)))
fecesRF_Mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(bmy_grob)
ggsave("Figure2b.jpg", width = 4, height = 4, units = "in")

#GBM
cmy_grob <- grobTree(textGrob("c", x=0.865,  y=0.95, hjust=0,
                              gp=gpar(col="black", fontsize=12)))
fecesGBM_mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.4", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(cmy_grob)
ggsave("Figure2c.jpg", width = 4, height = 4, units = "in")

dmy_grob <- grobTree(textGrob("d", x=0.865,  y=0.95, hjust=0,
                              gp=gpar(col="black", fontsize=12)))
fecesGBM_mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(dmy_grob)
ggsave("Figure2d.jpg", width = 4, height = 4, units = "in")

#FIGURE 3 - Soil Var Importance Plots
#RF
my_groba <- grobTree(textGrob("a", x=0.9,  y=0.05, hjust=0,
                              gp=gpar(col="black", fontsize=12)))

my_soil_RF_plot + xlab("") + ylab("Relative Importance") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  annotation_custom(my_groba)
ggsave("Figure3a.jpg")

#GBM
my_grobb <- grobTree(textGrob("b", x=0.9,  y=0.05, hjust=0,
                              gp=gpar(col="black", fontsize=12)))

my_soil_GBM_plot + ylab("Relative Importance") + xlab("") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  annotation_custom(my_grobb)
ggsave("Figure3b.jpg")

#FIGURE 4 - Soil PDPs

#RF
soilRF_Mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(amy_grob)
ggsave("Figure4a.jpg", width = 4, height = 4, units = "in")

soilRF_Mod %>%
  partial(pred.var = "MinTemperatureTwoDay", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(bmy_grob)
ggsave("Figure4b.jpg", width = 4, height = 4, units = "in")

#GBM
soilGBM_mod %>%
  partial(pred.var = "AvgAverageHumiditySamp.3", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(cmy_grob)
ggsave("Figure4c.jpg", width = 4, height = 4, units = "in")

soilGBM_mod %>%
  partial(pred.var = "AvgMinTemperatureSamp.2", prob = TRUE) %>%
  autoplot(rug = FALSE, train = soilTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black")) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) + annotation_custom(dmy_grob)
ggsave("Figure4d.jpg", width = 4, height = 4, units = "in")


#FIGURE 5 - ROC Curves for Feces
#RF
plot(roc(fecesTest$Listeria, feces_pred_prob$Positive, smooth = FALSE))
lines(roc(fecesTest$Listeria, feces_pred_GBM_prob$Positive, smooth = FALSE), lty = 2)
legend("bottomright", c("RF", "GBM"), lty = 1:2, cex = 0.75)
dev.print(jpeg, "Figure5.jpg", res = 600, height = 4, width = 4, units = "in")

#Figure 6 - ROC Curves for Soil
plot(roc(soilTest$Listeria, soil_pred_prob$Positive, smooth = FALSE))
lines(roc(soilTest$Listeria, soil_pred_GBM_prob$Positive, smooth = FALSE), lty = 2)
legend("bottomright", c("RF", "GBM"), lty = 1:2, cex = 0.75)
dev.print(jpeg, "Figure6.jpg", res = 600, height = 4, width = 4, units = "in")
