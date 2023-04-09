socioeco <- read.csv(file = 'practcing_R_analysis/data_files/socioeco.csv',
                   header = TRUE)

# 공분산행렬
socioeco.S <- cov(socioeco[c('pop', 'school', 'employ', 'service', 'house')])

# 공분산행렬에 근거한 PCA 분석
socioeco.X <- socioeco[c('pop', 'school', 'employ', 'service', 'house')]
socioeco.X.prcomp <- prcomp(socioeco.X, center = TRUE, scale=FALSE)
print(socioeco.X.prcomp)
socioeco.X.prcomp$sdev^2
X.mean <-mean(socioeco.X.prcomp$sdev^2)
socioeco.X.prcomp$sdev^2 > X.mean
summary(socioeco.X.prcomp)

# 공분산행렬에 근거한 인자분석
# install.packages("psych")
library(psych)
socioeco.X.pm <- principal(socioeco.X, cor="cor", nfactors = 2, rotate = "none")
print(socioeco.X.pm)

# 표준화된 행렬 Z
socioeco.Z <- scale(socioeco.X, center=TRUE, scale = TRUE)
socioeco.Sz <- cov(socioeco.Z)

# 상관행렬 R
socioeco.R <- cor(socioeco.X)

# 표준화된 공분산행렬에 근거한 PCA 분석
socioeco.R.prcomp <- prcomp(socioeco.X, center = TRUE, scale=TRUE)
print(socioeco.R.prcomp)
socioeco.R.prcomp$sdev^2
summary(socioeco.R.prcomp)

# 상관행렬에 근거한 인자분석
socioeco.R.pm <- principal(socioeco.R, cor="cor", nfactors = 2, rotate = "none")
print(socioeco.R.pm)


# 점수
socioeco.R.score <- cbind(socioeco, socioeco.R.prcomp$x[,1:2])
print(socioeco.R.score)


