library(sf)
library(tmap)
library(raster)

#Aquisição de imagens --------------
library(rgdal)
library(fs)
library(getSpatialData)
library(devtools)

user = 'renantavanti'
password = 'chicoc91'

#Funcao que realiza o login na sua conta
login_CopHub(user, password)

#Desenhar a area de interesse para busca das imagens
set_aoi() #Chamar set_aoi() sem argumentos,abre um mapedit editor

## Outra forma e definir o AOI (podendo ser uma matriz, sf ou sp objeto)
contorno = readRDS('data/field_sat.rds')
contorno = st_as_sfc(st_bbox(contorno))
plot(contorno)

# Define o AOI para esta secao
set_aoi(st_geometry(contorno))
view_aoi() #abre o AOI no viewer

set_archive("D:/R/Imagens_sat")

## Use getSentinel_query para pesquisar as imagens que possuem o AOI
records = getSentinel_query(time_range = c("2019-03-01", "2019-03-30"), 
                            platform = "Sentinel-2") #ou "Sentinel-1" ou "Sentinel-3"



#Aula Recomendação ---------------
# Import the field boundaries:
field = readRDS('data/field_sat.rds')

# Plot the imported fields:
plot(field)

# Import one of the Sentinel images:
rst1 = stack('data/Images/S2B_tile_20190525.TIF')
rst2 = stack('data/Images/S2A_tile_20190520.TIF')
rst3 = stack('data/Images/S2B_tile_20190515.TIF')

# Reproject the vector to the same CRS of the raster:
field1 = st_transform(field, crs(rst1)@projargs)
field2 = st_transform(field, crs(rst2)@projargs)
field3 = st_transform(field, crs(rst3)@projargs)

# Assign the names to each band:
# o nome das bandas estão nas respectiva ordem de aquisição
names(rst1) = c('B3', 'B8', 'B4', 'B2')
names(rst2) = c('B3', 'B8', 'B4', 'B2')
names(rst3) = c('B3', 'B8', 'B4', 'B2')
str(rst1)

# Show the false-color representation of the image:
# Aplicou-se a conversão linear (pode usar a de distribuição) dos niveis de cor de cada banda para um intervalo que pode ser lido no plot (etre 0 e 255 "8 bits").
plotRGB(rst1, stretch = 'lin')
plotRGB(rst2, stretch = 'lin')
plotRGB(rst3, stretch = 'lin')

# Aplly the linear stretch to create a new raster:
# Criando nova variável com o stretch
rst_m1 <- stretch(rst1[[1:3]], minq = 0.02, maxq = 0.98) #De 1:3 para selecionar as bandas B3, B8 e B4
rst_m1[is.na(rst_m1)] = 255 #Setando valores NA como branco

rst_m2 <- stretch(rst2[[1:3]], minq = 0.02, maxq = 0.98)
rst_m2[is.na(rst_m2)] = 255

rst_m3 <- stretch(rst3[[1:3]], minq = 0.02, maxq = 0.98)
rst_m3[is.na(rst_m3)] = 255

# Show the false-color representation of the image using tmap:
tm_shape(field1) + tm_borders() +
  tm_shape(rst_m1) + tm_rgb() + 
  tm_shape(field1) + tm_borders(lwd = 3, col = 'blue')

tm_shape(field2) + tm_borders() +
  tm_shape(rst_m2) + tm_rgb() + 
  tm_shape(field2) + tm_borders(lwd = 3, col = 'blue')

tm_shape(field3) + tm_borders() +
  tm_shape(rst_m3) + tm_rgb() + 
  tm_shape(field3) + tm_borders(lwd = 3, col = 'blue')


# Crop the raster to the field extend and mask cells outside of the field:
# Recorte pelo principio 1° Crop (recorte pelo limite), 2° mask (pixels fora da borda com valor NA atributido)
#Raster 1
rst_c1 = mask(crop(rst1, field1), field1) #Fazendo para o raster orginal
rst_mc1 = mask(crop(rst_m1, rst_c1), rst_c1$B3) #Fazendo para o raster do stretch; PS: está sendo usado o raster original como parâmetro de corte ao invés dos limites
rst_mc1[is.na(rst_mc1)] = 255 #Atributindo o branco ao NA

#Raster 2
rst_c2 = mask(crop(rst2, field2), field2) #Fazendo para o raster orginal
rst_mc2 = mask(crop(rst_m2, rst_c2), rst_c2$B3) #Fazendo para o raster do stretch; PS: está sendo usado o raster original como parâmetro de corte ao invés dos limites
rst_mc2[is.na(rst_mc2)] = 255 #Atributindo o branco ao NA

#Raster 3
rst_c3 = mask(crop(rst3, field3), field3) #Fazendo para o raster orginal
rst_mc3 = mask(crop(rst_m3, rst_c3), rst_c3$B3) #Fazendo para o raster do stretch; PS: está sendo usado o raster original como parâmetro de corte ao invés dos limites
rst_mc3[is.na(rst_mc3)] = 255 #Atributindo o branco ao NA

