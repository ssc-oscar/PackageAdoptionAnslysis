setwd('./angularVSreact')
f1 = read.csv2('survival_data' ,header = FALSE,sep=';')
colnames(f1) = c('status','time','calenda_time','pack_choice')
f1$time = f1$time/3600/24
f1$calenda_time = f1$calenda_time/3600/24/365.25 + 1970
f1$calenda_time = as.integer(f1$calenda_time * 10)

library(survival)
surv.fit = survreg(Surv(time, status==1) ~ strata(pack_choice,calenda_time), f1[f1[,2] > 0,], control = list(maxiter=90))
summary(surv.fit)

f2 = read.csv2('being.angular' ,header = FALSE,sep=';')
colnames(f2) = c('prj','calenda_time','pack_choice')
f2$calenda_time = f2$calenda_time/3600/24/365.25 + 1970
f2$calenda_time = as.integer(f2$calenda_time * 10)
g2 = f2
pred = predict(surv.fit,newdata = f2[,2:3], type='quantile', p=.5)
f2$survival.predicted = pred
write.table(f2,'firsttimereply.angular',row.names = FALSE, col.names = FALSE,quote = FALSE, sep = ';', dec = '.')

f3 = read.csv2('being.react' ,header = FALSE,sep=';')
colnames(f3) = c('prj','calenda_time','pack_choice')
f3$calenda_time = f3$calenda_time/3600/24/365.25 + 1970
f3$calenda_time = as.integer(f3$calenda_time * 10)
g3 = f3
pred2 = predict(surv.fit,newdata = f3[,2:3], type='quantile', p=0.5)
f3$survival.predicted = pred2
write.table(f3,'firsttimereply.react',row.names = FALSE, col.names = FALSE,quote = FALSE, sep = ';', dec = '.')
