# Introduction
This repository contains code to benchmark the performance of machine learning classifiers based on real negotiation data from an international organization and benchmarked against a synthetic dataset.

The impetus for the code was a project trying to model gridlock on the World Trade Organization's Committee on Trade and Development. To a human reader, the negotiations have a clear delineation in factions promoting different views of the committee. Our qualitative interpretation was that one faction promoted policies that would produce transfers to less-developed countries, while the second faction was not interested in additional transfers.

However, we could not capture this using text analysis methods. Several features of data make it very difficult to model:

- The data is taken from a specific context with a narrow substantive issue area. This means that most algorithms that cluster documents based on shared words are less effective.
- Disagreements and contention tend to occur in subtext and via omissions
- We were interested in frames (the interpretation of the mission preferred by different factions) rather than themes (the content being discussed)

This project is addressing two questions:
1. Which machine learning classifiers work best on this type of data?

2. Can we estimate how much of the real data we will need to hand tag in order to get acceptable performance if we want to us an ML algorithem to scale up the rest of the classification.
    
We hand-classified a subset of the paragraphs, and in order to scale up analysis we wanted some benchmark data for how classifiers do in this type of data. These metrics were difficult to find, so we decided to create our own.

## Scripts

[SimDat.R]("SimDat.R")

SimData uses the tokens found from the WTO negotitions data to create synthetic data with a known "frame." 
It uses the WTO data to produce the synthetic data to address the first problem above: the specific and narrow issue area. This replicates the narrow subject matter by directly resusing the tokens found in the WTO data. It produces ground truth frames by assigning certain tokens to the frame and simulating documents with a known proportion of the frame tokens.
This is a relatively simple proof-of-concept implementation where the "frame" words are a random 20\% of the tokens in the data. Each "frame" consistes of half of the sampled tokens. 

[02compareCats.R]("02compareCats.R")

CompareCats.R takes the simulated texts and two helper scripts [compareSlices.R]("compareSlices.R") and [makeROC.R]("makeROC.R"). It evaluates the Receiver Operating Characteristic (ROC) curve for a series of conditions: 
(1) Comparison model performance for frames with the ground truth tagged at 5%, 10%, and 25% of the data
(2) Comparison model performance for simulated texts with low or high frame "separation." 

