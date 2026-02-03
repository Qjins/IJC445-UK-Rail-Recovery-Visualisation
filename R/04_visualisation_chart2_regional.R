# 04_visualisation_chart2_regional.R
# Regional time-series visualisation (Chart 2)

library(tidyverse)
library(scales)

# Load processed regional data
regional_time_series <- read_csv("Data/02_processed/regional_time_series.csv")

# Convert journeys to millions for readability
regional_plot <- regional_time_series %>%
  mutate(Passenger_Journeys_M = Passenger_Journeys / 1e6)

# Faceted line chart by region
ggplot(regional_plot, aes(x = Year, y = Passenger_Journeys_M)) +
  geom_line(linewidth = 0.7) +
  facet_wrap(~ Region, scales = "free_y", ncol = 3) +
  geom_vline(xintercept = 2020, linetype = "dashed") +
  scale_x_continuous(breaks = seq(1996, 2025, by = 4)) +
  scale_y_continuous(labels = label_number(accuracy = 0.1)) +
  labs(
    title = "Rail passenger journeys by region (1996–2025)",
    subtitle = "Uneven recovery patterns following the COVID-19 disruption",
    x = "Year (Apr–Mar)",
    y = "Passenger journeys (millions)"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    strip.text = element_text(face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )






