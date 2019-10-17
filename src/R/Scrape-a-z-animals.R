#!/usr/bin/env Rscript
library(rvest)
library(purrr)
library(tidyverse)
library(glue)

animals <- tibble()
links_html <- read_html("https://a-z-animals.com/animals/")
# scrape the html script from https://a-z-animals.com/animals/ as the main entrance
links_li <- links_html %>%
  html_nodes('[class^="az-phobia-link"]')
# there are 593 animals in this page
# use html_nodes to find all these links html tags with the css class name beginning with az-phobia-link
for(index in 1:length(links_li)){
# from link 1 to link 593
  animal_name <- links_li[index] %>%
    html_node("a") %>%
    html_attr("href")
  url <- glue("https://a-z-animals.com{animal_name}")
# combine the basic url and animal name as the new url link
  raw_response <- read_html(url)
  table_html <- raw_response %>%
    html_node(".az-facts")
# extract the table element with the css class named az-facts
  table_tr <- table_html %>%
    html_nodes("tr")
# find the tr tag in another loop of the table
  new_row <- tibble(index = numeric())
  new_row <- new_row %>% add_row(index = index)
# add an index (numeric ID) column to the data frame
  for(i in 1:length(table_tr)){
    attribute <- table_tr[i] %>%
      html_nodes("a") %>% html_text()
    table_td <- table_tr[i] %>%
      html_nodes("td")
    if(length(table_td) < 2)
      next
    value <- table_td[2] %>% html_text()
# two columns are controlled by td tag 
# the first column is the attribute and the second is the value of that attribute
    new_row <- new_row %>% add_column(!!attribute:=value)
# put the attribute as the column name and the value as the cell and add a new column to a data frame
  }
  if(new_row$index == 1){
    animals <- new_row
  }else{
    animals <- animals %>%
      full_join(new_row)
# add new columns to a data frame
  }
  Sys.sleep(1)
# pause the program for one second in every loop 
}
animals %>% write_csv("a-z-animals.csv")
# write this data frame into a file


#title <-
#page_title %>%
#  html_nodes('[class^="az-phobia-link"]') %>%
#  html_text()
#animal_name_df <- tibble(Name = title) 
#animal_name_df %>% write_csv("animal_name.csv")
#animals_df <- read_csv(file = "a-z-animals.csv")
#animals_df <- read_csv(file = "a-z-animals.csv") %>% 
#  rename(Index = index)
#animal_name_df <- read_csv(file = "animal_name.csv" )
# <- as.matrix(animal_name_df)
#animal_name <- as.vector(animal_name)
#a_z_annimals <- add_column(animals_df, Name = animal_name, .after = 1)
#a_z_annimals %>% write_csv("a-z-animal_name.csv")
