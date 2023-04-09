ch1_data <- read.csv(file = 'practcing_R_analysis/data_files/ch1_data.csv',
                   header = TRUE)

# calculate mean, median, weighted mean, standard deviation and interquartile range
mean1 <- mean(ch1_data[["population"]])
median1 <- median(ch1_data[['population']])
weighted_mean1 <- weighted.mean(ch1_data[['population']]) # 가중할 요소가 없어서 일반으로 진행함
sd1 <- sd(ch1_data[['population']])
iqr1 <- IQR(ch1_data[['population']])
sprintf('평균: %f, 중앙값: %f, 가중평균(가중부여는 하지 않음): %f, 표준편차: %f, 사분위수 범위:, %f',
        mean1, median1, weighted_mean1, sd1, iqr1)


# boxplot and descriptive statistics
bank50 <- read.csv(file = 'practcing_R_analysis/data_files/bank50.csv',
                   header = TRUE)
summary(bank50["age"])
boxplot_bank <- boxplot(bank50[['age']], ylab='age')


# Do an excercise using from practiced above
real_life_ex <- read.csv(file = 'practcing_R_analysis/data_files/Real-life-ex.csv',
                   header = TRUE)
summary(real_life_ex[c('Price', 'Mileage')])

boxplot.price <- boxplot(Price~Brand, data=real_life_ex)
# install.packages('plyr')
library(plyr)
real_life_ex_omitted <- na.omit(real_life_ex)
tapply(real_life_ex_omitted$Price, real_life_ex_omitted$Brand, median)

plot(real_life_ex$EngineV, real_life_ex$Price, pch="@")
plot(real_life_ex$EngineV, real_life_ex$Price, xlim=c(0,10), pch="*")
