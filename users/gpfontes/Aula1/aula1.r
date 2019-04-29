diretorio = "C:/Users/giovani3/Documents/TreinamentoR/SmartR/data"
diretorio2 = "./data"

#lista de arquivos que estao na pasta
list.files(diretorio)

#abrindo um arquivo csv
#cria uma variavel contendo o arquivo csv
csv = list.files(diretorio, pattern = ".csv")
csv
