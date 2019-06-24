setwd('/home/yuxing/Result_choicemodel/angularVSreact')

CMTsAus.datatable = read.csv2(file = "numofCMTsAusuptothatPoint.filter3",header = FALSE)
AusRecs.datatable = read.csv2(file = "numofPrjsAcuRec.filter3",header = FALSE)
AusRecsCross.datatable = read.csv2(file = "numofPrjsAcuRecCross.filter3.1to2",header = FALSE)
Cfiles.datatable = read.csv2(file = "ContainCfiles.filter3",header = FALSE)
replygap.datatable = read.csv2(file = "firsttimereply.ready1.filter3",header = FALSE)
#close.datatable = read.csv2(file = "close.ready.filter2",header = FALSE)
unresolved.datatable = read.csv2(file = "unresolvedNum1.filter3",header = FALSE)
stackflow.datatable = read.csv2(file = "stackoverflow_prj2both.1.filter3",header = FALSE)
#???existingtime.datatable = read.csv2(file = "existingtime1.filter2",header = FALSE)
#network variables
closeness.datatable = read.csv2(file = "closeness2both.1.filter3",header = FALSE)
closeness_author.datatable = read.csv2(file = "closeness_author2both.1.filter3",header = FALSE)


#CMTsAus.tidy = read.csv2(file = "numofCMTsAusuptothatPoint2.filter2",header = FALSE)
CMTsAus.tidy = read.csv2(file = "numofCMTsAusuptothatPoint2.filter3",header = FALSE)
AusRecs.tidy = read.csv2(file = "numofPrjsAcuRec2.filter3",header = FALSE)
AusRecsCross.tidy = read.csv2(file = "numofPrjsAcuRecCross.filter3.2to1",header = FALSE)
Cfiles.tidy = read.csv2(file = "ContainCfiles2.filter3",header = FALSE)
replygap.tidy = read.csv2(file = "firsttimereply.ready2.filter3",header = FALSE)
#close.tidy = read.csv2(file = "close.ready2.filter2",header = FALSE)
unresolved.tidy = read.csv2(file = "unresolvedNum2.filter3",header = FALSE)
stackflow.tidy = read.csv2(file = "stackoverflow_prj2both.2.filter3",header = FALSE)
#???existingtime.tidy = read.csv2(file = "existingtime2.filter2",header = FALSE)

closeness.tidy = read.csv2(file = "closeness2both.2.filter3",header = FALSE)
closeness_author.tidy = read.csv2(file = "closeness_author2both.2.filter3",header = FALSE)


# qes_0.datatable =read.csv2(file = "stackoverflow_prj2both.1.0qes.filter2",header = FALSE)
# qes_5.datatable =read.csv2(file = "stackoverflow_prj2both.1.5qes.filter2",header = FALSE)
# qes_20.datatable =read.csv2(file = "stackoverflow_prj2both.1.20qes.filter2",header = FALSE)
# qes_0.tidy =read.csv2(file = "stackoverflow_prj2both.2.0qes.filter2",header = FALSE)
# qes_5.tidy =read.csv2(file = "stackoverflow_prj2both.2.5qes.filter2",header = FALSE)
# qes_20.tidy =read.csv2(file = "stackoverflow_prj2both.2.20qes.filter2",header = FALSE)
# 
# ans_0.datatable =read.csv2(file = "stackoverflow_prj2both.1.0ans.filter2",header = FALSE)
# ans_5.datatable =read.csv2(file = "stackoverflow_prj2both.1.5ans.filter2",header = FALSE)
# ans_20.datatable =read.csv2(file = "stackoverflow_prj2both.1.20ans.filter2",header = FALSE)
# ans_0.tidy =read.csv2(file = "stackoverflow_prj2both.2.0ans.filter2",header = FALSE)
# ans_5.tidy =read.csv2(file = "stackoverflow_prj2both.2.5ans.filter2",header = FALSE)
# ans_20.tidy =read.csv2(file = "stackoverflow_prj2both.2.20ans.filter2",header = FALSE)
# 
# 
# 
# #for (i in c(qes_0.datatable,qes_5.datatable,qes_20.datatable,qes_0.tidy,qes_5.tidy,qes_20.tidy,
# #            ans_0.datatable,ans_5.datatable,ans_20.datatable,ans_0.tidy,ans_5.tidy,ans_20.tidy)){}
# 
# colnames(qes_0.datatable) = c('prjs','stackflow.datatable.q0','stackflow.tidy.q0')  
# colnames(qes_5.datatable) = c('prjs','stackflow.datatable.q5','stackflow.tidy.q5')
# colnames(qes_20.datatable) = c('prjs','stackflowq20.datatable','stackflowq20.tidy')
# colnames(qes_0.tidy) = c('prjs','stackflow.datatable.q0','stackflow.tidy.q0')
# colnames(qes_5.tidy) = c('prjs','stackflow.datatable.q5','stackflow.tidy.q5')
# colnames(qes_20.tidy) = c('prjs','stackflowq20.datatable','stackflowq20.tidy')
# 
# 
# colnames(ans_0.datatable) = c('prjs','stackflow.datatable.a0','stackflow.tidy.a0')  
# colnames(ans_5.datatable) = c('prjs','stackflow.datatable.a5','stackflow.tidy.a5')
# colnames(ans_20.datatable) = c('prjs','stackflowa20.datatable','stackflowa20.tidy')
# colnames(ans_0.tidy) = c('prjs','stackflow.datatable.a0','stackflow.tidy.a0')
# colnames(ans_5.tidy) = c('prjs','stackflow.datatable.a5','stackflow.tidy.a5')
# colnames(ans_20.tidy) = c('prjs','stackflowa20.datatable','stackflowa20.tidy')
# 
# library(dplyr)
# 
# Mixs1 = inner_join(qes_0.datatable,qes_5.datatable,by = 'prjs')
# Mixs2 = inner_join(ans_0.datatable,ans_5.datatable,by = 'prjs')
# Mixs.full = inner_join(Mixs1,Mixs2,by="prjs")
# Mixs.full = inner_join(Mixs.full,qes_20.datatable,by="prjs")  
# Mixs.full = inner_join(Mixs.full,ans_20.datatable,by="prjs")

