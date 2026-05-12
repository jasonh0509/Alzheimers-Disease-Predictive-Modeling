glimpse(ALZH)

na_plot_ALZH <- vis_miss(ALZH_noID)
na_plot_ALZH + ggtitle("Figure 1.5 Visualization of Missing Values")

colSums(is.na(ALZH_noID))


alzh_classes <- ggplot(ALZH_class.set, aes(x = Diagnosis, fill = Diagnosis)) +
  geom_bar() +
  xlab("Diagnosis Status") +
  ggtitle("Figure 1.1 Classes of Alzheimer's Disease")

alzh_classes


alzh_pos <- subset(ALZH_noID, Diagnosis == 1)

ALZH_for_explore <- ALZH_for_explore %>%
  mutate(Gender = recode(Gender, `0` = "Male", `1` = "Female"))


alzh_ethnicity + ggtitle("Alzheimer's and Ethnicity")