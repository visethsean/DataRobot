set.seed(1234)
setwd("C:/Users/Viseth Sean/Dropbox/2015 Summer/DataRobot")

library(leaps)
library(glmnet)
library(pls)

mydata = read.csv("OnlineNewsPopularity.csv")
dim(mydata)

names(mydata)
sum(is.na(mydata))
#remove string column, and other irrelevant/duplicate columns
mydata$url <- NULL
mydata$LDA_00 <- NULL
mydata$LDA_01 <- NULL
mydata$LDA_02 <- NULL
mydata$LDA_03 <- NULL
mydata$LDA_04 <- NULL
mydata$title_subjectivity <- NULL
mydata$title_sentiment_polarity <- NULL
mydata$weekday_is_saturday <- NULL
mydata$weekday_is_sunday <- NULL

#Sampling data
train = sample(dim(mydata)[1], 5000)
mytrain = mydata[train, ]
mytest = mydata[-train, ]
test = sample(dim(mytest)[1], 1000)
#1000 observations for testing
mytest1 = mytest[test, ]

#Find correlation between predictors and response
cor(mytrain)
#mytrain = subset(mytrain, kw_avg_avg < 15000)

#the most correlated variable (only 0.135)
#try to plot it against respose to see true relationship
plot(mytrain$shares~mytrain$kw_avg_avg)

#seems like small amount of data is outlier (kw_avg_avg >= 10000) which can affect regression line; so remove them
mytrain = mytrain[mytrain$kw_avg_avg <10000,]
nrow(mytrain)
attach(mytrain)


#Linear Regression with the most correlated variable (only 0.135)
plot(shares~kw_avg_avg, data = mytrain, col="darkgrey")
kw_avg_avg.range = range(mytrain$kw_avg_avg)
kw_avg_avg.grid = seq(from=kw_avg_avg.range[1], to=kw_avg_avg.range[2])
lm.fit = lm(shares~poly(kw_avg_avg, 10), data=mytrain)
summary(lm.fit)
#P-value shows that degree 3 is the best
lm.fit = lm(shares~poly(kw_avg_avg, 3), data=mytrain)
lm.pred = predict(lm.fit, data.frame(kw_avg_avg=kw_avg_avg.grid))
lines(kw_avg_avg.grid, lm.pred, col="blue", lwd=2)
lm.pred.test = predict(lm.fit, mytest1)
sqrt(mean(mytest1$shares - lm.pred.test)^2)

# Try other method to reduce number of predictors
# Forward subset
nv = ncol(mytrain)
regfit.full=regsubsets(shares~., mytrain, nvmax = nv-1, really.big=T, method = "forward")
reg.summary=summary(regfit.full)
reg.summary
par(mfrow=c(2,2))
plot(reg.summary$rss,xlab="Number of Variables",ylab="RSS",type="l")

plot(reg.summary$adjr2,xlab="Number of Variables",ylab=" Adjusted RSq",type="l")
max_adjr2=which.max(reg.summary$adjr2)
max_adjr2
points(max_adjr2,reg.summary$adjr2[max_adjr2], col ="red",cex =2, pch =20)

plot(reg.summary$cp,xlab="Number of Variables",ylab="Cp",type="l")
min_cp=which.min(reg.summary$cp)
min_cp
points(min_cp,reg.summary$cp[min_cp],col="red",cex=2,pch=20)

min_bic=which.min(reg.summary$bic)
min_bic
plot(reg.summary$bic,xlab="Number of Variables",ylab="BIC",type="l")
points(min_bic,reg.summary$bic[min_bic],col="red",cex=2,pch=20)

#Backward
regfit.full=regsubsets(shares~., mytrain, nvmax = nv-1, really.big=T, method = "backward")
reg.summary=summary(regfit.full)
reg.summary
par(mfrow=c(2,2))
plot(reg.summary$rss,xlab="Number of Variables",ylab="RSS",type="l")

plot(reg.summary$adjr2,xlab="Number of Variables",ylab=" Adjusted RSq",type="l")
max_adjr2=which.max(reg.summary$adjr2)
max_adjr2
points(max_adjr2,reg.summary$adjr2[max_adjr2], col ="red",cex =2, pch =20)

plot(reg.summary$cp,xlab="Number of Variables",ylab="Cp",type="l")
min_cp=which.min(reg.summary$cp)
min_cp
points(min_cp,reg.summary$cp[min_cp],col="red",cex=2,pch=20)

