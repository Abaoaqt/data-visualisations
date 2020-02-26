library(ggplot2)
library(dplyr)
library(ggthemes)

d = 'enter table name here'
#position by year for a team
p1 <- ggplot(data = d, aes(x = Year, y = Position))
p1 + geom_line(size = 1, color = '#34495E' ) +
  geom_line(size = 1, aes(x = Year, y = Total_Teams), color = '#C70039', alpha = 0.5) + scale_y_reverse(breaks = c(1:18)) +
  scale_x_continuous(breaks = seq(1900,2020, by=10)) + expand_limits(y=c(1:max(d$Total_Teams)))

#points by year 

p2 <- ggplot(data = d, aes(x = Year, y = Points))
p2 + geom_line(size = 1, color = '#34495E' ) +
  geom_line(size = 1, aes(x = Year, y = 4 * Played), color = '#C70039', alpha = 0.5) +
  scale_x_continuous(breaks = seq(1900,2020, by=10)) + expand_limits(y=c(4 * max(d$Played)))