#merge parts
colnames(CMTsAus.datatable) = c('prjs','cmts','aus')
colnames(CMTsAus.tidy) = c('prjs','cmts','aus')
colnames(AusRecs.datatable) = c('prjs','cumulative.datatable','recent.datatable')
colnames(AusRecsCross.datatable) = c('prjs','cumulative.tidy','recent.tidy')
colnames(AusRecs.tidy) = c('prjs','cumulative.tidy','recent.tidy')
colnames(AusRecsCross.tidy) = c('prjs','cumulative.datatable','recent.datatable')
colnames(Cfiles.datatable) = c('prjs', 'Cfile')
colnames(Cfiles.tidy) = c('prjs', 'Cfile')
colnames(replygap.datatable) = c('prjs','replygap.datatable','replygap.tidy')
colnames(replygap.tidy) = c('prjs','replygap.datatable','replygap.tidy')
#colnames(close.datatable) = c('prjs','close.datatable','close.tidy')
#colnames(close.tidy) = c('prjs','close.datatable','close.tidy')
colnames(unresolved.datatable) = c('prjs','unresolved.datatable','unresolved.tidy')
colnames(unresolved.tidy) = c('prjs','unresolved.datatable','unresolved.tidy')
colnames(stackflow.datatable) = c('prjs','stackflow.datatable','stackflow.tidy')
colnames(stackflow.tidy) = c('prjs','stackflow.datatable','stackflow.tidy')
#colnames(existingtime.tidy) = c('prjs','existingtime')
#colnames(existingtime.datatable) = c('prjs','existingtime')
colnames(closeness.datatable) = c('prjs','closeness2datatable','closeness2tidy')
colnames(closeness.tidy) = c('prjs','closeness2datatable','closeness2tidy')
colnames(closeness_author.datatable) = c('prjs','closeness_author2datatable','closeness_author2tidy')
colnames(closeness_author.tidy) = c('prjs','closeness_author2datatable','closeness_author2tidy')

replygap.tidy = transform(replygap.tidy,replygap.datatable= as.numeric(as.character(replygap.datatable)),
                          replygap.tidy= as.numeric(as.character(replygap.tidy)))
replygap.datatable = transform(replygap.datatable,replygap.datatable= as.numeric(as.character(replygap.datatable)),
                               replygap.tidy= as.numeric(as.character(replygap.tidy)))
unresolved.datatable = transform(unresolved.datatable,unresolved.datatable= as.numeric(as.character(unresolved.datatable)),
                                 unresolved.tidy= as.numeric(as.character(unresolved.tidy)))
unresolved.tidy = transform(unresolved.tidy,unresolved.datatable= as.numeric(as.character(unresolved.datatable)),
                            unresolved.tidy= as.numeric(as.character(unresolved.tidy)))
closeness_author.datatable = transform(closeness_author.datatable,closeness_author2datatable= as.numeric(as.character(closeness_author2datatable)),
                                       closeness_author2tidy= as.numeric(as.character(closeness_author2tidy)))
