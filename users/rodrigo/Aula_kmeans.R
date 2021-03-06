## packages ---------------------------------------------------------------
library(sf)
library(raster)
library(dplyr)


st_utm = function(sf_obj) {
  # Function to get UTM Zone from mean longitude:
  long2UTM <- function(long) {
    (floor((long + 180) / 6) %% 60) + 1
  }
  
  # Check if the object class is 'sf':
  obj_c <- class(sf_obj)[1]
  if (obj_c == "sf") {
    # In case the object has no projectin assigned,
    #  assume it to geographic WGS84 :
    if (is.na(sf::st_crs(sf_obj))) {
      sf::st_crs(sf_obj) <- sf::st_crs(4326)
    }
    
    # Get the center longitude in degrees:
    bb <- sf::st_as_sfc(sf::st_bbox(sf_obj))
    bb <- sf::st_transform(bb, sf::st_crs(4326))
    
    # Get UTM Zone from mean longitude:
    utmzone <- long2UTM(mean(sf::st_bbox(bb)[c(1, 3)]))
    
    # Get the hemisphere based on the latitude:
    NS <- 100 * (6 + (mean(sf::st_bbox(bb)[c(2, 4)]) < 0))
    
    # Add all toghether to get the EPSG code:
    projutm <- sf::st_crs(32000 + NS + utmzone)
    
    # Reproject data:
    sf_obj <- sf::st_transform(sf_obj, projutm)
    return(sf_obj)
  } else {
    options(error = NULL)
    stop("Object class is not 'sf', please insert a sf object!")
  }
}



## read data --------------------------------------------------------------
rst <- readRDS("data/simul.rds")
field <- readRDS("data/field.rds")
field2 <- readRDS("data/sample_field.rds")

field2 <- st_utm(field2)

## make clusters
clus = kmeans(rst$sim1[], 4, nstart = 100)

plot(rst$sim1[], col = clus$cluster)

## create raster with the clusters:
rst$clus = clus$cluster

## compare result:
plot(rst[[c('sim1','clus')]])


## make clusters
clus = kmeans(rst[[1:2]][], 4)

## create raster with the clusters:
rst$clus = clus$cluster

clus$centers

plot(rst$sim1[], rst$sim2[], col = clus$cluster)

## compare result:
plot(rst[[c('sim1','sim2','clus')]])

## Convert to points
rpts = data.frame(rasterToPoints(rst))

## make clusters
clus = kmeans(rpts[1:2], 4)

## create raster with the clusters:
rst$clus = clus$cluster

## compare result:
plot(rst[[c('sim1','sim2','clus')]])


## make clusters
clus = kmeans(rpts[1:4], 4)

sd(rpts[,1])
sd(rpts[,3])

## create raster with the clusters:
rst$clus = clus$cluster

## compare result:
plot(rst[[c('sim1','sim2','clus')]])

## make clusters
clus = kmeans(scale(rpts[1:4]), 4)

## create raster with the clusters:
rst$clus = clus$cluster

## compare result:
plot(rst[[c('sim1','sim2','clus')]])

## make clusters
clus = kmeans(rpts[1:2], 50, nstart = 100, iter.max = 100)

plot(st_geometry(field))
points(clus$centers)

grd_regular = st_make_grid(field, n = sqrt(50), what = 'centers')
points(st_coordinates(grd_regular), col = 'red')


grd_regular = st_make_grid(field2, n = sqrt(50), what = 'centers')
grd_regular = st_intersection(grd_regular, field2)
plot(st_geometry(field2))
points(st_coordinates(grd_regular), col = 'red')


grd = st_make_grid(field2, cellsize = 10, what = 'centers')
grd = st_intersection(grd, field2)
grd_pts = st_coordinates(grd)

plot(as_Spatial(field2))
points(grd_pts, pch = '.')


## make clusters
clus = kmeans(grd_pts, 50, nstart = 10, iter.max = 100)
points(clus$centers, col = 'red', pch = 20)
points(grd_pts, pch = '.', col = clus$cluster)

'voronoi'

#Tarefa:
# Definir poligonos para amostragem em celulas
# Definir pontos das cubamostras em cada celula (15)
