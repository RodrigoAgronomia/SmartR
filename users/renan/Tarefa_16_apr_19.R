#Tarefa aula 2 16/04/19;

library(sf)
library(raster)
library(tmap)

rst<-readRDS('data/simul.rds')
field<-readRDS('data/field.rds')

#Criando grid de poligonos (1 ha);
pols<-st_make_grid(field,cellsize=c(100, 100))

#Plotando raster;
plot(rst)
plot(rst$sim1)

#Plotando grid;
plot(st_geometry(pols),add=TRUE,lwd=2)

#Convertendo raster para formato sf;
rst_pts<-st_as_sf(rasterToPoints(rst,spatial=TRUE))

#Convertendo poligonos para formato sf;
pols<-st_as_sf(data.frame(id=1:length(pols),pols))

#Selecionando poligono 20 do grid de 1 ha;
pols20<-pols[20,];pols20
plot(st_geometry(pols))
plot(st_geometry(pols20),col=2,add=TRUE)

#Selecionando pontos que correspondem a poligono 20;
rst_pts20<-rst_pts[pols20,];rst_pts20
plot(st_geometry(polsubpols))
plot(st_geometry(pols20),lwd=3,add=TRUE)
plot(rst_pts20,add=TRUE)

#Construção do loop para extrair a média de cada poligono do grid de 1 ha;
for (i in length(pols$id)){
                          subpol<-pols[pols$id==i,];subpol
                          sub_pts_rst<-rst_pts[subpol,];sub_pts_rst
                          mean_pol<-apply(sub_pts_rst,2,mean,na.rm=TRUE);mean_pol
                          }

polsf<-merge(pols,mean_pol);polsf


