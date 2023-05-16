remiss <- read.csv(file='practcing_R_analysis/data_files/remiss.csv',
                    header = TRUE)
remiss.X <- remiss[c(-1, -2)]

# 모분산행렬들의 동일성에 대한 검정
library(biotools)
remiss.boxM <- boxM(remiss.X, remiss$remiss)
 print(remiss.boxM)

# 선형 판별점수, 예측확률, 예측변수
library(MASS)
remiss.lda <- lda(remiss~x1+x2+x3+x4+x5+x6, data = remiss)
print(remiss.lda)

# 두 판별분석의 그래프적 표현-- 사용불가로 판별
library(klaR)
remiss$remiss <- as.factor(remiss$remiss)
partimat(remiss~x1+x2+x3+x4+x5+x6, data = remiss, method = "qda") # 이차판별분석

#정준 판별분석
plot(remiss.lda, cex=1)
plot(remiss.lda, dimen = 1, type = "both")

# 로지스틱 판별함수
remiss.logit <- glm(remiss~x1+x2+x3+x4+x5+x6, data = remiss,
                    family = binomial)
summary(remiss.logit)

#검정
# install.packages("car")
library(car)
Anova(remiss.logit, type = "II", test = "Wald")

# AIC 통계량을 활용한 변수선택
remiss.step <- stepAIC(remiss.logit, direction = c("backward"))
# remiss.step <- stepAIC(remiss.logit, direction = c("forward")) --x
summary(remiss.step)

# 오분류표-정준판별분석
pred <- predict(remiss.lda, remiss)
remiss.cbtl <- table(remiss$remiss, pred$class)
library(DescTools)
Desc(remiss.cbtl, digits=2)

# 오분류그래프:로지스틱 판별분석
# install.packages("ROCR")
library(ROCR)
remiss.fit <- data.frame(default = remiss$remiss, fit = remiss.logit$fitted.values)
pred <- prediction(remiss.fit$fit, remiss.fit$default)
plot(performance(pred, "err"))