min_bic=which.min(reg.summary$bic)
min_bic
plot(reg.summary$bic,xlab="Number of Variables",ylab="BIC",type="l")
points(min_bic,reg.summary$bic[min_bic],col="red",cex=2,pch=20)

#Try Linear Regression with selected variables in accordance to appropriate number of predictors from Forward stepwise
mylm1 = lm(shares~timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, data=mytrain)
summary(mylm1)
#confint(mylm1)
mylm1.pred = predict(mylm1, mytest1)
sqrt(mean((mytest1$shares - mylm1.pred)^2))

mylm2 = lm(shares~kw_avg_avg+global_subjectivity, data=mytrain)
summary(mylm2)
mylm2.pred = predict(mylm2, mytest1)
sqrt(mean((mytest1$shares - mylm2.pred)^2))

mylm.1 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 1), data=mytrain)
mylm.2 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 2), data=mytrain)
mylm.3 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 3), data=mytrain)
mylm.4 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 4), data=mytrain)
mylm.5 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 5), data=mytrain)
mylm.6 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 6), data=mytrain)
mylm.7 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 7), data=mytrain)
mylm.8 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 8), data=mytrain)
mylm.9 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 9), data=mytrain)
mylm.10 = lm(shares~poly(timedelta+n_tokens_title+kw_avg_avg+global_subjectivity+n_unique_tokens+n_non_stop_words, 10), data=mytrain)
anova(mylm.1, mylm.2, mylm.3, mylm.4, mylm.5, mylm.6, mylm.7, mylm.8, mylm.9, mylm.10)

summary(mylm.3)
mylm.3.pred = predict(mylm.3, mytest1)
sqrt(mean((mytest1$shares - mylm.3.pred)^2))



#Lasso
x=model.matrix(shares~.,mytrain)[,-1]
y=mytrain$shares
xtest = model.matrix(shares~.,mytest1)[,-1]
ytest = mytest1$shares

par(mfrow=c(1,1))
mylambda=10^seq(10,-2,length=100)
lasso.mod=glmnet(x,y,alpha=1,lambda=mylambda)
plot(lasso.mod)
myCoef = coef(lasso.mod)
myPredict = predict(lasso.mod, newx=xtest)
  # Plot the coefficients
plot(myCoef[2:51,90],col='red',pch=1)
points(myCoef[2:51,10],col='green',pch=2)
points(myCoef[2:51,1],col='blue',pch=3)

errors = NULL
for (i in 1:100) {
  errors[i] = mean( (ytest - myPredict[,i])^2 )
}

plot(mylambda,errors,type='l')

myCoef[,which.min(errors)]
mylambda[which.min(errors)]



#Ridge
ridge.mod=glmnet(x,y,alpha=0,lambda=mylambda)
dim(coef(ridge.mod))
myCoef = coef(ridge.mod)
  # Plot the coefficients
plot(myCoef[2:51,90],col='red',pch=1)
points(myCoef[2:51,10],col='green',pch=2)
points(myCoef[2:51,1],col='blue',pch=3)

ridge.mod$lambda[50]
coef(ridge.mod)[,50]
sqrt(sum(coef(ridge.mod)[-1,50]^2))
predict(ridge.mod,s=50,type="coefficients")[1:nv,]

myPredict = predict(ridge.mod, newx=xtest)
errors = NULL
for (i in 1:100) {
  errors[i] = mean( (ytest - myPredict[,i])^2 )
}

plot(mylambda,errors,type='l')

myCoef[,which.min(errors)]
mylambda[which.min(errors)]

#PCR
pcr.fit=pcr(shares~., data=mytrain, scale=TRUE)
summary(pcr.fit)
validationplot(pcr.fit,val.type="MSEP")
validationplot(pcr.fit,val.type='R2')


######(b) try methods with 10-fold Cross Validation######

#Lasso
cv.lasso = cv.glmnet(x, y, type.measure = "mse")
plot(cv.lasso)
coef(cv.lasso)
cv.lasso$cvm[cv.lasso$lambda == cv.lasso$lambda.1se]

#Ridge
cv.ridge = cv.glmnet(x, y, type.measure = "mse", alpha = 0)
plot(cv.ridge)
coef(cv.ridge)
cv.ridge$cvm[cv.ridge$lambda == cv.ridge$lambda.1se]

#PCR
pcr.fit=pcr(shares ~ ., data = mytrain,scale=TRUE,validation = "CV")
validationplot(pcr.fit,val.type="MSEP")
summary(pcr.fit)







