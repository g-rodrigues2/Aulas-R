#Homework 01/06: arrumar o gráfico de barras deste bloco
library(ggplot2)
library(tidyr)
library(dplyr)
library(ggthemes)
library(rcartocolor)

dados <- read.csv("./Dados/Pokemon_full.csv")
head(dados)

df <- dados %>%
  group_by(type) %>% 
  summarise(
    media_h = mean(height),
    media_w = mean(weight)
  ) 

fator <- max(df$media_w)/max(df$media_h)
fator

df$media_h <- df$media_h*fator

df
df %>% 
  select(Tipo = type, M_Altura = media_h, M_Peso = media_w) %>%
  tidyr::pivot_longer(cols = c("M_Altura", "M_Peso"), names_to = "tipo", values_to = "media") %>% 
  ggplot()+
  geom_col(aes(x = Tipo, y = media, color = tipo, fill = tipo), position = position_dodge2())+
  scale_y_continuous(
    
    # Features of the first axis
    name = "Média do peso",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~./fator, name="Média da altura"),
    expand = c(0,0)
  )+
  scale_color_brewer(palette = "Set1", name="Médias")+
  scale_fill_brewer(palette = "Set1", name="Médias")+
  theme_bw()+
  theme(
    axis.title= element_text(size = 14, face = "bold"),
    axis.text = element_text(size = 12),
    axis.text.x = element_text(angle=60, hjust = 1)
  )

