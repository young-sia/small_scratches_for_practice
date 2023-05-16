fish <- read.csv(file='practcing_R_analysis/data_files/fish.csv',
                    header = TRUE)
fish <- na.omit(fish)
fish.X <- fish[c(-1, -2)]
cor(fish.X)

fish.X_fin <- fish.X[-2]

# 선형 판별점수, 예측확률, 예측변수
library(MASS)
fish.lda <- lda(species~weight+length1+length2+length3+height+width, data = fish)
print(fish.lda)
pred1 <- predict(fish.lda, fish)
fish.pred1 <- cbind(fish, pred1$x, pred1$posterior, pred1$class)
fish.cbtl1 <- table(fish$species, pred1$class)
library(DescTools)
Desc(fish.cbtl1, digits=2)

# 모분산행렬들의 동일성에 대한 검정
library(biotools)
fish.boxM <- boxM(fish.X_fin, fish$species)
 print(fish.boxM)

# 이차 판별분석
fish.qda <- qda(species~weight+length2+length3+height+width, data = fish)
print(fish.qda)
pred2 <- predict(fish.qda, fish)
fish.ctbl2 <- table(fish$species, pred2$class)
# install.packages("DescTools")
library(DescTools)
Desc(fish.ctbl2, digits=2)

# 두 판별분석의 그래프적 표현-- 사용불가로 판별
library(klaR)
fish$species <- as.factor(fish$species)
partimat(species~weight+length1+length2+length3+height+width, data = fish, method = "lda") # 선형판별분석
partimat(species~weight+length2+length3+height+width, data = fish, method = "qda") # 이차판별분석

#정준 판별분석
plot(fish.lda, cex=1)
plot(fish.lda, dimen = 2)
