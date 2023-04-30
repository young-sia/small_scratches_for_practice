carpref <- read.csv(file = 'practcing_R_analysis/data_files/carpref.csv',
                   header = TRUE)
carinfo <- read.csv(file = 'practcing_R_analysis/data_files/carinfo.csv',
                   header = TRUE)
carpref.T <- t(carpref[,-1])
rownames(carpref.T)<- carinfo$model
colnames(carpref.T) <- carinfo$judge
carpref.X <- t(carpref.T)
carpref.Z <-scale(carpref.X, center = TRUE, scale = TRUE)

# 인자들에 대한 군집분석
library(psych)
carpref.fa <- fa(carpref.X, cor ="cor", nfactors = 2, fm="ml", rotate = "none" )
print(carpref.fa$loadings, sort = TRUE, digits = 5)

carpref.fa.dist <- dist(carpref.fa$loadings, method = "euclidian")
carpref.fa.hclust <- hclust(carpref.fa.dist, method = "ward.D")
plot(carpref.fa.hclust, hang = -1)
rect.hclust(carpref.fa.hclust, k=4, border = "red")


# raw data 에 대한 군집분석
carpref.Z.dist <- dist(carpref.Z, method = "euclidian")
carpref.Z.hclust <- hclust(carpref.Z.dist, method = "ward.D")
plot(carpref.Z.hclust, labels = carpref$judge, hang = -1)
rect.hclust(carpref.Z.hclust, k=5, border = "red")

hcluster <- cutree(carpref.Z.hclust, k=5)
carpref.X.hclust<- data.frame(carpref.X, hcluster)
head(carpref.X.hclust, n=10)

for(i in 1:5) {
  summaries <- subset(carpref.X.hclust, hcluster == i)
  print(i)
  print(summary(summaries[1:17]))
}


