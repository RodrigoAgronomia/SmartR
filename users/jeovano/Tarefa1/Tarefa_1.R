# Importando bibliotecas

library(readxl)

diretorio="data"

# Selecionando arquivo e caminho
csv <- list.files(diretorio, pattern = ".csv", full.names = TRUE)
csv

# Lendo o arquivo csv
?read.csv
tabela_csv <- read.csv(csv[1]) # Abre um csv com separador ","
?write.table


#salvando o arquivo csv em txt
write.table(tabela_csv, "./users/jeovano/Tarefa1/tabela.txt", sep="\t")


print('executado ate o fim!')

