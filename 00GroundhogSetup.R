rm(list=ls())

loadPkg=function(toLoad){
  for(lib in toLoad){
    if(! lib %in% installed.packages()[,1])
    { install.packages(lib, repos='http://cran.rstudio.com/') }
    suppressMessages( library(lib, character.only=TRUE) ) }}

library(groundhog)

groundhog_day <- "2024-02-09"

packs <- c('tidyr',
           'quanteda',
           'dplyr',
           'tidyverse',
           'tidytext',
           'textrecipes',
           'rsample',
           "discrim")

engines <-  c('glmnet',
              "tidymodels",
              "naivebayes",
              "kernlab",
              "ranger",
              'kknn')

groundhog.library(c(packs, engines), 
                  groundhog_day, tolerate.R.version='4.3.3')