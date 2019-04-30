library(tidyverse)
library(rpart)
library(rpart.plot)
library(rattle)
library(RColorBrewer)

##funcao para salvar um .csv com os dados estimados e preditos na arvore recursiva
write_sub = function(model,test_set,sub_id){
  preds = predict(model, test, type = 'class')
  submission = data.frame(PassengerId = test_set$PassengerId, Survived = preds)
  write.csv(submission,file = paste0('submission_',sub_id,'.csv'),row.names = FALSE)
}

##funcao para retornar a acuracia do modelo no conjunto de teste
get_score = function(model,test_set){
  reais = test_set$Survived
  preds = predict(model, test_set, type = 'class')
  acc = mean(preds==reais)
  return(acc)
}

getwd()
setwd("C:/Users/joaqu/Google Drive/Doutorado/2019_1/mineracao_dados/aula7_bag_rf_b/data/")

##carregando o cunjunto de treino e teste e as labels
train = read_csv('../data/train.csv')
test = read_csv('../data/test.csv')
test_labelled = read_csv('../data/test_labelled.csv')

## ajustando uma arvore em função de Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked
## os atributos PassengerId, Name, Ticket, Cabin não foram utilizados para predicao
fit = rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
            data=train, 
            method="class")

## pipe para visualizar as variaveis de maior importancia na arvore
fit$variable.importance %>% as.data.frame() %>% rownames()

##predicao dos atributos no modelo de arvore(apenas para as variaveis de interesse)
## notar que a predicao esta sendo realizado apenas para os atributos considerados
## na arvore
preds = predict(fit, test %>% select(Pclass,Sex,Age,SibSp,Parch,Fare,Embarked),type = 'class')

## executando a funcao criada acima para salvar o modelo
## sintaxe :
## primeiro - modelo ## segundo - conjunto teste ## terceiro - nome do arquivo
write_sub(fit,test, 'simple_tree')
## plotando a arvore
fancyRpartPlot(fit,cex = 1)
##acuracia da arvore
get_score(fit, test_labelled)

##criando uma outra arvores induzindo ao overfit
overfit = rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked,
                data=train,
                method="class", 
                control=rpart.control(minbucket=2, #minimum number of observations in a leaf
                                      cp=0 #any split that does not increase the fit by a factor of cp is not done
                ))
##plotando a arvore
fancyRpartPlot(overfit)
## executando a funcao criada acima para salvar o modelo
write_sub(overfit,test,'overfitted')
#acuracia da arvore
get_score(overfit, test_labelled)

##-------------- criando alguns recursos -----------
##adicionando o test$survived para igualar o numero de colunas
## o nome da coluna tem que ser EXATAMENTE o mesmo 
test$Survived = NA
##unindo as linhas dos dataframes train e test
df = rbind(train, test)
str(df)

##retirando os nomes e deixando apenas o prefixo "Mrs" "Ms" "Cap"
##fazendo pra primeira linha
strsplit(df$Name[1],split='[,.]')[[1]][2]
##fazendo isso para todas as linhas
prefix = sapply(df$Name, function(x){strsplit(x,split='[,.]')[[1]][2]})
df$Title =  as.character(prefix)
df$Title = str_replace(df$Title, " ","")
table(df$Title)

df$Title[df$Title %in% c('Mme', 'Mlle')] = 'Mlle'
df$Title[df$Title %in% c('Capt', 'Don', 'Major', 'Sir')] = 'Sir'
df$Title[df$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] = 'Lady'
##passando a coluna title para caracter
df$Title = as.factor(df$Title)

##criando uma variavel tamanho da familia
df$FamilySize = df$SibSp + df$Parch + 1
df$FamilySize
surnames = sapply(df$Name, function(x){strsplit(x,split='[,.]')[[1]][1]})

surnames

## concatenando vetores depois de passalos para fator
df$FamilyId = paste(as.character(df$FamilySize), surnames, sep="")
table(df$FamilyId)
##criando a variavel famId
famId = as.data.frame(table(df$FamilyId))
famId

##substituindo FamilyId em famId$Var1 por 'Small'
df$FamilyId[df$FamilyId %in% famId$Var1] = 'Small'
df$FamilyId = factor(df$FamilyId)
df$FamilyId

##depois de adicionado algumas variaveis retornamos com os conjuntos de train e test
train = df[1:891,]
test = df[892:1309,]
##labels de test
test_labels = test_labelled$Survived
test_labelled = test
test_labelled$Survived = test_labels



fit1 = rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyId,
            data=train, 
            method="class")
write_sub(fit,test,'featured')
get_score(fit, test_labelled)

rpart_tune = data.frame(
  expand.grid(minbucket = seq(from =2, to =50, by = 2),
              cp = c(0.0001,0.001, 0.01, 0.1, 0.2),
              # maxdepth = 3:7,
              fold = 1:5),
  acc = NA
)

create_fold_index = function(nrows, folds){
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}

cv_index = create_fold_index(nrow(train),5)

aggregate(acc ~ minbucket + cp + maxdepth , rpart_tune, mean) %>% arrange(desc(acc))
aggregate(acc ~ minbucket + cp , rpart_tune, mean) %>% arrange(desc(acc))

tuned_fit = rpart( Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyId,
                   train,
                   control = rpart.control(
                     minbucket = 42,
                     #maxdepth = 30,
                     cp = 0.0001),
                   method='class')
get_score(tuned_fit,test_labelled)
write_sub(tuned_fit, test, 'tuned')

get_score(fit,test_labelled)
get_score(tuned_fit,test_labelled)

fancyRpartPlot(fit)

fit$variable.importance %>% as.data.frame() %>% rownames_to_column() %>% rename('attribute' = rowname, 'importance' = '.')  %>% 
  ggplot(aes(x = attribute, y = importance)) + geom_bar(stat='identity',fill='steelblue') + theme_classic() + coord_flip()
