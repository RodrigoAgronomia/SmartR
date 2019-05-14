#Bibliotecas
library(sf)
library(tmap)
library(tmaptools)

#Atribuir o diretorio
diretorio = 'C:/MSc_Felippe/SmartR/data'

#Listar arquivos no diretorio
files = list.files(diretorio, pattern = '.rds', full.names = T)

#Busca um padrao numa lista
CE_file = grep('dataCE', files, value = T)

#Realiza a leitura do arquivo
CE = readRDS(CE_file)

#Transformar para UTM
CE = st_transform(CE, 32615)

plot(CE['CE_15000'])

#Buscar o aquivo de contorno
contorno_file = list.files(diretorio, pattern = 'fieldCE.rds', full.names = T)
contorno = readRDS(contorno_file)
contorno = st_transform(contorno, 32615)

#Plotar dois mapas sobrepostos
plot(contorno, col='transparent', reset = FALSE)
plot(CE['CE_15000'], add = TRUE)

#Criando um buffer negativo
cbuffer = st_buffer(contorno, dist = -6.5)

plot(cbuffer, col='transparent', reset = FALSE)
plot(CE['CE_15000'], add = TRUE)

dev.off()

#Recortar um arquivo sf com base em um outro arquivo sf
recortado = st_intersection(CE, cbuffer)
plot(recortado['CE_15000'])

#Calcular a media para o arquivo recortado
media = mean(recortado$CE_15000)

recortado_altaCE = recortado[recortado$CE_15000>media,]
plot(recortado_altaCE['CE_15000'])

recortado_baixaCE = recortado[recortado$CE_15000<media,]
plot(recortado_baixaCE['CE_15000'])

#Boxplot para CE
boxplot(recortado$CE_15000)

#Criando um mapa e salvando
png_file = 'C:/MSc_Felippe/SmartR/users/felippe/Mapa_CE.png'
png(png_file, width = 10, height = 7.5, res = 300, units = "in")

plot(recortado['CE_15000'], reset = FALSE, main = 'Condutividade Eletrica 15000 kHz')
plot(contorno, col = 'transparent', add = T)

dev.off()

#Usando tmap

?qtm
qtm(recortado['CE_15000'])

tm_shape(recortado) + tm_dots("CE_15000", style = "quantile", size = 0.1) +
  tm_shape(contorno) + tm_borders(lwd = 8) +
  tm_grid(alpha = 0.2) +
  tm_legend(scale = 0.8)

