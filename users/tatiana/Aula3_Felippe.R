#Libraries
library(sf)
library(readxl)

## create a new function
st_over <- function(x, y) {
  sapply(st_intersects(x, y), function(z) if (length(z) == 0) NA_integer_ else z[1])
}

#Read the data
data = read.csv('data/Colheita_Soja.csv')
str(data)
field <- read_sf("data/Boundary_colheita_Soja.shp")
str(field)
plot(field['id'])

#Transform csv to spatial data
data = st_as_sf(data, coords = c('Longitude', 'Latitude'), crs = 4326)
str(data) #coordenadas em geometry

#Change graus to UTM para produtividade
prod = st_transform(data, 32722)
st_coordinates(prod)

st_coordinates(field)
field = st_transform(field, 32722)
st_coordinates(field)

plot(field, col = 'transparent', reset = FALSE)
plot(prod['Yld.Mass.Dry..tonne.ha.'], add = TRUE)

dev.off()

#Histogram to grain moisture
hist(prod$Moisture...)
dev.off()
table(prod$Moisture...<0)

#Criteria to filter data based on Moisture
#media +ou - 2 dp
sd_moi = sd(prod$Moisture...)
mean_moi = mean(prod$Moisture...)

crit = prod$Moisture...>(mean_moi-2*sd_moi) & prod$Moisture...<(mean_moi+2*sd_moi)

prod_clean = prod[crit,] #selecao dos dados que atendem criterio

hist(prod_clean$Moisture...)

#Criteria to filter data based on Yield
hist(prod_clean$Yld.Mass.Dry..tonne.ha.)
str(prod_clean$Yld.Mass.Dry..tonne.ha.)

sd_y = sd(prod$Yld.Mass.Dry..tonne.ha.)
mean_y = mean(prod$Yld.Mass.Dry..tonne.ha.)

prod_clean = prod_clean[prod_clean$Yld.Mass.Dry..tonne.ha. < 7,]

hist(prod_clean$Yld.Mass.Dry..tonne.ha.)

#Change the column name
names(prod_clean)[17] = 'Yield_ton_ha'

#Plot the area
plot(prod_clean['Yield_ton_ha'])

#Deletar pontos fora do talhao
ov = st_over(prod_clean, st_geometry(field))
prod_clean$Headland = is.na(ov)

plot(prod_clean["Headland"])

prod_clean = prod_clean[!prod_clean$Headland,] #! desde que nao seja

plot(prod_clean['Yield_ton_ha'])

#Outra forma de deletar
prod_clean = st_intersection(prod_clean,field) #sobreposicao espacial
plot(prod_clean['Yield_ton_ha'])

#Tarefa
