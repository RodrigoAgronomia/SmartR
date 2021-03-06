## packages ---------------------------------------------------------------
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
plot(CE['CE_15000'], reset = FALSE)
plot(field, col = 'transparent', add = TRUE)
# dev.off()

## creat a buffer - objective: exclude the heaslands ----------------------
field_b = st_buffer(field, dist = -8)

plot(CE['CE_15000'], reset = FALSE)
plot(field_b, col = 'transparent', add = TRUE)
# dev.off()

## clip the data using the created buffer ---------------------------------
ov <- st_over(CE, st_geometry(field_b))
CE$Headland <- is.na(ov)

plot(CE["Headland"])

CE = CE[!CE$Headland,]

plot(CE['CE_15000'])
hist(CE$CE_15000)

## Geostatistic Def.: Geostatistics is a set of models and methods that are designed to study variables which
## are distributed in space (or possibly space-time). 
## Access https://journal.r-project.org/archive/2016-1/na-pebesma-heuvelink.pdf

## creat a grid to interpolate -------------------------------------------
grid = st_make_grid(field, cellsize = c(10, 10)) #Poligono a cada 10m
plot(grid)
plot(st_geometry(field),add=TRUE)
plot(st_geometry(CE),add=TRUE)

CE_sp <- as_Spatial(CE) #Converte para sp por causa de versao
grid_sp <- as_Spatial(grid)

## start geostatiscal analysis - create the objects of analysis ---------
gOK = gstat(NULL,'CE', CE_15000 ~ 1, CE, nmax = 100)

## calculates the variogram ----------------------------------------------
v = variogram(gOK,  width = 10, cutoff = 120) #Pontos agrupados em classe - distancia maxima
plot(v)

## create the basic model to be ajusted ----------------------------------
varinit = sd(CE$CE_15000)
m = vgm(0.8*varinit, "Sph", 60, 0.2*varinit)

## fits the model to the variogram ---------------------------------------
m = fit.variogram(v, m, fit.method = 7, fit.sills = TRUE) #Cria ajuste - gamma é a semivariancia

## present the fitted model ----------------------------------------------
plot(v,model = m, plot.numbers = TRUE,
     main = 'CE_15000', col = "black",
     cex = 1.5, pch = 20) #Linha continua e a estimativa inicial

## ordinary kriging -----------------------------------------------------
OK = krige(CE_15000 ~ 1, CE, newdata = grid,
           model = m, maxdist = 100, nmax = 10) #Media ponderada dos vizinhos (com 10 vizinhos)
library(stars)
plot(OK)

## crop to the original boudary -----------------------------------------
map = st_intersection(OK, field)
plot(map['var1.pred'])
plot(CE['CE_15000'])

#Criar raster
rst = raster(field, res = c(1,1))

gOK = gstat(gOK, 'CE', formula = CE_15000 ~1, CE,
           model = m, maxdist = 100, nmax = 10)

OK = interpolate(rst,gOK)
pred = mask(crop(OK,field),field)
plot(pred)
