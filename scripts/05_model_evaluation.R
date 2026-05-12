################################################################################
# 05_model_evaluation.R
# Purpose: Run repeated cross-validation loops and calculate performance metrics
#          for MLR, best-subset MLR, LASSO, kNN, and GBM.
################################################################################

### Logistic / MLR repeated CV

## Repeated cv MLR.
set.seed(1234)

## Create metric containers.
# auc.values <- c()
# recall.val<-c()
# precision.val<-c()
# accuracy.val<-c()

recall.set <- c()
precision.set <- c()
accuracy.set <- c()
auc.set <- c()

for (r in 1:300) {
  # print(r)
  ## Create k-fold indices for this repeat.
  folds <- createFolds(ALZH.logistic$Diagnosis, k = 5)
  # print(folds)
  recall.vect <- c()
  precision.vect <- c()
  accuracy.vect <- c()
  auc.vect <- c()

  for (i in seq_along(folds)) {
    # print(i)
    # print(folds[[i]])
    test.index <- folds[[i]]
    train.index <- -test.index

    train.fold <- ALZH.logistic[train.index, ]
    test.fold <- ALZH.logistic[test.index, ]

    ## Fit the logistic regression model.
    model <- glm(Diagnosis ~ ., data = train.fold, family = binomial)

    ## Predictions and calculate probabilities on the test set.
    probs <- predict(model, test.fold, type = "response")

    ## Get class prediction.
    preds <- ifelse(probs > 0.5, 1, 0)

    ## Make sure it is factor.
    preds <- factor(preds, levels = c("0", "1"))
    actual <- factor(test.fold$Diagnosis, levels = c("0", "1"))

    ## Confusion matrix.
    mtx <- confusionMatrix(preds, actual, positive = "1")

    ## Get recall and precision and accuracy and auc value.
    recall <- sum(preds == "1" & actual == "1") / sum(actual == "1")
    # recall2<-mtx$byClass["Sensitivity"]
    recall.vect <- c(recall.vect, recall)
    # print(recall.vect)
    # print(recall)
    # print(recall2)
    precision <- mtx$byClass["Pos Pred Value"]
    precision.vect <- c(precision.vect, precision)

    accuracy <- mtx$overall["Accuracy"]
    accuracy.vect <- c(accuracy.vect, accuracy)

    roc.curve <- roc(test.fold$Diagnosis, probs)
    auc <- auc(roc.curve)
    auc.vect <- c(auc.vect, auc)
  }
  # print(recall.vect)
  # print(mean(recall.vect))
  recall.set <- c(recall.set, mean(recall.vect))
  precision.set <- c(precision.set, mean(precision.vect))
  accuracy.set <- c(accuracy.set, mean(accuracy.vect))
  auc.set <- c(auc.set, mean(auc.vect))
}

## MLR performance metrics.
mean.recall.final <- round(mean(recall.set), 3); mean.recall.final
CI.recall.final <- round(t.test(recall.set)$conf.int, 5); CI.recall.final

mean.precision.final <- round(mean(precision.set), 3); mean.precision.final
CI.precision.final <- round(t.test(precision.set)$conf.int, 5); CI.precision.final

mean.accuracy.final <- round(mean(accuracy.set), 3); mean.accuracy.final
CI.accuracy.final <- round(t.test(accuracy.set)$conf.int, 5); CI.accuracy.final

mean.auc.final <- round(mean(auc.set), 4); mean.auc.final
CI.auc.final <- round(t.test(auc.set)$conf.int, 5); CI.auc.final

### A MLR with best subset

## Repeated cv MLR bestsubset.
set.seed(1234)

## Create metric containers.
# auc.values <- c()
# recall.val<-c()
# precision.val<-c()
# accuracy.val<-c()

recall.set.sb <- c()
precision.set.sb <- c()
accuracy.set.sb <- c()
auc.set.sb <- c()

