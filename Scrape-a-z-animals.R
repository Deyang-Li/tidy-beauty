library(rvest)
library(purrr)
library(tidyverse)
library(glue)

animals <- tibble()
links_html <- read_html("https://a-z-animals.com/animals/")
links_li <- links_html %>%
  html_nodes('[class^="az-phobia-link"]')
for(index in 1:length(links_li)){
  animal_name <- links_li[index] %>%
    html_node("a") %>%
    html_attr("href")
  url <- glue("https://a-z-animals.com{animal_name}")
  raw_response <- read_html(url)
  table_html <- raw_response %>%
    html_node(".az-facts")
  table_tr <- table_html %>%
    html_nodes("tr")
  new_row <- tibble(index = numeric())
  new_row <- new_row %>% add_row(index = index)
  for(i in 1:length(table_tr)){
    attribute <- table_tr[i] %>%
      html_nodes("a") %>% html_text()
    table_td <- table_tr[i] %>%
      html_nodes("td")
    if(length(table_td) < 2)
      next
    value <- table_td[2] %>% html_text()
    new_row <- new_row %>% add_column(!!attribute:=value)
  }
  if(new_row$index == 1){
    animals <- new_row
  }else{
    animals <- animals %>%
      full_join(new_row)
  }
  Sys.sleep(1)
}
animals %>% write_csv("a-z-animals.csv")
title <-
page_title %>%
  html_nodes('[class^="az-phobia-link"]') %>%
  html_text()
animal_name_df <- tibble(Name = title) 
animal_name_df %>% write_csv("animal_name.csv")
animals_df <- read_csv(file = "a-z-animals.csv")
animals_df <- read_csv(file = "a-z-animals.csv") %>% 
  rename(Index = index)
animal_name_df <- read_csv(file = "animal_name.csv" )
animal_name <- as.matrix(animal_name_df)
animal_name <- as.vector(animal_name)
animals_df %>% add_column(Name = animal_name, .after = 1)
animals_df %>% write_csv("a-z-animal_name.csv")
