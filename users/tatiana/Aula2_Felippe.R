#Diretorio no projeto CursoR
dir = "./data"

#Listar arquivo .csv
file = list.files(dir, pattern = '.csv', full.names = TRUE)

#Leitura do arquivo .csv
dados = read.csv(file)

#Selecionar uma linha dos dados
linha = dados[1,]

#Selecionar um dado especifico
dados[30,13]

#Selecionar uma coluna especifica
coluna = dados[,2]
#coluna = dados$Yield

#Corrigir tipo de dados
#dados$Yield = as.numeric(as.character(dados$Yield))

#Criando criterio de selecao
media = mean(dados$Yield)
str(dados)

criterio = dados$Yield >= media
alta_prod = dados[criterio,]
min(alta_prod$Yield)

#Criando criterio complexo
media_flow = mean(dados$Flow)
criterio2 = dados$Yield >= media & dados$Flow >= media_flow
alta_flow = dados[criterio2,]

min(alta_flow$Yield)
min(alta_flow$Flow)

#Criar nova coluna no data frame
dados$NovaArea = dados$Distance*dados$Width #em m²

#Verificar o nome das colunas
names(dados)
#renomear variaveis
#names(dados) = c('1','2','3','4','5','6','7')

#head - apresenta os primeiros valores
?head
head(dados, 10)
tail(dados)

#summary - retorna uma estatistica descritiva dos dados
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
library(ggplot2)
esquisse::esquisser()

ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 57, fill = "#fb9a99") +
  labs(title = "Histograma Yield",
       x = "Yield (bu/ha)",
       y = "Index") +
  theme_grey()

#table - classifica e conta os dados por classificacao
?table
table(dados$CropName)
table(dados$Yield) #Nao faz sentido utilizao o table() - porque e numerico 
table(dados$GrowerName)

#bind - unir!
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