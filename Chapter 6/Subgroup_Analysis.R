library(metafor)
library(readxl)
library(meta)
library(grid)

setwd("~/Documents/College/Mishra Lab/Meta-analysis")

dat <- read_excel('Compiled Results_subgroup.xlsx')

##############
#Environmental
##############

environ_campy_sub <- dat[which(dat$Sample=='Environmental' & dat$Organism=='Campylobacter'),]
environ_sal_sub <- dat[which(dat$Sample=='Environmental' & dat$Organism=='Salmonella'),]

res_environ_campy_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = environ_campy_sub)
res_environ_campy_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = environ_campy_sub, mods = ~ factor(Production) + factor(SampleMethod) + Year)
((res_environ_campy_sub$tau2 - res_environ_campy_sub_mods$tau2)/res_environ_campy_sub$tau2) * 100

res_environ_sal_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = environ_sal_sub)
res_environ_sal_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = environ_sal_sub, mods = ~ factor(Production) +  Year)
((res_environ_sal_sub$tau2 - res_environ_sal_sub_mods$tau2)/res_environ_sal_sub$tau2) * 100

##############
#Rehang
##############

rehang_campy_sub <- dat[which(dat$Sample=='Rehang' & dat$Organism=='Campylobacter'),]
rehang_sal_sub <- dat[which(dat$Sample=='Rehang' & dat$Organism=='Salmonella'),]

res_rehang_campy_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = rehang_campy_sub)
res_rehang_campy_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = rehang_campy_sub, mods = ~ factor(SampleMethod) + Year)
((res_rehang_campy_sub$tau2 - res_rehang_campy_sub_mods$tau2)/res_rehang_campy_sub$tau2) * 100

res_rehang_sal_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = rehang_sal_sub)
res_rehang_sal_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = rehang_sal_sub, mods = ~ factor(SampleMethod) +  Year)
((res_rehang_sal_sub$tau2 - res_rehang_sal_sub_mods$tau2)/res_rehang_sal_sub$tau2) * 100


################
#Prechill
################

prechill_campy_sub <- dat[which(dat$Sample=='Prechill' & dat$Organism=='Campylobacter'),]
prechill_sal_sub <- dat[which(dat$Sample=='Prechill' & dat$Organism=='Salmonella'),]

res_prechill_campy_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = prechill_campy_sub)
#res_prechill_campy_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = prechill_campy_sub, mods = ~ Year)
#((res_prechill_campy_sub$tau2 - res_prechill_campy_sub_mods$tau2)/res_prechill_campy_sub$tau2) * 100

res_prechill_sal_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = prechill_sal_sub)
res_prechill_sal_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = prechill_sal_sub, mods = ~ factor(SampleMethod) +  Year)
((res_prechill_sal_sub$tau2 - res_prechill_sal_sub_mods$tau2)/res_prechill_sal_sub$tau2) * 100

##################
#Postchill
##################

postchill_campy_sub <- dat[which(dat$Sample=='Postchill' & dat$Organism=='Campylobacter'),]
postchill_sal_sub <- dat[which(dat$Sample=='Postchill' & dat$Organism=='Salmonella'),]

res_postchill_campy_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = postchill_campy_sub)
res_postchill_campy_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = postchill_campy_sub, mods = ~ factor(SampleMethod) + factor(Production) + Year)
((res_postchill_campy_sub$tau2 - res_postchill_campy_sub_mods$tau2)/res_postchill_campy_sub$tau2) * 100

res_postchill_sal_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = postchill_sal_sub)
res_postchill_sal_sub_mods <- rma.glmm(measure = "PLO", xi = x, ni = n, data = postchill_sal_sub, mods = ~ factor(SampleMethod) + Year)
((res_postchill_sal_sub$tau2 - res_postchill_sal_sub_mods$tau2)/res_postchill_sal_sub$tau2) * 100

##############
#Retail
##############

retail_campy_sub <- dat[which(dat$Sample=='Retail' & dat$Organism=='Campylobacter'),]
retail_sal_sub <- dat[which(dat$Sample=='Retail' & dat$Organism=='Salmonella'),]

res_retail_campy_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = retail_campy_sub)
res_retail_campy_sub_mods <- rma.glmm(btt=c(5,9), measure = "PLO", xi = x, ni = n, data = retail_campy_sub, mods = ~ factor(SampleMethod) + factor(Production) + factor(SampleType)+ Year)
((res_retail_campy_sub$tau2 - res_retail_campy_sub_mods$tau2)/res_retail_campy_sub$tau2) * 100

res_retail_sal_sub <- rma.glmm(measure = "PLO", xi = x, ni = n, data = retail_sal_sub)
res_retail_sal_sub_mods <- rma.glmm(btt = c(5,9),measure = "PLO", xi = x, ni = n, data = retail_sal_sub, mods = ~ factor(SampleMethod) + factor(Production) + factor(SampleType)+ Year)
((res_retail_sal_sub$tau2 - res_retail_sal_sub_mods$tau2)/res_retail_sal_sub$tau2) * 100



