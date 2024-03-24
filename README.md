# Introduction
This repository contains code to benchmark the performance of machine learning classifiers on real and simulated negotaition data in international relations

The impetus for the code was a project trying to model gridlock on the World Trade Organization's Committee on Trade and Development. To a human reader, the negotiations have a clear deliniation in factions promoting different views of the committee. Our read was that one faction promoted policies that would produce transfers to less-developed countries while the second faction was not interested in additional transfers. 

However, we could not capture this with then-existig text analysis methods. Several facets of the data make it very difficult to model:
- The topic issue area is very narrow (trade, development, capacity-building), so topic and frames overlap
- Disgreements and contention tends occur in subtext and via omissions 

