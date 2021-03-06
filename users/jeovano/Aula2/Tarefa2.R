## packages ---------------------------------------------------------------
library(sf)
library(raster)
library(tmap)

## read data --------------------------------------------------------------
rst <- readRDS("data/simul.rds")
field <- readRDS("data/field.rds")


## create a polygon grid --------------------------------------------------
pols <- st_make_grid(field, cellsize = c(100, 100))
pols <- st_as_sf(data.frame(id = 1:length(pols), pols))

## Making Plots  ----------------------------------------------------------
# plot using the standard plot_sf:
plot(pols)

# plot using the standard tmap layout:
qtm(pols)

# use the id to fill the polygons:
qtm(pols, fill = "id")

# add the field borders:
tm <- tm_shape(pols) + tm_polygons("id")
tm + tm_shape(field) + tm_borders(lwd = 3)

#Vizualização interativa
tmap_mode("view")



# Plot the raster using the standard plot:
plot(rst)
plot(rst$sim1)

# Try to overlay both:
plot(st_geometry(pols), add = TRUE, lwd = 2)

tmap_mode("view")

# Try to overlay both:
tm_shape(rst) + tm_raster("sim1") +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders()

tmap_mode("plot")

# Try to overlay both:
tm_shape(rst) + tm_raster("sim1", style = "quantile") +
  tm_shape(field) + tm_borders(lwd = 10) +
  tm_shape(pols) + tm_borders() +
  tm_grid(alpha = 0.2) +
  tm_compass(position = c("left", "bottom")) +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_credits("Author: Lima, J.L.A.",
    size = 0.7, align = "left",
    position = c("left", "bottom")
  ) +
  tm_legend(scale = 0.8)

## Subsetting  ----------------------------------------------------------
rst_pts <- st_as_sf(rasterToPoints(rst, spatial = TRUE))

# by index:
pols20 <- pols[20, ]

# by attribute:
pols20 <- pols[pols$id == 20, ]

# Spatial:
rst_pts20 <- rst_pts[pols20, ]

# Tarefa:
# Construir um loop para calcular a media dos valores
# de todas as simulações em cada um dos polígonos do grid.
# Juntar ao conjuto de dados dos poligonos.

#Resolução da tarefa

resumo<-list() #cria lista para valores das medias

for (i in pols$id) {
  subpol <- pols[pols$id == i, ]

  sub_pts <- rst_pts[subpol, ]
  
  #subtrai os valores da coluna geometria
 sub_pts <- st_set_geometry(sub_pts,NULL)
 
 resumo[[i]] <- apply(sub_pts, 2,mean,na.rm=TRUE) #aplica as medias a lista 
 
} 

resumodf <- do.call(rbind, resumo) #converte a lista em matrix 

uniao<- cbind(pols,resumodf) # faz a união dos dados mais a geometria

plot(uniao)
