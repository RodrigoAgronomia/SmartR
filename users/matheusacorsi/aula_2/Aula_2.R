diretorio = './data'

# abrir .csv

# listar arquivos .csv

file = './data/Colheita.csv'

file = list.files(diretorio, pattern = '.csv', full.names = TRUE)

#leitura do arquivo .csv

dados = read.csv(files)

# Selecionar uma linha dos dados

linha = dados[1,]

coluna = dados[,2]

coluna = dados$Yield

# Comando para converter dados lidos como nao numerico em numerico

as.numeric(as.character(dados$Yield))

dados$yield = as.numeric(as.character(dados$Yield))

str(dados)

# Criando criterio de selecao

media = mean(dados$Yield)

crit = dados$Yield >= media

alt_prod = dados[crit,]

min(alt_prod$yield)

# criando criterio mais complexo

media_flow = mean(dados$Flow)

crit2 = dados$Yield >= media & dados$Flow >= media_flow

alt_prod_flow = dados[crit2,]

min(alt_prod_flow$Flow)

# criar uma nova coluna no dataframe

dados$NovaArea = (dados$Distance*dados$Width)/10000

# Verificar o nome das minhas colunas

names(dados)

# Substituir cabecalho dos dados

names(dados) = c('pedro', 'paulo', 'joao', 'alex', 'renato', 'barbara', '1', '2', '3', '4', '5', '6', '7', '8')
