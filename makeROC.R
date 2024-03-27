makeROC <- function(modelList, thresh){

    print("make tagged")
    print(paste0("ROC Plot data for: ", length(modelList), " Models"))
    
    ## ROC -- in Tagged Set
    ## Removed hardcoded names for flexibility:
    
<<<<<<< HEAD
    
    first_roc <- modelList[[1]] %>% ## GLM + Ridge
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
    ## Could prob make into an arbitrary loop if wanted...
    ## eg:  for(i in length(modelList){
    ##     assign("roc.", i) <- modelList[[i]] %>%  ## GLM + LASSO
    ##         roc_curve(truth = as.factor(Frame),
    ##                   .pred_A,
    ##                   event_level= "first")}
    
    first_roc <- modelList[[1]] %>%  ## GLM + LASSO
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")
    
    second_roc <- modelList[[2]] %>% ## NB
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
    roc_curve(truth = Frame,
=======
    roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
              .pred_A,
              event_level= "first")
    
    third_roc <- modelList[[3]] %>% ##RF
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
    roc_curve(truth = Frame,
=======
    roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
              .pred_A,
              event_level= "first")
    
    fourth_roc <- modelList[[4]] %>% ##SVM
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
    roc_curve(truth = Frame,
=======
    roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
              .pred_A,
              event_level= "first")
    
    ninth_roc <- modelList[[9]] %>% ## KNN
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
              event_level= "first")    

    print("make predict")
    ## ROC -- in Predict Set
    fifth_pred_roc <- modelList[[5]] %>% ## GLM + LASSO Pred
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")
    
    sixth_pred_roc <- modelList[[6]] %>% ## NB pred
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")

    print("pred six")
    
    seventh_pred_roc <- modelList[[7]] %>% ## RF Pred
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")
    
    eigth_pred_roc <- modelList[[8]] %>% ## SVM Pred
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")

    print("pred 10")
    
    tenth_pred_roc <- modelList[[10]] %>%  ## KNN Pred
<<<<<<< HEAD
      mutate(across(c(Frame), factor)) %>%
        roc_curve(truth = Frame,
=======
        roc_curve(truth = as.factor(Frame),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
                  .pred_A,
                  event_level= "first")

    
    ##  Combine
    roc_all_mods <- rbind(
        cbind(first_roc,
<<<<<<< HEAD
              mod=unique(modelList[[1]]$model),
              group=unique(modelList[[1]]$group),
              level=thresh),
        cbind(second_roc,
              mod=unique(modelList[[2]]$model),
              group=unique(modelList[[2]]$group), level=thresh),
        cbind(third_roc,
              mod=unique(modelList[[3]]$model),
              group=unique(modelList[[3]]$group), level=thresh),
        cbind(fourth_roc,
              mod=unique(modelList[[4]]$model),
              group=unique(modelList[[4]]$group),level=thresh),
        cbind(fifth_pred_roc,
              mod=unique(modelList[[5]]$model),
              group=unique(modelList[[5]]$group), level=thresh),
        cbind(sixth_pred_roc,
              mod=unique(modelList[[6]]$model),
              group=unique(modelList[[6]]$group),
              level=thresh),
        cbind(seventh_pred_roc,
              mod=unique(modelList[[7]]$model),
              group=unique(modelList[[7]]$group),
              level=thresh),
        cbind(eigth_pred_roc,
              mod=unique(modelList[[8]]$model),
               group=unique(modelList[[8]]$group),level=thresh),
        cbind(ninth_roc,
              mod=unique(modelList[[9]]$model),
              group=unique(modelList[[9]]$group),
              level=thresh),
        cbind(tenth_pred_roc,
              mod=unique(modelList[[10]]$model),
=======
              mod=unique(modelList[[1]]$mod),
              group=unique(modelList[[1]]$group),
              level=thresh),
        cbind(second_roc,
              mod=unique(modelList[[2]]$mod),
              group=unique(modelList[[2]]$group), level=thresh),
        cbind(third_roc,
              mod=unique(modelList[[3]]$mod),
              group=unique(modelList[[3]]$group), level=thresh),
        cbind(fourth_roc,
              mod=unique(modelList[[4]]$mod),
              group=unique(modelList[[4]]$group),level=thresh),
        cbind(fifth_pred_roc,
              mod=unique(modelList[[5]]$mod),
              group=unique(modelList[[5]]$group), level=thresh),
        cbind(sixth_pred_roc,
              mod=unique(modelList[[6]]$mod),
              group=unique(modelList[[6]]$group),
              level=thresh),
        cbind(seventh_pred_roc,
              mod=unique(modelList[[7]]$mod),
              group=unique(modelList[[7]]$group),
              level=thresh),
        cbind(eigth_pred_roc,
              mod=unique(modelList[[8]]$mod),
               group=unique(modelList[[8]]$group),level=thresh),
        cbind(ninth_roc,
              mod=unique(modelList[[9]]$mod),
              group=unique(modelList[[9]]$group),
              level=thresh),
        cbind(tenth_pred_roc,
              mod=unique(modelList[[10]]$mod),
>>>>>>> 2f0def503d62fdbf178a5ce52499964fd2a7c575
              group=unique(modelList[[10]]$group),
              level=thresh))

    ## Send out
    return(roc_all_mods)
}
