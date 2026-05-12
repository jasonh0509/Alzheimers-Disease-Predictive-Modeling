### Load Datas
ALZH <- read.csv("https://raw.githubusercontent.com/jasonh0509/StatsLearningFinal/refs/heads/main/alzheimers_disease_data.csv")

## Initial structural inspection
glimpse(ALZH)

## Remove ID column
ALZH_noID <- ALZH[, -1]

## Missingness visualization
na_plot_ALZH <- vis_miss(ALZH_noID)
na_plot_ALZH + ggtitle("Figure 1.5 Visualization of Missing Values")

## Missing value count
colSums(is.na(ALZH_noID))

## changing data types
ALZH_noID$Diagnosis <- as.factor(ALZH_noID$Diagnosis)

ALZH_noID <- ALZH_noID %>%
  mutate(across(
    c(Gender, Ethnicity, EducationLevel, Smoking,
      FamilyHistoryAlzheimers, CardiovascularDisease,
      Diabetes, Depression, HeadInjury, Hypertension,
      MemoryComplaints, BehavioralProblems, Confusion,
      Disorientation, PersonalityChanges,
      DifficultyCompletingTasks, Forgetfulness),
    as.factor
  ))

### Set up Data Set(Keep Same Across All Stats Leraning Models)
ALZH.raw <- ALZH_noID %>%
  select(-DoctorInCharge) %>%
  mutate(Diagnosis = as.numeric(as.character(Diagnosis)))

ALZH.gbm <- ALZH.raw

## Dataset for exploration
ALZH_for_explore <- ALZH.gbm

## Class visualization set
ALZH_class.set <- ALZH_noID %>%
  mutate(Diagnosis = recode(Diagnosis,
                            `0` = "Negative",
                            `1` = "Positive"))