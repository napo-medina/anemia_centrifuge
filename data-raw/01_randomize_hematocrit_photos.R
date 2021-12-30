library(tibble)
library(tools)
library(dplyr)
library(readr)
library(xlsx)
library(here)
library(purrr)

# Create master data frame
files <- list.files(here("data-raw/hematocrit_photos/original"))
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
  from = here("data-raw/hematocrit_photos/original", master_df$original),
  to = here("data-raw/hematocrit_photos/random", master_df$new)
)

# Create blind data frame
blind_df <- select(master_df, -original)
blind_df <- mutate(blind_df, hematocrit = "")

# Write data frames
write_csv(master_df, here("data-raw/hematocrit_photos/master_df.csv"))
write.xlsx(blind_df, here("data-raw/hematocrit_photos/blind_df.xlsx"))
