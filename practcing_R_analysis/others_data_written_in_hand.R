# 상관행렬 R 표기
written1.R <- matrix(c(1.00, 0.73, 0.70, 0.58, 0.46, 0.56,
                       0.73, 1.00, 0.68, 0.61, 0.43, 0.52,
                       0.70, 0.68, 1.00, 0.57, 0.40, 0.48,
                       0.58, 0.61, 0.57, 1.00, 0.37, 0.41,
                       0.46, 0.43, 0.40, 0.37, 1.00, 0.71,
                       0.56, 0.52, 0.48, 0.41, 0.71, 1.00),
                     nrow = 6, ncol= 6, byrow = TRUE)

written1.R.prcomp <- prcomp(written1.R, center = TRUE, scale=TRUE)
# 상관행렬에 근거한 인자분석
written1.R.prcomp$sdev^2
library(psych)
written1.R.pm <- principal(written1.R, cor="cor", nfactors = 2, rotate = "none")
print(written1.R.pm)


# 검증 방법들: 카이제곱, F
written2 <- matrix(c(200, 182,
                     23539, 22406), nrow=2, ncol=2, byrow = TRUE)
chisq.test(written2, simulate.p.value = TRUE)

fisher.test(written2)
