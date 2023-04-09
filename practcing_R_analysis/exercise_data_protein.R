
protein <- read.csv(file = 'practcing_R_analysis/data_files/protein.csv',
                   header = TRUE)


# 공분산행렬에 근거한 PCA 분석
protein.X <- protein[c('x1', 'x2', 'x3', 'x4', 'x5', 'x6', 'x7', 'x8', 'x9')]
protein.X.prcomp <- prcomp(protein.X, center = TRUE, scale=FALSE)
print(protein.X.prcomp)
protein.X.prcomp$sdev^2
X.mean <-mean(protein.X.prcomp$sdev^2)
protein.X.prcomp$sdev^2 > X.mean
summary(protein.X.prcomp)


# 상관행렬 R
protein.R <- cor(protein.X)

# 표준화된 공분산행렬에 근거한 PCA 분석
protein.R.prcomp <- prcomp(protein.X, center = TRUE, scale=TRUE)
print(protein.R.prcomp)
summary(protein.R.prcomp)


# 고윳값의 크기, 인자의 공헌도, scree 도형, 카이제곱적합도검정: 상관행렬
protein.R.prcomp$sdev^2 # 고윳값

# install.packages("psych")
library(psych)
scree(protein.R, hline = 1) # scree 도형

protein.R.none <- principal(protein.R, nfactors = 3, rotate = "none")
print(protein.R.none, digits = 3)
protein.R.varimax <- principal(protein.R, nfactors = 3, rotate = "varimax")
print(protein.R.varimax, digits = 3) # 인자의 공헌도

protein.fa1 <- fa(protein.R, nfactors = 1, fm='ml', rotate = 'varimax')
factor.stats(r=protein.R, f=protein.fa1)
protein.fa2 <- fa(protein.R, nfactors = 3, fm='ml', rotate = 'varimax')
factor.stats(r=protein.R, f=protein.fa2) # 카이제곱적합도검정

# 고윳값의 크기, 인자의 공헌도, scree 도형, 카이제곱적합도검정: 공분산행렬
protein.X.prcomp$sdev^2
X.mean <-mean(protein.X.prcomp$sdev^2)
protein.X.prcomp$sdev^2 > X.mean # 고윳값

# install.packages("psych")
library(psych)
scree(protein.X, hline = 1) # scree 도형

protein.X.2 <- principal(protein.X, nfactors = 2, rotate = "varimax")
print(protein.X.2, digits = 3)
protein.X.3 <- principal(protein.X, nfactors = 3, rotate = "varimax")
print(protein.X.3, digits = 3) # 인자의 공헌도

protein.fa1 <- fa(protein.X, nfactors = 2, fm='ml', rotate = 'varimax')
factor.stats(r=protein.X, f=protein.fa1)
protein.fa2 <- fa(protein.X, nfactors = 3, fm='ml', rotate = 'varimax')
factor.stats(r=protein.X, f=protein.fa2) # 카이제곱적합도검정


# 인자분석 : 상관행렬
protein.R.pm <- principal(protein.R, cor="cor", nfactors = 3, rotate = "varimax")
print(protein.R.pm)

# 인자분석: 공분산행렬
protein.X.pm <- principal(protein.X, nfactors = 3, rotate = "varimax", scores = TRUE)
print(protein.X.pm)



# 인자적재 플롯, 인자점수 플롯, 행렬도: 상관행렬

## 인자적재 플롯
print(protein.R.pm$loadings, digit = 5, cut = 0) # 인자적재값 출력
biplot(x=protein.R.pm$loadings[,c(1,2)], y=protein.R.pm$loadings[,c(1,3)],
       xlabs = colnames(protein.X), ylabs = colnames(protein.X))
abline(h=0, v=0, lty=2)

## 인자 점수 플롯
## 행렬도
xcodin.R <- protein.R.pm$scores
ycodin.R <- protein.R.pm$loadings
print(xcodin.R)

# 인자적재 플롯, 인자점수 플롯, 행렬도: 공분산행렬

## 인자적재 플롯
print(protein.X.pm$loadings, digit = 5, cut = 0) # 인자적재값 출력
biplot(x=protein.X.pm$loadings[,c(1,3)], y=protein.X.pm$loadings[,c(1,3)],
       xlabs = colnames(protein.X), ylabs = colnames(protein.X))
abline(h=0, v=0, lty=2)

## 인자 점수 플롯
protein.Z <- as.data.frame(scale(protein.X, center = TRUE, scale = TRUE)) # 인자점수계수행렬
protein.Z.fscore <- cbind(protein.Z, protein.X.pm$scores) # 인자점수
print(protein.Z.fscore, digits = 3)
plot(protein.X.pm$scores) # 인자점수 플롯

## 행렬도
biplot(protein.X.pm, cex = c(1,1), col = c("green", "red"))
biplot(protein.X.pm$scores, y= protein.X.pm$loadings, col = c("green", "red"),
       xlabs = rownames(protein.X), ylabs = colnames(protein.X))
abline(h=0, v=0, lty=2)
