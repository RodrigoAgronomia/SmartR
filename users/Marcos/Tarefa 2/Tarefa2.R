library(readxl)
library(writexl)
library(ggplot2)

diretorio="C:/SmartR-master/SmartR-master/SmartR/users/Marcos/Tarefa 2"
arquivo=list.files(diretorio, pattern = ".xlsx", full.names=TRUE)
tabela=read_xlsx(arquivo,sheet="Dados_R")
tabela
summary(tabela)

esquisse::esquisser()
library(ggplot2)


#Gráfico 1
ggplot(data = tabela) +
  aes(x = Tempo, y = `Pressão a cada 1`) +
  geom_line(color = "#0c4c8a") +
  labs(title = "Incremento de 1 bar a cada 1 segundo",
    x = "Tempo",
    y = "Pressão (bar)",
    subtitle = "Pressão Real ") +
  theme_grey()

#Gráfico 2
ggplot(data = tabela) +
  aes(x = `Tempo a cada 5`, y = `Pressão a cada 5`) +
  geom_line(color = "#35b779") +
  labs(title = "Incremento de 5 bar a cada 5 segundos",
       x = "Tempo",
       y = "Pressão (Bar)",
       subtitle = "Pressão Real") +
  theme_economist()

#Gráfico 3
ggplot(data = tabela) +
  aes(x = `Erro a cada 1`) +
  geom_histogram(bins = 30, fill = "#35b779") +
  labs(title = "Incremento de 1 bar a cada 1 segundos",
       x = "Erro",
       y = "Frequencia",
       subtitle = "Erro (%)") +
  theme_economist()

#Gráfico 4
ggplot(data = tabela) +
  aes(x = `Erro a cada 5`) +
  geom_histogram(bins = 30, fill = "#0c4c8a") +
  labs(title = "Incremento de 5 bar a cada 5 segundos",
       x = "Erro",
       y = "Frequencia",
       subtitle = "Erro (%)") +
  theme_economist()

#salvando gráfico

grafico=file.path(diretorio, paste0("Marcos",  " Grafico"," ", "1", ".png"))

                  
png(grafico)   
print(ggplot(data = tabela) +
        aes(x = `Erro a cada 5`) +
        geom_histogram(bins = 30, fill = "#0c4c8a") +
        labs(title = "Incremento de 5 bar a cada 5 segundos",
             x = "Erro",
             y = "Frequencia",
             subtitle = "Erro (%)") +
        theme_economist())
