# CARREGAMENTO DOS PACOTES NECESSARIOS ----------------------------------------------------------

library(sf)
library(raster)
library(tmap)

# LEITURA DOS DADOS MATRICIAIS E VETORIAIS ------------------------------------------------------

rast_10c <- readRDS("data/simul.rds")
limite <- readRDS("data/field.rds")

# CRIANDO MALHA DE POLIGONOS DE 1 HECTARE CADA EM CIMA DO PERIMETRO (LIMITE) --------------------

parcelas = st_make_grid(limite, cellsize = c(100, 100))

# CONVERTENDO PARA O FORMATO SF E ATRIBUINDO ID PARA CADA POLIGONO ------------------------------

parcelas = st_as_sf(data.frame(id = 1:length(parcelas), parcelas))

# PLOTANDO AS PARCELAS DELIMITADAS --------------------------------------------------------------
 
plot(parcelas)
plot(rast_10c)
plot(rast_10c$sim1)

# SOBREPOSIÇÃO DE CAMADAS -----------------------------------------------------------------------

plot(st_geometry(parcelas), add = TRUE, lwd = 2)

# SOBREPOSIÇÃO UTILIZANDO O PACOTE TMAP

tm_shape(rast_10c) + tm_raster('sim2') + 
  tm_shape(limite) + tm_borders(lwd = 5) +
  tm_shape(parcelas) + tm_borders(lwd = 3)

# TAREFA ----------------------------------------------------------------------------------------
# Construir um loop para calcular a media dos valores
# de todas as simulações em cada um dos polígonos do grid.
# Juntar ao conjuto de dados dos poligonos.

# CONVERSÃO DOS DADOS RASTER (RAST_10C) PARA PONTOS ---------------------------------------------
raster_pts = st_as_sf(rasterToPoints(rast_10c, spatial = TRUE))

teste = raster_pts

resumo = list()
for(i in parcelas$id) {
  sub_parc = parcelas[parcelas$id == i, ]
  sub_pts = raster_pts[sub_parc,]
  sub_pts = st_set_geometry(sub_pts, NULL)
  resumo[[i]] = apply(sub_pts, 2, mean, na.rm = TRUE)
  
}

resumodf <- do.call(rbind, resumo)
uniao <- cbind(parcelas,resumodf)
plot(uniao)



