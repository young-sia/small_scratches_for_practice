Sys.setlocale(category = "LC_ALL", locale = "Korean_Korea.UTF-8")

# for Pycharm
company <- read.csv(file='practcing_R_analysis/data_files/company.csv',
                    header = TRUE)
company.Y <- company[-1]
company.X <- company.Y[-9]
summary(company.X)

# 산점도 행렬
par(mfrow=c(1,1))
pairs(company.X, cex=2, xlim=c(0,10000), ylim=c(0, 10000), cex.labels = 1.2)
plot(company.X, pch=20, cex=2, xlim=c(0,10000), ylim=c(0, 10000))

# mean, cov, cor
compnay.x_bar <- colMeans(company.X)
company.S <- cov(company.X)
company.R <- cor(company.X)

# 중심화된 자료행렬 C
compnay.C <- scale(company.X, center=TRUE, scale=FALSE)
# 표준화된 자료행렬 Z
company.Z <- scale(company.X, center=TRUE, scale = TRUE)

# 공분산행렬
company.Sz <- cov(company.Z)
check_bool <- company.Sz == company.R
check_subtract <- company.Sz - company.R

#class별 평균벡터, 표준편차
compnay.Agg.mean <- aggregate(company.Y, list(company.Y$class), mean)
company.Agg.std <- aggregate(company.Y, list(company.Y$class), sd)

# 새로운 자료행렬 V 계산
company.V <- as.data.frame(lapply(company.X, FUN= function(x)
                    (x-min(x))/(max(x)-min(x))))