#EXERCICIO 1

library(dplyr)
library(lubridate)
library(stringr)

dados <- read.csv("Dados/Pokemon_full.csv")

df_means <- dados %>%
  group_by(type, secundary.type) %>%
  summarise(
    media_h = mean(height),
    media_w = mean(weight)
  )

df_means
View(df_means)

#? left_join
#TODO
df1 <- left_join(dados, df_means, by="type")
View(df1)
df_bug1 <- df1 %>% 
  filter(type =="bug") %>% head(15)
View(df_bug1)

#? right_join
#TODO
df2 <- right_join(dados, df_means, by="type")
View(df2)
df_bug2 <- df2 %>% 
  filter(type =="bug") %>% head(15)
View(df_bug2)


#############################################################
#EXERCICIO 2

library(tidyr)
library(readr)

#? baixado de https://livro.curso-r.com/

dados <- readr::read_rds("Dados/imdb.rds")
View(dados)
head(dados)
names(dados)

df <- dados %>% 
  select(orcamento, receita, receita_eua, nota_imdb, num_avaliacoes, num_criticas_publico, num_criticas_critica)
df

#Utilizei a função cor e, no argumento "use", coloquei o comando "complete.obs" para ignorar as observações com os valores ausente.
matriz_correlacao <- cor(df, use="complete.obs")
View(matriz_correlacao)

#A matriz de correlação é uma matriz quadrada em que os elementos na diagonal principal representam
# as correlações das variáveis individuais, que neste caso, são as maximas dado que uma variável sempre é correlacionada
#consigo mesma. Os elementos fora da diagonal principal representam as correlações entre os pares de variáveis.

# Organizando os resultados da matriz de correlação em um ranking decrescente:

valores_correlacao <- matriz_correlacao[upper.tri(matriz_correlacao)]
ranking_correlacao <- sort(valores_correlacao, decreasing = TRUE)
matriz_correlacao_decrescente <- matrix(ranking_correlacao, ncol = 1)
View(matriz_correlacao_decrescente)
