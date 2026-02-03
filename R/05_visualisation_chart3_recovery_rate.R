# 05_visualisation_chart3_recovery_rate.R
# Regional recovery rate compared to 2019 (Chart 3)

# setwd("/Users/qjin/Documents/University of Sheffield/IJC445 Data Visualisation (AUTUMN 2025-26)/Assessment")
# getwd()

library(tidyverse)
library(scales)

regional <- read_csv("Data/02_processed/regional_time_series.csv")

# Recovery rate: (Year value / 2019 value) * 100
recovery <- regional %>%
  filter(Year %in% c(2019, 2024, 2025)) %>%
  select(Year, Region, Passenger_Journeys) %>%
  pivot_wider(names_from = Year, values_from = Passenger_Journeys) %>%
  mutate(
    recovery_2024 = (`2024` / `2019`) * 100,
    recovery_2025 = (`2025` / `2019`) * 100
  ) %>%
  select(Region, recovery_2024, recovery_2025) %>%
  pivot_longer(
    cols = starts_with("recovery_"),
    names_to = "Year",
    values_to = "Recovery_pct"
  ) %>%
  mutate(
    Year = recode(Year, recovery_2024 = "2024 vs 2019", recovery_2025 = "2025 vs 2019")
  ) %>%
  filter(!is.na(Recovery_pct))

# Order regions by 2025 recovery (highest to lowest)
region_order <- recovery %>%
  filter(Year == "2025 vs 2019") %>%
  arrange(desc(Recovery_pct)) %>%
  pull(Region)

recovery <- recovery %>%
  mutate(Region = factor(Region, levels = region_order))

label_region <- tail(levels(recovery$Region), 1)

ggplot(recovery, aes(x = Region, y = Recovery_pct, fill = Year)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.7) +
  geom_hline(yintercept = 100, linetype = "dashed") +
  annotate(
    "text",
    x = label_region,
    y = 101,
    label = "2019 baseline",
    size = 3,
    colour = "grey40",
    hjust = 0
  ) +
  coord_flip() +
  scale_y_continuous(labels = label_number(accuracy = 1)) +
  scale_fill_manual(
    values = c(
      "2024 vs 2019" = "#AED6F1",
      "2025 vs 2019" = "#5DADE2"
    )
  ) +
  labs(
    title = "Regional recovery relative to pre-pandemic level",
    subtitle = "Passenger journeys as a percentage of 2019 (baseline = 100)",
    x = NULL,
    y = "Recovery (% of 2019)",
    fill = NULL,
    caption = "Dashed line at 100 indicates the 2019 baseline (pre-pandemic level)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    axis.text.y = element_text(face = "bold")
  )
  