## Perform repeated cross-validation.
for (r in 1:300) {
  # cat("Iteration:", r, "\n")

  ## Create k-fold indices for this repeat.
  folds <- createFolds(set.with.BestsubsetVar$Diagnosis, k = 5)
  # print(folds)
  recall.vect.sb <- c()
  precision.vect.sb <- c()
  accuracy.vect.sb <- c()
  auc.vect.sb <- c()

  for (i in seq_along(folds)) {
    ## Get index for training and test sets.
    # print(folds[[i]])
    test.index <- folds[[i]]
    train.index <- -test.index

    train.fold <- set.with.BestsubsetVar[train.index, ]
    test.fold <- set.with.BestsubsetVar[test.index, ]

    ## Fit the logistic regression model.
    model <- glm(Diagnosis ~ ., data = train.fold, family = binomial)

    ## Get predictions and calculate probabilities on the test set.
    probs <- predict(model, test.fold, type = "response")
    preds <- ifelse(probs > 0.5, 1, 0)
    preds <- factor(preds, levels = c("0", "1"))
    actual <- factor(test.fold$Diagnosis, levels = c("0", "1"))

    ## Confusion matrix.
    mtx <- confusionMatrix(preds, actual, positive = "1")

    ## Get recall and precision and accuracy and auc value.
    recall <- sum(preds == "1" & actual == "1") / sum(actual == "1")
    # recall2<-mtx$byClass["Sensitivity"]
    recall.vect.sb <- c(recall.vect.sb, recall)
    # print(recall.vect)
    # print(recall)
    # print(recall2)
    precision <- mtx$byClass["Pos Pred Value"]
    precision.vect.sb <- c(precision.vect.sb, precision)
    # print(precision.vect)

    accuracy <- mtx$overall["Accuracy"]
    accuracy.vect.sb <- c(accuracy.vect.sb, accuracy)

    # test.fold$Diagnosis <- as.numeric(as.character(test.fold$Diagnosis))
    roc.curve <- roc(test.fold$Diagnosis, probs)
    auc <- auc(roc.curve)
    auc.vect.sb <- c(auc.vect.sb, auc)
  }
  # print(recall.vect)
  # print(mean(recall.vect))
  recall.set.sb <- c(recall.set.sb, mean(recall.vect.sb))
  precision.set.sb <- c(precision.set.sb, mean(precision.vect.sb))
  accuracy.set.sb <- c(accuracy.set.sb, mean(accuracy.vect.sb))
  auc.set.sb <- c(auc.set.sb, mean(auc.vect.sb))
}

## Best-subset MLR performance metrics.
mean.recallBestSub.final <- round(mean(recall.set.sb), 3); mean.recallBestSub.final
CI.recallSb.final <- round(t.test(recall.set.sb)$conf.int, 5); CI.recallSb.final

mean.precisionBestSub.final <- round(mean(precision.set.sb), 4); mean.precisionBestSub.final
CI.precisionSb.final <- round(t.test(precision.set.sb)$conf.int, 5); CI.precisionSb.final

mean.accuracySb.final <- round(mean(accuracy.set.sb), 4); mean.accuracySb.final
CI.accuracySb.final <- round(t.test(accuracy.set.sb)$conf.int, 5); CI.accuracySb.final

mean.aucSb.final <- round(mean(auc.set.sb), 4); mean.aucSb.final
CI.aucSb.final <- round(t.test(auc.set.sb)$conf.int, 5); CI.aucSb.final

### Lasso

## Repeated CV of Lasso.
set.seed(1234)

## Create metric containers.
# auc.values <- c()
# recall.val<-c()
# precision.val<-c()
# accuracy.val<-c()

recall.set.lasso <- c()
precision.set.lasso <- c()
accuracy.set.lasso <- c()
auc.set.lasso <- c()

## Nested loop doing repeated cv.
for (r in 1:300) {
  # print(r)

  ## Create k-folds.
  folds <- createFolds(ALZH.logistic$Diagnosis, k = 5)
  # print(folds)
  recall.vect.lasso <- c()
  precision.vect.lasso <- c()
  accuracy.vect.lasso <- c()
  auc.vect.lasso <- c()

  for (i in seq_along(folds)) {
    ## Get index for training and test sets.
    # print(folds[[i]])
    test.index <- folds[[i]]
    train.index <- -test.index

    train.fold <- ALZH.logistic[train.index, ]
    train.fold <- as.matrix(train.fold)
    test.fold <- ALZH.logistic[test.index, ]
    test.fold <- as.matrix(test.fold)

    ## Fit the lasso regression model.
    model <- glmnet(train.fold[, -30], train.fold[, 30],
                    alpha = 1, lambda = best_lambda, family = "binomial")
    # coef(model)

    ## Get predictions and calculate probabilities on the test set.
    probs <- predict(model, newx = test.fold[, -30], type = "response")
    # print(probs)
    preds <- ifelse(probs > 0.5, 1, 0)
    preds <- factor(preds, levels = c("0", "1"))
    actual <- factor(test.fold[, "Diagnosis"], levels = c("0", "1"))

    ## Confusion matrix.
    mtx <- confusionMatrix(preds, actual, positive = "1")

    ## Get recall and precision and accuracy and auc value.
    recall <- sum(preds == "1" & actual == "1") / sum(actual == "1")
    # recall2<-mtx$byClass["Sensitivity"]
    recall.vect.lasso <- c(recall.vect.lasso, recall)
    # print(recall.vect)
    # print(recall)
    # print(recall2)
    precision <- mtx$byClass["Pos Pred Value"]
    precision.vect.lasso <- c(precision.vect.lasso, precision)

    accuracy <- mtx$overall["Accuracy"]
    accuracy.vect.lasso <- c(accuracy.vect.lasso, accuracy)

    roc.curve <- roc(test.fold[, "Diagnosis"], probs)
    auc <- auc(roc.curve)
    auc.vect.lasso <- c(auc.vect.lasso, auc)
  }
  # print(recall.vect)
  # print(mean(recall.vect))
  recall.set.lasso <- c(recall.set.lasso, mean(recall.vect.lasso))
  precision.set.lasso <- c(precision.set.lasso, mean(precision.vect.lasso))
  accuracy.set.lasso <- c(accuracy.set.lasso, mean(accuracy.vect.lasso))
  auc.set.lasso <- c(auc.set.lasso, mean(auc.vect.lasso))
}

