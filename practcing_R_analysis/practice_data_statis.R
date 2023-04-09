statis <- read.csv(file = 'practcing_R_analysis/data_files/satis.csv',
                   header = TRUE)

# install.packages('psych')
library(psych)

# describe about stais data
describe(statis[c('x1', 'x2', 'x3', 'x4', 'x5')])

# correlations: correlations matrix, p-value
cor(statis[c('x1', 'x2', 'x3', 'x4', 'x5')])
corr.test(statis[c('x1', 'x2', 'x3', 'x4', 'x5')])

#coveriance matrix
cov(statis[c('x1', 'x2', 'x3', 'x4', 'x5')])

# PCA analysis
statis.prcomp <- prcomp(~x1+x2+x3+x4+x5, data = statis)
print(statis.prcomp)
statis.prcomp$sdev # 주성분의 표준편차
statis.prcomp$sdev^2 # 고윳값 출력
summary(statis.prcomp)

# PCA score
statis.score <- cbind(statis, statis.prcomp$x[,1:2])
print(statis.score)

# PCA graph: 개체 번호별
plot(statis.score[c('PC1', 'PC2')], xlim = c(-4, 4), ylim = c(-2.5, 2.5))
abline(h=0, v=0)
text(statis.score[c('PC1', 'PC2')], labels = rownames(statis.score), pos = 2)

# PCA graph: 성별
plot(statis.score[c('PC1', 'PC2')], xlim = c(-4, 4), ylim = c(-2.5, 2.5))
abline(h=0, v=0)
text(statis.score[c('PC1', 'PC2')], labels = statis.score$gender, pos = 2)

# PCA graph: 연령대
plot(statis.score[c('PC1', 'PC2')], xlim = c(-4, 4), ylim = c(-2.5, 2.5))
abline(h=0, v=0)
text(statis.score[c('PC1', 'PC2')], labels = statis.score$age, pos = 2)

# PCA graph: 집단 중심점 plot
statis.X <- statis[c('x1', 'x2', 'x3', 'x4', 'x5')]
statis.X.prcomp <- prcomp(statis.X, center = TRUE, scale=FALSE)
statis.score <- cbind(statis, statis.X.prcomp$x)

pcm.age <- aggregate(cbind(PC1, PC2)~age, data=statis.score, FUN = mean)
pcm.gender <- aggregate(cbind(PC1, pc2)~gender, data=statis.socre, FUN=mean)

plot(statis.score[c('PC1', 'PC2'), xlim = c(-4, 4), ylim = c(-2.5, 2.4)])
abline(h=0, v=0)

points(pcm.age[, 2:3], pch=8, cex= 1.5, col='darkgreen')
text(pcm.age[, 2:3], labels= pcm.age$age, pos=4, col = 'darkgreen')

points(pcm.gender[, 2:3], pch=8, cex= 1.5, col='red')
text(pcm.gender[, 2:3], labels= pcm.age$age, pos=4, col = 'red')

# PCA: 행렬도(Biplot)
biplot(statis.prcomp, cex=1)
abline(h=0, v=0, lty=2)

