tvprog <- read.csv(file = 'practcing_R_analysis/data_files/tvprog.csv',
                   header = TRUE)
tvprog <- na.omit(tvprog)

tvprog.X <- na.omit(tvprog[2:9])

# 인자적재 플롯
library(psych)
tvprog.fa <- principal(tvprog.X, cor ="cor", nfactors = 2, rotate = "varimax" )
print(tvprog.fa, sort = TRUE, digits = 5) # 인자적재값 출력
biplot(x=tvprog.fa$loadings[,c(1,2)], y=tvprog.fa$loadings[,c(1,2)],
       xlabs = colnames(tvprog.X), ylabs = colnames(tvprog.X))
abline(h=0, v=0, lty=2)

# 인자점수
tvprog.Z <- as.data.frame(scale(tvprog.X, center = TRUE, scale = TRUE)) # 인자점수계수행렬
tvprog.Z.fscore <- cbind(tvprog.Z, tvprog.fa$scores) # 인자점수
print(head(tvprog.Z.fscore, digits = 3))

tvprog.Z.fscore_gender <- cbind(tvprog.Z.fscore, tvprog$gender)
tvprog.Z.fscore_age <- cbind(tvprog.Z.fscore, tvprog$age)
tvprog.Z.fscore_married <- cbind(tvprog.Z.fscore, tvprog$married)
tvprog.Z.fscore_house <- cbind(tvprog.Z.fscore, tvprog$house)
tvprog.Z.fscore_job <- cbind(tvprog.Z.fscore, tvprog$job)
library(plyr)

aggregate(tvprog.Z.fscore_gender[1:10], by = list(tvprog.Z.fscore_gender$`tvprog$gender`),
          mean)
aggregate(tvprog.Z.fscore_age[1:10], by = list(tvprog.Z.fscore_age$`tvprog$age`),
          mean)
aggregate(tvprog.Z.fscore_married[1:10], by = list(tvprog.Z.fscore_married$`tvprog$married`),
          mean)
aggregate(tvprog.Z.fscore_house[1:10], by = list(tvprog.Z.fscore_house$`tvprog$house`),
          mean)
aggregate(tvprog.Z.fscore_job[1:10], by = list(tvprog.Z.fscore_job$`tvprog$job`),
          mean)

# 인자적재와 인자점수의 평균을 함꼐 표현한 행렬도
xcodin <- tvprog.fa$scores
ycodin <- tvprog.fa$loadings
plot(xcodin, col = 'green')
biplot(protein.X.pm, col = c('green', 'yellow'))
biplot(x=xcodin, y=ycodin, col = c("green", "yellow"), cex = c(0.9, 1),
       xlabs = rownames(tvprog.X), ylabs = colnames(tvprog.X))
abline(h=0, v=0, lty=2)
points(x=mean(tvprog.Z.fscore$RC1), y= mean(tvprog.Z.fscore$RC2), pch=11, col = "red")


