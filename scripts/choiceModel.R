setwd('./angularVSreact')
CMTsAus.angular = read.csv2(file = "numofCMTsAusuptothatPoint.filter3",header = FALSE)
AusRecs.angular = read.csv2(file = "numofPrjsAcuRec.filter3",header = FALSE)
AusRecsCross.angular = read.csv2(file = "numofPrjsAcuRecCross.filter3.1to2",header = FALSE)
Cfiles.angular = read.csv2(file = "ContainCfiles.filter3",header = FALSE)
replygap.angular = read.csv2(file = "firsttimereply.ready1.filter3",header = FALSE)
#close.angular = read.csv2(file = "close.ready.filter2",header = FALSE)
unresolved.angular = read.csv2(file = "unresolvedNum1.filter3",header = FALSE)
stackflow.angular = read.csv2(file = "stackoverflow_prj2both.1.filter3",header = FALSE)
#existingtime.angular = read.csv2(file = "existingtime1.filter2",header = FALSE)
#network variables
closeness.angular = read.csv2(file = "closeness2both.1.filter3",header = FALSE)
closeness_author.angular = read.csv2(file = "closeness_author2both.1.filter3",header = FALSE)

CMTsAus.react = read.csv2(file = "numofCMTsAusuptothatPoint2.filter3",header = FALSE)
AusRecs.react = read.csv2(file = "numofPrjsAcuRec2.filter3",header = FALSE)
AusRecsCross.react = read.csv2(file = "numofPrjsAcuRecCross.filter3.2to1",header = FALSE)
Cfiles.react = read.csv2(file = "ContainCfiles2.filter3",header = FALSE)
replygap.react = read.csv2(file = "firsttimereply.ready2.filter3",header = FALSE)
unresolved.react = read.csv2(file = "unresolvedNum2.filter3",header = FALSE)
stackflow.react = read.csv2(file = "stackoverflow_prj2both.2.filter3",header = FALSE)

closeness.react = read.csv2(file = "closeness2both.2.filter3",header = FALSE)
closeness_author.react = read.csv2(file = "closeness_author2both.2.filter3",header = FALSE)


# qes_0.angular =read.csv2(file = "stackoverflow_prj2both.1.0qes.filter2",header = FALSE)
# qes_5.angular =read.csv2(file = "stackoverflow_prj2both.1.5qes.filter2",header = FALSE)
# qes_20.angular =read.csv2(file = "stackoverflow_prj2both.1.20qes.filter2",header = FALSE)
# qes_0.react =read.csv2(file = "stackoverflow_prj2both.2.0qes.filter2",header = FALSE)
# qes_5.react =read.csv2(file = "stackoverflow_prj2both.2.5qes.filter2",header = FALSE)
# qes_20.react =read.csv2(file = "stackoverflow_prj2both.2.20qes.filter2",header = FALSE)
# 
# ans_0.angular =read.csv2(file = "stackoverflow_prj2both.1.0ans.filter2",header = FALSE)
# ans_5.angular =read.csv2(file = "stackoverflow_prj2both.1.5ans.filter2",header = FALSE)
# ans_20.angular =read.csv2(file = "stackoverflow_prj2both.1.20ans.filter2",header = FALSE)
# ans_0.react =read.csv2(file = "stackoverflow_prj2both.2.0ans.filter2",header = FALSE)
# ans_5.react =read.csv2(file = "stackoverflow_prj2both.2.5ans.filter2",header = FALSE)
# ans_20.react =read.csv2(file = "stackoverflow_prj2both.2.20ans.filter2",header = FALSE)
# 
# colnames(qes_0.angular) = c('prjs','stackflow.angular.q0','stackflow.react.q0')  
# colnames(qes_5.angular) = c('prjs','stackflow.angular.q5','stackflow.react.q5')
# colnames(qes_20.angular) = c('prjs','stackflowq20.angular','stackflowq20.react')
# colnames(qes_0.react) = c('prjs','stackflow.angular.q0','stackflow.react.q0')
# colnames(qes_5.react) = c('prjs','stackflow.angular.q5','stackflow.react.q5')
# colnames(qes_20.react) = c('prjs','stackflowq20.angular','stackflowq20.react')
# 
# 
# colnames(ans_0.angular) = c('prjs','stackflow.angular.a0','stackflow.react.a0')  
# colnames(ans_5.angular) = c('prjs','stackflow.angular.a5','stackflow.react.a5')
# colnames(ans_20.angular) = c('prjs','stackflowa20.angular','stackflowa20.react')
# colnames(ans_0.react) = c('prjs','stackflow.angular.a0','stackflow.react.a0')
# colnames(ans_5.react) = c('prjs','stackflow.angular.a5','stackflow.react.a5')
# colnames(ans_20.react) = c('prjs','stackflowa20.angular','stackflowa20.react')
# 
# library(dplyr)
# 
# Mixs1 = inner_join(qes_0.angular,qes_5.angular,by = 'prjs')
# Mixs2 = inner_join(ans_0.angular,ans_5.angular,by = 'prjs')
# Mixs.full = inner_join(Mixs1,Mixs2,by="prjs")
# Mixs.full = inner_join(Mixs.full,qes_20.angular,by="prjs")  
# Mixs.full = inner_join(Mixs.full,ans_20.angular,by="prjs")

