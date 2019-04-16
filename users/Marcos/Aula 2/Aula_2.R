diretorio="./data"

#abrir um arquivo .csv

##listar arquivo CSV
file = list.files(diretorio, pattern = ".csv", full.names=TRUE)

##Leitura do arquivo csv
dados = read.csv2(file)
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
dados$