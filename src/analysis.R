library(here)
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)

dat <- read_rds(here("data/database.rds"))

# Exploratory analysis -----------

dat_plot <- dat %>% pivot_wider(names_from = method, values_from = hematocrit)

ggplot(dat_plot) +
  geom_point(aes(id, runrun), color = "blue") +
  geom_point(aes(id, centrifuge), color = "red") +
  geom_linerange(aes(id, ymax = runrun, ymin = centrifuge))
