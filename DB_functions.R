#install.packages("RPostgreSQL")
#install.packages("config")

library(DBI)
library(RPostgreSQL)
library(data.table)
library(here)
library(config)
library(tidyverse)
library(randomNames)



# setwd(dirname(rstudioapi::getSourceEditorContext()$path))

get_db_connection <- function(db_name="RIO_KRONOS"){
  options(warn=-1)
  dw <- config::get(db_name)
  options(warn=0)
  
  DB_connection <- dbConnect(dbDriver("PostgreSQL"),
                             dbname = dw$database,
                             host = dw$server, port = dw$port,
                             user = dw$uid, password = dw$pwd)
  DB_connection
}

get_query_and_disconnect <- function(input_query, connection_name="DB_ALIAS_1"){
  DB_connection <-   get_db_connection(connection_name)
  input_query <- gsub("[\n\t]", "", input_query)
  result_dt <- dbGetQuery(DB_connection, input_query) %>% as.data.table()
  dbDisconnect(DB_connection)
  result_dt
}

get_db_name <- function(connection_name="DB_ALIAS_1"){
  DB_connection <-   get_db_connection(connection_name)
  query <- " SELECT current_database();"
  result_dt <- dbGetQuery(DB_connection, query) %>% as.data.table()
  dbDisconnect(DB_connection)
  result_dt
}


update_users_passwords <- function(connection_name="DB_ALIAS_1"){
  query <- "UPDATE table 
            SET password = '**********=',
            salt = '**********/26AOfVBDmIas='
            WHERE password IS NOT NULL"
  query <- gsub("[\n\t]", "", query)
  print(query)
  DB_connection <-   get_db_connection(connection_name)
  dbSendQuery(DB_connection, query)
  dbDisconnect(DB_connection)
}

get_db_size <- function(connection_name="DB_ALIAS_1"){
  query <- "SELECT
   relname AS table_name,
   reltuples AS row_count, 
       pg_size_pretty(relpages::bigint*8*1024) AS size
   FROM pg_class
   WHERE relpages >= 8
   ORDER BY relpages DESC;"
  
  query <- gsub("[\n\t]", "", query)
  
  get_query_and_disconnect(query,connection_name)
  
}


