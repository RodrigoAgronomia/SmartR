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
CE <- readRDS("data/dataCE.rds")


field <- readRDS("data/fieldCE.rds")

## identify System coordinate

st_crs(CE)

## change the CRS ---------------------------------------------------------
st_coordinates(CE)
CE = st_transform(CE, 26915)
st_coordinates(CE)

st_coordinates(field)
field = st_transform(field, 26915)
st_coordinates(field)

##Define Plot mode on TM function - by jeovano
tmap_mode("plot")

##use the function qtm - Quick thematic map - by jeovano
qtm(CE, symbols.col =  'CE_15000')
qtm(field)

## create a polygon grid --------------------------------------------------
pols <- st_make_grid(field, cellsize = c(10, 10), square = FALSE)
pols <- st_as_sf(data.frame(id = 1:length(pols), pols))

## Making Plots  ----------------------------------------------------------
# plot using the standard tmap layout:
qtm(pols)

# use the id to fill the polygons:
qtm(pols, fill = "id")

## creat a buffer - objective: exclude the heaslands ----------------------
field_b = st_buffer(field, dist = -12)
##qtm(CE, symbols.col =  'CE_15000')
##qtm(field_b)
##dev.off()

##use the function tmap to overlay - by jeovano
tm <- tm_shape(pols) + tm_polygons("id")
tm + tm_shape(field) + tm_borders(lwd = 3)
dev.off()


##tm + tm_shape(field_b) + tm_borders(lwd = 3) + tm_shape(field) + tm_borders(lwd = 4) + tm_shape(CE) + tm_symbols('CE_15000', col = 'CE_15000')

tm_shape(field) + tm_borders(lwd = 2) + tm_shape(field_b) + tm_borders(lwd = 3) + tm_shape(CE) +
tm_symbols(col = 'CE_15000')

## clip the data using the created buffer ---------------------------------

ov <- st_over(CE, st_geometry(field_b))
CE$Headland <- is.na(ov) ## ov foi criada, com todos os campos NA

#plot(CE["Headland"])
qtm(CE["Headland"])

CE = CE[!CE$Headland,] ##Essa funcão esta zerando a variável CE

qtm(CE['CE_15000'])
#plot(CE['CE_15000'])


hist(CE$CE_15000)
## Geostatistic Def.: Geostatistics is a set of models and methods that are designed to study variables which
## are distributed in space (or possibly space-time). 
## Access https://journal.r-project.org/archive/2016-1/na-pebesma-heuvelink.pdf

## creat a grid to interpolate -------------------------------------------
##grid = st_make_grid(field, cellsize = c(10, 10))
##plot(grid)
plot(st_geometry(field), add=TRUE)
plot(st_geometry(CE), add=TRUE)

CE_sp <- as_Spatial(CE)
grid_sp <- as_Spatial(grid)


## start geostatiscal analysis -  create the objects of analysis ---------
gOK = gstat(NULL,'CE', CE_15000 ~ 1, CE, nmax = 100)

## calculates the variogram ----------------------------------------------
v = variogram(gOK,  width = 10, cutoff = 120)
plot(v)

## create the basic model to be ajusted ----------------------------------
varinit = sd(CE$CE_15000)
m = vgm(0.8*varinit, "Sph",20, 0.2*varinit)

## fits the model to the variogram ---------------------------------------
m = fit.variogram(v, m, fit.method = 7, fit.sills = TRUE)

## present the fitted model ----------------------------------------------
plot(v,model = m, plot.numbers = TRUE,
     main = 'CE_15000', col = "black",
     cex = 1.5, pch = 20)


## ordinary kriging -----------------------------------------------------
OK_krige = krige(CE_15000 ~ 1, CE, newdata = grid,
           model = m, maxdist = 100, nmax = 10)

## ordinary IDW-----------------------------------------------------
OK_idw = idw(CE_15000 ~ 1, CE, newdata = grid,
           model = m, maxdist = 100, nmax = 10)

## crop to the original boudary -----------------------------------------

map = st_intersection(OK_krige, field)
plot(map['var1.pred'])

plot(CE['CE_15000'])

## create a raster

rst<-raster(field,res=c(1,1))

gOK = gstat(gOK,'CE', formula=CE_15000 ~ 1, CE, model=m,maxdist=100,nmax = 10)
OK=interpolate(rst,gOK)
pred<-mask(crop(OK,field),field)


##Define View mode on TM function em plot prediction - by jeovano
tmap_mode("view")
qtm(pred)