closeness_author.tidy = transform(closeness_author.tidy,closeness_author2datatable= as.numeric(as.character(closeness_author2datatable)),
                                  closeness_author2tidy= as.numeric(as.character(closeness_author2tidy)))
#close.datatable = transform(close.datatable,close.datatable= as.numeric(as.character(close.datatable)),
#                            close.tidy= as.numeric(as.character(close.tidy)))
#close.tidy = transform(close.tidy,close.datatable= as.numeric(as.character(close.datatable)),
#                            close.tidy= as.numeric(as.character(close.tidy)))

closeness.datatable = transform(closeness.datatable,closeness2datatable= as.numeric(as.character(closeness2datatable)),
                                closeness2tidy= as.numeric(as.character(closeness2tidy)))
closeness.tidy = transform(closeness.tidy,closeness2datatable= as.numeric(as.character(closeness2datatable)),
                           closeness2tidy= as.numeric(as.character(closeness2tidy)))

#fill closeness for projects that have no relation to dependency network



#closeness.tidy = 


#AusRecs.datatable
#AusRecsCross.datatable
####################
V1 = AusRecs.datatable[,2]/(AusRecs.datatable[,2]+AusRecsCross.datatable[,2])
V2 = AusRecsCross.datatable[,2]/(AusRecs.datatable[,2]+AusRecsCross.datatable[,2])
V3 = AusRecs.datatable[,3]/(AusRecs.datatable[,3]+AusRecsCross.datatable[,3])
V4 = AusRecsCross.datatable[,3]/(AusRecs.datatable[,3]+AusRecsCross.datatable[,3])
AusRecs.datatable[,2] = V1
AusRecs.datatable[,3] = V3
AusRecsCross.datatable[,2] = V2
AusRecsCross.datatable[,3] = V4

#for tidy
V1 = AusRecs.tidy[,2]/(AusRecs.tidy[,2]+AusRecsCross.tidy[,2])
V2 = AusRecsCross.tidy[,2]/(AusRecs.tidy[,2]+AusRecsCross.tidy[,2])
V3 = AusRecs.tidy[,3]/(AusRecs.tidy[,3]+AusRecsCross.tidy[,3])
V4 = AusRecsCross.tidy[,3]/(AusRecs.tidy[,3]+AusRecsCross.tidy[,3])
AusRecs.tidy[,2] = V1
AusRecs.tidy[,3] = V3
AusRecsCross.tidy[,2] = V2
AusRecsCross.tidy[,3] = V4
####################
removeNa <- function(d,v){
  d[is.na(d)] <- v
  return (d)
}

AusRecs.datatable = removeNa(AusRecs.datatable,0.5)
AusRecs.tidy  = removeNa(AusRecs.tidy,0.5)
AusRecsCross.datatable = removeNa(AusRecsCross.datatable,0.5)
AusRecsCross.tidy = removeNa(AusRecsCross.tidy,0.5)


closeness.datatable = merge(x = CMTsAus.datatable,y=closeness.datatable,by = 'prjs',all = TRUE)
closeness.datatable = removeNa(closeness.datatable,0)[,c(-2,-3)]
closeness.tidy = merge(x = CMTsAus.tidy,y=closeness.tidy,by = 'prjs',all = TRUE)
closeness.tidy = removeNa(closeness.tidy,0)[,c(-2,-3)]

closeness_author.datatable = merge(x = CMTsAus.datatable,y=closeness_author.datatable,by = 'prjs',all = TRUE)
closeness_author.datatable = removeNa(closeness_author.datatable,0)[,c(-2,-3)]
closeness_author.tidy = merge(x = CMTsAus.tidy,y=closeness_author.tidy,by = 'prjs',all = TRUE)
closeness_author.tidy = removeNa(closeness_author.tidy,0)[,c(-2,-3)]

#qes_20.datatable[,2] = qes_20.datatable[,2]/(qes_20.datatable[,2]+qes_20.datatable[,3])
#qes_20.datatable[,3] = 1 - qes_20.datatable[,2]
#qes_20.tidy[,2] = qes_20.tidy[,2]/(qes_20.tidy[,2]+qes_20.tidy[,3])
#qes_20.tidy[,3] = 1 - qes_20.tidy[,2]

#ans_20.datatable[,2] = ans_20.datatable[,2]/(ans_20.datatable[,2]+ans_20.datatable[,3])
#ans_20.datatable[,3] = 1 - ans_20.datatable[,2]
#ans_20.tidy[,2] = ans_20.tidy[,2]/(ans_20.tidy[,2]+ans_20.tidy[,3])
#ans_20.tidy[,3] = 1 - ans_20.tidy[,2]

