Sys.setlocale(category = "LC_ALL", locale = "Korean_Korea.UTF-8")
# Student data analysis
student <- read.csv(file='practcing_R_analysis/data_files/student.csv',
                    header = TRUE)
student.X <- student[-1]
summary(student.X)

# Student: graph
plot(x2~x1, data = student, pch = "*", cex = 2, col ="blue")
plot(student$x1, student$x2, pch=8, cex=2, col = 'blue')

# Student: Star plot
 stars(student.X, full = TRUE, scale = TRUE, radius = TRUE, draw.segments =  TRUE,
                   frame.plot = TRUE, labels = rownames(student.X), nrow = 3, ncol = 5, cex = 0.8,
                   len = 0.8, lwd = 1, axes = TRUE, ylim = c(1, 8), key.loc = c(7,2) )
 
# Student: 연결선 그래프
student.ox1 <- student[order(student$x1),]
plot(x2~x1, data = student.ox1, cex = 2, col = "red", type = "o", lty = 5, lwd = 2)
 
# Student: 한 화면에 여러개의 그래프 표현하기
par(mfrow=c(1, 2))
plot(x4~x3, data = student, pch = 20, cex=2, xlim=c(0,100), ylim=c(0,100))
plot(x4~x5, data = student, pch = 20, cex=2, xlim=c(0,100), ylim=c(0,100))


# Student: 산점도 행렬
par(mfrow=c(1,1))
plot(student.X, pch=20, cex=2, xlim=c(0,100), ylim=c(0, 100))
pairs(student.X, cex=2, xlim=c(0,100), ylim=c(0, 100), cex.labels = 1.2)

# Student: 레이더 도표
#install.packages("plotrix")
library(plotrix)
radial.plot(student.X, rp.type='p', radial.lim=c(0, 100),
            lwd=2, lty=1, labels=names(student.X),
            show.grid=TRUE, show.radial.grid=TRUE, show.grid.labels=1)