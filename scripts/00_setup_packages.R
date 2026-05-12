
##This chunk is only needed when running on Jason's laptop.If it is on Jason's device change eval=TRUE
options("install.lock"=FALSE)


###This is a function used to make sure cluster is terminated to avoid "invalid connection" error
unregister_dopar <- function() {
  env <- foreach:::.foreachGlobals
  rm(list=ls(name=env), pos=env)
}



library(xfun)



##These packages are needed for later code chunks,if you do not have the following packages installed, please run this chunk to ensure all packages needed are installed.
install.packages(c("ggplot2","broom","gridExtra","class","tidyverse","leaps","corrplot","RColorBrewer","glmnet","xtable","randomForest","pROC","devtools","UpSetR","naniar","report","rpart","rattle","rpart.plot","BART","DataExplorer","gbm"))
install.packages("randomForest")
install.packages("caret")
install.packages("yardstick")
install.packages("rtools")
install.packages("tree")
install.packages("doParallel")



##Here we load the packages needed
library(ggplot2)
library(broom)
library(gridExtra)
library(class)
library(tidyverse)
library(gridExtra)
library(leaps)
library(corrplot)
library(RColorBrewer)
library(glmnet)
library(xtable)
library(randomForest)
library(tree)
library(pROC)
#library(smotefamily)
library(devtools)
library(UpSetR)
library(naniar)
library(report)
library(rpart)
library(rattle)
library(rpart.plot)
library(DataExplorer)
library(BART)
library(gbm)
library(caret)
library(pROC)
library(doParallel)


