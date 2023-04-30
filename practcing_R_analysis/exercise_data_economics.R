economics <- read.csv(file = 'practcing_R_analysis/data_files/economic.csv',
                   header = TRUE)
economics.X <- economics[,-1]

economics.Z <- scale(economics.X, center = TRUE, scale = TRUE)

# 군집개수
library(factoextra)
fviz_nbclust(economics.X, kmeans, method = "wss", k.max = 10)
fviz_nbclust(economics.X, kmeans, method = "silhouette", k.max = 10)
fviz_nbclust(economics.X, kmeans, method = "gap_stat", nboot = 500)

groups <- 3
economics.Z.dist <- dist(economics.X, method = 'euclidean')
# 최단연결법
economics.Z.hclust_single <- hclust(economics.Z.dist, method = "single")
plot(economics.Z.hclust_single, labels = economics$country)
rect.hclust(economics.Z.hclust_single, k = groups, border = "red")
# 최장연결법
economics.Z.hclust_complete <- hclust(economics.Z.dist, method = "complete")
plot(economics.Z.hclust_complete, labels = economics$country)
rect.hclust(economics.Z.hclust_complete, k = groups, border = "red")
# 평균연결법
economics.Z.hclust_average <- hclust(economics.Z.dist, method = "average")
plot(economics.Z.hclust_average, labels = economics$country)
rect.hclust(economics.Z.hclust_average, k = groups, border = "red")
# ward의 방법
economics.Z.hclust_ward <- hclust(economics.Z.dist, method = "ward.D")
plot(economics.Z.hclust_ward, labels = economics$country)
rect.hclust(economics.Z.hclust_ward, k = groups, border = "red")
# k 평균 군집분석
economics.X.kmeans <- kmeans(economics.X, centers = groups)
economics.X.kclust <- data.frame(economics.X, economics.X.kmeans$cluster)
print(economics.X.kclust)

economics.Z.kmeans <- kmeans(economics.Z, centers = groups, nstart = 10)
kcluster <- economics.Z.kmeans$cluster

library(cluster)
clusplot(economics.X, kcluster, labels = 4, lines = 1, color = TRUE,
         shade = TRUE, cex = 1.5)