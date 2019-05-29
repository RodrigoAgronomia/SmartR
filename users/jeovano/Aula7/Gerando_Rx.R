library(sf)
library(tmap)
library(raster)

# Import the field boundaries:
field = readRDS('data/field_sat.rds')

# Plot the imported fields:
plot(field)

# Import one of the Sentinel images:
#rst = stack('data/Images/S2B_tile_20190525.TIF')
rst = stack('data/Images/S2A_tile_20190520.TIF')
#rst = stack('data/Images/S2B_tile_20190515.TIF')

# Reproject the vector to the same CRS of the raster:
field = st_transform(field, crs(rst)@projargs)

# Assign the names to each band:
names(rst) = c('B3', 'B8', 'B4', 'B2')

# Show the false-color representation of the image:
plotRGB(rst, stretch = 'lin')

# Aplly the linear stretch to create a new raster:
rst_m <- stretch(rst[[1:3]], minq = 0.02, maxq = 0.98)
rst_m[is.na(rst_m)] = 255

# Show the false-color representation of the image using tmap:
tm_shape(field) + tm_borders() +
  tm_shape(rst_m) + tm_rgb() + 
  tm_shape(field) + tm_borders(lwd = 3, col = 'blue')

# Crop the raster to the field extend and mask cells outside of the field:
rst_c = mask(crop(rst, field), field)
rst_mc = mask(crop(rst_m, rst_c), rst_c$B3)
rst_mc[is.na(rst_mc)] = 255

# Show the false-color representation of the image:
plotRGB(rst_c, stretch = 'lin')

# Show the false-color representation of the image using tmap:
tm_shape(field) + tm_borders() +
  tm_shape(rst_mc) + tm_rgb() + 
  tm_shape(field) + tm_borders(lwd = 3, col = 'blue')


# Define a function to calculate vegetation index:
calc_VI = function(B1, B2){
  VI = (B2 - B1)/(B2 + B1)
  names(VI) = 'VI'
  return(VI)
}

# Calc the NDVI:
NDVI = calc_VI(rst_c$B4, rst_c$B8)

dev.off()
# Show the frequency distribution of the NDVI values:
hist(NDVI[])

# Adjust very low NDVI points:
NDVI[NDVI < quantile(NDVI, 0.01)] = quantile(NDVI, 0.01)

# Show the frequency distribution of the NDVI values:
hist(NDVI[])

# Plot the NDVI map:
plot(NDVI)

# Show the the NDVI map using tmap:
tm_shape(field) + tm_borders() +
  tm_shape(NDVI) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field) + tm_borders(lwd = 3, col = 'blue')


# Field based prescription of nitrogem and PGR:
df_rx = data.frame(VI = quantile(NDVI, c(0.1,0.25,0.5,0.75,0.9)), 
                   N = c(130, 120, 100, 80, 60),
                   PGR = c(NA, 60, 80, 100, 120))
plot(df_rx)

# Prescription model for N:
lm_N = lm(N ~ poly(VI, 2), df_rx)

# Predict the rate based on the model:
Rx_N = predict(NDVI, lm_N)

# Show the frequency distribution of the N rates:
hist(Rx_N[])

# Adjust the extreme rates:
Rx_N[NDVI < min(df_rx$VI)] = max(df_rx$N, na.rm = TRUE)
Rx_N[NDVI > max(df_rx$VI)] = min(df_rx$N, na.rm = TRUE)

# Show the frequency distribution of the N rates:
hist(Rx_N[])
names(Rx_N) = 'Rate'

plot(Rx_N)

# Show the the nitrogen prescription map using tmap:
tm_shape(field) + tm_borders() +
  tm_shape(Rx_N) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field) + tm_borders(lwd = 3, col = 'blue')

# Prescription model for PGR:
lm_PGR = lm(PGR ~ poly(VI, 2), df_rx)

# Predict the rate based on the model:
Rx_PGR = predict(NDVI, lm_PGR)

# Show the frequency distribution of the PGR rates:
hist(Rx_PGR[])


# Adjust the extreme rates:
Rx_PGR[NDVI < min(df_rx$VI)] = 0
Rx_PGR[NDVI > max(df_rx$VI)] = max(df_rx$PGR, na.rm = TRUE)
names(Rx_PGR) = 'Rate'

# Show the frequency distribution of the PGR rates:
hist(Rx_PGR[])


# Show the the nitrogen prescription map using tmap:
tm_shape(field) + tm_borders() +
  tm_shape(Rx_PGR) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field) + tm_borders(lwd = 3, col = 'blue')

# Show the relationship between NDVI and the prescription rates:
plot(NDVI[], Rx_N[], pch = '.', col = 'red', ylim = c(0,150))
points(NDVI[], Rx_PGR[], pch = '.', col = 'blue')


# Define a function to prepare the Rx map and save it:
save_rx = function(r, file){
  pols = rasterToPolygons(r)
  pols = st_as_sf(pols)
  pols = st_transform(pols, 4326)
  pols$Rate = round(pols$Rate)
  write_sf(pols, file)
  return(TRUE)
}

# Save the prescription maps:
dir.create('data/Rx')
save_rx(Rx_N, 'data/Rx/Rx_N.shp')
save_rx(Rx_PGR, 'data/Rx/Rx_PGR.shp')



