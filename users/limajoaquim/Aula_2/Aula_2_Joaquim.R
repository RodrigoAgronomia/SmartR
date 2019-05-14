##instalando pacote esquisse

#library
install.packages('ggplot2')
library(ggplot2)
library(esquisse)

diretorio = './data'

#Abrir um arquivo .csv

##Listar arquivo .csv

file = list.files(diretorio, pattern = '.csv', full.names = TRUE)

##Leitura do arquivo .csv

dados = read.csv("./data/Colheita.csv")

##selecionar uma linha dos dados

linha = dados[1,]
linha

## selecionar um dado de uma linha especifica

dados[30,12]

## selecionar uma coluna especifica

coluna = dados[,2]
coluna = dados$Yield

##criando criterio de selecao

media = mean(dados$Yield)
media
str(dados)

crit = dados$Yield > media
alt_prod = dados[crit,]
min(alt_prod$Yield)

# criando um criterio mais complexo

media_flow = mean(dados$Flow)
media_flow
crit2 = dados$Yield >= media & dados$Flow >= media_flow
alt_prod_flow = dados[crit2,]
min(alt_prod_flow$Yield)
min(alt_prod_flow$Flow)

#criando uma nova coluna no data.frame

dados$NovaArea = dados$Distance*dados$Width 
dados$NovaArea = (dados$NovaArea)/10000
dados$NovaArea

##  verificar o nome das minhas colunas
names(dados)

# plotando os dados

plot(dados$Yield)
hist(dados$Yield)

plot(dados$Yield, dados$Flow, xlab = "Yield (bu/ac)", ylab = "Flow")
hist(dados$Yield, main = "Histogram Yield", col = "blue")

##Graficos com ggplot2

esquisse::esquisser()

ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 58, fill = "#9e9ac8") +
  labs(title = "Histogram of productivity",
       x = "Yield (bu/ac)",
       y = "Frequency",
       subtitle = "- Corn") +
  theme_classic()

## packages ---------------------------------------------------------------
install.packages("sf")
install.packages("raster")
install.packages("tmap")

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
tm = tm_shape(pols) + tm_polygons("id")
tm + tm_shape(field) + tm_borders(lwd = 10)

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

tm_shape(rst) + tm_raster("sim1", style = 'kmeans') +
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
  tm_credits("Author: Lima, J.P.",
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

resumo = list()


for (i in pols$id) {
  subpol = pols[pols$id == i, ]
  sub_pts = rst_pts[subpol, ]
  sub_pts = st_set_geometry(sub_pts,NULL) 
  resumo[[i]] = apply(sub_pts, 2, mean, na.rm = TRUE)

  }
resumodf = do.call(rbind,resumo)
uniao = cbind(pols, resumodf)
uniao
plot(uniao)
resumo

# polsf <- merge(pols, mmmm)

plot(st_geometry(pols20))
plot(rst_pts20, add = TRUE)

plot(st_geometry(pols))
plot(st_geometry(pols20), lwd = 5, add = TRUE)
plot(st_geometry(rst_pts20), add = TRUE)

saveRDS(pols, "data/grid_pols.rds")

write_sf(pols, "data/grid_pols.gpkg")




#Selecionar uma linha dos dados

linha = dados[1,]

#Selecionar um dado de uma linha especifica

dados[30,1]

#Selecionar uma coluna especifica

coluna = dados[,2]

coluna = dados$Yield

#Arrumando problemas com a leitura de dados como fator
str(dados)

dados$Yield = as.numeric(as.character(dados$Yield))

str(dados)

#Criando criterio de selecao
media = mean(dados$Yield)

crit = dados$Yield >= media

alt_prod = dados[crit,]
min(alt_prod$Yield)

#Criando um criterio mais complexo

media_flow = mean(dados$Flow)

crit2 = dados$Yield >= media & dados$Flow >=media_flow

alt_prd_fl = dados[crit2,]

min(alt_prd_fl$Yield)
min(alt_prd_fl$Flow)

#Criar uma nova coluna no data frame
dados$NovaArea = (dados$Distance*dados$Width)/10000 

#Verificar o nome das minhas colunas
names(dados)
#names(dados) = c('Fernando', 'Felippe', 'Marccos', 'Rodrigo', 'Joao', 'Fernando', 'Felippe', 'Marccos', 'Rodrigo', 'Joao', '1', '2', '3', '4')

#head() - apresenta os primeiros valores
?head
head(dados, 10)
tail(dados)

#summary() - retorna uma estatistica descritiva dos dados
summary(dados)
summary(dados$Yield)

#Funcoes que apresentam os resultados da estatisca descritiva

mean(dados$Yield)
min(dados$Yield)
max(dados$Yield)
quantile(dados$Yield, 0.9)
median(dados$Yield)

#Plotando os dados
plot(dados$Yield, dados$Flow, xlab = 'Yield (bu/ac)', ylab = 'Flow')
hist(dados$Yield, main = 'Histograma Yield', col = 'blue')

#Graficos com ggplot
esquisse::esquisser()

ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 57, fill = "#fb9a99") +
  labs(title = "Histograma Yield",
       x = "Yield (bu/ha)",
       y = "Index") +
  theme_grey()

#table() - classifica e conta os dados por classificacao
?table

table(dados$CropName)
table(dados$Yield) #Nao faz sentido utilizao o table() - porque e numerico 
table(dados$GrowerName)


#bind() - unir!
?bind
rbind()#adiciona linha
cbind()#adiciona coluna

NovaArea = 2
cbind(linha, NovaArea)

rbind(dados, linha)

is = c('Felippe', 'Marcos', 'Fernando')

for (i in is){
  print(paste0("O participante e o: ", i))
}

#Funcoes print(), paste0(), cat()
print("Meu nome e Felippe")
paste0("Eu ", "fui ", "no ", "Brasil")

?write.csv
write.csv(dados, file.path('./data', paste0("SmartAgri_R_", i, ".csv")))


?cat()

cat("data", "ja", sep = ",")
