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