# Show the false-color representation of the image:
plotRGB(rst_c1, stretch = 'lin')
plotRGB(rst_c2, stretch = 'lin')
plotRGB(rst_c3, stretch = 'lin')

# Show the false-color representation of the image using tmap:
tm_shape(field1) + tm_borders() +
  tm_shape(rst_mc1) + tm_rgb() + 
  tm_shape(field1) + tm_borders(lwd = 3, col = 'blue')

tm_shape(field2) + tm_borders() +
  tm_shape(rst_mc2) + tm_rgb() + 
  tm_shape(field2) + tm_borders(lwd = 3, col = 'blue')

tm_shape(field2) + tm_borders() +
  tm_shape(rst_mc2) + tm_rgb() + 
  tm_shape(field2) + tm_borders(lwd = 3, col = 'blue')


# Define a function to calculate vegetation index:
# Criando função para calcular o índice de vegetação (NDVI)
calc_VI = function(B1, B2){
  VI = (B2 - B1)/(B2 + B1)
  names(VI) = 'VI'
  return(VI)
}

# Calc the NDVI:
NDVI1 = calc_VI(rst_c1$B4, rst_c1$B8)
NDVI2 = calc_VI(rst_c2$B4, rst_c2$B8)
NDVI3 = calc_VI(rst_c3$B4, rst_c3$B8)

dev.off()
# Show the frequency distribution of the NDVI values:
hist(NDVI1[])
hist(NDVI2[])
hist(NDVI3[])

# Adjust very low NDVI points:
# Setando valores do último quantil (baixos valores de NDVI) para corresponder a um mesmo valor
NDVI1[NDVI1 < quantile(NDVI1, 0.01)] = quantile(NDVI1, 0.01)
NDVI2[NDVI2 > quantile(NDVI2, 0.99)] = quantile(NDVI2, 0.99)
NDVI3[NDVI3 > quantile(NDVI3, 0.98)] = quantile(NDVI3, 0.98)
NDVI3[NDVI3 < quantile(NDVI3, 0.002)] = quantile(NDVI3, 0.002)

# Show the frequency distribution of the NDVI values:
hist(NDVI1[])
hist(NDVI2[])
hist(NDVI3[])

# Plot the NDVI map:
plot(NDVI1)
plot(NDVI2)
plot(NDVI3)

# Show the the NDVI map using tmap:
mapNDVI1<-tm_shape(field1) + tm_borders() +
  tm_shape(NDVI1) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field1) + tm_borders(lwd = 3, col = 'blue');mapNDVI1

mapNDVI2<-tm_shape(field2) + tm_borders() +
  tm_shape(NDVI2) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field2) + tm_borders(lwd = 3, col = 'blue');mapNDVI2

mapNDVI3<-tm_shape(field3) + tm_borders() +
  tm_shape(NDVI3) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field3) + tm_borders(lwd = 3, col = 'blue');mapNDVI3

tmap_mode("plot")
tmap_arrange(mapNDVI1,mapNDVI2,mapNDVI3)

# Field based prescription of nitrogem and PGR:
# Recomendação pelo NDVI "Ajuste teórico"
df_rx1 = data.frame(VI = quantile(NDVI1, c(0.1,0.25,0.5,0.75,0.9)), #Mostrando valores dos quartis que correspondem a 10, 25, 50, 75 e 90%
                   N = c(130, 120, 100, 80, 60), #130 kg de N para valores correspondentes até os 10%; 120 kg para valores até 25%...
                   PGR = c(NA, 60, 80, 100, 120)) #Valores para o regulador de crescimento aplicado ao algodoeiro;

#Mudar valores: O NDVI está negativo, a dose máxima e mínima fica invertida
df_rx2 = data.frame(VI = quantile(NDVI2, c(0.1,0.25,0.5,0.75,0.9)), #Mostrando valores dos quartis que correspondem a 10, 25, 50, 75 e 90%
                    N = c(130, 120, 100, 80, 60), #130 kg de N para valores correspondentes até os 10%; 120 kg para valores até 25%...
                    PGR = c(NA, 60, 80, 100, 120)) #Valores para o regulador de crescimento aplicado ao algodoeiro;

#Mudar valores: O NDVI está negativo, a dose máxima e mínima fica invertida
df_rx3 = data.frame(VI = quantile(NDVI3, c(0.1,0.25,0.5,0.75,0.9)), #Mostrando valores dos quartis que correspondem a 10, 25, 50, 75 e 90%
                    N = c(130, 120, 100, 80, 60), #130 kg de N para valores correspondentes até os 10%; 120 kg para valores até 25%...
                    PGR = c(NA, 60, 80, 100, 120)) #Valores para o regulador de crescimento aplicado ao algodoeiro;


