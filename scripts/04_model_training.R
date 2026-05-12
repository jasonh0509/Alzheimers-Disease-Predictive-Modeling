################################################################################
# 04_model_training.R
# Purpose: Fit/tune model components that are needed before repeated evaluation,
#          including LASSO lambda selection, kNN k tuning, and GBM grid training.
################################################################################

### Lasso

## Conduct CV to find the best lambda for LASSO.
set.seed(1234)
library(glmnet)
grid <- 10^seq(10, -2, length = 100)
train_y.lasso <- train_y %>% mutate(Diagnosis = as.factor(Diagnosis))
train_x_lasso <- as.matrix(train_x)
lasso.mod <- glmnet(train_x_lasso, train_y.lasso$Diagnosis,
                    alpha = 1, lambda = grid, family = "binomial")

summary(lasso.mod)
cv.out <- cv.glmnet(train_x_lasso, train_y.lasso$Diagnosis,
                    alpha = 1, family = "binomial", nfolds = 10)
plot(cv.out)
best_lambda <- cv.out$lambda.min; best_lambda
lasso_coefs <- coef(cv.out, s = "lambda.min"); lasso_coefs

## Final LASSO model using selected lambda.
train_y <- as.matrix(train_y)
lasso.final <- glmnet(train_x_lasso, train_y.lasso$Diagnosis,
                      alpha = 1, lambda = best_lambda, family = "binomial")
# coef(lasso.final)
# testP<-predict(lasso.final,newx=as.matrix(test.fold%>%select(-Diagnosis)),type = "response");testP

### kNN

## Tune k across candidate values.
set.seed(12345)
k_list <- seq(1, 20, by = 1)
nk <- length(k_list); nk
Perf.Metric.knn <- data.frame(k = rep(0, nk),
                              Recall = rep(0, length(k_list)),
                              Precision = rep(0, length(k_list)),
                              F1_Score = rep(0, length(k_list)),
                              Accuracy = rep(0, length(k_list)))

set.seed(12345)
n <- nrow(alzh_secondKNN)
pool <- rep(1:10, ceiling(n / 10))
fold <- sample(pool, n, replace = FALSE)

for (k in 1:nk) {
  Perf.Metric.knn$k[k] <- k

  recall.sum <- 0
  precision.sum <- 0
  f1_score.sum <- 0
  accuracy.sum <- 0

  for (i in 1:10) {
    ## Find data in each fold.
    infold <- which(fold == i)

    ## Create training and testing sets.
    Train <- alzh_secondKNN[-infold, ]
    Test <- alzh_secondKNN[infold, ]

    ## Run kNN.
    k_preds <- knn(Train %>% select(-Diagnosis), Test %>% select(-Diagnosis),
                   k = k, cl = Train$Diagnosis)

    Recall <- sum(k_preds == 1 & Test$Diagnosis == 1) / sum(Test$Diagnosis == 1); recall.sum <- recall.sum + Recall
    Precision <- sum(k_preds == 1 & Test$Diagnosis == 1) / sum(k_preds == 1); precision.sum <- precision.sum + Precision
    F1_Score <- 2 * Precision * Recall / (Precision + Recall); f1_score.sum <- f1_score.sum + F1_Score
    Accuracy <- sum(k_preds == Test$Diagnosis) / length(Test$Diagnosis); accuracy.sum <- accuracy.sum + Accuracy
  }

  Perf.Metric.knn$Recall[k] <- recall.sum / 10
  Perf.Metric.knn$Precision[k] <- precision.sum / 10
  Perf.Metric.knn$F1_Score[k] <- f1_score.sum / 10
  Perf.Metric.knn$Accuracy[k] <- accuracy.sum / 10
}

Perf.Metric.knn$k[which.max(Perf.Metric.knn$Recall)]
Perf.Metric.knn

### GBM

#### Tune Together with 10 fold cv

### Grid Creation
train.control <- trainControl(method = "cv", number = 10,
                              summaryFunction = twoClassSummary,
                              classProbs = TRUE, savePredictions = TRUE)
grid <- expand.grid(shrinkage = lambda_val,
                    n.trees = ntree_val,
                    interaction.depth = 4,
                    n.minobsinnode = 10) ## default is 10

set.seed(12345)
Boosting_alzh_grid <- train(
  Diagnosis ~ .,
  data = ALZH.gbm.forGrid,
  method = "gbm",
  trControl = train.control,
  tuneGrid = grid,
  distribution = "bernoulli",
  metric = "ROC",
  verbose = FALSE,
  train.fraction = 0.9
)

gridTrainResult <- as.data.frame(Boosting_alzh_grid$results)
gridTrainResult[which.max(gridTrainResult$Sens), ]
Boosting_alzh_grid$bestTune
