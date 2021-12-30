library(readr)
library(dplyr)
library(tibble)
library(here)
library(xlsx)
library(stringr)
library(lubridate)

# Original database ---------

database <- read.xlsx(here("data-raw/database_original.xlsx"), sheetIndex = 1)
database <- tibble(database)
database <- database %>%
  select(
    id,
    fecha,
    hora_muestra,
    hora_runrun,
    hora_centrifugadora,
    edad,
    sexo,
    operario,
    dispositivo
  )

# Drop rows without information
database <- database %>% filter(!is.na(fecha))

# ID should be a character to match with the names of the images
database$id <- formatC(database$id, width = 2, format = "d", flag = "0")

# Deal with hours
get_time <- function(x) {
  # Transform to seconds
  res <- 0
  res <- res + hour(x) * 60 * 60
  res <- res + minute(x) * 60
  res <- res + second(x)
  hms::as_hms(res)
}
database <- mutate(database, across(starts_with("hora"), get_time))


# Hematocrit values --------------

hematocrit <- read_csv(here("data-raw/hematocrit_values.csv"))
# Change the ID to the original ID, that of the original database
hematocrit <- hematocrit %>%
  mutate(
    id = as.numeric(str_sub(original, 1, 2)),
    runrun = str_detect(original, "runrun")
  )

arrange_chr <- function(.data) {
  .data %>%
    arrange(id) %>%
    mutate(id = formatC(id, width = 2, format = "d", flag = "0"))
}
select_values <- function(.data) {
  .data %>%
    select(id, hematocrit)
}
values_runrun <- hematocrit %>% filter(runrun) %>% arrange_chr() %>% select_values()
values_centrifuge <- hematocrit %>% filter(!runrun) %>% arrange_chr() %>% select_values()


# Join data sets ------------

database <- left_join(database, values_runrun, by = "id")
database <- left_join(database, values_centrifuge, by = "id", suffix = c("_runrun", "_centrifuge"))


# Write ------------

write_csv(database, here("data-raw/database_complete.csv"))