## LASSO performance metrics.
mean.recallLasso.final <- round(mean(recall.set.lasso), 4); mean.recallLasso.final
CI.recallLasso.final <- round(t.test(recall.set.lasso)$conf.int, 5); CI.recallLasso.final

mean.precisionLasso.final <- round(mean(precision.set.lasso), 4); mean.precisionLasso.final
CI.precisionLasso.final <- round(t.test(precision.set.lasso)$conf.int, 5); CI.precisionLasso.final

mean.accuracyLasso.final <- round(mean(accuracy.set.lasso), 4); mean.accuracyLasso.final
CI.accuracyLasso.final <- round(t.test(accuracy.set.lasso)$conf.int, 5); CI.accuracyLasso.final

mean.aucLasso.final <- round(mean(auc.set.lasso), 4); mean.aucLasso.final
CI.aucLasso.final <- round(t.test(auc.set.lasso)$conf.int, 5); CI.aucLasso.final

### kNN

set.seed(1234)

## Create metric containers.
# auc.values <- c()
# recall.val<-c()
# precision.val<-c()
# accuracy.val<-c()

recall.set.knn <- c()
precision.set.knn <- c()
accuracy.set.knn <- c()
auc.set.knn <- c()

## Perform repeated cross-validation.
for (r in 1:300) {
  ## Create k-fold indices for this repeat.
  folds <- createFolds(alzh_secondKNN$Diagnosis, k = 5)
  # print(folds)
  recall.vect.knn <- c()
  precision.vect.knn <- c()
  accuracy.vect.knn <- c()
  auc.vect.knn <- c()

  for (i in seq_along(folds)) {
    ## Get index for training and test sets.
    # print(folds[[i]])
    test.index <- folds[[i]]
    train.index <- -test.index

    train.fold <- alzh_secondKNN[train.index, ]
    test.fold <- alzh_secondKNN[test.index, ]

    ## Fit the knn regression model.
    model <- knn(train = train.fold %>% select(-Diagnosis),
                 test = test.fold %>% select(-Diagnosis),
                 cl = train.fold$Diagnosis, k = 1)

    ## Get predictions and calculate probabilities on the test set.
    # probs <- predict(model, test.fold, type = "response")
    # preds<-ifelse(probs>0.5,1,0)
    # preds <- factor(preds, levels = c("0", "1"))
    actual <- factor(test.fold$Diagnosis, levels = c("0", "1"))

    ## Confusion matrix.
    mtx <- confusionMatrix(model, actual, positive = "1")

    ## Get recall and precision and accuracy and auc value.
    recall <- sum(model == "1" & actual == "1") / sum(actual == "1")
    # recall2<-mtx$byClass["Sensitivity"]
    recall.vect.knn <- c(recall.vect.knn, recall)
    # print(recall.vect)
    # print(recall)
    # print(recall2)
    precision <- mtx$byClass["Pos Pred Value"]
    precision.vect.knn <- c(precision.vect.knn, precision)

    accuracy <- mtx$overall["Accuracy"]
    accuracy.vect.knn <- c(accuracy.vect.knn, accuracy)

    roc.curve <- roc(test.fold$Diagnosis, as.numeric(model))
    auc <- auc(roc.curve)
    auc.vect.knn <- c(auc.vect.knn, auc)
  }
  # print(recall.vect)
  # print(mean(recall.vect))
  recall.set.knn <- c(recall.set.knn, mean(recall.vect.knn))
  precision.set.knn <- c(precision.set.knn, mean(precision.vect.knn))
  accuracy.set.knn <- c(accuracy.set.knn, mean(accuracy.vect.knn))
  auc.set.knn <- c(auc.set.knn, mean(auc.vect.knn))
}

## kNN performance metrics.
mean.recallknn.final <- round(mean(recall.set.knn), 4); mean.recallknn.final
CI.recallknn.final <- round(t.test(recall.set.knn)$conf.int, 5); CI.recallknn.final

