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

#TODO Vamos filtrar todos os pokemons que tem  "fly"
dados %>% filter(grepl("fly", name))

#TODO Vamos filtrar todos os pokemons que tem  "bee" ou "saur"
dados %>% filter(grepl("bee", name) | grepl("saur", name))
dados %>% filter(grepl("bee|saur", name))
dados %>% head

#? REGEX

vetor = c("banana", "Banana", "maça")
grepl("[Bb]anana", vetor)
grep("[Bb]anana", vetor)
vetor = c("2023/04/01", "Banana", "maça")
grepl("[A-Z]*", vetor)



#! errado
dados %>% filter((name == "bee" | name == "saur"))
filter(dados, name == "bee" | name =="saur")

#* FUNCIONA
dados[str_detect(dados$name, "bee|saur"),]

names(dados)

#? A função pull devolve um vetor

dados %>% pull(name)

dados %>%
    filter(type == "fire") %>%
    pull(secundary.type) %>%
    unique

dados2 <- dados[dados$type == "fire",]
unique(dados2$secundary.type)

unique(dados[dados$type == "fire",]$secundary.type)


dados %>% select(type) %>% unique
dados %>% select(type, secundary.type)
dados %>% select(type, secundary.type) %>% unique

#? A função select seleciona colunas
dados %>% select(c(1, 2, 3)) #? pelo número
df <- dados %>% select(name, type, height) #? pelo nome

df <- dados %>%select(height, weight, hp) %>% as.matrix()
df
#TODO achar todas as combinações existentes de type e secondary.type

dados %>% select(type, secundary.type) %>% unique

#? Outras possibilidades
dados %>% names
dados %>%
    select(starts_with("h")) %>% head #? starts_with, ends_with, contains

dados %>% select(-name) %>% head #? negativo exclui as colunas

#? A função mutate modifica ou cria uma coluna com base em outras
mutate(dados, height2=2*height) %>% head

df <- mutate(dados, height2 = 2*height) %>% head
nrow(df)

dados %>% mutate(height2=2*height)


dados <- dados %>% 
    mutate(
        height2 = 2*height,
        speed2 = 2*speed,
        bee = grepl("bee", name)
    )

dados %>% head


#? A função arrange organiza o data frame com base em colunas
dados %>%
    arrange(name) %>%
        head()

dados %>%
    arrange(name) %>%
        tail()

dados %>%
    arrange(desc(name)) %>%
        tail()

dados %>%
    arrange(desc(name)) %>%
        head()

dados %>%
    arrange(desc(name), height) %>% #Para organizar em ordem decrescente
        head()

df <- data.frame(
        nome = c("maria", "zé", "joão", "maria"),
        altura = c(2, 3, 4, 1)
    )
df

df %>%
    arrange(nome, altura)

#? Vamos fazer algumas contas!!

dados %>%
    summarise(
        media_altura = mean(height),
        media_peso = mean(weight)
    )

#? Podemos fazer isso por grupos
dados %>%
    group_by(type) %>%
        summarise(
            media_altura = mean(height),
            media_peso = mean(weight),
            N = n()
        ) %>%
            arrange(media_altura)

#TODO Filtrar os pokemons que tem o peso acima da média da altura do seu type
dados %>%
  group_by(type) %>% 
  mutate(
    media_altura = mean(height) #utilizamos a mutate pois não queremos criar outro dataframe, mas queremos manter o mesmo para depois descartar os pokemons que não estão acima da média
  ) %>% View

dados %>%
  group_by(type) %>% 
  mutate(
    media_altura = mean(height), 
    media_peso = mean(weight) #utilizamos a mutate pois não queremos criar outro dataframe, mas queremos manter o mesmo para depois descartar os pokemons que não estão acima da média
    ) %>% 
  filter(height > media_altura, weight > media_peso) %>%
  select(-media_altura, -media_peso) %>% 
  ungroup() %>% 
  rowwise() %>% 
  mutate(
    imc = weight/height^2,
    mm = sum(weight)
  ) %>% View


dados %>%
    group_by(type) %>%
    mutate(
        media_altura = mean(height)
    )  -> df 

    write.csv(df, "df.csv")
    xlsx::write.xlsx(df, "df.csv")

dados %>%
    group_by(type) %>%
    mutate(
        media_altura = mean(height),
        media_peso = mean(weight)
    ) %>%
    filter(height > media_altura, weight > media_peso) %>%
    select(-media_altura) %>%
    ungroup() %>%
    mutate(
        imc = weight/height^2,
        mm = sum(weight) #! Não funciona
    )-> df 

