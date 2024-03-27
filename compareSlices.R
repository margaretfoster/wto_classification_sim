compareSlices <- function(data, slicepercent, seed){

    set.seed(seed)
    
    ## Split data into "tagged" and "untagged"
    ## to simulate having a corpus with a subset tagged
    nRs <- dim(sims)[1]*slicepercent
    
    rs <- sample(x=sims$id,
                 size=nRs,
                 replace=FALSE)
    
    tagged <- sims[sims$id %in% rs,]
    unsupervised <-sims[!(sims$id %in% rs), ]

    print(colnames(tagged))
    
    ## Training-Test in "Tagged" Slice
    ## Consistently 70/30
    tagged_split <- initial_split(data = tagged,
                                  strata = Frame,
                                  prop = .7)
    
    tagged_train <- training(tagged_split)
    tagged_test <- testing(tagged_split)
    
    ##%%%%%%%%%%%%%%%%%%%%%%%
    ## Prep global settings for models
    ##%%%%%%%%%%%%%%%%%%%%%%%
    ## ID the columns for analysis + ID
    
    sim_rec <- recipe(Frame ~ texts + id,
                      data = tagged_train) %>% 
                          update_role(id,
                                      new_role = "ID") 

    ## Clean and convert to dtm
    sim_rec <- sim_rec %>%
        step_tokenize(texts) %>%
            step_stopwords(texts) %>%
                step_tokenfilter(texts) %>%
                    step_tfidf(texts)

    ##%%%%%%%%%%%%%%%%%%
    ## Naive Bayes
    ##%%%%%%%%%%%%%%%%%
    set.seed(seed)
    nb_spec <- naive_Bayes() %>%
        set_mode("classification") %>%
            set_engine("naivebayes")
    
    nb_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(nb_spec)
    
    nb_fit <- nb_workflow %>%
        fit(data = tagged_train)

    print("start NB")
    
    ## Predict on Tagged Subset:
    nb.pred <- predict(nb_fit, tagged_test)
    tagged_nb_aug <- augment(nb_fit, tagged_test)
    tagged_nb_aug$Frame <- as.factor(tagged_nb_aug$Frame)
<<<<<<< HEAD
    tagged_nb_aug$model <- "NB"
=======
    tagged_nb_aug$mod <- "NB"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    tagged_nb_aug$group <- "tagged"
    
    ## Scale to "untagged" part:
    nb_pred_all <- predict(nb_fit, unsupervised)
    sim_nb_aug <- augment(nb_fit, unsupervised)
<<<<<<< HEAD
    sim_nb_aug$model <- "NB"
=======
    sim_nb_aug$mod <- "NB"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    sim_nb_aug$group <- "predict"

    ##%%%%%%%%%%%%%%%%%%
    ## Random Forest
    ##%%%%%%%%%%%%%%%%%%
    print("start RF")
    
    ## Structure:
    set.seed(seed)
    rf_spec <- rand_forest() %>%
        set_mode("classification") %>%
            set_engine("ranger")
    
    rf_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(rf_spec)
    
    ## train:
    rf_fit <- rf_workflow %>%
        fit(data = tagged_train)
    
    ## Predict on Tagged Subset:
    rf_pred <- predict(rf_fit, tagged_test)
    tagged_rf_aug <- augment(rf_fit, tagged_test)
    tagged_rf_aug$Frame <- as.factor(tagged_rf_aug$Frame)
<<<<<<< HEAD
    tagged_rf_aug$model <- "RF"
=======
    tagged_rf_aug$mod <- "RF"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    tagged_rf_aug$group <- "tagged"    

    ## Scale to untaged
    rf_pred.all <- predict(rf_fit, unsupervised)
    sim_rf_aug <- augment(rf_fit, unsupervised)
<<<<<<< HEAD
    sim_rf_aug$model <- "RF"
=======
    sim_rf_aug$mod <- "RF"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    sim_rf_aug$group <- "predict"

    ##%%%%%%%%%%%%%%%%%%
    ## SVM
    ##%%%%%%%%%%%%%%%%%%
    print("Start SVM")
    
    ## structure:
    set.seed(seed)
    svm_spec <- svm_poly() %>%
        set_mode("classification") %>%
            set_engine("kernlab")
    
    svm_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(svm_spec)
    
    svm_fit <- svm_workflow %>%
        fit(data = tagged_train)
    
    ## Predict on Tagged Subset:
    svm_pred <- predict(svm_fit, tagged_test)
    tagged_svm_aug <- augment(svm_fit, tagged_test)
<<<<<<< HEAD
    tagged_svm_aug$Frame <- as.factor(tagged_svm_aug$Frame)
    tagged_svm_aug$model <- "SVM"
=======
    tagged_svm_aug$Frame <- as.factor(tagged.svm.aug$Frame)
    tagged_svm_aug$mod <- "SVM"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    tagged_svm_aug$group <- "tagged"

    ## Scale:
    svm_pred.all <- predict(svm_fit, unsupervised)
    sim_svm_aug <- augment(svm_fit, unsupervised)
<<<<<<< HEAD
    sim_svm_aug$model <- "SVM"
=======
    sim_svm_aug$mod <- "SVM"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    sim_svm_aug$group <- "predict"

    ##%%%%%%%%%%%%%%%%%%
    ## Ridge Regression (Logistic with penalty)
    ##%%%%%%%%%%%%%%%%%%
    ## penalty: mixture =1 is LASSO
    ## mixture =0 is ridge

    print("start GLM")
    
    glm_spec <- multinom_reg(mixture=double(1),
                             mode="classification",
                             engine= "glmnet",
                             penalty=0)
    
    glm_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(glm_spec)
    
    glm_fit <- glm_workflow %>%
        fit(data = tagged_train)
    
    ## Predict on Tagged Subset:
    glm_pred <- predict(glm_fit, tagged_test)
    tagged_glm_aug <- augment(glm_fit, tagged_test)    
<<<<<<< HEAD
    tagged_glm_aug$Frame <- as.factor(tagged_glm_aug$Frame)
    tagged_glm_aug$model <- "Ridge"
=======
    tagged_glm_aug$Frame <- as.factor(tagged.glm.aug$Frame)
    tagged_glm_aug$mod <- "Ridge"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    tagged_glm_aug$group <- "tagged"

    ## Scale to unsupervised portion
    ## GLM + LASSO
    glm_pred.all <- predict(glm_fit, unsupervised)
    sim_glm_aug <- augment(glm_fit, unsupervised)
<<<<<<< HEAD
    sim_glm_aug$model <- "Ridge"
=======
    sim_glm_aug$mod <- "Ridge"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    sim_glm_aug$group <- "predict"
    ##%%%%%%%%%%%%%%%%%%
    ## K Nearest Neighbors
    ##%%%%%%%%%%%%%%%%%%

    print("start KNN")
    
    knn_spec <- nearest_neighbor(
        mode = "classification",
        engine = "kknn",
        neighbors = 10,
        )

    knn_workflow <- workflow() %>%
        add_recipe(sim_rec) %>%
            add_model(knn_spec)
    
    knn_fit <- knn_workflow %>%
        fit(data = tagged_train)
    
    ## Predict on Tagged Subset:
    knn.pred <- predict(knn_fit, tagged_test)
    tagged_knn_aug <- augment(knn_fit, tagged_test)    
    tagged_knn_aug$Frame <- as.factor(tagged_knn_aug$Frame)
<<<<<<< HEAD
    tagged_knn_aug$model <- "KNN"
=======
    tagged_knn_aug$mod <- "KNN"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    tagged_knn_aug$group <- "tagged"

    ## Scale to unsupervised portion
    ## KNN
    knn_pred_all <- predict(knn_fit, unsupervised)
    sim_knn_aug <- augment(knn_fit, unsupervised)
<<<<<<< HEAD
    sim_knn_aug$model <- "KNN"
=======
    sim_knn_aug$mod <- "KNN"
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
    sim_knn_aug$group <- "predict"
    
    ##%%%%%%%%%%%%%%%%%%%%%%%%%
    ## Send data out
    ##%%%%%%%%%%%%%%%%%%%%%%%%
    
    ## Assemble data:
    return(outlist=list(
               perfSubsetGLM= tagged_glm_aug,
               perfSubsetNB= tagged_nb_aug,
               perfSubsetRF= tagged_rf_aug,
               perfSubsetSVM= tagged_svm_aug,
               predictedGLM = sim_glm_aug,
               predictedNB = sim_nb_aug,
               predictedRF = sim_rf_aug,
               predictedSVM = sim_svm_aug,
               predictedKNN = tagged_knn_aug,
               predictedKNN = sim_knn_aug))
}
