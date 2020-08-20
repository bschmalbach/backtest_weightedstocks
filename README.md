# Backtesting Stocks and Indices

An algorithm for backtesting (via bootstrapping) stocks or indices, including weighting, and comparisons


Input variables are:

`data` - Historical data for NASDAQ100 and S&P500 are included but any reasonably large data set of daily performance can be used<br>
`start` - Start of overall time interval to consider in analysis<br>
`end` - End of overall time interval to consider in analysis<br>
`length` - Length of the subsamples (time of investment)<br>
`leverage` - Strength of the lever. 1x is always calculated as a comparison<br>
`iterations` - Number of subsamples to be drawn. For reliable results i >= 1000 should be chosen<br>


Example Input<br>

`res <- yield(data=SP500, length = 1000, iterations=1000, leverage=3)
options(scipen=20)
summary <- unpack(res)
summary
`

Example Output<br>

`

               Average         SD   Median         5%       10%         20%      80%       90%       95%
Start         357.2450  516.36862  94.4500         NA        NA          NA       NA        NA        NA
x1 End        480.5399  699.37133 101.0900         NA        NA          NA       NA        NA        NA
x1 Gain       123.2036  267.28280  16.8250 -123.54811 -10.75200  -0.6379982 152.7740  778.7125  778.7125
x1 Percentage 134.4138   42.87838 132.6105   72.05592  85.01754  98.2460803 163.7518  209.0888  209.0888
x3 End        742.4670 1278.15293 121.7042         NA        NA          NA       NA        NA        NA
x3 Gain       384.9479 1050.81169   0.0000 -644.35342 -41.72181   0.0000000 483.8834 1756.3766 2547.9529
x3 Percentage 185.0562  192.10846 100.0000   45.55466  66.17316 100.0000000 247.8428  557.1598  557.1598`
