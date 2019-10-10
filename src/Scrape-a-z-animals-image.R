#!/usr/bin/env Rscript
library(rvest)
library(purrr)
library(tidyverse)
library(glue)

animal_images <- tibble(animal_name=character(), image_url=character(), file_name=character())
animals <- tibble()
links_html <- read_html("https://a-z-animals.com/animals/")
links_li <- links_html %>%
  html_nodes('[class^="az-phobia-link"]')
for(index in 1:length(links_li)){
  animal_name <- links_li[index] %>%
    html_node("a") %>%
    html_attr("href")
  url <- glue("https://a-z-animals.com{animal_name}")
  content_html <- read_html(url)
  images <- content_html %>% html_node(".content") %>% html_nodes("img")
  image_root <- images[1] %>% html_attr('src')
  image_url <- glue("https://a-z-animals.com{image_root}")
  filename <- unlist(strsplit(image_url, "/"))
  animal_name <- content_html %>% 
    html_node("main header") %>% 
    html_node("h1") %>% 
    html_text()
  animal_images <- animal_images %>% add_row(animal_name=animal_name,image_url=image_url,file_name=filename[length(filename)])
  if(file.exists(paste0("animal-images/", destfile = filename[length(filename)]))){
    print(filename[length(filename)])
    next
  }
  download.file(url = image_url,paste0("animal-images/", destfile = filename[length(filename)]), mode="wb")
  
  Sys.sleep(1)
}
animal_images %>% write_csv("a-z-animals-image.csv")