#merge parts
colnames(CMTsAus.angular) = c('prjs','cmts','aus')
colnames(CMTsAus.react) = c('prjs','cmts','aus')
colnames(AusRecs.angular) = c('prjs','cumulative.angular','recent.angular')
colnames(AusRecsCross.angular) = c('prjs','cumulative.react','recent.react')
colnames(AusRecs.react) = c('prjs','cumulative.react','recent.react')
colnames(AusRecsCross.react) = c('prjs','cumulative.angular','recent.angular')
colnames(Cfiles.angular) = c('prjs', 'Cfile')
colnames(Cfiles.react) = c('prjs', 'Cfile')
colnames(replygap.angular) = c('prjs','replygap.angular','replygap.react')
colnames(replygap.react) = c('prjs','replygap.angular','replygap.react')
colnames(unresolved.angular) = c('prjs','unresolved.angular','unresolved.react')
colnames(unresolved.react) = c('prjs','unresolved.angular','unresolved.react')
colnames(stackflow.angular) = c('prjs','stackflow.angular','stackflow.react')
colnames(stackflow.react) = c('prjs','stackflow.angular','stackflow.react')
colnames(closeness.angular) = c('prjs','closeness2angular','closeness2react')
colnames(closeness.react) = c('prjs','closeness2angular','closeness2react')
colnames(closeness_author.angular) = c('prjs','closeness_author2angular','closeness_author2react')
colnames(closeness_author.react) = c('prjs','closeness_author2angular','closeness_author2react')

replygap.react = transform(replygap.react,replygap.angular= as.numeric(as.character(replygap.angular)),
                          replygap.react= as.numeric(as.character(replygap.react)))
replygap.angular = transform(replygap.angular,replygap.angular= as.numeric(as.character(replygap.angular)),
                               replygap.react= as.numeric(as.character(replygap.react)))
unresolved.angular = transform(unresolved.angular,unresolved.angular= as.numeric(as.character(unresolved.angular)),
                                 unresolved.react= as.numeric(as.character(unresolved.react)))
unresolved.react = transform(unresolved.react,unresolved.angular= as.numeric(as.character(unresolved.angular)),
                            unresolved.react= as.numeric(as.character(unresolved.react)))
closeness_author.angular = transform(closeness_author.angular,closeness_author2angular= as.numeric(as.character(closeness_author2angular)),
                                       closeness_author2react= as.numeric(as.character(closeness_author2react)))
closeness_author.react = transform(closeness_author.react,closeness_author2angular= as.numeric(as.character(closeness_author2angular)),
                                  closeness_author2react= as.numeric(as.character(closeness_author2react)))
closeness.angular = transform(closeness.angular,closeness2angular= as.numeric(as.character(closeness2angular)),
                                closeness2react= as.numeric(as.character(closeness2react)))
