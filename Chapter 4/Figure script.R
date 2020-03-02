setwd("~/Documents/College/Mishra Lab/Poultry Dissertation Project/Listeria Farm Practice Paper/R Scripts/Figures")


#FIGURE 1 - Feces Var Importance plots
#RF
my_groba <- grobTree(textGrob(expression(bold("(A)")), x=0.85,  y=0.05, hjust=0,
                              gp=gpar(col="black", fontsize=12)))

my_feces_RF_plot + xlab("") + ylab("Relative Importance") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"),axis.text=element_text(size=10), 
        axis.title=element_text(size=11,face="bold")) 
ggsave("Figure1a.jpg")




#FIGURE 2 - Partial dependency plots of top 2 important variable
#RF
amy_grob <- grobTree(textGrob(expression(bold("(A)")), x=0.865,  y=0.95, hjust=0,
                              gp=gpar(col="black", fontsize=12)))



fecesRF_Mod %>%
  partial(pred.var = "DayOfYear", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), axis.text=element_text(size=10),
        axis.title=element_text(size=12)) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(amy_grob)

ggsave("Figure2a.jpg", width = 4, height = 4, units = "in")

bmy_grob <- grobTree(textGrob(expression(bold("(B)")), x=0.865,  y=0.95, hjust=0,
                              gp=gpar(col="black", fontsize=12)))
fecesRF_Mod %>%
  partial(pred.var = "FlockAgeWeeks", prob = TRUE) %>%
  autoplot(rug = FALSE, train = fecesTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), axis.text=element_text(size=10),
        axis.title=element_text(size=12)) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(bmy_grob) + scale_x_continuous(limits = c(0,15)) 
ggsave("Figure2b.jpg", width = 4, height = 4, units = "in")


#FIGURE 3 - WCRF Var Importance Plots
#RF


my_WCRF_RF_plot + xlab("") + ylab("Relative Importance") + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"),axis.text=element_text(size=10), 
        axis.title=element_text(size=11,face="bold")) 
ggsave("Figure3a.jpg")



#FIGURE 4 - WCRF PDPs

#RF
WCRF_RF_Mod %>%
  partial(pred.var = "RinseWaterChlor", prob = TRUE) %>%
  autoplot(rug = FALSE, train = WCRFTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), axis.text=element_text(size=10),
        axis.title=element_text(size=12)) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(bmy_grob) + scale_y_continuous(limit = c(0.18, 0.5), breaks = c(0.2, 0.3, 0.4, 0.5))
ggsave("Figure4b.jpg", width = 4, height = 4, units = "in")

WCRF_RF_Mod %>%
  partial(pred.var = "BroodFeed", prob = TRUE) %>%
  autoplot(rug = FALSE, train = WCRFTrain) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), axis.text=element_text(size=10),
        axis.title=element_text(size=12)) +
  ylab(expression(paste("Probability of ", italic("Listeria"), " spp. isolation"))) +
  annotation_custom(amy_grob) + scale_y_continuous(limits = c(0.09, 0.5), 
                                                   breaks = c(seq(from = 0.1, to = 0.5, by = 0.1)))
ggsave("Figure4a.jpg", width = 4, height = 4, units = "in")




#FIGURE 5 - ROC Curves for both models
#RF
plot(roc(fecesTest$Listeria, feces_pred_prob$Positive, smooth = FALSE))
lines(roc(WCRFTest$Listeria, WCRF_pred_prob$Positive, smooth = FALSE), lty = 2)
legend("bottomright", c("Enivronmental", "WCR"), lty = 1:2, cex = 0.65)
dev.print(jpeg, "Figure5.jpg", res = 600, height = 4, width = 4, units = "in")

