library(sf)
library(raster)
library(tmap)
library(fasterize)
library(gstat)

## create a new function
st_over <- function(x, y) {
  sapply(st_intersects(x, y), function(z) if (length(z) == 0) NA_integer_ else z[1])
}

## read data --------------------------------------------------------------
CE <- readRDS("data/dataCE.rds") #Condutividade
field <- readRDS("data/fieldCE.rds") #Limite

## change the CRS ---------------------------------------------------------
CE = st_transform(CE,4326) #Se estivesse em lat long
#st_crs(CE) #Ver formato dado
st_coordinates(CE) #Em UTM
CE = st_transform(CE, 26915)
st_coordinates(CE)

st_coordinates(field)
field = st_transform(field, 26915)
st_coordinates(field)

## plot the data and boundary ---------------------------------------------
#plot(CE['CE_15000'], reset = FALSE)
qtm(CE, symbols.size = 0.4, symbols.col = "CE_15000", fill.title = "CE_15000")

#plot(field, col = 'transparent', add = TRUE)
qtm(field)

# dev.off()

## creat a buffer - objective: exclude the heaslands ----------------------
field_b = st_buffer(field, dist = -8)

#plot(CE['CE_15000'], reset = FALSE)
#plot(field_b, col = 'transparent', add = TRUE)
qtm(field_b)

# dev.off()

## clip the data using the created buffer ---------------------------------
ov <- st_over(CE, st_geometry(field_b))
CE$Headland <- is.na(ov)
#plot(CE["Headland"])
qtm(CE, symbols.size = 0.3, symbols.col = "Headland", fill.title = "CE_Headland")

CE = CE[!CE$Headland,]

#NAO FUNCIONOU
plot(CE['CE_15000'])
qtm(CE, symbols.size = 0.6, symbols.col = "CE_15000", fill.title = "CE_15000")
hist(CE$CE_15000)

## Geostatistic Def.: Geostatistics is a set of models and methods that are designed to study variables which
## are distributed in space (or possibly space-time). 
## Access https://journal.r-project.org/archive/2016-1/na-pebesma-heuvelink.pdf

## creat a grid to interpolate -------------------------------------------
grid = st_make_grid(field, cellsize = c(10, 10)) #Poligono a cada 10m

#plot(grid)
tmap_mode("plot")
qtm(grid)
plot(st_geometry(field),add=TRUE)
plot(st_geometry(CE),add=TRUE)

#NAO FUNCIONOU Overlay
tm_grid(grid) +
  tm_shape(field) +
  tm_borders() +
  tm_shape(CE) +
  tm_borders()
  
CE_sp <- as_Spatial(CE) #Converte para sp por causa de versao
grid_sp <- as_Spatial(grid)

## start geostatiscal analysis - create the objects of analysis ---------
gOK = gstat(NULL,'CE', CE_15000 ~ 1, CE, nmax = 100)

## calculates the variogram ----------------------------------------------
v = variogram(gOK,  width = 10, cutoff = 120) #Pontos agrupados em classe - distancia maxima

