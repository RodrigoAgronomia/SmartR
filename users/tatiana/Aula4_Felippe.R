#Library
library(sf)
library(sp)
library(rgdal)
library(maptools)

#Criacao da variavel diretorio
diretorio = './data'

#Encontrar meus arquivos
file = list.files(diretorio, pattern = 'Soja.csv', full.names = TRUE)

#Abrir o arquivo 
dados_df = read.csv(file)
dados = read.csv(file)
str(dados)

#df como espacial usando biblioteca sp
coordinates(dados) = ~Longitude+Latitude
str(dados)

#Definir qual a projecao dos dados
proj4string(dados) = CRS('+init=epsg:4326')

#Transformar para UTM
projUTM = CRS('+init=epsg:32722')
dados = spTransform(dados, projUTM) #muda datum
str(dados)
coordinates(dados)

#df como espacial usando biblioteca sf
dados_sf = st_as_sf(dados_df, coords = c('Longitude', 'Latitude')) #arquivo espacial
str(dados_sf)

#Definir projecao
st_crs(dados_sf) = 4326

#df como espacial e adicionando projecao
dados_sf = st_as_sf(dados_df, coords = c('Longitude', 'Latitude'), crs = 4326)

#Transformar para UTM
dados_sf = st_transform(dados_sf, crs=32722)

#Salvar dados como arquivo de extensao espacial 

writeOGR(dados, dsn = diretorio , layer = 'colheita_sp', driver="ESRI Shapefile") #SE FOR SP

write_sf(dados_sf, file.path(diretorio, 'colheita_sf.gpkg'))

#Abrindo arquivo com extensao espacial
#Encontrar meus arquivos
file_sp = list.files(diretorio, pattern = 'sp.shp', full.names = TRUE)
file_gpkg = list.files(diretorio, pattern = 'gpkg', full.names = TRUE)

d_sp = readOGR(file_sp)

d_sf = read_sf(file_sp)
d_sf = read_sf(file_gpkg)

#Plotar o mapa
plot(d_sf['Field'], col = 'red')
?plot