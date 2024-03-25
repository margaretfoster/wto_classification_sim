# Introduction
This repository contains code to benchmark the performance of machine learning classifiers based on real negotiation data from an international organization and benchmarked against a synthetic dataset.

The impetus for the code was a project trying to model gridlock on the World Trade Organization's Committee on Trade and Development. To a human reader, the negotiations have a clear delineation in factions promoting different views of the committee. Our qualitative interpretation was that one faction promoted policies that would produce transfers to less-developed countries, while the second faction was not interested in additional transfers. 

However, we could not capture this using text analysis methods. Several features of data make it very difficult to model:

- Topic and frames overlap because the substantive issue area is narrow
- Disagreements and contention tend to occur in subtext and via omissions
- We were interested in frames (the interpretation of the mission preferred by different factions) rather than themes (the content being discussed)

