
diretorio = './data'

#Abrir um arquivo .csv

##Listar arquivo .csv

file = './data/colheita.csv'

file = list.files(diretorio, pattern = ',csv', full.names = TRUE)

##Leitura do arquivo .csv

dados = read.csv(file)

#Selecionar uma linha dos dados

linha = dados[1,]

#Selecionar um dado de uma linha especifica

dados[30,13]

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
names(dados) = c('Fernando', 'Felippe', 'Marccos', 'Rodrigo', 'Joao', 'Fernando', 'Felippe', 'Marccos', 'Rodrigo', 'Joao', '1', '2', '3', '4')
