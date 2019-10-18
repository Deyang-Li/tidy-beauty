#!/usr/bin/env Rscript
if(!require("aws.s3")){
    install.packages("aws.s3")
    library("aws.s3")
}
library(glue)
library(tidyverse)

Sys.setenv("AWS_ACCESS_KEY_ID" = "xxxxx","AWS_SECRET_ACCESS_KEY" = "xxxxxx","AWS_DEFAULT_REGION" = "us-east-2")
filename <- "a-z-animals.csv"
df <- aws.s3::s3read_using(read_csv, object = glue("s3://deyang.data/{filename}"))
df
