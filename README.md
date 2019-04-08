# SmartR
Smart Agri R training

----------------------------------------------%
%------ Aula 1 -  Treinamento R SmartAgri -----%
%---- Título: Passo a passo instação do R -----%
%----------- Autor:  Felippe Karp -------------%
%----------------------------------------------%


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


%----------------------------------------------%
%------ Aula 1 -  Treinamento R SmartAgri -----%
%------- Título: Atividades da Aula 1 ---------%
%----------- Autor:  Felippe Karp -------------%
%----------------------------------------------%

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

7. Funções mode(), str(), print(), cat(), paste0()

8. Tarefa: Criar um script que demonstre operacões simples no R usando variáveis, abra um 
arquivo .csv, .txt e excell, verifica os tipos de variáveis e salva eles em um formato
diferente do inicial. Ex.: se era .csv, salva como .txt.

Ler um pouco mais sobre o básico do R - https://rstudio-education.github.io/hopr/basics.html