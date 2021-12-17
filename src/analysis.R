library(readxl)
library(lubridate)
library(dplyr)

dat <- read_excel("database_excel.xlsx", sheet = 1)

# Transform time ---------------

get_time <- function(x) {
  # Transform to seconds
  res <- 0
  res <- res + hour(x) * 60 * 60
  res <- res + minute(x) * 60
  res <- res + second(x)
  hms::as_hms(res)
}

dat <- mutate(dat, across(starts_with("hora"), get_time))


# ----------------


