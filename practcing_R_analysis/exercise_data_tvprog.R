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
# biplot(tvprog.X.pm, col = c('green', 'yellow'))
biplot(x=xcodin, y=ycodin, col = c("green", "yellow"), cex = c(0.9, 1),
       xlabs = rownames(tvprog.X), ylabs = colnames(tvprog.X))
abline(h=0, v=0, lty=2)
points(x=mean(tvprog.Z.fscore$RC1), y= mean(tvprog.Z.fscore$RC2), pch=11, col = "red")

# 인자의 설명분산에 대한 군집분석:(x1~x8)
tvprog.fa.dist <- dist(tvprog.fa$loadings, method = "euclidian")
tvprog.fa.hclust <- hclust(tvprog.fa.dist, method = "ward.D")
plot(tvprog.fa.hclust, hang = -1)
rect.hclust(tvprog.fa.hclust, k=2, border = "red")

# raw data에 대한 군집분석
tvprog.Z.dist <- dist(tvprog.Z, method = "euclidian")
tvprog.Z.hclust <- hclust(tvprog.Z.dist, method = "ward.D")
plot(tvprog.Z.hclust, labels = tvprog$ID, hang = -1)
rect.hclust(tvprog.Z.hclust, k=5, border = "red")

hcluster <- cutree(tvprog.Z.hclust, k=5)
tvprog.X.hclust<- data.frame(tvprog.X, hcluster)
head(tvprog.X.hclust, n=10)


# Define the number of clusters
num_clusters <- 5

# Create an empty list to store the hierarchical clustering results
hclust_results <- list()

# Loop through each cluster
for (i in 1:num_clusters) {
  # Subset the data for the current cluster
  tvprog.X.hclust <- subset(tvprog.X, hcluster==i)

  # Scale the data
  tvprog.Z.hclust <- scale(tvprog.X.hclust[-1], center = TRUE, scale = TRUE)

  # Compute distance matrix
  tvprog.Z.hclust.dist <- dist(tvprog.Z.hclust, method = "euclidean")

  # Perform hierarchical clustering
  tvprog.Z.hclust.hclust <- hclust(tvprog.Z.hclust.dist, method = "ward.D")

  # Store the hierarchical clustering result in the list
  hclust_results[[i]] <- tvprog.Z.hclust.hclust

  # Plot the dendrogram with labels
  plot(tvprog.Z.hclust.hclust, labels = tvprog.X.hclust$ID, hang = -1)

  # Add rectangles to the plot
  rect.hclust(tvprog.Z.hclust.hclust, k=5, border = "red")
}