closeness.react = transform(closeness.react,closeness2angular= as.numeric(as.character(closeness2angular)),
                           closeness2react= as.numeric(as.character(closeness2react)))

####################
V1 = AusRecs.angular[,2]/(AusRecs.angular[,2]+AusRecsCross.angular[,2])
V2 = AusRecsCross.angular[,2]/(AusRecs.angular[,2]+AusRecsCross.angular[,2])
V3 = AusRecs.angular[,3]/(AusRecs.angular[,3]+AusRecsCross.angular[,3])
V4 = AusRecsCross.angular[,3]/(AusRecs.angular[,3]+AusRecsCross.angular[,3])
AusRecs.angular[,2] = V1
AusRecs.angular[,3] = V3
AusRecsCross.angular[,2] = V2
AusRecsCross.angular[,3] = V4

#for react
V1 = AusRecs.react[,2]/(AusRecs.react[,2]+AusRecsCross.react[,2])
V2 = AusRecsCross.react[,2]/(AusRecs.react[,2]+AusRecsCross.react[,2])
V3 = AusRecs.react[,3]/(AusRecs.react[,3]+AusRecsCross.react[,3])
V4 = AusRecsCross.react[,3]/(AusRecs.react[,3]+AusRecsCross.react[,3])
AusRecs.react[,2] = V1
AusRecs.react[,3] = V3
AusRecsCross.react[,2] = V2
AusRecsCross.react[,3] = V4
####################
removeNa <- function(d,v){
  d[is.na(d)] <- v
  return (d)
}

AusRecs.angular = removeNa(AusRecs.angular,0.5)
AusRecs.react  = removeNa(AusRecs.react,0.5)
AusRecsCross.angular = removeNa(AusRecsCross.angular,0.5)
AusRecsCross.react = removeNa(AusRecsCross.react,0.5)


closeness.angular = merge(x = CMTsAus.angular,y=closeness.angular,by = 'prjs',all = TRUE)
closeness.angular = removeNa(closeness.angular,0)[,c(-2,-3)]
closeness.react = merge(x = CMTsAus.react,y=closeness.react,by = 'prjs',all = TRUE)
closeness.react = removeNa(closeness.react,0)[,c(-2,-3)]

closeness_author.angular = merge(x = CMTsAus.angular,y=closeness_author.angular,by = 'prjs',all = TRUE)
closeness_author.angular = removeNa(closeness_author.angular,0)[,c(-2,-3)]
closeness_author.react = merge(x = CMTsAus.react,y=closeness_author.react,by = 'prjs',all = TRUE)
closeness_author.react = removeNa(closeness_author.react,0)[,c(-2,-3)]

#qes_20.angular[,2] = qes_20.angular[,2]/(qes_20.angular[,2]+qes_20.angular[,3])
#qes_20.angular[,3] = 1 - qes_20.angular[,2]
#qes_20.react[,2] = qes_20.react[,2]/(qes_20.react[,2]+qes_20.react[,3])
#qes_20.react[,3] = 1 - qes_20.react[,2]

#ans_20.angular[,2] = ans_20.angular[,2]/(ans_20.angular[,2]+ans_20.angular[,3])
#ans_20.angular[,3] = 1 - ans_20.angular[,2]
#ans_20.react[,2] = ans_20.react[,2]/(ans_20.react[,2]+ans_20.react[,3])
#ans_20.react[,3] = 1 - ans_20.react[,2]

#stackflow.angular[,2] = stackflow.angular[,2]/(stackflow.angular[,2]+stackflow.angular[,3])
#stackflow.angular[,3] = 1 - stackflow.angular[,2]
#stackflow.react[,2] = stackflow.react[,2]/(stackflow.react[,2]+stackflow.react[,3])
#stackflow.react[,3] = 1 - stackflow.react[,2]

