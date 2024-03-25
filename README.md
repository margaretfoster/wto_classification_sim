# Introduction
This repository contains code to benchmark the performance of machine learning classifiers based on real negotiation data from an international organization and benchmarked against a synthetic dataset.

The impetus for the code was a project trying to model gridlock on the World Trade Organization's Committee on Trade and Development. To a human reader, the negotiations have a clear delineation in factions promoting different views of the committee. Our qualitative interpretation was that one faction promoted policies that would produce transfers to less-developed countries, while the second faction was not interested in additional transfers. 

However, we could not capture this using text analysis methods. Several features of data make it very difficult to model:

- The data is taken from a specific context with a narrow substantive issue area. This means that most algorithms that cluster documents based on shared words are less effective.
- Disagreements and contention tend to occur in subtext and via omissions
- The actual sea
- We were interested in frames (the interpretation of the mission preferred by different factions) rather than themes (the content being discussed)

We hand-classified a subset of the paragraphs, and in order to scale up analysis we wanted some benchmark data for how classifiers do in this type of data. These metrics were difficult to find, so we decided to create our own.

The repository consists of scripts to generate synthetic data along with "frame" ground truth, scripts using ML models to classify the synethetic data, and scripts to visualize the results.

## Scripts

[SimDat.R]("SimDat.R")

SimData uses the tokens found from the WTO negotitions data to create synthetic data with a known "frame." 
It uses the WTO data to produce the synthetic data to address the first problem above: the specific and narrow issue area. This replicates the narrow subject matter by directly resusing the tokens found in the WTO data. It produces ground truth frames by assigning certain tokens to the frame and simulating documents with a known proportion of the frame tokens.
