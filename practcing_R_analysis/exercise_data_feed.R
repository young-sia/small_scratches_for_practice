feed <- read.csv(file = 'practcing_R_analysis/data_files/feed.csv',
                   header = TRUE)
feed$Feed3 <- ifelse(!is.na(feed$Feed3),feed$Feed3, round(mean(feed$Feed3, na.rm=TRUE), 2))

# 사료 종류별 상자그림
boxplot(feed, xlab = "group type", ylab = "pig's weight")

# 일원분산분석
group_mean <- apply(feed, 2, mean)
for_anova <-function(data)
{
  fix_data <- data.frame()
  count <- 1
  for( i in 1:nrow(data)){
    for(j in 1:ncol(data)){
      fix_data[count, 1] <- data[i, j]
      fix_data[count, 2] <- dimnames(feed[j])[[2]]
      count <- count+1
    }
  }
  return(fix_data)
}
feed_fix <- for_anova(feed)
anova<-aov(V1~V2, data = feed_fix)
summary(anova)