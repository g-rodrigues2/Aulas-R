library(dplyr)
library(lubridate)
library(stringr)

dados <- read.csv("Dados/Pokemon_full.csv")

#TODO Lição
#TODO criar uma coluna com a transformação Z-score para altura POR type utilizando TODAS

dados %>%
  group_by(type) %>% 
  mutate(
    media_altura = mean(height), 
    desvio_padrao = sd(height),
    Z_score = (height-media_altura)/desvio_padrao
  ) %>% View
