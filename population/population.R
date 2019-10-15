#!/usr/bin/env Rscript
library("jsonlite")
library(tidyverse)
library(purrr)
library(glue)
library(rvest)
library(stringr)

json_file <- 'https://datahub.io/core/population/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse = ""))

# get list of all resources:
print(json_data$resources$name)

# print all tabular data(if exists any)
for (i in 1:length(json_data$resources$datahub$type)) {
  if (json_data$resources$datahub$type[i] == 'derived/csv') {
    path_to_file = json_data$resources$path[i]
    data <- read.csv(url(path_to_file))
  }
}

population_df <-
  data %>% filter(
    grepl("^East Asia & Pacific$", data$Country.Name) |
      grepl("^Europe & Central Asia$", data$Country.Name) |
      grepl("^Latin America & Caribbean$", data$Country.Name) |
      grepl("^Middle East & North Africa$", data$Country.Name) |
      grepl("^North America$", data$Country.Name) |
      grepl("^South Asia$", data$Country.Name) |
      grepl("^Sub-Saharan Africa$", data$Country.Name)
  )
population_df %>% write_csv("population.csv")