plot(df_rx1)
plot(df_rx2)
plot(df_rx3)


# Prescription model for N:
# Criando modelo linear 2° grau para recomendação
lm_N1 = lm(N ~ poly(VI, 2), df_rx1)
lm_N2 = lm(N ~ poly(VI, 2), df_rx2)
lm_N3 = lm(N ~ poly(VI, 2), df_rx3)

# Predict the rate based on the model:
# Predição no raster com base no modelo linear criado
Rx_N1 = predict(NDVI1, lm_N1)
Rx_N2 = predict(NDVI2, lm_N2)
Rx_N3 = predict(NDVI3, lm_N3)

# Show the frequency distribution of the N rates:
hist(Rx_N1[])
hist(Rx_N2[])
hist(Rx_N3[])

# Adjust the extreme rates:
# Ajustando a variação Max e Min com base na "Recomendação teórica". PS: o modelo tende a extrapolar valores.
Rx_N1[NDVI1 < min(df_rx1$VI)] = max(df_rx1$N, na.rm = TRUE)
Rx_N1[NDVI1 > max(df_rx1$VI)] = min(df_rx1$N, na.rm = TRUE)

Rx_N2[NDVI2 < min(df_rx2$VI)] = max(df_rx2$N, na.rm = TRUE)
Rx_N2[NDVI2 > max(df_rx2$VI)] = min(df_rx2$N, na.rm = TRUE)

Rx_N3[NDVI3 < min(df_rx3$VI)] = max(df_rx3$N, na.rm = TRUE)
Rx_N3[NDVI3 > max(df_rx3$VI)] = min(df_rx3$N, na.rm = TRUE)

# Show the frequency distribution of the N rates:
# Nomeando a camada "Layer" para "Rate"
hist(Rx_N1[])
names(Rx_N1) = 'Rate'

hist(Rx_N2[])
names(Rx_N2) = 'Rate'

hist(Rx_N3[])
names(Rx_N3) = 'Rate'

# Mostrando doses de aplicação
plot(Rx_N1)
plot(Rx_N2)
plot(Rx_N3)

# Show the the nitrogen prescription map using tmap:
mapRxN1<-tm_shape(field1) + tm_borders() +
  tm_shape(Rx_N1) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field1) + tm_borders(lwd = 3, col = 'blue');mapRxN1

mapRxN2<-tm_shape(field2) + tm_borders() +
  tm_shape(Rx_N2) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field2) + tm_borders(lwd = 3, col = 'blue');mapRxN2

mapRxN3<-tm_shape(field3) + tm_borders() +
  tm_shape(Rx_N3) + tm_raster(palette = '-viridis', style = 'kmeans', n = 10) + 
  tm_shape(field3) + tm_borders(lwd = 3, col = 'blue');mapRxN3

tmap_mode("plot")
tmap_arrange(mapRxN1,mapRxN2,mapRxN3)

# Recomendação para o regulador de crescimento
# Prescription model for PGR:
lm_PGR = lm(PGR ~ poly(VI, 2), df_rx)

# Predict the rate based on the model:
# Criando modelo 2° grau para regulador
Rx_PGR = predict(NDVI, lm_PGR)

# Show the frequency distribution of the PGR rates:
hist(Rx_PGR[])


# Adjust the extreme rates:
# Ajustando valores Max e Min com base no modelo
# Ajustando valores de aplicação "dose fixa" para uma classe de NDVI
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
# Salvando recomendação para inserir no controlador da máquina
save_rx = function(r, file){
  pols = rasterToPolygons(r)         #1° converter raster para polígonos
  pols = st_as_sf(pols)              #2° formato st ("sp") para sf
  pols = st_transform(pols, 4326)    #3° transformando UTM para geográficas
  write_sf(pols, file)               #Salvando
  return(TRUE)                       #Retornando objeto corrigido
}


# Define a function to prepare the Rx map and save it:
# Mexendo na resolução do pixel
save_rx = function(r, file, resolution = 10){ #Inserindo argumento resolução
  rr = r
  res(rr) <- resolution
  r = projectRaster(r, rr)
  pols = rasterToPolygons(r)
  pols = st_as_sf(pols)
  pols = st_transform(pols, 4326)
  pols$Rate = round(pols$Rate)      #Transformando valores para números inteiros (arredondando). PS: alguns controladores não leêm frações
  write_sf(pols, file)
  return(TRUE)
}

# Save the prescription maps:
dir.create('data/Rx')
save_rx(Rx_N, 'data/Rx/Rx_N.shp', 20)
save_rx(Rx_PGR, 'data/Rx/Rx_PGR.shp', 30)


# Atividade:
# Elaborar comparativo de doses considerando as tres datas das imagens e tres resolucoes espaciais (1, 20 e 30 m)
# 9 recomendacoes de cada (N e PGR) = 18 rec
