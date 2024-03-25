## Use each model to estimate a DF with the tags
## at the end, compare the regression model
## for each version 
rm(list=ls())

loadPkg=function(toLoad){
    for(lib in toLoad){
        if(! lib %in% installed.packages()[,1])
            { install.packages(lib, repos='http://cran.rstudio.com/') }
        suppressMessages( library(lib, character.only=TRUE) ) }}


packs <- c('tidyr',
           'quanteda',
           'dplyr',
           'tidyverse',
           "readxl",
           'textrecipes',
           'rsample',
           "discrim")

engines <-  c('glmnet',
              "tidymodels",
              "naivebayes",
              "kernlab",
              "ranger",
              'kknn')

loadPkg(c(packs, engines))

#############################
## Load simulated data with ground truth
#############################

load("simulatedTextData.Rdata")
## Training -test split

## TO HERE: Figure out thresholds for split
## Split at:
## 1%, 5%, 10%, 25% of data; then within that
## make training/test

## Load compareSlices()
## takes: simulated data,
## slice percent
## and a random seed
## returns 8-entry list comparing:
## (1) performance in the "tagged" slice
## (2) "unsupervised" tags in the rest of the data

source("compareSlices.R")
source("makeROC.R")

## 5% tagged

sim_05 <- compareSlices(data= sims,
                       slicepercent=.05,
                       seed=2822)

roc_05 <- makeROC(modelList=sim_05,
                     thresh=5)

## 10% "tagged"
sim_1 <- compareSlices(data= sims,
                       slicepercent=.1,
                       seed=2822)

roc_1 <- makeROC(modelList=sim_1,
                     thresh=10)

## 25% tagged
sim_25 <- compareSlices(data= sims,
                       slicepercent=.25,
                       seed=2822)

roc_25 <- makeROC(modelList=sim_25,
                     thresh=25)

## ROC for taged:

head(roc_25)


gg <- ggplot(rbind(roc_05,
                   roc_1,
                   roc_25),
             aes(x = 1 - specificity,
                 y = sensitivity,
                 color=mod)) +
    geom_path() +
    geom_abline(lty = 3) +
    coord_equal() +
    theme_bw()+
    facet_wrap(group~ level)

gg

ggsave(gg,
       file="pooledGammaClassificationComparison.pdf") 

### Low vs high Gamma condition
## 05:
sim_05_highG <- list()
sim_05_lowG <- list()
for(i in 1:length(sim_05)){
    sim_05_highG[[i]] <- sim_05[[i]][which(
        sim_05[[i]]$gamma %in% c(0, 1)),]
    sim_05_lowG[[i]] <- sim_05[[i]][which(
            sim_05[[i]]$gamma %in% c(.25, .75)),] 
}

## 10
sim_10_highG <- list()
sim_10_lowG <- list()
for(i in 1:length(sim_1)){
    sim_10_highG[[i]] <- sim_1[[i]][which(
        sim_1[[i]]$gamma %in% c(0, 1)),]
    sim_10_lowG[[i]] <- sim_1[[i]][which(
            sim_1[[i]]$gamma %in% c(.25, .75)),] 
}

##25
sim_25_highG <- list()
sim_25_lowG <- list()
for(i in 1:length(sim_25)){
    sim_25_highG[[i]] <- sim_25[[i]][which(
        sim_25[[i]]$gamma %in% c(0, 1)),]
    sim_25_lowG[[i]] <- sim_25[[i]][which(
            sim_25[[i]]$gamma %in% c(.25, .75)),] 
}

## ROC Low

sim_05_lowG_roc <-makeROC(modelList=sim_05_lowG,
                          thresh=05)

sim_10_lowG_roc <-makeROC(modelList=sim_10_lowG,
                          thresh=10)

sim_25_lowG_roc <-makeROC(modelList=sim_25_lowG,
                          thresh=25)

sim_05_highG_roc <-makeROC(modelList=sim_05_highG,
                          thresh=05)

sim_10_highG_roc <-makeROC(modelList=sim_10_highG,
                          thresh=10)

sim_25_highG_roc <-makeROC(modelList=sim_25_highG,
                          thresh=25)


ggdat2 <- rbind(
    cbind(sim_05_highG_roc, cat="high frame separation"),
        cbind(sim_10_highG_roc, cat="high frame separation"),
    cbind(sim_25_highG_roc, cat="high frame separation"),
    cbind(sim_05_lowG_roc, cat="low frame separation"),
    cbind(sim_10_lowG_roc, cat="low frame separation"),
    cbind(sim_25_lowG_roc, cat="low frame separation"))

gg2 <- ggplot(ggdat2,
             aes(x = 1 - specificity,
                 y = sensitivity,
                 color=mod,
                 linetype=cat)) +
    geom_path() +
    geom_abline(lty = 3) +
    coord_equal() +
    theme_bw()+
    facet_wrap(group~ level)

gg2

ggsave(gg2,
       file="modelComparisonSeparatedGammas.pdf")
