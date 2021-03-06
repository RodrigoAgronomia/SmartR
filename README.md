# SmartR
Smart Agri R training


## Passo a passo: instalação do R 

*Autor:  Felippe Karp* 


1. Fazer o download do R correspondente ao seu sistema operacional;
	- Windows - https://cran.r-project.org/bin/windows/base/
	- Linux - https://cran.r-project.org/bin/linux/
	- MacOS - https://cran.r-project.org/bin/macosx/

2. Após concluir o download é só seguir os passos de instalação!
	- Caso exista alguma dúvida ou problema na instalação, consulte as páginas 1-6 deste livro:
	  http://128.95.149.81/trilobite/sr320_labnotebook_060113.enex/Cookbook%20for%20R.resources/r_cookbook.pdf

3. Finalizada a instalação você já pode usar o R. Contudo, a interface original dele não é tão amigável ("user-friendly").
Portanto, usa-se o Rstudio, que tarnsforma a experiência e uso do R muito mais agradável. 

4. Fazer o download do RStudio Desktop correspondente ao seu sistema operacional;
	- Link: https://www.rstudio.com/products/rstudio/download/#download.

5. IMPORTANTE: O RStudio não funciona sem que o R esteja instalado! Portanto, é necessário fazer a instalação do R primeiro!

6. Agora sim! Para começar a usar o R é só abrir o RStudio!



## Aula 1 -  Atividades

*Autor:  Felippe Karp*


Nosso objetivo na primeira aula é nos sentirmos familiarizados com o uso de controle de 
versão no R, termos, instalação de bibliotecas e funções básicas.

1. Abrir o RStudio e criar um novo projeto com controle de versão;

2. Familiarizar com o ambiente do RStudio;
	- Onde está o que?
	- Ajuda

3. R é uma calculadora sofisticada!
	- Funções básicas de cálculo

4. Alguns atalhos do teclado que facilitam a vida!
	- Ctrl + Enter
	- Ctrl + Alt + B
	- Ctrl + Alt + R

	Quer mais? 
	Acesse este link: https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts

5. Criação de variáveis;
	- Não use caracteres especiais!
	- O R é "case-sensitive"
	- O R sobrescreve sem pedir sua permissão!
	- ls()

6. Vamos abrir um arquivo!
	- .csv - read.csv() ou read.csv2()
	- .txt - read.delim() ou read.delim2()
	- excell file - readxl package, read_excel()
	- outras opções: read.table()...

7. Tarefa: Criar um script que demonstre operacões simples no R usando variáveis, abra um 
arquivo .csv, .txt e excell, verifica os tipos de variáveis e salva eles em um formato
diferente do inicial. Ex.: se era .csv, salva como .txt.

Ler um pouco mais sobre o básico do R - https://rstudio-education.github.io/hopr/basics.html

8. Acesse a video aula em: https://youtu.be/gpTj46WPlYU



## Aula 2 -  Atividades


*Autor:  Felippe Karp*

1. Recapitulando atividades da Aula 1;
    - Atalhos
    - Abrindo um arquivo .csv, .txt ou excel
    - Uso do github

2. Seleção de colunas e linhas;
    - Criação de critérios de seleção
    - Criação de variáveis com base em seleção
  
3. Criação de novas colunas em um data frame;
  
4. Funções mode(), str() e class();
    - Mudar tipo do objeto 
      - Ex.: as.numeric(as.character())
    
5. Funções: head, summary, plot, hist, names, table, rbind, cbind
    - names()
    - head()
    - summary() 
      - Atlernativas para obter apenas uma informação são: mean(), min(), max(), median() e quantile()
    - plot() ou ggplot() 
      - No caso do ggplot(), como a forma de programar é um pouco diferente, use essa ferramenta para se acostumar: https://github.com/dreamRs/esquisse e leia mais sobre o ggplot() neste livro https://r4ds.had.co.nz/data-visualisation.html
    - hist()
    - table()
    - rbind()
    - cbind()
  
6. Outras funções: print(), cat(), paste0()

7. Salvar arquivos - .csv, .txt and excell

8. TAREFA: Criar um script que abra um arquivo de dados que vocês possuem, apresentar uma estatistica descritiva dos dados e gerar pelo menos 3 diferentes gráficos usando ggplot.

    - DESAFIO: Exportar o grafico como uma imagem por meio de uma linha de comando e usar o paste0 para nomear.
    
9. Acesse as video aulas relacionadas a este tópico em: https://youtu.be/eObPJKlsnxo e https://youtu.be/fgY7TKHdHPI 

## Aula 3 -  Lidando com arquivos espaciais

*Autor:  Felippe Karp*

Agora que já sabemos como lidar com um "data frame", vamos complicar um pouquinho e vamos começar a lidar com dados espaciais. Então vamos começar olhando o arquivo!

1. Abrir novo arquivo 'Colheita_Soja.csv';
    - Primeiro é necessário definir o diretório e obter o caminho do arquivo (DICA: list.files());
    - Tendo obtido o caminho para o arquivo, usar a função read.csv() para abrir o arquivo;
    - Contudo, o R vai abrir e entender o arquivo como um data frame. Portanto, como mostrar para o R que é um arquivo espacial?