dados %>%
    group_by(type) %>%
    mutate(
        media_altura = mean(height),
        media_peso = mean(weight)
    ) %>%
    filter(height > media_altura, weight > media_peso) %>%
    select(-media_altura) %>%
    ungroup() %>%
    rowise() %>%
    mutate(
        imc = weight/height^2,
        mm = sum(weight) #* Funciona
    )-> df 

    write.csv(df, "df.csv")

    #TODO Lição
    #TODO criar uma coluna com a transformação Z-score para altura POR type utilizando TODAS
    
    #feito por mim
    dados %>%
      group_by(type) %>% 
      mutate(
        media_altura = mean(height), 
        desvio_padrao = sd(height),
        Z_score = (height-media_altura)/desvio_padrao
      ) %>% View
    
    #feito pelo professor
    dados %>% 
      group_by(type) %>% 
      mutate(
        z_height = (height-mean(height))/sd(height),
        z_weight = (weight-mean(weight))/sd(weight)
        )
  library(ggplot2)
  
    dados %>% pull(type) %>% unique
    
    ggplot(df)+
      geom_density(aes(x = z_height, color=type))+
      theme_bw()
    

#? Renomear colunas
dados %>%
    group_by(type) %>%
        summarise(
            media_altura = mean(height),
            media_peso = mean(weight),
            N = n() #n retorna o número de ocorrências
        ) %>%
            arrange(media_altura) %>%
                rename("Número de pokemons" = N)

#? Movê-las
dados %>%
    group_by(type) %>%
        summarise(
            media_altura = mean(height),
            media_peso = mean(weight),
            N = n()
        ) %>%
            arrange(media_altura) %>%
                rename("Número de pokemons" = N) %>%
                relocate("Número de pokemons")
dados %>%
    group_by(type) %>%
        summarise(
            media_altura = mean(height),
            media_peso = mean(weight),
            N = n()
        ) %>%
            arrange(media_altura) %>%
                rename("Número de pokemons" = N) %>%
                relocate("Número de pokemons", .after = type)


#? rowwise

#? A função mutate e outras do pacote dplyr trabalham diretamente com as colunas
#? como se fossem operações de vetor

dados %>%
    mutate(
        name2 = paste(name, " - NOVO")
    ) %>% head

#? Na prática, o dplyr faz isso:
paste(dados$name, "- NOVO")

#? o que significa que a função PRECISA aceitar um vetor

#? Imagine que você queira criar uma função que testa se o valor de uma coluna
#? na observação i é maior ou menor que um dado valor e executa uma certa ação.

f <- function(x){
    if(x <= 15){ #? no caso, o valor é 300
        return("Executei essa ação")
    }else{

        return("Executei Aquela ação")
    }
}

x1 <- c(30,16,20,3)
f(x1)

#! O código abaixo não funciona
dados %>%
    mutate(
        nova_var = f(height)
    ) %>%
        select(height, nova_var) %>% head(30)

#* O código abaixo funciona
#TODO
dados %>%
rowwise() %>%
    mutate(
        nova_var = f(height)
    ) %>%
        select(height, nova_var) %>% head(30)


#? ifelse e case_when
# A função ifelse aceita um vetor, logo não precisamos
# colocar o rowwise nesse caso.

dados %>%
    mutate(
        tamanho = ifelse(
            height < 15,
            "baixinho",
            "altão"
        )
    ) %>% head

#Construindo na mao

ff <- function(y){
  resposta <- c()
  
  for(i in 1:length(y)){
    if(y[i] <= 15){ #? no caso, o valor é 300
      resposta[i] <- "baixinho"
    }else{
      
      resposta[i] <- "altão"
    }
  }
  return(resposta)
}

ff(x1)
x1

#case_when: anda teste por teste e se o teste que ela
# estiver não for verdade ela passa para o próximo

dados %>%
    mutate(
        tamanho = case_when(
            height < 5 ~ "baixinho",
            height < 10 ~ "pequeno",
            height < 15 ~ "médio",
            TRUE ~ "altão"
        )
    ) %>% head

#Se esquecer de por o TRUE: tudo que não se
#encaixa nos teste se torna vazio (NA), exemplo:

# ERRADO !!
dados %>%
  mutate(
    tamanho = case_when(
      height < 5 ~ "baixinho",
      height < 10 ~ "pequeno",
      height < 15 ~ "médio",
    )
  ) %>% head(15)

