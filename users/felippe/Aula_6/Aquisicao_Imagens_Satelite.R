#Aquisicao de imagens de satelite manualmente
# https://earthexplorer.usgs.gov/
# https://scihub.copernicus.eu/dhus/#/home

#Como automatizar? APIs
# https://github.com/16EAGLE/getSpatialData

#Bibliotecas
library(sf)
library(raster)
library(rgdal)
library(getSpatialData)

# Se ainda nao tiver o pacote 'devtools' instalado, realizar a instalacao:
# install.packages('devtools')
devtools::install_github("16EAGLE/getSpatialData")

#Criar um usuario para o CoperHub - https://scihub.copernicus.eu/dhus/#/self-registration
user = 'feh_karp'
password = 'f=330180125'

#Funcao que realiza o login na sua conta
login_CopHub(user, password)

#Desenhar a area de interesse para busca das imagens
set_aoi() #Chamar set_aoi() sem argumentos,abre um mapedit editor

## Outra forma e definir o AOI (podendo ser uma matriz, sf ou sp objeto)
contorno = read_sf('data/Boundary_colheita_Soja.shp')
contorno = st_as_sf(contorno)

# Define o AOI para esta secao
set_aoi(st_geometry(contorno))
view_aoi() #abre o AOI no viewer

#Define o local onde salvar as imagens
set_archive("C:/Images")

## Use getSentinel_query para pesquisar as imagens que possuem o AOI
records = getSentinel_query(time_range = c("2019-03-01", "2019-03-30"), 
                             platform = "Sentinel-2") #ou "Sentinel-1" ou "Sentinel-3"

## Filtrar os resultados
colnames(records) #apresenta todos os atributos diponiveis para a filtragem 
unique(records$processinglevel) 

#filtra pr porcetagem de recobrimento de nuvens
records_filtered = records[as.numeric(records$cloudcoverpercentage) <= 15, ] 

## Apresenta a tabela com os resultados iniciais
View(records)
## Apresenta a tabela com os resultados filtrados
View(records_filtered)

## Apresenta um dos resultados com a AIO
getSentinel_preview(record = records_filtered[3,])

## Download do dataset para o arquivo definido em set_archive
datasets <- getSentinel_data(records = records_filtered[3, ])

## Define o formato do output
datasets = list.files("Y:/", full.names = T)

#VRT
datasets_prep <- prepSentinel(datasets, format = "vrt")

## Visualizacao dos dados
datasets_prep[[1]][[1]][1] #10 m 
datasets_prep[[1]][[1]][2] #20 m 
datasets_prep[[1]][[1]][3] #60 m 

## Abre os arquivos direto do diretorio no R
r = stack(datasets_prep[[1]][[1]][1])
plot(r)

contorno = as(contorno, 'Spatial')

r = mask(crop(r, contorno), contorno)
