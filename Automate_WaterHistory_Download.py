import ee
ee.Initialize()

dataset = ee.ImageCollection('JRC/GSW1_1/MonthlyHistory') \
                  .filterDate('2016-01-01', '2018-12-31')
water = dataset.select('water')
print(water.getInfo())


#Want to remove NA values (0)
filterList = ee.Image.constant(ee.List([1,2])) #only want values 1 and 2 (not 0)

#Function to reduce resolution (resample mean) from 30 to 5000m
def reduceRes(image):
  image_reduce = image \
  .updateMask(image.eq(filterList) \
  .reduce(ee.Reducer.anyNonZero())) \
  .reduceResolution(reducer=ee.Reducer.mean(),maxPixels=65536) \
  .reproject(crs='EPSG:4326',scale=5000)                 
  return(ee.Image(image_reduce))
  
  #Run function
water_reduce = water.map(reduceRes)

from geetools import batch

geom = ee.Geometry.Rectangle([-83.831060546875, 24.957740288199492, -79.810064453125, 29.756334027334518], 'EPSG:4326')
size = water_reduce.size().getInfo()
clist = water_reduce.toList(size)
for i in range(size):
    image = ee.Image(clist.get(i))
    iid = image.id().getInfo()
    name = iid
    print('downloading '+name)
    batch.Download.image.toLocal(image=image, name=name, scale=5000, region=geom, toFolder=False)