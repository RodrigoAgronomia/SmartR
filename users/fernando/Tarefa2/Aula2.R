#"C:/TreinamentoR/SmartR/Aula_1/Dados"

diretorio = './data'

#Abrir um arquivo.csv

#Listar arquivos. scv
list.files(diretorio, pattern = '.csv', full.names = T)
file = "./data/Colheita.csv"

#Leitura do arquivo 
dados = read.csv(file)

#Selecionar uma linha dos dados
linha = dados[2,]

#Selecionar coluna de dados
coluna = dados[,2]

#Criando criterios de selecao
media = mean(dados$Yield)

crit = dados$Yield > media

alta_prod = dados[crit,]
min(alta_prod$Yield)

#Criando nova coluna
dados$NovaArea = (dados$Distance*dados$Width)/10000

#Verificar o nome das minhas colunas
names(dados)
head(dados)
head(dados, 5) #apenas 5 primeiros 
head(dados, -5) #nao apresenta os 5 ultimos?
tail(dados)
summary(dados)

#Funcoes de estatistica descritiva para colunas especificas
mean(dados$Yield)
min(dados$Yield)
max(dados$Yield)
summary(dados$Yield)
median(dados$Yield)
median(dados$Yield, 0.1)
median(dados$Yield, 0.25) 
quantile(dados$Yield)

#Plotando em graficos
plot(dados$Yield, dados$Flow, xlab = 'Yield (bu/ac)', ylab = 'Flow') #fez o grafico com nome nos eixos
hist(dados$Yield, main = 'Histograma Yield', col = 'blue')

#graficos em ggplot
library(ggplot2)
install.packages("devtools")
install.packages("esquisse")
devtools::install.github("dreamRs/esquisse")
library(esquisse)
esquisse::esquisser()

#a linha abaixo foi retirada do esquisse
ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 21, fill = "#0c4c8a") +
  labs(x = "Yield (bu/ac)") +
  theme_minimal()

#table() classifica e conta os dados por classificacao
?table
table(dados$CropName) #aqui o table nos mostras quantas observacoes de cada cultura
table(dados$Yield) #nao faz sentido usar o table nesse caso
str(dados)

#bind() - unir
rbind#adiciona linha
cbind#adiciona coluna

NovaArea = 2
cbind(linha, NovaArea)
rbind(dados, linha)

#funcoes print(), paste0() e cat()
print("Meu nome e xadao")
paste0("Eu ", "fui ", "no ", "Brasil") #usa muito para salvar arquivos