#stackflow.datatable[,2] = stackflow.datatable[,2]/(stackflow.datatable[,2]+stackflow.datatable[,3])
#stackflow.datatable[,3] = 1 - stackflow.datatable[,2]
#stackflow.tidy[,2] = stackflow.tidy[,2]/(stackflow.tidy[,2]+stackflow.tidy[,3])
#stackflow.tidy[,3] = 1 - stackflow.tidy[,2]

#contains negative numbers, on idea y
#existingtime.datatable[existingtime.datatable$existingtime < 0,2] = 0
#existingtime.datatable$existingtime =  existingtime.datatable$existingtime/3600/24
#existingtime.tidy[existingtime.tidy$existingtime < 0,2] = 0
#existingtime.tidy$existingtime =  existingtime.datatable$tidy/3600/24

# replaceNAstack1 = read.csv('replaceNA.stackoverflow.1',header = FALSE)
# replaceNAstack2 = read.csv('replaceNA.stackoverflow.2',header = FALSE)
# colnames(replaceNAstack1) = c('prjs')
# colnames(replaceNAstack2) = c('prjs')
# stackflow.datatable[stackflow.datatable[,1] %in% replaceNAstack1[,1],c(2,3)] = NA
# stackflow.tidy[stackflow.tidy[,1] %in% replaceNAstack2[,1],c(2,3)] = NA

datatable.1 = merge(x = CMTsAus.datatable, y = Cfiles.datatable, by = "prjs", all = TRUE)
#datatable.6 = merge(x = datatable.1, y = existingtime.datatable, by = "prjs", all = TRUE)
datatable.7 = merge(x = datatable.1, y = closeness.datatable, by = "prjs", all = TRUE)
datatable.8 = merge(x = datatable.7, y = closeness_author.datatable, by = "prjs", all = TRUE)
datatable.2 = merge(x = datatable.8, y = AusRecs.datatable, by = "prjs", all = TRUE)
datatable.3 = merge(x = datatable.2, y = AusRecsCross.datatable, by = "prjs", all = TRUE)
#datatable.3 = merge(x = datatable.2, y = Cfiles.datatable, by = "prjs", all = TRUE)
datatable.4 = merge(x = datatable.3, y = replygap.datatable, by = "prjs", all = TRUE)
#datatable = merge(x = datatable.4, y = close.datatable, by = "prjs", all = TRUE)
datatable.5 = merge(x = datatable.4, y = unresolved.datatable, by = "prjs", all = TRUE)
#datatable.6 = merge(x = datatable.5, y = qes_20.datatable, by = "prjs", all = TRUE)
#datatable.7 = merge(x = datatable.6, y =  ans_20.datatable, by = "prjs", all = TRUE)
datatable = merge(x = datatable.5, y = stackflow.datatable, by = "prjs", all = TRUE)
#qes_20.tidy

tidy.1 = merge(x = CMTsAus.tidy, y = Cfiles.tidy, by = "prjs", all = TRUE)
#tidy.6 = merge(x = tidy.1, y = existingtime.tidy, by = "prjs", all = TRUE)
tidy.7 = merge(x = tidy.1, y = closeness.tidy, by = "prjs", all = TRUE)
tidy.8 = merge(x = tidy.7, y = closeness_author.tidy, by = "prjs", all = TRUE)
tidy.2 = merge(x = tidy.8, y = AusRecs.tidy, by = "prjs", all = TRUE)
tidy.3 = merge(x = tidy.2, y = AusRecsCross.tidy, by = "prjs", all = TRUE)
#tidy.3 = merge(x = tidy.2, y = Cfiles.tidy, by = "prjs", all = TRUE)
tidy.4 = merge(x = tidy.3, y = replygap.tidy, by = "prjs", all = TRUE)
#tidy = merge(x = tidy.4, y = close.tidy, by = "prjs", all = TRUE)
tidy.5 = merge(x = tidy.4, y = unresolved.tidy, by = "prjs", all = TRUE)
#tidy.6 = merge(x = tidy.5, y = qes_20.tidy, by = "prjs", all = TRUE)
#tidy.7 = merge(x = tidy.6, y = ans_20.tidy, by = "prjs", all = TRUE)
tidy = merge(x = tidy.5, y = stackflow.tidy, by = "prjs", all = TRUE)
#test if any overlaps occur
#nrow(merge(x = datatable, y = tidy, by = "prjs", all = FALSE)) == 105 (only from 2015 -- 2016)
#so actully there are some overlaps ()


