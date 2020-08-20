# Backtesting Stocks and Indices

An algorithm for backtesting (via bootstrapping) stocks or indices, including weighting, and comparisons


Input variables are:

`data` - Historical data for NASDAQ100 and S&P500 are included but any reasonably large data set of daily performance can be used.<br>
start - Start of overall time interval to consider in analysis
end - End of overall time interval to consider in analysis
length - Length of the subsamples (time of investment)
leverage - Strength of the lever. 1x is always calculated as a comparison
iterations - Number of subsamples to be drawn. For reliable results i >= 1000 should be chosen

