#especificando diretorio

diretorio="./data"
diretorio = "./data"
diretorio

library(readxl)
library(writexl)

# lendo arquivo CSV
csv = list.files(diretorio, pattern = "csv",full.names=TRUE)
csv
tabela_csv = read.csv(csv)

#salvando em txt
write.table(tabela_csv,file = file.path(diretorio,"colheita_tarefa.txt"))

#Salvando em excel
write_xlsx(tabela_csv,path = file.path(diretorio,"colheita_tarefa.xlsx"))

#lendo aqruivo txt
txt = list.files(diretorio, pattern = "Colheita.txt",full.names=TRUE)
txt
tabela_txt = read.delim(txt)

#salvando txt em csv
write.csv(tabela_txt,file = file.path(diretorio,"colheita_tarefa.csv"))
