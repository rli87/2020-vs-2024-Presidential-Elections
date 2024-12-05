# Author: Lisa Ruixuan Li
# Project: Presidential Vote count in 2024

# 0. Load libraries

library(dplyr)
library(ggplot2)
library(readxl)
library(writexl)
library(tidyr)

# Join 2024 and 2020 data
wide_sum2020 <- read_excel("wide_sum2020.xlsx")
wide_sum2024 <- read_excel("wide_sum2024.xlsx")

# Merge based on the 'state_po' column (inner join by default)
wide_sum <- merge(wide_sum2020, wide_sum2024, by = "state_po")

# Use mutate to subtract 'col2' from 'col1' and create a new column 'result'
wide_sum <- wide_sum %>%
  mutate(DEMOCRAT_diff_share = vote_share_DEMOCRAT_2024 - vote_share_DEMOCRAT_2020,
         REPUBLICAN_diff_share = vote_share_REPUBLICAN_2024 - vote_share_REPUBLICAN_2020, 
         OTHERS_diff_share = vote_share_OTHERS_2024 - vote_share_OTHERS_2020, 
         DEMOCRAT_diff_count = vote_count_DEMOCRAT_2024 - vote_count_DEMOCRAT_2020,
         REPUBLICAN_diff_count = vote_count_REPUBLICAN_2024 - vote_count_REPUBLICAN_2020, 
         OTHERS_diff_count = vote_count_OTHERS_2024 - vote_count_OTHERS)

# Export to Excel
write_xlsx(wide_sum, "wide_sum.xlsx")