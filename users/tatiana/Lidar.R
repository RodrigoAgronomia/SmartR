library(raster)
library(rgdal)
library(lidR)
library(rLiDAR)

#Leitura dos dados Lidar
las = readLAS("data/Talhao1.las")
summary(las)

#Leitura do poligono e recorte
#poligono = readOGR(dsn="C:/Users/ivana/Documents/Tati/Dados/shp",layer="contorno_UTM")
#sublas = lasclip(las, data.shape)

#Extracao de metricas
p95 <- grid_metrics(las, ~quantile(Z, probs = 0.95), 10)
plot(p95, xlab="UTM Easting", ylab="UTM Northing")
hist(p95, xlab="Elevação (metros)", ylab="Frequência")

metrics = grid_metrics(las, max(Z), 1) #canopy surface model with 1 m² cells
plot(metrics1, xlab="UTM Easting", ylab="UTM Northing")
hist(metrics1, xlab="Elevação (metros)", ylab="Frequência")

#Gerar CHM
chm1 <- grid_canopy(las, 1, p2r()) #point to raster method
plot(chm1, xlab="UTM Easting", ylab="UTM Northing")
hist(chm1, xlab="Elevação (metros)", ylab="Frequência")

chm2 <- grid_canopy(las, 1, dsmtin()) #triangulation and raster of first returns
plot(chm2, xlab="UTM Easting", ylab="UTM Northing")
hist(chm2, xlab="Elevação (metros)", ylab="Frequência")

#Gerar DTM
dtm = grid_terrain(las, algorithm = tin())
plot(dtm, xlab="UTM Easting", ylab="UTM Northing")
hist(dtm, xlab="Elevação (metros)", ylab="Frequência")

#Converter para raster
chm1.raster = raster(chm1)
chm2.raster = raster(chm2)
dtm.raster = raster(dtm)

writeRaster(chm1.raster,paste0("data","/","CHM1.tif"))
writeRaster(chm2.raster,paste0("data","/","CHM2.tif"))
writeRaster(dtm.raster,paste0("data","/","DTM.tif"))

#Altura de planta
altura = chm1.raster - dtm.raster

plot(altura, xlab="UTM Easting", ylab="UTM Northing")
hist(altura, xlab="UTM Easting", ylab="UTM Northing")
writeRaster(altura,paste0("data","/","Altura.tif"))

#Voxel com resolucao de 1m (computa o numero de pontos)
#Usaria para estimar volume de biomassa
voxel1 = grid_metrics3d(las, length(Z))