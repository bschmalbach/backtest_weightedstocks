rm(list = ls())

NASDAQ <- read.csv("^NDX.csv")
SP500 <- read.csv("^GSPC.csv")

NASDAQ$Change <- NASDAQ$Close - NASDAQ$Open
SP500$Change <- SP500$Close - SP500$Open
NASDAQ$Percentage <- NASDAQ$Change/NASDAQ$Open
SP500$Percentage <- SP500$Change/SP500$Open

max(NASDAQ$Percentage)
min(NASDAQ$Percentage)
max(SP500$Percentage)
min(SP500$Percentage)

#mean(NASDAQ$Percentage)
#mean(SP500$Percentage)

yield <- function(data=NULL, start=NULL, end=NULL, length=30, leverage=2, iterations=1000) {
  
  
  
  #inputs
  inputs <- as.list(args(yield))
  inputs[["data"]] <- data
  inputs[["start"]] <- start
  inputs[["end"]] <- end
  inputs[["length"]] <- length
  inputs[["leverage"]] <- leverage
  inputs[["iterations"]] <- iterations
  
  
  #pick lengths
  l <- length(data$Date)-length
  i_start <- sample(l, size=iterations)
  i_end <- i_start+length
  durations <- cbind(i_start, i_end)
  
  
  #calculate yield
  
  res <- data.frame(matrix(NA,0,6))
  for (k in 1:iterations) {
    start_prices <- c()
    start_prices[k] <- data$Open[durations[k,1]]
    iter <- c()
    date <- c()
    real_price <- c()
    percentage <- c()
    lever <- c()
    lever_percentage <- c()
    lev_price <- c()
    for (i in 1:length) {
      iter[i] <- k
      date[i] <- data$Date[durations[k,1]+(i-1)]
      real_price[i] <- data$Open[durations[k,1]+(i-1)] * (1 + (data$Percentage[durations[k,1]+(i-1)]))
      percentage[i] <- data$Percentage[durations[k,1]+(i-1)]
      lever[i] <- leverage
      lever_percentage[i] <- data$Percentage[durations[k,1]+(i-1)] * leverage
      if (i==1) {lev_price[1] <- start_prices[k] * (1 + lever_percentage[i])} else {
        lev_price[i] <- lev_price[i-1] * (1 + lever_percentage[i])  
      }
    }
    res_t <- cbind(iter, date, real_price, percentage, lever, lever_percentage, lev_price)
    res <- rbind(res, res_t)
  }
  res <- list("results"=res, "inputs"=inputs)
  res[[1]][,1] <- as.numeric(res[[1]][,1])
  for (p in 3:7) {
    res[[1]][,p] <- as.numeric(res[[1]][,p])  
  }
  
  return(res)
}

res <- yield(data=SP500, length = 1000, iterations=1000, leverage=3)  


  #unpack
  
