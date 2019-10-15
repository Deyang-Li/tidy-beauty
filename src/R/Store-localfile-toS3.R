#!/usr/bin/env Rscript
if(!require("aws.s3")){
    install.packages("aws.s3")
    library("aws.s3")
}
library(glue)
library(tidyverse)

Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIA3J5TUH2FQMC6REW4","AWS_SECRET_ACCESS_KEY" = "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","AWS_DEFAULT_REGION" = "us-east-2")

filename <- "a-z-animals.csv"
animals_df <- read.csv(file = filename )
s3write_using(animals_df, write_csv, object = glue("s3://deyang.data/{filename}"))
