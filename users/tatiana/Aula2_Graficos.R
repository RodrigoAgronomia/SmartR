library(ggplot2)
diretorio = './data'

#Listar arquivo .csv
file = list.files(diretorio, pattern = '.csv', full.names = TRUE)

#Leitura do arquivo .csv
dados = read.csv(file)

#Plotando os dados
plot(dados$Yield)
hist(dados$Yield)

plot(dados$Yield, dados$Flow, xlab = 'yield', ylab = 'flow')

esquisse:esquisser()

ggplot(data=dados)+
  aes(x=Yield)+
  geom_histogram(bins=57, fill ="#fb9a99") + 
  labs(title = "histogram yield")