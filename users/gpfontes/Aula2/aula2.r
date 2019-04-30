#Recap aula 1
#abrir um arquivo csv
#antes de abrir precisa salvar o diretorio

diretorio = "./data" #o ponto pega o diretorio que esta em cima, no caso treinamento/SmartR

#listar arquivo csv
#example, se tiver varios arquivos cvs, podemos pedir a lista de todos os arquivos csv na pasta
file = list.files(diretorio, pattern = ".csv", full.names = T)

#arquivos da lista
file[1]
file[2]

#leitura do arquivo csv
dados = read.csv(file[1])

#selecionar uma linha dos dados
linha = dados[1,] #[linha,coluna]. Seleciona linha 1 de todas as colunas

#selecionar uma coluna dos dados
coluna = dados[,2]
coluna2 = dados$Yield #pode usar o $ para selecionar a coluna inteira

#vendo a estrutura do arquivo dados
str(dados)

#criando criterio de selecao
#selecionar yield que for maior que a media
media = mean(dados$Yield)

criterio = dados$Yield > media

alta_prod = dados[criterio,]
min(alta_prod$Yield)

#criterio mais complexo
media_flow = mean(dados$Flow)

criterio2 = dados$Yield > media & dados$Flow > media_flow #mais de um criterio & = and

alta_prod1 = dados[criterio2,]

#criar uma nova coluna no dataframe
dados$NovaArea = (dados$Distance * dados$Width) / 10000

#verificar o nome das colunas
names(dados)

#mudar nome das colunas - deve ter o mesmo numero de coluna
names(dados) = c("a","b","c","d","e","f","g","h","i","j","1","2","3")

#aula terminou aqui

