# 06_visualisation_chart4_heatmap_recovery.R
# Regional recovery heatmap (Index: 2019 = 100) (Chart 4 candidate)

library(tidyverse)
library(scales)

regional <- read_csv("Data/02_processed/regional_time_series.csv")

# Build 2019 baseline index and keep post-pandemic window
heat_df <- regional %>%
  group_by(Region) %>%
  mutate(baseline_2019 = Passenger_Journeys[Year == 2019][1]) %>%
  ungroup() %>%
  mutate(Index_2019 = (Passenger_Journeys / baseline_2019) * 100) %>%
  filter(
    Year >= 2019,
    Year <= 2025,
    !is.na(Index_2019),
    !is.infinite(Index_2019)
  )

# Order regions by 2025 index (top = recovered more)
region_order <- heat_df %>%
  filter(Year == 2025) %>%
  arrange(desc(Index_2019)) %>%
  pull(Region)

heat_df <- heat_df %>%
  mutate(
    Region = factor(Region, levels = region_order),
    Year = factor(Year, levels = 2019:2025)
  )

ggplot(heat_df, aes(x = Year, y = Region, fill = Index_2019)) +
  geom_tile(colour = "white", linewidth = 0.4) +
  geom_text(
    aes(label = round(Index_2019, 0)),
    size = 3,
    colour = "grey15"
  ) +
  scale_fill_gradient2(
    low = "#E57373",      # pandemic disruption
    mid = "#E3F2FD",      # baseline (2019 = 100)
    high = "#0D47A1",     # strong recovery
    midpoint = 100,
    limits = c(0, 120),
    name = "Index\n(2019 = 100)"
  ) +
  labs(
    title = "Regional rail recovery heatmap (indexed to 2019)",
    subtitle = "Red indicates pandemic disruption; blue indicates recovery relative to the 2019 baseline",
    x = "Year (Apr–Mar)",
    y = NULL,
    caption = "Source: ORR regional passenger journeys tables (processed)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(face = "bold"),
    axis.text.y = element_text(face = "bold"),
    legend.position = "right"
  )