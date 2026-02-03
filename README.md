# IJC445-UK-Rail-Recovery-Visualisation
Uneven Recovery of UK Rail Passenger Usage After COVID-19
IJC445 Data Visualisation Coursework (2025–2026)

Project overview
This project analyses the uneven post-COVID recovery of UK rail passenger usage, with a focus on regional differences over time. Using official data from the Office of Rail and Road (ORR), the analysis develops a four-chart composite visualisation to move beyond national averages and reveal spatially uneven recovery patterns.

The project is submitted as part of the IJC445 Data Visualisation coursework at the University of Sheffield.

Research questions
The analysis addresses the following questions:

1. How did the COVID-19 pandemic affect UK rail passenger usage at a national level?
2. To what extent has rail usage recovered across different UK regions compared to pre-pandemic levels?
3. Has post-COVID recovery followed a uniform trajectory, or have distinct regional recovery patterns emerged?

Visualisations
The composite visualisation consists of four figures:

Figure 1: National rail passenger trends (1996–2025)  
Figure 2: Regional rail passenger trends using faceted time-series charts  
Figure 3: Regional recovery comparison (2024 and 2025 relative to the 2019 baseline)  
Figure 4: Heatmap of regional recovery indexed to 2019 (=100)

All figures are generated using R and saved in the Figures directory.

Project structure
.
├── Data
│   ├── 01_raw
│   │   ├── national
│   │   ├── regional
│   │   └── station
│   └── 02_processed
│       ├── national_time_series.csv
│       └── regional_time_series.csv
│
├── Figures
│   ├── Figure 1.png
│   ├── Figure 2.png
│   ├── Figure 3.png
│   └── Figure 4.png
│
├── R
│   ├── 02_data_cleaning_regional.R
│   ├── 03_visualisation_chart1_national.R
│   ├── 04_visualisation_chart2_regional.R
│   ├── 05_visualisation_chart3_recovery_rate.R
│   └── 06_visualisation_chart4_heatmap_recovery.R
│
└── README.md

Reproducibility
All visualisations can be reproduced by running the R scripts in the R folder in numerical order, with the working directory set to the project root.

Required R packages:
tidyverse  
readr  
readODS  
stringr  
scales  

Recommended execution order:
1. 02_data_cleaning_regional.R
2. 03_visualisation_chart1_national.R
3. 04_visualisation_chart2_regional.R
4. 05_visualisation_chart3_recovery_rate.R
5. 06_visualisation_chart4_heatmap_recovery.R

Data source
All datasets are sourced from the Office of Rail and Road (ORR) Data Portal.
Passenger rail journeys tables (national and regional time series).
https://dataportal.orr.gov.uk

Methods and frameworks
The project applies established data visualisation theory, including the ASSERT framework, the Grammar of Graphics, and principles of accessibility and ethical visualisation. These are discussed in detail in the accompanying written report.

