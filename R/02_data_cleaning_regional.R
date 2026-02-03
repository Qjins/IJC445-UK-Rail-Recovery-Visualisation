# 02_data_cleaning_regional.R
# Combine ORR regional ODS time-series into one tidy dataset
# Output: Data/02_processed/regional_time_series.csv

# install.packages("readODS")  
# install.packages("dplyr")
# install.packages("readr")
# install.packages("stringr")

setwd("/Users/qjin/Documents/University of Sheffield/IJC445 Data Visualisation (AUTUMN 2025-26)/Assessment")
getwd()

library(dplyr)
library(readr)
library(readODS)
library(stringr)

# 1) raw_path: use your actual folder name
raw_path <- "Data/01_raw/regional"

# 2) ensure output folder exists
dir.create("Data/02_processed", showWarnings = FALSE, recursive = TRUE)

# 3) list files safely (exclude temp lock files like "~$")
files <- list.files(raw_path, full.names = TRUE)
files <- files[grepl("\\.(ods|ODS)$", files)]
files <- files[!grepl("/~\\$", files)]

# 4) stop early if no files found (prevents silent empty output)
if (length(files) == 0) {
  stop("No .ods files found in: ", raw_path, 
       "\nCheck folder path and file extensions.")
}

make_region_label <- function(file_path) {
  x <- tools::file_path_sans_ext(basename(file_path))
  x <- str_replace(x, "^table-\\d+-regional-passenger-journeys-", "")
  x <- str_replace_all(x, "-", " ")
  str_to_title(x)
}

clean_regional_ods <- function(file_path) {
  
  # Data are always in the 3rd sheet, header starts at row 6 (A6)
  df <- read_ods(file_path, sheet = 3, skip = 5, col_names = TRUE)
  
  # Extract only Table XXXX a: Time period + Total journeys (thousands)
  out <- df %>%
    select(1, 4) %>%
    rename(
      Time_period = 1,
      Total_journeys_thousands = 2
    ) %>%
    mutate(
      Time_period = as.character(Time_period),
      Year = as.numeric(str_extract(Time_period, "\\d{4}$")),
      
      # Convert to numeric (thousands -> journeys)
      Passenger_Journeys = as.numeric(gsub(",", "", as.character(Total_journeys_thousands))) * 1000,
      
      # Round to avoid odd decimals from ODS import
      Passenger_Journeys = round(Passenger_Journeys),
      
      Region = make_region_label(file_path)
    ) %>%
    select(Year, Region, Passenger_Journeys) %>%
    filter(!is.na(Year), !is.na(Passenger_Journeys))
  
  out
}

regional_time_series <- bind_rows(lapply(files, clean_regional_ods)) %>%
  arrange(Region, Year)

# sanity checks
print(paste("Files read:", length(files)))
print(paste("Rows produced:", nrow(regional_time_series)))
print(head(regional_time_series, 10))

# Optional: quick check for missing years by region (helps debugging/appendix note)
missing_years <- regional_time_series %>%
  group_by(Region) %>%
  summarise(
    min_year = min(Year, na.rm = TRUE),
    max_year = max(Year, na.rm = TRUE),
    n_years = n_distinct(Year),
    .groups = "drop"
  )
print(missing_years)

write_csv(regional_time_series, "Data/02_processed/regional_time_series.csv")

# Summary
summary(regional_time_series$Passenger_Journeys)
table(regional_time_series$Region)
regional_time_series %>% group_by(Region) %>% summarise(min_year=min(Year), max_year=max(Year), n=n())

