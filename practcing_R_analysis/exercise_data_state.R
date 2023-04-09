state <- read.csv(file = 'practcing_R_analysis/data_files/state.csv',
                   header = TRUE)

# population 변수가 정규분포를 따르는지 확인하기
shapiro.test(state$Population)

# 표본평균, 표준편차, 히스토그램
mean_all <- mean(state$Population)
sd_all <- sd(state$Population)
cat("mean:",mean_all,"sd:", sd_all)
hist(state$Population, main = "Histogram of All Population", xlab = "population")

# Population 변수로부터 10개의 표본을 복원추출 하여 표본 평균을 계산한다. 이와 같은 작업을 500번 반복하여 표본평균의 표본분포를 생성한다. 표본분포로부터 평균, 표준편차, 히스토그램을 작성하고 2)의 결과와 비교하여라.
sample_population <- data.frame(income=tapply(sample(state$Population, 50*10, replace = TRUE),
                                               rep(1:50, rep(10, 50)),FUN = mean))
mean_sample <- mean(sample_population[["income"]])
sd_sample <- mean(sample_population[["income"]])
cat("sample mean:",mean_sample,"sample sd:", sd_sample)
hist(sample_population[["income"]], main = "Histogram of Sample Population", xlab="population sample mean")

# 평균에 대한 95% 신뢰구간(확률분포 사용)
n <- 50
mu <- mean_sample
sigma <- sqrt(sd_sample^2 / n)
interval <- mu + c(-1.96, 1.96) * sigma
print(interval)

# 평균에 대한 95% 부트스트랩 신뢰구간
library(boot)
stat_fun <- function(x, idx)mean(x[idx])
boot_mean <- boot(state$Population,statistic = stat_fun,R=100)
boot.ci(boot_mean,type='basic')

# 부트스트랩 표본상자그림
boxplot(boot_mean$t, main = "Bootstrap Boxplot")

# 표준편차에 대한 95% 신뢰구간(R=100)
stat_fun <- function(x, idx)sd(x[idx])
boot_sd <- boot(state$Population,statistic = stat_fun,R=100)
boot.ci(boot_sd,type='basic')

# 부트스트랩 표본의 히스토그램
hist(boot_sd$t, main = "Histogram of Standard Deviation: bootstrap")
# 히스토그램에 신뢰구간 표시
abline(v=boot_ci$basic[4],col="red", lty=2)
abline(v=boot_ci$basic[5],col="red", lty=2)