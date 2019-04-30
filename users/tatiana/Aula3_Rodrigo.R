## packages ---------------------------------------------------------------
library(sf)
library(raster)
library(dplyr)
library(tmap)

# Create a new function
st_over <- function(x, y) {
  sapply(st_intersects(x, y), function(z) if (length(z) == 0) NA_integer_ else z[1])
} #informacoes entre camadas - somente o primeiro id

## read data --------------------------------------------------------------
rst <- readRDS("data/simul.rds")
field <- readRDS("data/field.rds")

## create a polygon grid --------------------------------------------------
pols <- st_make_grid(field, cellsize = c(100, 100))
pols <- st_as_sf(data.frame(id = 1:length(pols), pols))


## Spatial Join  ----------------------------------------------------------
rst_pts <- st_as_sf(rasterToPoints(rst, spatial = TRUE))

# Point in polygon opreation
ov <- st_over(rst_pts, pols) #a qual poligono pertence o ponto

# Get the polygon id for each point:
rst_pts$id <- pols$id[ov]
  
# How many points in each polygon?
table(ov)

# Set the geometry to null, converting back to a data frame:
rst_pts <- st_set_geometry(rst_pts, NULL)

# Makes a subgroup:
rst_pts$subid <- 1:2

# Group points based on the polygon id:
rst_pts <- group_by(rst_pts, id, subid)

# Calculates de average of every collum for each group:
rst_rsm <- summarise_all(rst_pts, mean)

# Join the data summary to the polygon geometries:
pols_rsm <- left_join(pols, rst_rsm, by = 'id') #mantem poligono que nao tenha pontos (merge)

# Makes a simple map to compare the raster and polygon results:
qtm(rst$sim1)
qtm(pols_rsm, 'sim1')

## Pipe  ----------------------------------------------------------

pols_rsm <- rst %>%
  rasterToPoints(spatial = TRUE) %>% 
  st_as_sf() %>% 
  mutate(id = pols$id[st_over(., pols)]) %>%  #cria nova coluna (.)resultado da linha anterior
  st_set_geometry(NULL) %>%
  group_by(id) %>%  
  summarise_all(mean) %>%
  left_join(pols, ., by = 'id')

# Makes a simple map to compare the raster and polygon results:
qtm(rst$sim1)
qtm(pols_rsm, 'sim1')

write_sf(pols_rsm, "data/pols_rsm.gpkg")
