fitness <- read.csv(file = 'practcing_R_analysis/data_files/fitness.csv',
                   header = TRUE)
fitness.X <- fitness[,c("weight", "waist", "pulse")]
fitness.Y <- fitness[,c("chins", "situps", "jumps")]
cancor(fitness.X, fitness.Y)

# 상관행렬
# install.packages("CCA")
library(CCA)
matcor(fitness.X, fitness.Y)

# 정준계수 출력
fitness.cc <- cc(fitness.X, fitness.Y)
fitness.cc$xcoef # x 집단(원 정준계수)
fitness.cc$ycoef # y 집단(원 정준 상관계수)
fitness.cc$xcoef*sapply(fitness.X, sd) # x 집단, 표준화된 정준계수
fitness.cc$ycoef*sapply(fitness.Y, sd) # y 집단, 표준화된 정준계수

#정준상관계수
fitness.cc$cor


# 정준점수 출력 및 정준점수 플롯

## 정준점수
fitness.X.score <- fitness.cc$scores$xscores
colnames(fitness.X.score) <- paste0("ChrVar", 1:3)
fitness.Y.score <- fitness.cc$scores$yscores
colnames(fitness.Y.score) <- paste0("SatVar", 1:3)
fitness.score <- cbind(fitness.X.score, fitness.Y.score)
round(fitness.score, digits = 3) # 정준점수 출력

## 정준점수 플롯
plot(fitness.score[, 1:2], pch = 1, col = "blue")
abline(v=0, h=0, lty=2)
text(fitness.score[,1:2], labels = 1:20, pos = 4, col = "red")

plot(fitness.score[, 4:5], pch = 1, col = "green")
abline(v=0, h=0, lty=2)
text(fitness.score[,4:5], labels = 1:20, pos = 4, col = "red")

plot(fitness.score[, c(1, 4)], pch = 1, col = "purple")
abline(v=0, h=0, lty=2)
text(fitness.score[,c(1, 4)], labels = 1:20, pos = 4, col = "red")