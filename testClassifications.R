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
              "ranger")

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

colnames(sims)

compareSlices <- function(slicedDat){
    
    set.seed(2322) 
    tagged_split <- initial_split(data = slicedDat,
                                  strata = Frame,
                                  prop = .7)
    
    tagged_train <- training(tagged_split)
    tagged_test <- testing(tagged_split)
    
    ##%%%%%%%%%%%%%%%%%%%%%%%
### Prep global settings for models
    ##%%%%%%%%%%%%%%%%%%%%%%%
    ## ID the columns for analysis + ID
    
    sim_rec <- recipe(Frame ~ texts
                      data = tagged_train) %>% 
                          update_role(id,
                                      new_role = "ID") 
    
    ## Clean and convert to dtm
    sim_rec <- sim_rec %>%
        step_tokenize(cleanedtext) %>%
            step_stopwords(cleanedtext) %>%
                step_tokenfilter(cleanedtext) %>%
                    step_tfidf(cleanedtext)
    
    
    ##%%%%%%%%%%%%%%%%%%
    ## Naive Bayes
    ##%%%%%%%%%%%%%%%%%
    
    set.seed(2322)
    nb_spec <- naive_Bayes() %>%
        set_mode("classification") %>%
            set_engine("naivebayes")
    
    nb_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(nb_spec)
    
    nb_fit <- nb_workflow %>%
        fit(data = tagged_train)
    
    nb_pred <- predict(nb_fit, tagged_test)
    
    sim_nb_aug <- augment(nb_fit, tagged_test)
    sim_nb_aug$Frame <- as.factor(sim_nb_aug$Frame)
    
    ##%%%%%%%%%%%%%%%%%%
    ## Random Forest
    ##%%%%%%%%%%%%%%%%%%
    
    ## Structure:
    set.seed(2322)
    
    rf_spec <- rand_forest() %>%
        set_mode("classification") %>%
            set_engine("ranger")
    
    rf_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(rf_spec)
    
    ## train:
    rf_fit <- rf_workflow %>%
        fit(data = tagged_train)
    
    ## predict:
    
    rf_pred <- predict(rf_fit, tagged_test)
    
    ## Map into df 
    sim_rf_aug <- augment(rf_fit, tagged_test)
    sim_rf_aug$Frame <- as.factor(sim_rf_aug$Frame)
    
    ##%%%%%%%%%%%%%%%%%%
    ## SVM
    ##%%%%%%%%%%%%%%%%%%
    
    ## structure:
    set.seed(2322)
    
    svm_spec <- svm_poly() %>%
        set_mode("classification") %>%
            set_engine("kernlab")
    
    svm_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(svm_spec)
    
    svm_fit <- svm_workflow %>%
        fit(data = tagged_train)
    
    ## predict:
    
    svm_pred <- predict(svm_fit, tagged_test)
    
    sim_svm_aug <- augment(svm_fit, tagged_test)
    
    sim_svm_aug$Frame <- as.factor(sim_svm_aug$Frame)
    
    ##%%%%%%%%%%%%%%%%%%
    ## Logistic Reg with LASSO
    ##%%%%%%%%%%%%%%%%%%
    
    ## structure:
    set.seed(2322)
    
    ## penalty: mixture =1 is LASSO
    ## mixture =0 is ridge
    glm_spec <- multinom_reg(mixture=double(1),
                             mode="classification",
                             engine= "glmnet",
                             penalty=0)
    
    glm_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(glm_spec)
    
    glm_fit <- glm_workflow %>%
        fit(data = tagged_train)
    
    ## predict:
    glm_pred <- predict(glm_fit, tagged_test)
    
    sim_glm_aug <- augment(glm_fit, tagged_test)
    
    sim_glm_aug$Frame <- as.factor(sim_glm_aug$Frame)

}
##%%%%%%%%%%%%%%%%%%%%
## Scale Predictions
##%%%%%%%%%%%%%%%%%%%
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

## Scale prediction from RF Model:
## Whole data:

## RF
rf_pred_all <- predict(rf_fit, untagged)
sim_rf_aug <- augment(rf_fit, untagged)

dim(sim_rf_aug) ## 8614 x 20

## GLM (glm_fit)
glm_pred_all <- predict(glm_fit, untagged)
sim_glm_aug <- augment(glm_fit, untagged)

## NB
nb_pred_all <- predict(nb_fit, untagged)
sim_nb_aug <- augment(nb_fit, untagged)

## SVM
svm_pred_all <- predict(svm_fit, untagged)
sim_svm_aug <- augment(svm_fit, untagged)

## By delegations -> sim.hand above
save(sim_glm_aug,
     sim_nb_aug,
     sim_rf_aug,
     sim_svm_aug,
     sim.hand,
     file="predicted-models.Rdata")
