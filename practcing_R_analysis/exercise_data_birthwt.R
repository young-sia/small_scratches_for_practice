birthwt <- read.csv(file = 'practcing_R_analysis/data_files/birthwt.csv',
                   header = TRUE)

# 미숙아여부에 따른 엄마의 몸무게
library(dplyr)
library(ggplot2)
birthwt['low'] <- as.character(birthwt[['low']])
ggplot(birthwt, aes(x=low, y=lwt))+geom_boxplot()

# 미숙아 여부에 따른 엄마 몸무게 평균차이에 대한 95% 신뢰구간
lwt0 <- birthwt[birthwt['low']==0, 'lwt']
lwt1 <- birthwt[birthwt['low']==1, 'lwt']
mean_lwt0 <- mean(birthwt[birthwt['low']==0, 'lwt'])
mean_lwt1 <- mean(birthwt[birthwt['low']==1, 'lwt'])

n0 <- length(birthwt[birthwt['low']==0, 'lwt'])
n1 <- length(birthwt[birthwt['low']==1, 'lwt'])

mu <- mean_lwt0-mean_lwt1
sigma <- sqrt(sd(lwt0)^2 / n0 + sd(lwt1)^2/n1)

interval <- mu + c(-1.96, 1.96) * sigma
sprintf("95%% 신뢰구간: (%f, %f)", interval[c(0, 1)], interval[c(0, 2)])

# 미숙아 여부에 따른 엄마 몸무게 평균차이에 대한 부트스트랩 95% 신뢰구간
library(boot)
stat_fun <- function(x, idx)mean(x[idx])
diff_lwt <- sample(lwt0, 100, replace = T)-sample(lwt1, 100, replace = T)
boot_mean <- boot(diff_lwt,statistic = stat_fun,R=100)
boot.ci(boot_mean,type='basic')

# 유의성 검정
t.test(lwt~low, data = birthwt, alternative = 'less')

# 순열 검정
perm_fun <- function(x, n1, n2)
{
  n <- n1 + n2
  idx_0<-sample(1:n, n1)
  idx_1<- setdiff(1:n, idx_0)
  mean_diff <- mean(x[idx_0]) - mean(x[idx_1])
  return(mean_diff)
}
perm_diff <- rep(0, 100)

for( i in 1:100)
  perm_diff[i] <- perm_fun(birthwt[, "lwt"],n0,n1)

perm_mean <- mean(perm_diff)
perm_sd <- sqrt(sd(perm_diff)^2 / length(perm_diff))

interval <- perm_mean + c(-1.96, 1.96) * perm_sd
sprintf("95%% 신뢰구간: (%f, %f)", interval[c(0, 1)], interval[c(0, 2)])

