#libraries
library(ggplot2)

diretorio="./data"

#abrir um arquivo .csv

##listar arquivo CSV
file = list.files(diretorio, pattern = ".csv", full.names=TRUE)

##Leitura do arquivo csv
dados = read.csv(file)
dados

#selecionar uma linha dos dados
#dados[linha,coluna]
linha = dados[1,]
linha

#selecionar um dado de uma linha especifica
dados[30,13]

#selcionar uma comuna especifica
coluna = dados[,2]
coluna = dados$Yield

#criar um critério para seleção
mean(dados$Yield)
#vendo o tipo de dados da minha tabela
str(dados)

#corrigindo problema de tipo de dad

as.numeric(as.character(dados$Yield))
dados$Yield=as.numeric(as.character(dados$Yield))
str(dados)
mean(dados$Yield)

#criar um critério para seleção - quero pegar apenas as variaveis com produtividade acima da média
media = mean(dados$Yield)
crit = dados$Yield >= media 
alt_prod = dados[crit,]
min(alt_prod$Yield)

#criando um critério mais complexo

dados$Flow=as.numeric(as.character(dados$Flow))
media_flow = mean(dados$Flow)
crit2 = dados$Yield>= media & dados$Flow>=media_flow
alt_prod_fl=dados[crit2,]
min(alt_prod_fl$Yield)
min(alt_prod_fl$Flow)

#criar uma nova coluna no data frame
dados$Distance=as.numeric(as.character(dados$Distance))
dados$Width=as.numeric(as.character(dados$Width))
dados$NovaArea = (dados$Distance*dados$Width)/10000


#verificar os nomes das minhas colunas
names(dados)
#criar novos nomes
#names(dados) = c("fernando","felipe","Marcos", "Rodrigo", "João", "1","2", "3","4","5", "6","7","8")

#head() - apresenta os primeiros valores, se negativo apresentará todos menos os x ultimos
#tail() - apresneta os ultimos valores
?head
head(dados,5)
tail(dados,5)
#summary() - retona uma estatistica descritiva dos dados
summary(dados)
summary(dados$Yield)

#funções que apresnetam resultados da estatistica descritiva 
mean(dados$Yield)
min(dados$Yield)
max(dados$Yield)
quantile(dados$Yield,0.9)#valor de "quartil"a 90% dos dados - valorque respresenta 90% dod dados
median(dados$Yield)

#plotando os dados
plot(dados$Yield)
plot(dados$Yield,dados$Flow) #definindo x e Y
plot(dados$Yield,dados$Flow,xlab="Yield (bu/ac",ylab="Flow")
hist(dados$Yield,main = "Histograma Yield", col="blue")

#gráficos com ggplot
esquisse::esquisser()
library(ggplot2)

ggplot(data = dados) +
  aes(x = Yield) +
  geom_histogram(bins = 40, fill = "#cf4446") +
  labs(title = "Histograma Yield",
    x = "Yield (bu/ac)",
    y = "Index",
    subtitle = "Aula R") +
  theme_bw()
esquisse::esquisser()
library(ggplot2)

ggplot(data = dados) +
  aes(x = Yield, y = Flow) +
  geom_point(color = "#e41a1c") +
  theme_economist()
#table() - classifica e conta os dados por classificação
?table
table(dados$CropName)
table(dados$Yield) #não faz sentido utilizar para dados numéricos
table(dados$GrowerName)

#bind() - Unir
?bind
rbind()#adiciona linha
cbind() #adiciona coluna
NovaArea = 2
cbind(linha,NovaArea)
rbind(dados,linha)

is=c("felippe","Marcos","fernando")
     
for(i in is){print(paste0("O participante é o :",i)}

#funções print(), paste0(), cat()
print("Meu Nome é Marcos")

paste0("eu ","Fui ", "no ", "Brasil")
#cat() - já tem o separador, por defout é o espaço
cat("data","já", sep=",")
