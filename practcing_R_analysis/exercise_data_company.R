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


# 선형판별분석
library(MASS)
company.lda <- lda(class~x1+x2+x3+x4+x5+x6+x7+x8, data = company.Y)
print(company.lda)
pred1 <- predict(company.lda, company.Y)
company.pred1 <- cbind(company.Y, pred1$x, pred1$posterior, pred$class)
company.ctbl1 <- table(company$class, pred1$class)
library(DescTools)
Desc(company.ctbl1, digits=2)

# 이차 판별분석
library(MASS)
company.qda <- qda(class~x1+x2+x3, data = company.Y)
company.qda2 <- qda(class~x4+x5+x6, data = company.Y)
company.qda3 <- qda(class~x7+x8, data = company.Y)
print(company.qda)
print(company.qda2)
print(company.qda3)
pred2 <- predict(company.qda, company.Y)
company.ctbl2 <- table(company$class, pred2$class)
# install.packages("DescTools")
library(DescTools)
Desc(company.ctbl2, digits=2)

# 두 판별분석의 그래프적 표현
install.packages("klaR")
library(klaR)
company.Y$class <- as.factor(company.Y$class)
partimat(class~x1+x2+x3+x4+x5+x6+x7+x8, data = company.Y, method = "lda") # 선형판별분석
partimat(class~x1+x2+x3+x4+x5+x6+x7+x8, data = company.Y, method = "qda") # 이차판별분석
