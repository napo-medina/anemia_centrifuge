library(readr)
library(here)
library(dplyr)

dat <- read_csv(here("data-raw/database_complete.csv"))
dat <- dat %>% select(-id)
i <- sample(nrow(dat))
dat <- dat[i, ]

dat <- dat %>% mutate(across(c(sexo, operario, dispositivo), as.factor))

write_csv(dat, here("data/database.csv"))
write_rds(dat, here("data/database.rds"))
