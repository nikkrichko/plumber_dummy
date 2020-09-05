library(janitor)
library(tidyverse)
library(data.table)
library(ggplot2)
library(plotly)
library(swagger)
library(knitr)
library(kableExtra)
library(rmarkdown)
library(DT)
library(plotly)
library(ggTimeSeries)

# library(tidydt)
library(stringr)
options(scipen = 999)
source("DB_functions.R")




generate_test_report <- function(){
  tmp <-  paste(getwd(),"/tempreport.html", sep="")
  render("test.Rmd", tmp, output_format = "html_document")
  readBin(tmp, "raw", n=file.info(tmp)$size)
}



