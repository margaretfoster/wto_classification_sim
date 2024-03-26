# Introduction
This repository contains code to benchmark the performance of machine learning classifiers based on real negotiation data from an international organization and benchmarked against a synthetic dataset.

![First Pass of Performance](./modelComparisonSeparatedGammas.pdf?raw=true "Initial Classification Performance")

The impetus for the code was a project trying to model gridlock on the World Trade Organization's Committee on Trade and Development. To a human reader, the negotiations have a clear delineation in factions promoting different views of the committee. Our qualitative interpretation was that one faction promoted policies that would produce transfers to less-developed countries, while the second faction was not interested in additional transfers.

However, we could not capture this using text analysis methods. Several features of data make it very difficult to model:

- The data is taken from a specific context with a narrow substantive issue area. This means that most algorithms that cluster documents based on shared words are less effective.
- Disagreements and contention tend to occur in subtext and via omissions.
- The texts are short, often on the order of a few hundred words.
- We were interested in frames (the interpretation of the mission preferred by different factions) rather than themes (the content being discussed).

This project is addressing two questions:
1. Which machine learning classifiers work best on this type of data?

2. Can we estimate how much of the real data we will need to hand tag in order to get acceptable performance if we want to use an ML algorithm to scale up the rest of the classification?
  
I hand-classified a subset of the paragraphs in the original text, which was laborious but produced a lot of insights into the ways that the frames were deployed. However, to scale up the analysis, we wanted some benchmark data for how classifiers perform in this type of data. These metrics were difficult to find, so I created my own.

The code in this repository provides a relatively simple proof-of-concept implementation with a lot of opportunity for customization. 

I start by creating "frame" words from a random 20\% of the tokens in the real negotiation data. I then divided the "frame" words into two sets, labeled "Frame A" and "Frame B." 

From there, I simulate the corpus:
The simulated texts have hyperparameters *length*, *alpha*, and *gamma*:

**Length** is a random uniform draw ranging from \[100, 300\] tokens, a length set to be roughly equivalent to the length of texts in the inspiration data. The length is easily customizable by setting the code.

**Alpha** sets the percentage of the text dedicated to frame words. A text with an *alpha* value of .25 would be comprised of one-quarter of it's length as draws from the "frame" words and three-quarters of random draws from non-frame words.

**Gamma** sets the text-level frame separation. Gamma is a weight on the Frame A words. It is sampled from the vector (0.01, 0.2, 0.4, 0.6, 0.8, 0.99), representing two easy (0.01, 0.99), two medium (0.2, 0.8), and two difficult classification (0.4, 0.6) tasks. A *gamma* value closer to 0 means that the "frame" content is exclusively drawn from Frame B words. Conversely, a *gamma* value closer to 1 means that the frame content is exclusively Frame A words. Likewise, a *gamma* value of around 0.5 indicates about equal occurance of the two frames.

Alpha and gamma are independent. Thus, for example, a 200-word long text where *alpha* = .1 and *gamma* = .5 would produce a text with 180 neutral words, 10 Frame A words, and 10 Frame B words.

## Code and Simulation

[SimDat.R](./SimDat.R)

SimData uses the tokens found from the WTO negotiations data to create synthetic data with a known "frame." 

It uses the WTO data to produce the synthetic data to address the first problem above: the specific and narrow issue area. This replicates the narrow subject matter by directly reusing the tokens from the WTO data. It produces ground truth frames by assigning particular tokens to the frame and simulating documents with a known proportion of the frame tokens.

[02compareCats.R](./02compareCats.R)

CompareCats.R takes the simulated texts and two helper scripts [compareSlices.R]("compareSlices.R") and [makeROC.R]("makeROC.R"). It evaluates the Receiver Operating Characteristic (ROC) curve for a series of conditions: 

(1) Comparison model performance for frames with the ground truth tagged at 5%, 10%, and 25% of the data
(2) Comparison model performance for simulated texts with low or high frame separation (*gamma*). 

[compareSlices.R](./compareSlices.R)

CompareSlices.R estimates the classifications. It uses a 70%-30% training/test split, with off-the-shelf implementation for each model.

The default models (via [Tidymodels](https://www.tidymodels.org/)) are:

- [Ridge Regression](https://parsnip.tidymodels.org/reference/details_logistic_reg_glmnet.html) via GLM
- [KNN](https://parsnip.tidymodels.org/reference/details_nearest_neighbor_kknn.html), with K = 10
- [Naive Bayes](https://parsnip.tidymodels.org/reference/naive_Bayes.html)
- [Random Forest](https://parsnip.tidymodels.org/reference/rand_forest.html), with the ranger implementation
- [Support Vector Machines](https://parsnip.tidymodels.org/reference/details_svm_linear_kernlab.html)