#just ignore that at this point
#let's add one column + fast
datatable$mode = rep('datatable',nrow(datatable))
tidy$mode = rep('tidy',nrow(tidy))

operate_data.replicate = rbind(datatable,tidy)
operate_data = operate_data.replicate[!duplicated(operate_data.replicate$prjs),]
operate_data = operate_data[,-1]
#rbind(datatable,tidy)[,-1]
library('mlogit')

##
operate_data = na.omit(operate_data)
##
# tune the format
a = operate_data$recent.datatable
operate_data$recent.datatable = operate_data$cumulative.tidy
operate_data$cumulative.tidy = a

colnames(operate_data)[9] = 'cumulative.tidy'
colnames(operate_data)[10] = 'recent.datatable'


save(file = 'datatable_for_TD.Rda',operate_data)


dataOp1 = mlogit.data(operate_data, shape = "wide", varying = 8:17, choice = "mode")
ml.choice1 = mlogit(mode ~  cumulative + replygap + unresolved + stackflow  |   cmts +  aus + Cfile + closeness2datatable + closeness2tidy + closeness_author2tidy + closeness_author2datatable,dataOp1)
#+ existingtime closeness2datatable + + closeness_author2datatable + cumulative + stackflowq20 +stackflow  + stackflowq20 +  +stackflow
# recent , cumulative
# + closeness2datatable
#  + +closeness_author2tidy   + closeness_author2datatable
# + replygap + unresolved + stackflow
# cmts + aus + Cfile +
# cumulative +
# +  closeness2tidy 
# cmts + aus +
summary(ml.choice1)











# 
# 
# 
# dataOp = mlogit.data(operate_data, shape = "wide", varying = 9:18, choice = "mode")
# ml.choice = mlogit(mode ~ recent + replygap + unresolved + stackflow| cmts + aus + Cfile +  closeness2tidy  + closeness_author2tidy + closeness2datatable  + closeness_author2datatable,dataOp)
# #+ existingtime closeness2datatable + + closeness_author2datatable + cumulative +
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
# datatable.dataOp = dataOp1[seq(1,nrow(dataOp1),2),]
# tidy.dataOp = dataOp1[seq(2,nrow(dataOp1),2),]
# 
# datatable.M = sapply(datatable.dataOp,median)
# tidy.M = sapply(tidy.dataOp,median)
# 
# median(dataOp1$stackflowq20)
# quantile(dataOp1$stackflowq20)
# 
# #datatable.M = datatable.M %>% as.data.frame()
# #tidy.M = tidy.M %>% as.data.frame()
# #datatable.M$alt = c("datatable")
# #tidy.M$alt = c("tidy")
# #M = cbind(datatable.M,tidy.M)
# #M = t(M)
# #M = as.data.frame((M))
# X = data.frame(datatable.M )
# Y = data.frame(tidy.M)
# l = list(X,Y)
# M = data.frame(t(data.frame(l)))
# M$alt[1] = "datatable"
# M$alt[2] = "tidy"
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
# dp2$closeness2tidy = 1 + dp2$closeness2tidy
# predict(ml.choice,dp2)
# 
# da2 = M
# da2$closeness_author2tidy = 1 + da2$closeness_author2tidy
# predict(ml.choice,da2)
# 
# 
# A.M =sapply(operate_data,median)
# MK = data.frame(t(data.frame(A.M)))
# B.M = sapply(operate_data,mean)
# MP = data.frame(t(data.frame(B.M)))
# MK = rbind(MK,MP)
# MK$mode = c("datatable","tidy")
# #MK$mode = c("tidy","datatable")
# MK.dataOp = mlogit.data(MK, shape = "wide", varying = 9:22, choice = "mode")
# predict(ml.choice1,MK.dataOp[-c(3,4),])
# 
# rdQuatile = MK
# rdQuatile$stackflowq20.datatable = c(157,157)
# rdQuatile$stackflowq20.tidy = c(157,157)
# rdQuatile.dataOp = mlogit.data(rdQuatile, shape = "wide", varying = 9:22, choice = "mode")
# predict(ml.choice1,rdQuatile.dataOp[-c(3,4),])
# 

#dataOp1 = mlogit.data(operate_data, shape = "wide", varying = 9:22, choice = "mode")
#M = rbind(datatable.M,tidy.M)
#M$alt = as.character(M$alt)

#fitted(ml.choice)
#alternative specific variables: cumulative, recent, fast
#individual specific variables: cmts, aus
#then the result will be just relevant to fast ... the choice?

#wait, the fast variable is problematic