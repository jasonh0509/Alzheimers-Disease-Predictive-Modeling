################################################################################
# 06_results_reporting.R
# Purpose: Create model-specific and final comparison performance tables.
################################################################################

## Performance Metrics of MLR Model.
Metrics_MLR <- data.frame(
  Metrics = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "AUC", "AUC CI"
  ),
  Performances = c(
    "0.728", "(0.7273,0.7285)",
    "0.793", "(0.7919, 0.7931)",
    "0.836", "(0.8357, 0.8364)",
    "0.8979", "(0.8977, 0.8980)"
  )
)
knitr::kable(Metrics_MLR, caption = "Performance Metrics of MLR Model")

## Performance Metrics of MLR Model with best subset.
Metrics_bestsub <- data.frame(
  Metrics = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "AUC", "AUC CI"
  ),
  MLR_BestSubset = c("0.742", "(0.7416,0.7424)",
                     "0.8044", "(0.8040, 0.8047)",
                     "0.8446", "(0.8440, 0.8447)",
                     "0.903", "(0.90288, 0.90304)")
)
knitr::kable(Metrics_bestsub, caption = "Performance Metrics of MLR Model with Lasso")

## Performance Metrics of MLR Model with Lasso.
Metrics_lasso <- data.frame(
  Metrics = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "AUC", "AUC CI"
  ),
  Lasso = c("0.7286", "(0.7281,0.7290)",
            "0.8083", "(0.8078, 0.8088)",
            "0.8426", "(0.8423, 0.8428)",
            "0.9011", "(0.90105, 0.90125)")
)
knitr::kable(Metrics_lasso, caption = "Performance Metrics of MLR Model with Lasso")

## Performance Metrics of KNN Classifier.
Metrics_knn <- data.frame(
  Metrics = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "AUC", "AUC CI"
  ),
  KNN = c("0.637", "(0.6368,0.6387)",
          "0.642", "(0.6411, 0.6429)",
          "0.7458", "(0.7452, 0.7463)",
          "0.721", "(0.7207, 0.7218)")
)
knitr::kable(Metrics_knn, caption = "Performance Metrics of KNN Classifier")

## Performance Metrics of GBM Classifier.
Metrics_gbm <- data.frame(
  Metrics = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "AUC", "AUC CI"
  ),
  GBM = c("0.917", "(0.9169,0.9174)",
          "0.947", "(0.9464, 0.9469)",
          "0.9524", "(0.9523, 0.9526)",
          "0.952", "(0.9513, 0.9516)")
)
knitr::kable(Metrics_gbm, caption = "Performance Metrics of GBM Classifier")

## Final model comparison.
Metrics.total <- data.frame(
  Metrics_Models = c(
    "Recall", "Recall CI",
    "Precision", "Precision CI",
    "Accuracy", "Accuracy CI",
    "ROC_AUC", "ROC CI"
  ),
  MLR = c(
    "0.728", "(0.7273,0.7285)",
    "0.793", "(0.7919, 0.7931)",
    "0.836", "(0.8357, 0.8364)",
    "0.8979", "(0.8977, 0.8980)"
  ),
  MLR_BestSubset = c("0.742", "(0.7416,0.7424)",
                     "0.8044", "(0.8040, 0.8047)",
                     "0.8446", "(0.8440, 0.8447)",
                     "0.903", "(0.90288, 0.90304)"),
  Lasso = c("0.7286", "(0.7281,0.7290)",
            "0.8083", "(0.8078, 0.8088)",
            "0.8426", "(0.8423, 0.8428)",
            "0.9011", "(0.90105, 0.90125)"),
  KNN = c("0.637", "(0.6368,0.6387)",
          "0.642", "(0.6411, 0.6429)",
          "0.7458", "(0.7452, 0.7463)",
          "0.721", "(0.7207, 0.7218)"),
  GBM = c("0.917", "(0.9169,0.9174)",
          "0.947", "(0.9464, 0.9469)",
          "0.9524", "(0.9523, 0.9526)",
          "0.952", "(0.9513, 0.9516)")
)

knitr::kable(Metrics.total)