#Se eu quiser que seja mesmo NA
dados %>%
  mutate(
    tamanho = case_when(
      height < 5 ~ "baixinho",
      height < 10 ~ "pequeno",
      height < 15 ~ NA,
      TRUE ~ "altão"
    )
  ) %>% head


#? Alguns perrengues da vida

#! O código abaixo não funciona
dados %>%
    mutate(
        tamanho = case_when(
            height < 5 ~ "baixinho",
            height < 10 ~ "pequeno",
            height < 15 ~ NA,
            TRUE ~ "altão"
        )
    ) %>% head

#* O código abaixo conserta isso
#* # forçar algum tipo especifico de NA
#TODO

dados %>%
  mutate(
    tamanho = case_when(
      height < 5 ~ "baixinho",
      height < 10 ~ "pequeno",
      height < 15 ~ NA_character_,
      TRUE ~ "altão"
    )
  ) %>% head

# Podemos juntar dados usando a função bind
#rbind: junta linha
#cbind: junta coluna
#junta do jeito que está

A=data.frame(A= c(1,2,3,4), B = c(5,6,3,2))
B=data.frame(A= c(2,22,32,42), B= c(7,5,3,2))

rbind(A,B)

A=data.frame(A= c(1,2,3,4))
B=data.frame(B= c(2,22,32))
cbind(A,B) 
bind_cols(A,B)


# outras funções
A=data.frame(A= c(1,2,3,4), B = c(5,6,3,2))
B=data.frame(A= c(2,22,32,42), C= c(7,5,3,2))
bind_rows(A,B) #dplyr

#? Vamos falar de JOIN
# Serve para juntar dados baseado em uma regra,
# como ele vai juntar.

df_means <- dados %>%
    group_by(type) %>%
    summarise(
        media_h = mean(height),
        media_w = mean(weight)
    )
df_means

#? vamos excluir os grupos que começam com "g"
#TODO
#REGEX
df_means %>% 
  filter(grepl("g", type)) #tudo que tem g

df_means %>% 
  filter(grepl("g$", type)) #tudo que termina com g

df_means %>% 
  filter(grepl(".+g.+$", type)) # g no meio, + pelo menos 1

df_means %>% 
  filter(grepl(".+g.*$", type)) # * significa 0 ou mais

df_means <- df_means %>% 
  filter(!grepl("^g", type)) #! (não), ou seja, filtrando os que não aparecem, ^ começam com g
df_means

#? vamos adicionar um grupo que não existe

novo_grupo <- data.frame(
    type = "Vozes da minha cabeça",
    media_h = 1000,
    media_w = 400.82
)

#TODO adicionar o grupo

df_means <- rbind(df_means, novo_grupo)
df_means


#? full_join
#TODO
# mantem tudo de todos, tendo ou nao correspondencia

df_full <- full_join(dados, df_means, by = "type")
View(df_full)

#? inner_join
#TODO
df_inner <- inner_join(dados, df_means, by = "type")
View(df_inner)

#? left_join
#na junção da preferencia para o da esquerda
#se o da esquerda tiver x linhas, ao final o df tera x linhas
# Se não tiver correspondência a linha é excluida
#TODO
df_left <- left_join(dados, df_means, by = "type")
View(df_left)

#? right_join
# o inverso da anterior
#TODO
df_right <- right_join(dados, df_means, by = "type")
View(df_right)

# SINTAXE
names(dados)

df_means <- dados %>%
  group_by(type, secundary.type) %>%
  summarise(
    media_h = mean(height),
    media_w = mean(weight)
  )

df_means

df <- right_join(dados, df_means, by = c("type", "secundary.type"))
View(df_right)

#juntar mesmo que não tenhamos colunas iguais
#Vai manter o que estiver na preferencia, exemplo, right_join mantem a coluna da direita
df <- right_join(dados, df_means, by = c("type" = "type", "secundary.type"="secundary.type"))
View(df)

#? vamos adicionar um grupo que JÁ existe

novo_grupo <- data.frame(
    type = "bug",
    media_h = 10,
    media_w = 800
)

#TODO adicionar o grupo

#? left_join
#TODO

#? right_join
#TODO


#?#####################################################################
#? TIDYR
#?#####################################################################

library(tidyr)

#? baixado de https://livro.curso-r.com/

dados <- readr::read_rds("Dados/imdb.rds")

head(dados)
names(dados)

#TODO checar se cada filme tem apenas um genero associado

#? Pivoteamento

#? pivot_wider

#? pivot_longer


#? Emissões de ar
#? https://www.kaggle.com/datasets/ashishraut64/global-methane-emissions


#? Netflix
#? https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies
