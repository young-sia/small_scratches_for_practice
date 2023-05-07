iris <- read.csv(file = 'practcing_R_analysis/data_files/iris.csv',
                   header = TRUE)
iris_nospecies <-iris[,-5]

# k 평균 군집분석
## 군집개수
library(factoextra)
fviz_nbclust(iris_nospecies, kmeans, method = "wss", k.max = 10)
fviz_nbclust(iris_nospecies, kmeans, method = "silhouette", k.max = 10)
fviz_nbclust(iris_nospecies, kmeans, method = "gap_stat", nboot = 500)

## k 평균 군집분석
iris.kmeans <- kmeans(iris_nospecies, centers = 2)
iris.kclust <- data.frame(iris_nospecies, iris.kmeans$cluster)
print(iris.kclust)

iris.Z <- scale(iris_nospecies, center = TRUE, scale = TRUE)
iris.Z.kmeans <- kmeans(iris.Z, centers = 2, nstart = 10)
kcluster <- iris.Z.kmeans$cluster

library(cluster)
clusplot(iris, kcluster, labels = 4, lines = 1,
         color=TRUE, shade = TRUE, cex=1.5)

# 군집개수 확인법:BIC
library(mclust)
iris_nospecies.mclust <- Mclust(iris_nospecies)
plot(iris_nospecies.mclust, what = "BIC")

# 변수를 사용하여 타당성 고려
iris.kmeans3 <- kmeans(iris_nospecies, centers = 3)
plot(iris[,-5], col=iris$species)
plot(iris_nospecies, col=iris.kmeans3$cluster)

# 모공분산행렬의 동일성 검정
# install.packages("biotools")
library(biotools)
iris.boxM <- boxM(iris_nospecies, iris$species)
print(iris.boxM)

# 선형 판별분석
library(MASS)
iris.lda <- lda(species~x1+x2+x3+x4, data = iris)
print(iris.lda)
pred1 <- predict(iris.lda, iris)
iris.pred1 <- cbind(iris, pred1$x, pred1$posterior, pred1$class)
library(DescTools)
Desc(iris.pred1, digits=2)

# 이차 판별분석
library(MASS)
iris.qda <- qda(species~x1+x2+x3+x4, data = iris)
print(iris.qda)
pred2 <- predict(iris.qda, iris)
iris.ctbl2 <- table(iris$species, pred2$class)
# install.packages("DescTools")
library(DescTools)
Desc(iris.ctbl2, digits=2)

# 두 판별분석의 그래프적 표현
# install.packages("klaR")
library(klaR)
iris$species <- as.factor(iris$species)
partimat(species~x1+x2+x3+x4, data = iris, method = "lda") # 선형판별분석
partimat(species~x1+x2+x3+x4, data = iris, method = "qda") # 이차판별분석
