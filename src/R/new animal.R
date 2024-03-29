#!/usr/bin/env Rscript
library(tidyverse)
library(purrr)
library(glue) 
library(rvest) 

new_animals <- tibble()

for (num in 1:11){
  url_titles <- glue("http://earthsendangered.com/continent.asp?gr=&view=&ID={num}")
  link_html <- read_html(url_titles)
  animal_link <- link_html %>%
    html_nodes("[data-title='Common Name'] a") %>%
    html_attr("href")
  animal_title <- link_html %>%
    html_nodes("[data-title='Common Name']") %>%
    html_text()
  animal_area <- link_html %>%
    html_nodes(".row .col-md-12 span[style='font-size: 36px']") %>%
    html_text() %>%
    trimws()
  for (index in 1:length(animal_link)){
    animal_name <- animal_link[index]
    url <- glue("http://earthsendangered.com/{animal_name}")
    raw_response <- read_html(url)
    #common_name <- raw_response %>%
     # html_nodes('[style^="font-size: 36px"]') %>%
      #html_text()
    contents <- raw_response %>%
      html_nodes('.dataSnippet') %>%
      html_text()  %>% 
      trimws()
    title <- raw_response %>% 
      html_nodes('.dataLabel')%>%
      html_text()
    #title <- all_title[1:5]
    new_row <- tibble(index = numeric())
    new_row <- new_row %>% add_row(index = index)
    new_row <- new_row %>% add_column('Common Name'=animal_title[index])
    new_row <- new_row %>% add_column('Endangered Animals of Area'=animal_area)
    for(i in 1:length(contents)){
      attribute <- title[i]
      value <- contents[i]
      new_row <- new_row %>% add_column(!!attribute:=value)
    }
    if(new_row$index == 1){
      new_animals <- new_row
    }else{
      new_animals <- new_animals %>%
        full_join(new_row)
    }
    Sys.sleep(1)
  }
  csv_name <- glue("new-animals_{num}.csv")
  new_animals %>% write_csv(csv_name)
}