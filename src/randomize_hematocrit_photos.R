
library(tibble)
library(tools)
library(dplyr)
library(readr)
library(xlsx)
library(here)
library(purrr)


# Randomize photos ------------

# Create master data frame
files <- list.files(here("data/hematocrit_photos/original"))
create_master_df <- function(files) {
  create_new_names <- function(x) {
    extensions <- file_ext(x)
    new_names <- formatC(seq_along(x), width = 2, format = "d", flag = "0")
    new_names <- paste0(new_names, ".", extensions)
    new_names
  }
  tibble(
    id = seq_along(files),
    original = sample(files),
    new = create_new_names(original)
  )
}
set.seed(123)
master_df <- create_master_df(files)

# Copy images
file.copy(
  from = here("data/hematocrit_photos/original", master_df$original),
  to = here("data/hematocrit_photos/random", master_df$new)
)

# Create blind data frame
blind_df <- select(master_df, -original)
blind_df <- mutate(blind_df, hematocrit = "")

# Write data frames
write_csv(master_df, here("data/hematocrit_photos/master_df.csv"))
write.xlsx(blind_df, here("data/hematocrit_photos/blind_df.xlsx"))


# Reveal / decode photos -------------------

master_df <- read_csv(here("data/hematocrit_photos/master_df.csv"))

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

files <- list.files(here("data/hematocrit_data"), full.names = TRUE)
hematocrit_data <- read_hematocrit_files(files)

join_df <- function(df1, df2) {
  result <- left_join(df1, df2, by = c("id", "new"))
  result
}

final_result <- reduce(hematocrit_data, join_df)
final_result <- left_join(master_df, final_result, by = c("id", "new"))

# Write the results

write_csv(final_result, here("data/hematocrit_data", "hematocrit_full_data.csv"))

