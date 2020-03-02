library(ggplot2)
library(dplyr)
library(ggthemes)
library(readr)


team <- read_csv("~/team_name.csv")


#position by year for a team
p1 <- ggplot(data = team, aes(x = Year, y = Position, color = Premiership)) 
p1 + geom_line(size = 1, color = '#34495E' ) + geom_point(size =2) +
  geom_line(size = 1, aes(x = Year, y = Total_Teams), color = '#C70039', alpha = 0.5) +
  scale_y_reverse(breaks = c(1:18)) +
  scale_x_continuous(breaks = seq(1900,2020, by=10)) + expand_limits(y=c(1:max(team$Total_Teams))) +
  scale_color_manual(values=c('#000000','#ccac00'), labels = c('Non-Winning Season', 'Winning Season')) +
  ggtitle("Season-by-Season Performance of Selected Team")+
  ylab("Final Ladder Position") +
  theme(plot.title = element_text(h=0.5), legend.position="bottom", legend.box = "Horizontal")

#saving the plot as a PNG file.
#   ***higher DPI results in a clearer plot but larger file size***
ggsave('~/plots/team.png', dpi = 512)

