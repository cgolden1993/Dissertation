library(metafor)
library(readxl)
library(meta)
library(grid)

setwd("~/Documents/College/Mishra Lab/Meta-analysis")

dat <- read_excel('Compiled Results.xlsx')

##############
#Environmental
##############

environ_campy <- dat[which(dat$Sample=='Environmental' & dat$Organism=='Campylobacter'),]
environ_sal <- dat[which(dat$Sample=='Environmental' & dat$Organism=='Salmonella'),]

#generate 
res_environ_campy <- metaprop(environ_campy$x, environ_campy$n, method = "GLMM", sm = "PLOGIT", data = environ_campy, 
                          byvar = environ_campy$Production, comb.random = TRUE, studlab = environ_campy$Citation)

res_environ_sal <- metaprop(environ_sal$x, environ_sal$n, method = "GLMM", sm = "PLOGIT", data = environ_sal, 
                        byvar = environ_sal$Production, comb.random = TRUE, studlab = environ_sal$Citation)

tiff("forest_EC.png", units="in", width=7, height=4.5, res=300)
forest(res_environ_campy, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "1mm")
grid.text("2A", .92, .91, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Campylobacter") ~ bold(" Environmental"))), .5, .91, gp=gpar(cex=1, fontface=2))
dev.off()

tiff("forest_ES.png", units="in", width=7.5, height=5.3, res=300)
forest(res_environ_sal, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "1mm")
grid.text("2B", .88, .94, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Salmonella") ~ bold(" Environmental"))), .5, .94, gp=gpar(cex=1, fontface=2))
dev.off()



##############
#Rehang
##############

rehang_campy <- dat[which(dat$Sample=='Rehang' & dat$Organism=='Campylobacter'),]
rehang_sal <- dat[which(dat$Sample=='Rehang' & dat$Organism=='Salmonella'),]

res_rehang_campy <- metaprop(rehang_campy$x, rehang_campy$n, method = "GLMM", sm = "PLOGIT", data = rehang_campy, 
                             comb.random = TRUE, studlab = rehang_campy$Citation)

res_rehang_sal <- metaprop(rehang_sal$x, rehang_sal$n, method = "GLMM", sm = "PLOGIT", data = rehang_sal, 
                            comb.random = TRUE, studlab = rehang_sal$Citation)

tiff("forest_RHC.png", units="in", width=7.5, height=4, res=300)
forest(res_rehang_campy, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "2.5mm")
grid.text("3A", .88, .76, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Campylobacter")~ bold(" Rehang"))), .5, .76, gp=gpar(cex=1, fontface=2))
dev.off()

tiff("forest_RHS.png", units="in", width=7.5, height=4, res=300)
forest(res_rehang_sal, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "1mm")
grid.text("3B", .88, .76, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Salmonella")~ bold(" Rehang"))), .5, .76, gp=gpar(cex=1, fontface=2))
dev.off()



################
#Prechill
################

prechill_campy <- dat[which(dat$Sample=='Prechill' & dat$Organism=='Campylobacter'),]
prechill_sal <- dat[which(dat$Sample=='Prechill' & dat$Organism=='Salmonella'),]

res_prechill_campy <- metaprop(prechill_campy$x, prechill_campy$n, method = "GLMM", sm = "PLOGIT", data = prechill_campy, 
                             comb.random = TRUE, studlab = prechill_campy$Citation)

res_prechill_sal <- metaprop(prechill_sal$x, prechill_sal$n, method = "GLMM", sm = "PLOGIT", data = prechill_sal, 
                           comb.random = TRUE, studlab = prechill_sal$Citation)

tiff("forest_PREC.png", units="in", width=7.5, height=4, res=300)
forest(res_prechill_campy, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "2.5mm")
grid.text("4A", .88, .71, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Campylobacter")~ bold(" Prechill"))), .5, .71, gp=gpar(cex=1, fontface=2))
dev.off()

tiff("forest_PRES.png", units="in", width=7.5, height=4, res=300)
forest(res_prechill_sal, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "2.5mm")
grid.text("4B", .92, .80, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Salmonella")~ bold(" Prechill"))), .5, .80, gp=gpar(cex=1, fontface=2))
dev.off()

##################
#Postchill
##################

postchill_campy <- dat[which(dat$Sample=='Postchill' & dat$Organism=='Campylobacter'),]
postchill_sal <- dat[which(dat$Sample=='Postchill' & dat$Organism=='Salmonella'),]

res_postchill_campy <- metaprop(postchill_campy$x, postchill_campy$n, method = "GLMM", sm = "PLOGIT", data = postchill_campy, 
                               comb.random = TRUE, studlab = postchill_campy$Citation, byvar = postchill_campy$Production)

res_postchill_sal <- metaprop(postchill_sal$x, postchill_sal$n, method = "GLMM", sm = "PLOGIT", data = postchill_sal, 
                             comb.random = TRUE, studlab = postchill_sal$Citation)

tiff("forest_POSTC.png", units="in", width=7.5, height=6, res=300)
forest(res_postchill_campy, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "2.5mm")
grid.text("5A", .88, .92, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Campylobacter")~ bold(" Postchill"))), .5, .93, gp=gpar(cex=1, fontface=2))
dev.off()

tiff("forest_POSTS.png", units="in", width=7.5, height=5, res=300)
forest(res_postchill_sal, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "1mm")
grid.text("5B", .915, .865, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Salmonella")~ bold(" Postchill"))), .5, .89, gp=gpar(cex=1, fontface=2))
dev.off()

##############
#Retail
##############

retail_campy <- dat[which(dat$Sample=='Retail' & dat$Organism=='Campylobacter'),]
retail_sal <- dat[which(dat$Sample=='Retail' & dat$Organism=='Salmonella'),]

res_ret_campy <- metaprop(retail_campy$x, retail_campy$n, method = "GLMM", sm = "PLOGIT", data = retail_campy, 
                         byvar = retail_campy$Production, comb.random = TRUE, studlab = retail_campy$Citation)

res_ret_sal <- metaprop(retail_sal$x, retail_sal$n, method = "GLMM", sm = "PLOGIT", data = retail_sal, 
                        byvar = retail_sal$Production, comb.random = TRUE, studlab = retail_sal$Citation)


tiff("forest_RETC.png", units="in", width=7.5, height=10.7, res=300)
forest(res_ret_campy, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "2.5mm")
grid.text("6A", .91, .95, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Campylobacter")~ bold(" Retail"))), .5, .96, gp=gpar(cex=1, fontface=2))
dev.off()

tiff("forest_RETS.png", units="in", width=7.5, height=10.7, res=300)
forest(res_ret_sal, xlim = c(0, 1), comb.fixed = F, pooled.totals = T, pooled.events = F, leftlabs = "Study", 
       hetstat = F,  just = "center", xlab = "Prevalence", col.inside = "black", leftcols = "studlab", 
       just.studlab = "right", colgap.forest = "6mm", colgap.forest.right = "1mm")
grid.text("6B", .915, .965, gp=gpar(cex=1.3, fontface=2))
#grid.text(expression(paste(bolditalic("Salmonella")~ bold(" Retail"))), .5, .97, gp=gpar(cex=1, fontface=2))
dev.off()