2. Dizer para o R que aquele data frame na realidade é um arquivo espacial;
    - Usando a biblioteca sp: coordinates(data) = ~x+y - pacote sp
    - Usando a biblioteca sf: st_as_sf(df, coords = c("X", "Y")) - pacote sf
    - Detalhe os arquivos criados não possuem as informações sobre CRS... é necessario adicionar...

3. Feito isso, vamos dar uma olhada nos dados e usar um pouco do que já usamos em um data frame!
    - Função plot() para dados espaciais (diferença entre usar '$' e '[]')

4. TAREFA: Utilizando os arquivos criados, criar critérios de seleção dos dados (ex.: Produtividade > Média da Produtividade) e gerar mapas.

5. Acesse a video aula em: https://youtu.be/vG84WpvDYzA

## Aula 4 -  Continuação lidando com arquivos espaciais e apresentação de resultados

*Autor:  Felippe Karp*

Nesta aula vamos aprender um pouco sobre como podemos manipular arquivos espaciais no R. Ou seja, como posso trabalhar com a tabela de atributos do meu objeto para fazer seleções, realizar buffer, sobrepor dois objetos, recortar um objeto baseado em outro e realizar a plotagem dos resutlados. 

1. Primeiro passo é a utilização da biblioteca que vai permitir a gente trabalhar com dados espaciais. Conforme comentamos em outras aulas, existe mais de uma biblioteca que pode ser utilizada. Contudo, já que a sf é a que nos permite obter a melhor perfomance, é esta que vamos usar! Além dessa bibliotea, vamos também utilizar a biblioteca tmap e tmaptools. Se você ainda nao tem elas instaladas, nao se esqueça, realiza a instalação antes de "chamar" ela no script;

2. Realizar a abertura dos dados que iremos trabalhar;
    - Na pasta data acessar o arquivo 'dataCE';
    - Uma das formas de acessar este arquivo é listar todos os arquivos da pasta data que tem o padrão ("pattern") '.rds';
    - Posteriormente, podemos utilizar a funcao grep() e procurar dentre estes arquivos aquele que possui 'dataCE' no nome;
    - Após atribuir o caminho do arquivo a um objeto, este objeto será o parametro da função readRDS() e a assim terá a leitura do arquivo;

3. Realizar o mesmo processo do item 2 para o contorno desta área que possui o nome 'fieldCE';

4. Checar e converter as coordenadas para UTM usando a função st_transform() e crs = 32615;

5. Usar a função plot() e seus parâmetros col, reset e add para plotar o contorno e os pontos no mesmo mapa;

6. Criar um buffer do contorno original utilizando a função st_buffer() - desde que os dados estejam em UTM o parametro dist desta função terá como unidade de medida o metro. Portanto, se o valor atribuido for 5, será equivalente a 5 m. IMPORTANTE: Se o valor for positivo, o buffer será positivo e vice-versa.

7. Recortar o arquivo de pontos com base no buffer criado - função st_intersection;

8. Realizar filtragem e seleção dos dados conforme a tabela de atributos;

9. Plotagem dos dados utilizando o tmap;

10. Acesse a video aula em: https://www.youtube.com/watch?v=yGrMKvOdjO4


## Aula 5 -  Geoestatística

*Autor:  Felippe Karp*

1. Acesse a video aula em: https://www.youtube.com/watch?v=lI58j5_R8Tg 




## Introdução ao R e GitHub (09/04/2019)

https://mediaspace.illinois.edu/media/t/1_puyino3e/

## Pacotes "sf" e "tmap" (16/04/2019)

https://mediaspace.illinois.edu/media/t/1_2ogep7hr

## Pacote "dplyr" (23/04/2019)

https://mediaspace.illinois.edu/media/t/1_9srtfxic

## Pacote "gstat" (30/04/2019)

https://mediaspace.illinois.edu/media/t/0_kl2vp986

## Filtragem de dados - Colheita (07/05/2019)

https://youtu.be/NeSFMY-T7X4

## Cluster (14/05/2019)

https://mediaspace.illinois.edu/media/t/1_pedae8i4

## Aquisição de imagens de satélite (21/05/2019)

*Autor: Isac Oliveira*

*link: https://www.youtube.com/watch?v=pPgbebd7eY4* 

Nessa aula Fellipe ensina como baixar imagens de satélite pelo R! utilizando *getSpatialData* (https://github.com/16EAGLE/getSpatialData). 

1. Criar um usuário para o *CoperHub* - https://scihub.copernicus.eu/dhus/#/self-registration ;

2. Definir a área de interesse, por desenho manual ou arquivo;

3. Escolha do local onde salvar as imagens;

4. Pesquisar as imagens por um período;

5. Filtrar os resultados, pré visualização;

6. Definição do formato do *output* e *download* das imagens.

-> TAREFA: Recortar apenas a área de interesse, salvá-las e excluir as imagens inteiras, a fim de reduzir o armazenamento utilizado.

## Gerando mapas de recomendação (28/05/2019)  

https://mediaspace.illinois.edu/media/t/1_rcwoft8h

## PAR package - Apresentacao do Pacote (08/06/2019)

https://mediaspace.illinois.edu/media/t/1_m124rgpj





