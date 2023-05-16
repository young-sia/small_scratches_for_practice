gamble <- read.csv(file='practcing_R_analysis/data_files/gamble.csv',
                    header = TRUE)
model<- lm(gamble~gender+grading+income+GPA, data = gamble)
print(model)

# 남녀 차이 비교
gamble_f <- subset(gamble, gender==1)
gamble_m <- subset(gamble, gender==0)
model_f <- lm(gamble~grading+income+GPA, data = gamble_f)
model_m <- lm(gamble~grading+income+GPA, data = gamble_m)

print(model_f)
print(model_m)

# 특정변수 income과의 단순선형회귀분석
model<- lm(gamble~income, data = gamble)
print(model)

# 특정 변수의 신뢰구간 구하기
sample_income <- data.frame(income=tapply(sample(gamble$income, 50*10, replace = TRUE),
                                               rep(1:50, rep(10, 50)),FUN = mean))
mean_sample <- mean(sample_income[["income"]])
sd_sample <- sd(sample_income[["income"]])
n <- 50
mu <- mean_sample
sigma <- sqrt(sd_sample^2 / n)
interval <- mu + c(-1.96, 1.96) * sigma
print(interval)

# 부트스트랩 신뢰구간
library(boot)
stat_fun <- function(x, idx)mean(x[idx])
boot_mean <- boot(gamble$income,statistic = stat_fun,R=100)
boot.ci(boot_mean,type='basic')

# 신뢰구간, 예측구간 구하기
sample<-sample(1:nrow(gamble), 1000, replace=T)
gamble.sample <- gamble[sample,]
model<- lm(gamble~gender+grading+income+GPA, data = gamble.sample)
print(model)
confint(model) # 신뢰구간

## 신뢰구간 그리기
# par(mfrow=c(1,2))
hist(resid(model), prob=T)
x<-resid(model)
curve(dnorm(x,mean(x), sd(x)), col=2, add=T)

## 예측구간
pre<-NULL
for(i in 1: 1000){
   sample<-sample(1:nrow(gamble), 1000, replace=T)
   gamble.sample <- gamble[sample,]
   model<- lm(gamble~gender+grading+income+GPA, data = gamble.sample)
   pre<-append(pre, predict(model, newdata=gamble[, names(coef(model))[-1]]))
}
print(quantile(pre))

# 잔차의 정규성
library(car)
residuals <- residuals(model)
shapiro.test(residuals)

# 잔차의 절댓값과 예측값에 대한 산첨도
library(ggplot2)
coef.er_pred <- data.frame(resid = residuals(model),
                           pred = predict(model))
cor(coef.er_pred)
ggplot(coef.er_pred, aes(pred, abs(resid)))+
  geom_point()+
  geom_smooth()

# 편잔차그림
terms <- predict(model, type = 'terms')
partial_resid <- resid(model) + terms
partialresid.income <- data.frame(income = gamble[,'income'],
                                  Terms = terms[, 'income'],
                                  partialresid = partial_resid[, 'income'])
ggplot(partialresid.income, aes(income, partialresid))+
  geom_point(shape=1)+scale_shape(solid = FALSE)+
  geom_smooth(linetype=2)+
  geom_line(aes(income, Terms))