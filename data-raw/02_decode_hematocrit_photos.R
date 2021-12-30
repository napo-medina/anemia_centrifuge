library(tibble)
library(tools)
library(dplyr)
library(readr)
library(xlsx)
library(here)
library(purrr)

master_df <- read_csv(here("data-raw/hematocrit_photos/master_df.csv"))

read_hematocrit_files <- function(files) {
  read_and_filter <- function(file) {
    df <- read.xlsx(file, sheetIndex = 1)
    df <- tibble(df)
    df <- df[1:3]
    df[[3]] <- suppressWarnings(as.numeric(df[[3]]))
    df
  }
  result <- map(files, read_and_filter)
  result
}

files <- list.files(here("data-raw/hematocrit_data"), full.names = TRUE, pattern = "[.]xlsx$")
hematocrit_data <- read_hematocrit_files(files)

join_df <- function(df1, df2) {
  result <- left_join(df1, df2, by = c("id", "new"))
  result
}

final_result <- reduce(hematocrit_data, join_df)
final_result <- left_join(master_df, final_result, by = c("id", "new"))

# Write the results
write_csv(final_result, here("data-raw/hematocrit_data", "hematocrit_full_data.csv"))
