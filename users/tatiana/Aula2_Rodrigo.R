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

tmap_mode("plot")
#tmap_save()

# Plot the raster using the standard plot:
plot(rst)
plot(rst$sim1)

# Try to overlay both:
plot(st_geometry(pols), add = TRUE, lwd = 2)

# Try to overlay both:
tm_shape(rst) + tm_raster('sim1') +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders() + 
  tm_grid(alpha = 0.2)+
  tm_compass(position = c("left", "bottom")) +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_credits('Author', size = 0.7, align = "left", position = c("left", "bottom")) +
  tm_legend(scale = 0.8)
  
# Try to overlay both:
tmap_mode("plot")

tm_shape(rst) + tm_raster('sim1', style = 'quantile') +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders() + 
  tm_grid(alpha = 0.2)+
  tm_compass(position = c("left", "bottom")) +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_credits('Tati', size = 0.7, align = "left", position = c("left", "bottom")) +
  tm_legend(scale = 0.8) + tm_layout(inner.margins = c(0, .02, .02, .02))

## Subsetting  ----------------------------------------------------------
rst_pts <- st_as_sf(rasterToPoints(rst, spatial = TRUE))

# by index:
pols20 <- pols[20,]
# by attribute:
pols20 <- pols[pols$id == 20,]
# Spatial:
rst_pts20 <- rst_pts[pols20,]

#Calcular a media de todas as simulacoes em cada poligono
#mean(rst_pts20$sim1)

resumo <- sapply(pols$id, function(i) {
  subpol <- pols[pols$id == i, ]
  sub_pts <- rst_pts[subpol, ]
  sub_pts = st_set_geometry(sub_pts, NULL)
  #sub_pts$geometry <- NULL
  apply(sub_pts, 2, mean, na.rm = TRUE)
})

#Converter lista em tabela (matrix)
resumo2 = data.frame(t(resumo))
resumo2$id = pols$id

uniao = merge(pols, resumo2, by = 'id')
plot(uniao)

#polsf <- merge(pols,media)

plot(polsf)

plot(st_geometry(pols20))
plot(rst_pts20, add = TRUE)

plot(st_geometry(pols))
plot(st_geometry(pols20), lwd = 5, add = TRUE)
plot(st_geometry(rst_pts20), add = TRUE)

saveRDS(pols, 'data/grid_pols.rds')

#GPKG é o mesmo formato do shp
write_sf(pols, 'data/grid_pols.gpkg')
write_sf(pols, 'data/grid_pols.shp')