#contains negative numbers, on idea y
#existingtime.angular[existingtime.angular$existingtime < 0,2] = 0
#existingtime.angular$existingtime =  existingtime.angular$existingtime/3600/24
#existingtime.react[existingtime.react$existingtime < 0,2] = 0
#existingtime.react$existingtime =  existingtime.angular$react/3600/24

# replaceNAstack1 = read.csv('replaceNA.stackoverflow.1',header = FALSE)
# replaceNAstack2 = read.csv('replaceNA.stackoverflow.2',header = FALSE)
# colnames(replaceNAstack1) = c('prjs')
# colnames(replaceNAstack2) = c('prjs')
# stackflow.angular[stackflow.angular[,1] %in% replaceNAstack1[,1],c(2,3)] = NA
# stackflow.react[stackflow.react[,1] %in% replaceNAstack2[,1],c(2,3)] = NA

angular.1 = merge(x = CMTsAus.angular, y = Cfiles.angular, by = "prjs", all = TRUE)
angular.7 = merge(x = angular.1, y = closeness.angular, by = "prjs", all = TRUE)
angular.8 = merge(x = angular.7, y = closeness_author.angular, by = "prjs", all = TRUE)
angular.2 = merge(x = angular.8, y = AusRecs.angular, by = "prjs", all = TRUE)
angular.3 = merge(x = angular.2, y = AusRecsCross.angular, by = "prjs", all = TRUE)
#angular.3 = merge(x = angular.2, y = Cfiles.angular, by = "prjs", all = TRUE)
angular.4 = merge(x = angular.3, y = replygap.angular, by = "prjs", all = TRUE)
angular.5 = merge(x = angular.4, y = unresolved.angular, by = "prjs", all = TRUE)
#angular.6 = merge(x = angular.5, y = qes_20.angular, by = "prjs", all = TRUE)
#angular.7 = merge(x = angular.6, y =  ans_20.angular, by = "prjs", all = TRUE)
angular = merge(x = angular.5, y = stackflow.angular, by = "prjs", all = TRUE)
#qes_20.react

react.1 = merge(x = CMTsAus.react, y = Cfiles.react, by = "prjs", all = TRUE)
#react.6 = merge(x = react.1, y = existingtime.react, by = "prjs", all = TRUE)
react.7 = merge(x = react.1, y = closeness.react, by = "prjs", all = TRUE)
react.8 = merge(x = react.7, y = closeness_author.react, by = "prjs", all = TRUE)
react.2 = merge(x = react.8, y = AusRecs.react, by = "prjs", all = TRUE)
react.3 = merge(x = react.2, y = AusRecsCross.react, by = "prjs", all = TRUE)
#react.3 = merge(x = react.2, y = Cfiles.react, by = "prjs", all = TRUE)
react.4 = merge(x = react.3, y = replygap.react, by = "prjs", all = TRUE)
#react = merge(x = react.4, y = close.react, by = "prjs", all = TRUE)
react.5 = merge(x = react.4, y = unresolved.react, by = "prjs", all = TRUE)
#react.6 = merge(x = react.5, y = qes_20.react, by = "prjs", all = TRUE)
#react.7 = merge(x = react.6, y = ans_20.react, by = "prjs", all = TRUE)
react = merge(x = react.5, y = stackflow.react, by = "prjs", all = TRUE)
#test if any overlaps occur
#nrow(merge(x = angular, y = react, by = "prjs", all = FALSE)) == 105 (only from 2015 -- 2016)
#so actully there are some overlaps ()


#just ignore that at this point
#let's add one column + fast
angular$mode = rep('angular',nrow(angular))
react$mode = rep('react',nrow(react))

operate_data.replicate = rbind(angular,react)
operate_data = operate_data.replicate[!duplicated(operate_data.replicate$prjs),]
operate_data = operate_data[,-1]
#rbind(angular,react)[,-1]
library('mlogit')
operate_data = na.omit(operate_data)
# tune the format
a = operate_data$recent.angular
operate_data$recent.angular = operate_data$cumulative.react
operate_data$cumulative.react = a

colnames(operate_data)[9] = 'cumulative.react'
colnames(operate_data)[10] = 'recent.angular'


