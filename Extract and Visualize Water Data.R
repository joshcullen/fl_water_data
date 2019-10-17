library(raster)
library(ggplot2)
library(dplyr)
library(purrr)


Jan_2018<- raster("2018_01.tif")
Jan_2018_utm<- Jan_2018
crs(Jan_2018_utm)<- CRS("+init=epsg:32617")


getValues(Jan_2018)

Jan_2018.df<- as.data.frame(Jan_2018, xy=TRUE)
Jan_2018.df$X2018_01<- as.factor(Jan_2018.df$X2018_01)
names(Jan_2018.df)[3]<- "Jan_2018"



ggplot(Jan_2018.df) +
  geom_tile(aes(x=x,y=y,fill=Jan_2018)) +
  coord_equal() +
  scale_fill_manual("",values=c('#ffffff', '#fffcb8', '#0905ff'), labels=c("NA","Land","Water")) +
  theme_bw() +
  theme(panel.grid = element_blank())





mypath <- "~/Documents/Snail Kite Project/Data/Global Surface Water Data/FL Water History_GSW"

# To extract all pixel values (the result is a list, each slot is a raster)
water.hist<- list.files(mypath, full.names = T) %>%
  map(raster)

water.hist.brick<- brick(water.hist)
plot(water.hist.brick)

# To extract max, min, mean and sd for each raster (the result is a data.frame)
list.files(mypath,full.names = T) %>%
  map(raster) %>%
  map_df(function(x){
    data.frame(
      mx=raster::maxValue(x),
      mn=raster::minValue(x),
      avg=mean(x[],na.rm=T),
      stdev=sd(x[],na.rm=T))})