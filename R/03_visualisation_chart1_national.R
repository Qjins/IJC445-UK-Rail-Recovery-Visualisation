# 03_visualisation_chart1_national.R
# National time-series visualisation (Chart 1)
# 
# setwd("/Users/qjin/Documents/University of Sheffield/IJC445 Data Visualisation (AUTUMN 2025-26)/Assessment")
# getwd()

library(tidyverse)
library(scales)

# Load processed national data
national <- read_csv("Data/02_processed/national_time_series.csv")

# Convert to millions for readability
national <- national %>%
  mutate(Total_journeys_M = Total_journeys / 1000)

ggplot(national, aes(x = Year, y = Total_journeys_M)) +
  geom_line(linewidth = 0.9, colour = "#2C3E50") +
  geom_point(size = 1.8, colour = "#2C3E50") +
  annotate(
    "rect",
    xmin = 2019.5, xmax = 2021.5,
    ymin = -Inf, ymax = Inf,
    alpha = 0.30,
    fill = "#BBDCF2"
  ) +
  annotate(
    "text",
    x = 2020.5,
    y = max(national$Total_journeys_M, na.rm = TRUE) * 0.95,
    label = "COVID-19 period",
    size = 3,
    colour = "#2C3E50"
  ) +
  scale_x_continuous(breaks = seq(1996, 2025, by = 4)) +
  scale_y_continuous(labels = label_number(accuracy = 10)) +
  labs(
    title = "UK rail passenger journeys (1996–2025)",
    subtitle = "Sharp decline during COVID-19 followed by a gradual recovery",
    x = "Year (Apr–Mar)",
    y = "Total passenger journeys (millions)",
    caption = "Source: Office of Rail and Road (ORR), Table 1510"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )