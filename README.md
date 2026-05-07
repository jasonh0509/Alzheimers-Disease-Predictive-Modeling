# Alzheimer’s Disease Risk Prediction

## Project Overview
This project compares multiple classification models for predicting Alzheimer’s disease risk using a publicly available synthetic health dataset. The analysis evaluates both linear and non-linear methods, with emphasis on identifying positive Alzheimer’s disease cases for screening-oriented applications.

## Methods
Models compared include:
- Logistic regression
- Logistic regression with best subset selection
- Lasso-regularized logistic regression
- k-nearest neighbors (kNN)
- Gradient Boosting Machine (GBM)

Model performance was evaluated using repeated 5-fold cross-validation over 300 iterations. Metrics included recall, precision, accuracy, and AUC.

## Tools
- R
- tidyverse
- caret
- glmnet
- gbm
- pROC
- Git/GitHub

## Key Deliverables
- [Full Technical Report](report/alzheimers_risk_prediction_report.pdf)
- [Original R Markdown Analysis](scripts/alzheimers_raw_project.Rmd)

## Notes
This project originated from graduate-level statistical learning coursework and was organized into a reproducible portfolio project. The dataset is synthetic, so results should be interpreted as methodological evidence rather than clinically deployable findings.

## Repository Structure
```text
data/
outputs/
report/
scripts/
README.md