library(raster)
library(dplyr)
library(purrr)
library(ggplot2)

### All data downloaded at 5 km resolution to match that of the snail kite data

mypath <- '/Users/joshcullen/Documents/Snail Kite Project/Data/R Scripts/fl_water_data/FL Water History_GSW'

# Load all raster files
water.hist<- list.files(mypath,full.names = T) %>%  #creates list
  map(raster)
water.hist.brick<- brick(water.hist)  #creates RasterBrick
plot(water.hist.brick)


#Example of better viz in ggplot
Jan_2016<- as.data.frame(water.hist.brick$X2016_01.water, xy=T)
Jan_2016[Jan_2016$X2016_01.water == 0,]<- NA

ggplot(Jan_2016) +
  geom_tile(aes(x=x, y=y, fill=X2016_01.water-1), na.rm = T) +
  scale_fill_viridis_c("Likelihood of Water", direction=-1) +
  labs(x="Longitude", y="Latitude") +
  coord_equal() +
  theme_bw() +
  theme(panel.grid = element_blank())
