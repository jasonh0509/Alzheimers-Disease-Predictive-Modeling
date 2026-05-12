################################################################################
# 03_feature_engineering_selection.R
# Purpose: Create model-specific datasets, screen cholesterol variables, run
#          best subset selection, and prepare feature sets for logistic, LASSO,
#          kNN, and GBM models.
################################################################################

### Exploration of Correlation of 4 Related Variables

## 4 logistic regression models with only response and one of the 4 cholesterol variables.
hdl.logistic <- glm(Diagnosis ~ CholesterolHDL, data = ALZH_for_explore, family = binomial); summary(hdl.logistic)
ldl.logistic <- glm(Diagnosis ~ CholesterolLDL, data = ALZH_for_explore, family = binomial); summary(ldl.logistic)
total.logistic <- glm(Diagnosis ~ CholesterolTotal, data = ALZH_for_explore, family = binomial); summary(total.logistic)
tryglycerides.logistic <- glm(Diagnosis ~ CholesterolTriglycerides, data = ALZH_for_explore, family = binomial); summary(tryglycerides.logistic)

## HDL is most correlated with the response variable.

### Logistic

## Dataset for logistic regression directly derived from ALZH.gbm,
## but with 3 cholesterol variables removed due to issues of multicolinearity they can introduce
ALZH.logistic <- ALZH.gbm %>% select(-c(CholesterolTotal, CholesterolLDL, CholesterolTriglycerides))
ALZH.logistic$Diagnosis <- as.factor(ALZH.logistic$Diagnosis)
n <- nrow(ALZH.logistic); n

#set.seed(114514)
draw <- (1:2149)

train <- ALZH.logistic[draw, ]
train_x <- train %>% dplyr::select(-Diagnosis)
train_y <- train %>% dplyr::select(Diagnosis)

x <- model.matrix(Diagnosis ~ ., data = ALZH.logistic)
y <- ALZH.logistic$Diagnosis

### MLR with best subset

## Best subset selection.
# ALZH_leanning<-ALZH_noID%>%dplyr::select(-DoctorInCharge)
ALZH_leanning <- ALZH.logistic
bestsubset <- regsubsets(Diagnosis ~ ., data = ALZH_leanning)
bestsubsum <- summary(bestsubset)
bestsubsum
which.min(bestsubsum$cp)
which.min(bestsubsum$bic)
which.min(bestsubsum$adjr2)

knitr::kable(coef(bestsubset, 8))
bestSubset_vars <- names(coef(bestsubset, 8))[-1]
bestSubset_vars

### A MLR with best subset
set.with.BestsubsetVar <- ALZH.logistic %>%
  dplyr::select(Diagnosis, Age, SleepQuality, CholesterolHDL, MMSE,
                FunctionalAssessment, MemoryComplaints, BehavioralProblems, ADL)

### kNN

## Separate integer, double, numeric, and factor datasets.
ALZH_IntOnly <- ALZH_noID[, sapply(ALZH.gbm, is.integer)]
ALZH_double <- ALZH_noID[, sapply(ALZH.gbm, is.double)]
ALZH_NumOnly <- cbind(ALZH_IntOnly, ALZH_double)
ALZH_fct <- ALZH_noID[, sapply(ALZH.gbm, is.factor)]

#### Feature Selection for kNN
RFE.featureSet <- ALZH_NumOnly[draw, -which(names(ALZH_NumOnly) == "Diagnosis")]
RFE.featureSet <- RFE.featureSet[, -which(names(RFE.featureSet) == "DoctorInCharge")]
RFE.featureSet <- RFE.featureSet %>% select(-c(CholesterolTotal, CholesterolLDL, CholesterolTriglycerides))
RFE.response <- ALZH_NumOnly[draw, "Diagnosis"]

set.seed(12345)
control <- rfeControl(functions = rfFuncs, method = "cv", number = 10)
RFE.result <- rfe(RFE.featureSet, RFE.response, sizes = c(1:15), rfeControl = control)
print(RFE.result)

## alzh_secondKNN and the later alzh.gbm.forTuning are the same.
alzh_secondKNN <- ALZH_NumOnly[draw, ] %>%
  dplyr::select(FunctionalAssessment, MMSE, ADL, DietQuality, SleepQuality, Diagnosis) %>%
  mutate(Diagnosis = as.factor(Diagnosis))

alzh_secondKNN.test <- ALZH.gbm[-draw, ] %>%
  dplyr::select(FunctionalAssessment, MMSE, ADL, DietQuality, SleepQuality, Diagnosis) %>%
  mutate(Diagnosis = as.factor(Diagnosis))

### GBM
set.seed(12345)
ALZH.boosting <- ALZH.gbm %>% select(-c(CholesterolTotal, CholesterolLDL, CholesterolTriglycerides))

#### Tune Together with 10 fold cv
ALZH.gbm.forTuning <- ALZH.gbm[draw, ]
# ALZH.gbm.realTest<-ALZH.gbm[-draw,]

## Add an RFE step for GBM.
## This block was eval=FALSE/include=FALSE in the original Rmd and can be slow.
library(parallel)
library(doParallel)
rfe.featureGBM <- ALZH.gbm.forTuning[draw, -which(names(ALZH.gbm.forTuning) == "Diagnosis")]
rfe.featureGBM <- rfe.featureGBM %>% dplyr::select(-CholesterolTotal, -CholesterolHDL, -CholesterolLDL, -CholesterolTriglycerides)
RFE.responseGBM <- ALZH.gbm.forTuning[draw, "Diagnosis"]
RFE.responseGBM <- as.factor(RFE.responseGBM)

num_cores <- detectCores() - 1
cl2 <- makeCluster(num_cores)
registerDoParallel(cl2)

set.seed(1124)
control.gbm <- rfeControl(functions = rfFuncs, method = "cv", number = 10, allowParallel = TRUE)
RFE.result.gbm <- rfe(rfe.featureGBM, RFE.responseGBM, sizes = c(5, 6, 10, 15), rfeControl = control.gbm)
print(RFE.result.gbm)

stopCluster(cl2)

closeAllConnections()
unregister_dopar()

## GBM grid dataset creation.
set.seed(12345)
lambda_val <- seq(0.01, 0.05, by = 0.01)
ntree_val <- c(1000, 2000, 3000)

ALZH.gbm.forGrid <- ALZH.gbm.forTuning %>%
  select(c(FunctionalAssessment, ADL, MMSE, MemoryComplaints, BehavioralProblems, CholesterolHDL, Diagnosis))
ALZH.gbm.forGrid$Diagnosis <- factor(ALZH.gbm.forGrid$Diagnosis, levels = c(0, 1), labels = c("No", "Yes"))
ALZH.gbm.realTest <- ALZH.gbm[-draw, ] %>% select(-c(CholesterolTotal, CholesterolLDL, CholesterolTriglycerides))
