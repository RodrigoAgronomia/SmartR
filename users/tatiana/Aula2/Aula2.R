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
#names(dad0s) = c('1','2','3','4','5','6','7')