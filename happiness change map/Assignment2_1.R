library(readr); library(ggplot2); library(dplyr); library(tidyr)
library(rgeos); library(maptools); library(ggmap); library(broom)
#reading in the happiness datasets
H15 <- read_csv("R/datasets/2015.csv")
H17 <- read_csv("R/datasets/2017.csv")

colnames(H15)[3] <- 'rank2015'
colnames(H17)[2] <- 'rank2017'

#selecting only the required rows from each dataset
sum15 <- data.frame(Country = H15$Country, Score15 = H15$`Happiness Score`)
sum17 <- data.frame(Country = H17$Country, Score17 = H17$Happiness.Score, Rank17 = H17$rank2017)

#merging the three datasets usig an outer merge
Happy <-merge(x = sum15, y = sum17, by = "Country", all = TRUE)

Happy$Score17[Happy$Country =='Taiwan'] <- 6.422
Happy$Score17[Happy$Country =='Hong Kong'] <- 5.472

#creating a new feature that has the change in happiness score
Happy <- Happy %>% mutate(Score17 = round(Score17, 3))
Happy$Change <- Happy$Score17 - Happy$Score15

#removing null values
Happy <- na.omit(Happy)

#importing the shape file
World.shp <- readShapeSpatial('R/datasets/World/TM_WORLD_BORDERS-0.3.shp')

#reducing the number of rows
World.shp.simp1 <- gSimplify(World.shp, tol = .01, topologyPreserve = TRUE)
World.shp.simp1 <- SpatialPolygonsDataFrame(World.shp.simp1, data= World.shp@data)

#preparing for merge
World.shp.f <- tidy(World.shp.simp1, region = 'NAME')
World.shp.f$Country <- World.shp.f$id
World.shp.f <- World.shp.f %>% filter(World.shp.f$Country != 'Antarctica')

World.shp.f$Country[World.shp.f$Country == 'Republic of Moldova'] = 'Moldova'
World.shp.f$Country[World.shp.f$Country == 'Democratic Republic of the Congo'] = 'Congo (Kinshasa)'
World.shp.f$Country[World.shp.f$Country == 'Libyan Arab Jamahiriya'] = 'Libya'
World.shp.f$Country[World.shp.f$Country == 'Iran (Islamic Republic of)'] = 'Iran'
World.shp.f$Country[World.shp.f$Country == 'Cote d\'Ivoire'] = 'Ivory Coast'
World.shp.f$Country[World.shp.f$Country == 'The former Yugoslav Republic of Macedonia'] = 'Macedonia'
World.shp.f$Country[World.shp.f$Country == 'Burma'] = 'Myanmar'
World.shp.f$Country[World.shp.f$Country == 'Palestine'] = 'Palestinian Territories'
World.shp.f$Country[World.shp.f$Country == 'Korea, Republic of'] = 'South Korea'
World.shp.f$Country[World.shp.f$Country == 'Syrian Arab Republic'] = 'Syria'
World.shp.f$Country[World.shp.f$Country == 'United Republic of Tanzania'] = 'Tanzania'
World.shp.f$Country[World.shp.f$Country == 'Viet Nam'] = 'Vietnam'

#merging the two dataframes and ordering for visualisation
merge.World.profiles <- merge(World.shp.f, Happy, by = "Country", all.x = TRUE)
World_df <- merge.World.profiles[order(merge.World.profiles$order),]


#visualisation
p1 <- ggplot(data = World_df, aes(x = long, y = lat, group = group, fill = Change))

p1 + geom_polygon(color = 'black', size = .1) + coord_map() + 
  scale_fill_gradientn(name = "Change", 
                       colours = c('#c10101', '#b2182b', '#d6604d',
                                   '#f4a582', '#fddbc7', '#f7f7f7',
                                   '#d1e5f0', '#67a9cf', '#0e59a5' ), 
                       na.value = 'LightGrey') +
  theme_minimal() + 
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        panel.grid   = element_blank(),
        plot.title = element_text(hjust=0.1),
        plot.caption=element_text(hjust=0.05, size=7.5)) + 
  labs(title="The Change in the World Happiness Report Scores from 2015 to 2017",
       caption = 'Source: https://www.kaggle.com/unsdsn/world-happiness/data')

#checking that the countries match up
countries <- data.frame(Country = unique(World.shp.f$Country))
countries$comparison <- countries$Country

test <- merge(Happy, countries, by = 'Country', all.x = TRUE)
test <- data.frame(Country = test$Country, comparison = test$comparison)
