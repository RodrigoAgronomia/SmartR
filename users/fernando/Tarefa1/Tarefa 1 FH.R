#Atividade Aula 1
# Tarefa: Criar um script que demonstre operacões simples no R usando variáveis, abra um 
#arquivo .csv, .txt e excell, verifica os tipos de variáveis e salva eles em um formato
#diferente do inicial. Ex.: se era .csv, salva como .txt.

library("readxl")
library("xlsx")

diretorio = "C:\\TreinamentoR\\SmartR\\Aula_1\\Dados"
list.files(diretorio)

#abrindo csv e salvando excel
#Como faco para abrir o arquivo sem ter que colocar todo o caminho?
csv = read.csv("C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\Colheita.csv")
str(csv)
View(csv)
head(csv)
tail(csv)

write.table(csv, file = "C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\csvtotxt.txt", sep = ',')

#abrindo excel e salvando txt e verificando o arquivo
xlsx = read_xlsx("C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\Colheita.xlsx")
View(xlsx)
write.table(xlsx, file = "C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\xlsxtotxt.txt")
checktxt = read.table("C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\xlsxtotxt.txt")
View(checktxt)

#abrindo txt e salvando em xlsx e csv
txt = read.table("C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\Colheita.txt")
write.csv(txt, "C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\txttocsv.csv")
write.xlsx(txt, "C:\\TreinamentoR\\SmartR\\Aula_1\\Dados\\txttoxlsx.xlsx")





