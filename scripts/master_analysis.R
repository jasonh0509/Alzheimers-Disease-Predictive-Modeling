################################################################################
# master_analysis.R
# Purpose: Run the modularized Alzheimer predictive modeling workflow in order.
# Note: Some sections, especially repeated CV and GBM/RFE tuning, may take extra time.
################################################################################

source("scripts/00_setup_packages.R")
source("scripts/01_data_import_cleaning.R")
source("scripts/02_exploratory_data_analysis.R")
source("scripts/03_feature_engineering_selection.R")
source("scripts/04_model_training.R")
source("scripts/05_model_evaluation.R")
source("scripts/06_results_reporting.R")