mean.precisionknn.final <- round(mean(precision.set.knn), 4); mean.precisionknn.final
CI.precisionknn.final <- round(t.test(precision.set.knn)$conf.int, 5); CI.precisionknn.final

mean.accuracyknn.final <- round(mean(accuracy.set.knn), 4); mean.accuracyknn.final
CI.accuracyknn.final <- round(t.test(accuracy.set.knn)$conf.int, 5); CI.accuracyknn.final

mean.aucknn.final <- round(mean(auc.set.knn), 4); mean.aucknn.final
CI.aucknn.final <- round(t.test(auc.set.knn)$conf.int, 5); CI.aucknn.final

### GBM

## True GBM CV.
alzh.forCI <- ALZH.gbm.forGrid
alzh.forCI <- alzh.forCI %>%
  mutate(Diagnosis = ifelse(Diagnosis == "Yes", 1, 0))
set.seed(1234)

## Create metric containers.
# auc.values <- c()
# recall.val<-c()
# precision.val<-c()
# accuracy.val<-c()

recall.set.gbm <- c()
precision.set.gbm <- c()
accuracy.set.gbm <- c()
auc.set.gbm <- c()

## Perform repeated cross-validation.
for (r in 1:300) {
  # print(r)

  ## Create k-fold indices for every iteration.
  folds <- createFolds(alzh.forCI$Diagnosis, k = 5)
  # print(folds)
  recall.vect.gbm <- c()
  precision.vect.gbm <- c()
  accuracy.vect.gbm <- c()
  auc.vect.gbm <- c()

  for (i in seq_along(folds)) {
    ## Get index for training and test sets.
    # print(folds[[i]])
    test.index <- folds[[i]]
    train.index <- -test.index

    train.fold <- alzh.forCI[train.index, ]
    test.fold <- alzh.forCI[test.index, ]

    ## Fit the logistic regression model.
    model <- gbm(Diagnosis ~ ., data = train.fold,
                 distribution = "bernoulli", n.trees = 1000,
                 interaction.depth = 4, shrinkage = 0.05)

    ## Get predictions and calculate probabilities on the test set.
    probs <- predict(model, test.fold, type = "response")
    preds <- ifelse(probs > 0.5, 1, 0)
    preds <- factor(preds, levels = c("0", "1"))
    actual <- factor(test.fold$Diagnosis, levels = c("0", "1"))

    ## Confusion matrix.
    mtx <- confusionMatrix(preds, actual, positive = "1")

    ## Get recall and precision and accuracy and auc value.
    recall <- sum(preds == "1" & actual == "1") / sum(actual == "1")
    # recall2<-mtx$byClass["Sensitivity"]
    recall.vect.gbm <- c(recall.vect.gbm, recall)
    # print(recall.vect)
    # print(recall)
    # print(recall2)
    precision <- mtx$byClass["Pos Pred Value"]
    precision.vect.gbm <- c(precision.vect.gbm, precision)

    accuracy <- mtx$overall["Accuracy"]
    accuracy.vect.gbm <- c(accuracy.vect.gbm, accuracy)

    roc.curve <- roc(test.fold$Diagnosis, probs)
    auc <- auc(roc.curve)
    auc.vect.gbm <- c(auc.vect.gbm, auc)
  }
  # print(recall.vect)
  # print(mean(recall.vect))
  recall.set.gbm <- c(recall.set.gbm, mean(recall.vect.gbm))
  precision.set.gbm <- c(precision.set.gbm, mean(precision.vect.gbm))
  accuracy.set.gbm <- c(accuracy.set.gbm, mean(accuracy.vect.gbm))
  auc.set.gbm <- c(auc.set.gbm, mean(auc.vect.gbm))
}

## GBM performance metrics.
mean.recallgbm.final <- round(mean(recall.set.gbm), 4); mean.recallgbm.final
CI.recallgbm.final <- round(t.test(recall.set.gbm)$conf.int, 5); CI.recallgbm.final

mean.precisiongbm.final <- round(mean(precision.set.gbm), 4); mean.precisiongbm.final
CI.precisiongbm.final <- round(t.test(precision.set.gbm)$conf.int, 5); CI.precisiongbm.final

mean.accuracygbm.final <- round(mean(accuracy.set.gbm), 4); mean.accuracygbm.final
CI.accuracygbm.final <- round(t.test(accuracy.set.gbm)$conf.int, 5); CI.accuracygbm.final

mean.aucgbm.final <- round(mean(auc.set.gbm), 4); mean.aucgbm.final
CI.aucgbm.final <- round(t.test(auc.set.gbm)$conf.int, 5); CI.aucgbm.final
