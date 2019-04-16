## ------------------------------------------------------------------------
library(sp)
library(sf)
library(raster)

set.seed(54321)

f_coords <- base::cbind(c(0, 800), c(0, 600))
geom <- sf::st_as_sfc(sf::st_bbox(sf::st_multipoint(f_coords)))
field <- sf::st_sf(geom, crs = 32621)
field <- sf::st_as_sf(data.frame(Talhao = 'T1', field))
saveRDS(field, 'data/field.rds')

pols <- sf::st_make_grid(field, cellsize = c(100, 100))

## ------------------------------------------------------------------------
rst <- raster::raster(field, res = 10)
rst_grd <- rasterToPoints(rst, spatial = T)
gridded(rst_grd) <- TRUE

m <- gstat::vgm(psill = 1, model = "Gau",
                range = 500,
                nugget = 0.1)
g.dummy <- gstat::gstat(
  formula = z ~ 1,
  dummy = TRUE, beta = 0,
  model = m, nmax = 10
)
rst_sim <- predict(g.dummy, rst_grd, nsim = 10)
rst <- stack(rst_sim)
saveRDS(rst, 'data/simul.rds')
