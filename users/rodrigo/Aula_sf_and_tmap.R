## packages ---------------------------------------------------------------
library(sf)
library(raster)
library(tmap)

## read data --------------------------------------------------------------
rst <- readRDS('data/simul.rds')
field <- readRDS('data/field.rds')

## create a polygon grid --------------------------------------------------
pols <- st_make_grid(field, cellsize = c(100, 100))
pols <- st_as_sf(data.frame(id = 1:length(pols), pols))

## Making Plots  ----------------------------------------------------------
# plot using the standard plot_sf:
plot(pols)

# plot using the standard tmap layout:
qtm(pols)

# use the id to fill the polygons:
qtm(pols, fill = 'id')

# add the field borders:
tm <- tm_shape(pols) + tm_polygons('id')
tm + tm_shape(field) + tm_borders(lwd = 10)

tmap_mode("view")
#tmap_save()

# Plot the raster using the standard plot:
plot(rst)
plot(rst$sim1)

# Try to overlay both:
plot(st_geometry(pols), add = TRUE, lwd = 2)

# Try to overlay both:
tm_shape(rst) + tm_raster('sim1') +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders()


# Try to overlay both:
tm_shape(rst) + tm_raster('sim1', style = 'quantile') +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders()

## Subsetting  ----------------------------------------------------------
rst_pts <- st_as_sf(rasterToPoints(rst, spatial = TRUE))

# by index:
pols20 <- pols[20,]
# by attribute:
pols20 <- pols[pols$id == 20,]
# Spatial:
rst_pts20 <- rst_pts[pols20,]

plot(st_geometry(pols20))
plot(rst_pts20, add = TRUE)

plot(st_geometry(pols))
plot(st_geometry(pols20), lwd = 5, add = TRUE)
plot(st_geometry(rst_pts20), add = TRUE)

