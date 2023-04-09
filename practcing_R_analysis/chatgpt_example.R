# Generate some example data
set.seed(123)
data <- rnorm(100, mean = 0, sd = 1)
group <- rep(c("A", "B"), each = 50)

# Define a function to compute the summary statistic
sum_stat <- function(x, i) {
  mean(x[i])
}

# Perform the bootstrap
library(boot)
boot_res <- tapply(data, group, function(x) boot(x, sum_stat, R = 1000))

# Extract the bootstrapped values using boot()
boot_vals <- lapply(boot_res, function(x) x$t)

# Compute the confidence interval
cis <- lapply(boot_res, function(x) {
  ci <- boot.ci(x, type = "basic", conf = 0.95)$basic
  ci <- ci[2:3] # extract only the lower and upper bounds
  names(ci) <- NULL # remove the names
  return(ci)
})

# Plot the boxplot and confidence interval: doesn't show the interval because of the confidence interval value
boxplot(data ~ group, main = "Example Boxplot")
for (i in 1:length(cis)) {
  lines(rep(i, 2), cis[[i]], col = "darkred", lwd = 2)
}

# fixed ver.
# Set the y-axis limits to include the range of the data and the confidence intervals
ylim <- c(min(data, na.rm = TRUE), max(data, na.rm = TRUE))
for (i in 1:length(cis)) {
  ylim[1] <- min(ylim[1], cis[[i]][1])
  ylim[2] <- max(ylim[2], cis[[i]][2])
}
ylim <- ylim + c(-1, 1) * diff(ylim) * 0.05 # add a small margin to the limits

# Plot the boxplot and confidence interval with the modified y-axis limits
boxplot(data ~ group, main = "Example Boxplot", ylim = ylim)
for (i in 1:length(cis)) {
  lines(rep(i, 2), cis[[i]], col = "darkred", lwd = 2)
}