# Author: Lisa Ruixuan Li
# Project: Presidential Vote count in 2024

# 0. Load libraries
install.packages("readxl")
library(dplyr)
library(ggplot2)
library(readxl)

# 1. Import Election database for 2024 Election
df <- read_excel("bbc_2024.xlsx")
str(df)

# 2. Clean 2024 data
# Recode the 'party' column
df <- df %>%
  mutate(
    party_reclassifed = case_when(
      grepl("republican", Party, ignore.case = TRUE) ~ "REPUBLICAN",
      grepl("democrat", Party, ignore.case = TRUE) ~ "DEMOCRAT",
      TRUE ~ "OTHERS"
    )
  )

# aggregate by dem, rep or others vote sum
# Group by party and state, and calculate total votes
grouped2024 <- df %>%
  group_by(State, party_reclassifed) %>%
  summarise(vote_count = sum(Votes),
            vote_share = sum(`Vote share`), 
            count_percentage = mean(`Expected votes counted (%)`))

# 3. Reshape from long to wide
# Load tidyr package
library(tidyr)

# Reshape from long to wide format
wide_sum2024 <- grouped2024 %>%
  pivot_wider(
    names_from = party_reclassifed,   # Column that will become new columns
    values_from = c(vote_count, vote_share)   # Values that will be spread across new columns
  )

# 4. Create new column that is total vote count
# Add a new column that is the sum of col1, col2, and col3
wide_sum2024 <- wide_sum2024 %>%
  mutate(totalvotes = vote_count_DEMOCRAT + vote_count_REPUBLICAN + vote_count_OTHERS)

# add _2024 to wide_sum2024
# Add a suffix "_updated" to each column name
colnames(wide_sum2024) <- paste0(colnames(wide_sum2024), "_2024")

# convert state name to abbreviation
wide_sum2024$state_po <- state.abb[match(wide_sum2024$State_2024, state.name)]
# Ammend specific entry to DC for state abbr
# wide_sum2024 <- wide_sum2024 %>%
#   mutate(state_po = if_else(State_2024 == "District of Columbia", 50, age))
wide_sum2024[wide_sum2024$State_2024 == "District of Columbia", "state_po"] <- "DC"

# Rename column state name
names(wide_sum2024)[names(wide_sum2024) == "State_2024"] <- "State"

# Export data
write_xlsx(wide_sum2024, "wide_sum2024.xlsx")

