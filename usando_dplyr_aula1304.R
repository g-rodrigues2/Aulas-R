#? Comentários com "?" são comentários normais
#! Comentários com "!" são códigos errados
#* Comentários com "*" são para correções
# Apenas "#" são códigos comentados (ignorados)
#TODO é algo para fazermos juntos

#? Vamos adicionar a biblioteca dplyr 
library(dplyr)

#? E outras bibliotecas que serão úteis
library(lubridate)
library(stringr)

#? Vamos começar com os dados de pokemon
#? https://www.kaggle.com/datasets/igorcoelho24/pokemon-all-generations/versions/1?resource=download
dados <- read.csv("Dados/Pokemon_full.csv")
head(dados) #? vê as primeiras linhas de dados
#dados <- read.csv("D:/Aulas/ferramentasdemodelagem/R/Dados/Pokemon_full.csv")
#? A biblioteca dplyr possui o operador "pipe"
#? dado por  %>%
#? Ele "pega" tudo que está à esquerda dele e coloca como primeiro elemento
#? da função à direita.
#? Também é possível usar o operador "."
#? para especificar onde ele deve substituir.

#? Exemplo: contar o número de linhas de dados

nrow(dados)
dados %>% nrow()
dados %>% nrow(.)


## grepl() # verifica se um padrão de string esta em um elemento
grepl("ap", "apple")
grepl("apple", "ap")

x <- "apple"

x %>% grepl("ap", .)
x %>% grepl("ap")

#? Algumas funções da biblioteca dplyr

#? A função filter seleciona linhas com base em um teste
df_grass <- filter(dados, type == "grass")
df_grass

#? podemos usar o seguinte comando também
 dados %>% filter(type == "grass")

#TODO Vamos filtrar todos os pokemons do tipo fogo ou água

df_fogo_e_agua <- dados %>% filter(type == "fire" | type == "water")
df_fogo_e_agua

#TODO Vamos filtrar todos os pokemons que tem  "fly"
dados %>% filter(grepl("fly", name))


#TODO Vamos filtrar todos os pokemons que tem  "bee" ou "saur"
dados %>% filter(grepl("bee", name) | grepl("saur", name))
dados %>% filter(grepl("bee|saur", name))
dados %>% head
