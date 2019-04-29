#library
library(ggplot2)


diretorio = './data'

#Abrir um arquivo .csv

##Listar arquivo .csv
file = list.files(diretorio, pattern = '.csv', full.names = TRUE)

##Leitura do arquivo .csv

dados = read.csv(file[1])

#plot padrão R
plot(dados$Yield)
hist(dados$Yield)

plot(dados$Yield, dados$Flow, xlab='Yield (bu/ac)',ylab='Flow')
hist(dados$Yield, main='Histogram Yield', col='blue')

#Plot com ggplot2
esquisse::esquisser()

#codigo copiado da interface ggplot2 e esquisse
ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 57, fill = "#08519c") +
  labs(title = "Histograma Produtividade",
       x = "produtividade",
       y = "frequencia") +
  theme_minimal()

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