save(file = 'angular_for_TD.Rda',operate_data)


dataOp1 = mlogit.data(operate_data, shape = "wide", varying = 8:17, choice = "mode")
ml.choice1 = mlogit(mode ~  cumulative + replygap + unresolved + stackflow  |   cmts +  aus + Cfile + closeness2angular + closeness2react + closeness_author2react + closeness_author2angular,dataOp1)
#+ existingtime closeness2angular + + closeness_author2angular + cumulative + stackflowq20 +stackflow  + stackflowq20 +  +stackflow
summary(ml.choice1)


# dataOp = mlogit.data(operate_data, shape = "wide", varying = 9:18, choice = "mode")
# ml.choice = mlogit(mode ~ recent + replygap + unresolved + stackflow| cmts + aus + Cfile +  closeness2react  + closeness_author2react + closeness2angular  + closeness_author2angular,dataOp)
# #+ existingtime closeness2angular + + closeness_author2angular + cumulative +
# summary(ml.choice)
# 
# ##############trying to give predictions
# 
# # give you probability
# predict(ml.choice,dataOp[c(1,2),])
# 
# #M = dataOp[c(1,2),]
# 
# 
# 
# #M = dataOp[c(1,2),]
# # the medium
# angular.dataOp = dataOp1[seq(1,nrow(dataOp1),2),]
# react.dataOp = dataOp1[seq(2,nrow(dataOp1),2),]
# 
# angular.M = sapply(angular.dataOp,median)
# react.M = sapply(react.dataOp,median)
# 
# median(dataOp1$stackflowq20)
# quantile(dataOp1$stackflowq20)
# 
# #angular.M = angular.M %>% as.data.frame()
# #react.M = react.M %>% as.data.frame()
# #angular.M$alt = c("angular")
# #react.M$alt = c("react")
# #M = cbind(angular.M,react.M)
# #M = t(M)
# #M = as.data.frame((M))
# X = data.frame(angular.M )
# Y = data.frame(react.M)
# l = list(X,Y)
# M = data.frame(t(data.frame(l)))
# M$alt[1] = "angular"
# M$alt[2] = "react"
# 
# predict(ml.choice1,M)
# #stackexchange
# st = M
# st$stackflowq20 = c(157,157)
# predict(ml.choice1,st)
# 
# C1 = M
# C1$Cfile = c(1,1)
# predict(ml.choice1,C1)
# 
# cmt2 = M
# cmt2$cmts = 10 * cmt2$cmts
# predict(ml.choice,cmt2)
# 
# dp2 = M
# dp2$closeness2react = 1 + dp2$closeness2react
# predict(ml.choice,dp2)
# 
# da2 = M
# da2$closeness_author2react = 1 + da2$closeness_author2react
# predict(ml.choice,da2)
# 
# 
# A.M =sapply(operate_data,median)
# MK = data.frame(t(data.frame(A.M)))
# B.M = sapply(operate_data,mean)
# MP = data.frame(t(data.frame(B.M)))
# MK = rbind(MK,MP)
# MK$mode = c("angular","react")
# #MK$mode = c("react","angular")
# MK.dataOp = mlogit.data(MK, shape = "wide", varying = 9:22, choice = "mode")
# predict(ml.choice1,MK.dataOp[-c(3,4),])
# 
# rdQuatile = MK
# rdQuatile$stackflowq20.angular = c(157,157)
# rdQuatile$stackflowq20.react = c(157,157)
# rdQuatile.dataOp = mlogit.data(rdQuatile, shape = "wide", varying = 9:22, choice = "mode")
# predict(ml.choice1,rdQuatile.dataOp[-c(3,4),])
# 

#dataOp1 = mlogit.data(operate_data, shape = "wide", varying = 9:22, choice = "mode")
#M = rbind(angular.M,react.M)
#M$alt = as.character(M$alt)

#fitted(ml.choice)
#alternative specific variables: cumulative, recent, fast
#individual specific variables: cmts, aus
#then the result will be just relevant to fast ... the choice?

#wait, the fast variable is problematic