unpack <- function(res) {
  
  start_prices <- c()
  end_prices <- c()
  gains <- c()
  percentages <- c()
  lever_start_prices <- c()
  lever_end_prices <- c()
  lever_gains <- c()
  lever_percentages <- c()
  length <- res[["inputs"]][["length"]]
  leverage <- res[["inputs"]][["leverage"]]
  iterations <- res[["inputs"]][["iterations"]]
  
  for (k in 1:iterations) {
    start_prices[k] <- res[["results"]][(1+(k-1)*length),"real_price"] / (1 + res[["results"]][(1+(k-1)*length),"percentage"])
  }
  for (k in 1:iterations) {
    end_prices[k] <- res[["results"]][(length+(k-1)*length),"real_price"]
  }
  for (k in 1:iterations) {
    gains[k] <- res[["results"]][(length+(k-1)*length),"real_price"] - res[["results"]][(1+(k-1)*length),"real_price"]
  }
 
  for (k in 1:iterations) {
    lever_end_prices[k] <- res[["results"]][(length+(k-1)*length),"lev_price"]
  }
  for (k in 1:iterations) {
    lever_gains[k] <- res[["results"]][((length+(k-1)*length)),"lev_price"] - res[["results"]][(1+(k-1)*length),"lev_price"]
  }
  
  average_start_price <- mean(start_prices)
  average_end_price <- mean(end_prices)
  average_gain <- mean(gains)
  average_percentage <- mean(end_prices/start_prices*100)
  average_lever_end_price <- mean(lever_end_prices)
  average_lever_gain <- mean(lever_gains)
  average_lever_percentage <- mean(lever_end_prices/start_prices*100)
  averages <- rbind(average_start_price, average_end_price, average_gain, average_percentage, average_lever_end_price, average_lever_gain, average_lever_percentage)

  sd_start_price <- sd(start_prices)
  sd_end_price <- sd(end_prices)
  sd_gain <- sd(gains)
  sd_percentage <- sd(end_prices/start_prices*100)
  sd_lever_end_price <- sd(lever_end_prices)
  sd_lever_gain <- sd(lever_gains)
  sd_lever_percentage <- sd(lever_end_prices/start_prices*100)
  sds <- rbind(sd_start_price, sd_end_price, sd_gain, sd_percentage, sd_lever_end_price, sd_lever_gain, sd_lever_percentage)
  
  median_start_price <- median(start_prices)
  median_end_price <- median(end_prices)
  median_gain <- median(gains)
  median_percentage <- median(end_prices/start_prices*100)
  median_lever_end_price <- median(lever_end_prices)
  median_lever_gain <- median(lever_gains)
  median_lever_percentage <- median(lever_end_prices/start_prices*100)
  medians <- rbind(median_start_price, median_end_price, median_gain, median_percentage, median_lever_end_price, median_lever_gain, median_lever_percentage)
  
  percentages <- end_prices/start_prices*100
  lever_percentages <- lever_end_prices/start_prices*100

  q5_gain <- quantile(gains, 0.05)
  q10_gain <- quantile(gains, 0.10)
  q20_gain <- quantile(gains, 0.20)
  q80_gain <- quantile(gains, 0.80)
  q90_gain <- quantile(gains, 0.90)
  q95_gain <- quantile(gains, 0.95)
  q5_lever_gain <- quantile(lever_gains, 0.05)
  q10_lever_gain <- quantile(lever_gains, 0.10)
  q20_lever_gain <- quantile(lever_gains, 0.20)
  q80_lever_gain <- quantile(lever_gains, 0.80)
  q90_lever_gain <- quantile(lever_gains, 0.90)
  q95_lever_gain <- quantile(lever_gains, 0.95)
  q5_percentage <- quantile(percentages, 0.05)
  q10_percentage <- quantile(percentages, 0.10)
  q20_percentage <- quantile(percentages, 0.20)
  q80_percentage <- quantile(percentages, 0.80)
  q90_percentage <- quantile(percentages, 0.90)
  q95_percentage <- quantile(percentages, 0.95)
  q5_lever_percentage <- quantile(lever_percentages, 0.05)
  q10_lever_percentage <- quantile(lever_percentages, 0.10)
  q20_lever_percentage <- quantile(lever_percentages, 0.20)
  q80_lever_percentage <- quantile(lever_percentages, 0.80)
  q90_lever_percentage <- quantile(lever_percentages, 0.90)
  q95_lever_percentage <- quantile(lever_percentages, 0.95)
  q5 <- c(NA, NA, q5_gain, q5_percentage, NA, q5_lever_gain, q5_lever_percentage)
  q10 <- c(NA, NA, q10_gain, q10_percentage, NA, q10_lever_gain, q10_lever_percentage)
  q20 <- c(NA, NA, q20_gain, q20_percentage, NA, q20_lever_gain, q20_lever_percentage)
  q80 <- c(NA, NA, q80_gain, q80_percentage, NA, q80_lever_gain, q80_lever_percentage)
  q90 <- c(NA, NA, q95_gain, q95_percentage, NA, q90_lever_gain, q95_lever_percentage)
  q95 <- c(NA, NA, q95_gain, q95_percentage, NA, q95_lever_gain, q95_lever_percentage)
  

  
  summary <- data.frame(cbind(averages, sds, medians, q5, q10, q20, q80, q90, q95))
  names(summary) <- c("Average", "SD","Median", "5%", "10%", "20%", "80%", "90%", "95%")
  rownames(summary) <- c("Start", "x1 End", "x1 Gain", "x1 Percentage", paste0("x",leverage," End"), paste0("x",leverage," Gain"), paste0("x",leverage," Percentage"))
  
  return(summary)
}
    
options(scipen=20)
summary <- unpack(res)
summary
