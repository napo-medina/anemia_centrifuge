library(here)
library(readr)
library(ggplot2)

dat_path <- here("doc/cronograma/cronograma.csv")
dat <- read_csv(dat_path)

# Order the activities based on start date to create a graph
i <- order(dat$start_date, decreasing = TRUE)
dat <- dat[i, ]
dat$activity <- factor(dat$activity, levels = unique(dat$activity))

# Group similar activities to give them the same color
dat$category_color <- factor(c(1, 2, 2, 3, 3, 3, 3))

ggplot(dat) +
  geom_linerange(
    aes(activity, ymin = start_date, ymax = end_date, color = category_color),
    size = 10
  ) +
  theme(
    axis.title = element_blank(),
    legend.position = "none",
    plot.margin = unit(c(0.5, 1, 0.5, 0.5), "cm")
  ) +
  scale_y_date(date_labels = "%Y-%m", position = "right") +
  coord_flip()

ggsave(here("doc/cronograma/cronograma.png"))
