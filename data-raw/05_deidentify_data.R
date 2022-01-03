library(readr)
library(here)
library(dplyr)

dat <- read_csv(here("data-raw/database_complete.csv"))

# Randomize ID
i <- unique(dat$id)
indx_vector <- setNames(sample(i), i)
dat <- dat %>% mutate(id = indx_vector[id]) %>% arrange(id)

dat <- dat %>%
  mutate(
    across(c(sex, operator, device, method), as.factor),
    across(c(id), as.integer)
  )

write_csv(dat, here("data/database.csv"))
write_rds(dat, here("data/database.rds"))
