#!/usr/bin/env Rscript
library(tidyverse)
library(purrr)
library(glue) 
library(rvest) 
library(stringr)

create.Area <- function(x) {
  area <-word(x,-1)
  pattern <- '[^a-zA-Z0-9 -]'
  area <- gsub(pattern, "", area) %>% trimws()
  return(area)
}

animals_df <- tibble()
for(num in 1:11){
  csv_file <- glue("new-animals_{num}.csv")
  animals <- read_csv(csv_file)
  animals <- animals %>% mutate(Area = create.Area(`Endangered Animals of Area`)) %>%
    mutate(Status = substr(`Status/Date Listed as Endangered:`, start = 1, stop = 2))
  if(num == 1){
    animals_df <- animals
  }
  else{
    animals_df <- animals_df %>%
      full_join(animals)
  }
}
animals_df %>% write_csv("new-animals_all.csv")
