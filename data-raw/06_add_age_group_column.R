library(readr)
library(dplyr)
library(here)

dat <- read_rds("data/database.rds")
dat <- dat %>% mutate(age_group = cut(age, breaks = c(5, 11, 14, Inf)))

write_csv(dat, here("data/database.csv"))
write_rds(dat, here("data/database.rds"))
