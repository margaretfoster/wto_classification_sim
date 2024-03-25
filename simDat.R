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

groundhog.library(packs, 
                  groundhog_day, tolerate.R.version='4.3.3')

##engines <-  c('glmnet',
##              "tidymodels",
##              "naivebayes",
##              "kernlab",
##              "ranger")


#############################
##Use the WTO data to generate a bank of word tokens:
#############################
setwd("~/Dropbox/WTO_Classification_Sim/")

load("./data/processedTextforSTM.Rdata")

ls()

## Remove stopwords and anything with fewer than 5 occurances
tokens <- tibble(text =  out$meta$cleanedtext)  %>%
  unnest_tokens(word, text) %>%
    count(word,sort = TRUE)  %>%
    filter(!word %in% stop_words$word) %>% ## remove stopwords
    filter(n>=5) ## clean up ~500 one-off tokens

class(tokens)
dim(tokens) #1451576 words; 14809 unique; 14206 after removing stopwords, 9927 tokens used more than once;
## 5,748 used at least 5 times. 8853 documents

## Synthetic frame data

seed <- 2722
set.seed(seed)
## Size of the keyword lists: 10% each

L <- 0.2 ## Total percent to dedicate to frame keywords

## Sample frames from the list of token, then split into two
frames <- sample_frac(tokens, L, replace=FALSE) ## 1150

## Frame A is a random sample of half of the tokens
## Frame "B" is the list of words that are in the frames
## but not sampled into Frame A
frame_A <- sample_frac(frames, .5, replace=FALSE) ## 575

frame_B <- frames %>%
    filter(!word %in% frame_A$word) ##575

## Non-frame words:
content <- tokens %>%
    filter(!word %in% frames$word)

## confirm separate:
length(intersect(frames$word, content$word)) ## 0

##%%%%%%%%%%%%%%%%
## Generate "texts" that are bags of words:
##%%%%%%%%%%%%%%%%

num_texts <- 10^4
length_low <- 100
length_high <- 300

## make vector of alphas
## and a vector of gammas:
alphas <- round(runif(n=num_texts,
                      min=0,
                      max=1), 1)

## vector of gammas:
## start simple: 0, .25, .75,1 )
## AKA: easy, hard, hard, easy
gammas <- round(sample(size=num_texts,
                       x=c(0, .25, .75, 1),
                       replace=TRUE) ,2)

tmp <- NULL
## Make texts:
for(n in 1:num_texts){
    ## each "text" is made up of:
    ## length:
    text_length <- runif(1, min=length_low,
                         max=length_high)
    
    ## Percent of text dedicated to frame (alpha)
    ## from list above
    alph <- alphas[n] ## note this will vary from.. .1-.9(?)
     
    text_content <- sample(x= content$word,
                           size=text_length*(1-alph),
                           replace=TRUE)
    
    ## Within-text frame separation (gamma)
    ## gamma > .5 = frame A dominant
    ## gamma <.5 = frame B dominant
    ## Closer to 1 or 0 means more frame B words to find
    length_of_frame <- floor(text_length*alph)
    
    gamma <- gammas[n] ## frame-dominance
    
    frame_content_A <-sample(x=frame_A$word,
                             size=floor(
                                 length_of_frame*
                                 alph*gamma), 
                             replace=TRUE)
    
    frame_content_B <-sample(x=frame_B$word,
                             size=floor(
                                 length_of_frame*alph*
                                 (1-gamma)),
                             replace=TRUE)
    
    ## put words together, shuffle order:
    sim_BOW <- paste0(sample(c(text_content,
                               frame_content_A,
                               frame_content_B)),
                      collapse=" ",
                      sep= " ")
    
    tmp <- c(tmp, sim_BOW)
}

sims <- as.data.frame(cbind(texts=tmp,
              alpha=alphas,
              gamma=gammas))


head(sims)

dim(sims)
class(sims)

## Indicator Variables

sims$Frame <- NA
sims$frameA <- 0
sims$frameB <- 0
sims[which(sims$alpha >=.5), "Frame"] <- "A"
sims[which(sims$alpha < .5), "Frame"] <- "B"
sims[which(sims$alpha >=.5), "frameA"] <- 1
sims[which(sims$alpha <.5), "frameB"] <- 1

table(sims$domFrame) ## 5438; 4562
table(sims$frameA)

sims$id <- rownames(sims)

save(sims,
     file="simulatedTextData.Rdata")
