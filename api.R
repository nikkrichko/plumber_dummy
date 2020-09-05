library(plumber)
library(Rook)
library(tidyverse)
library(data.table)
library(ggplot2)
library(plotly)
library(readr)
library(tictoc)
library(HARtools)
library(httr)
library(formattable)
library(jsonlite)
library(kableExtra)
library(knitr)
source("functions.R")
source("DB_functions.R")


#* @apiTitle HTML R API
# GET downloaded plot -------------------------------------
#' @serializer contentType list(type="application/octet-stream")
#' @get /get_plot
function(res) {
 
  gp <- ggplot(mtcars, aes(cyl,mpg)) + geom_point()
  
  ggsave("ggplot.png", gp)
  tfile <- paste(getwd(),"/", "ggplot.png", sep="")
  res$setHeader("Content-Disposition", "attachment; filename=ggplot_result_hello_world.png")
  readBin(tfile, "raw", n = file.info(tfile)$size)
  
}


# GET downloaded plot -------------------------------------
#' @get /print_get_plot
#' @png
function(res) {
  gp <- ggplot(mtcars, aes(cyl,mpg)) + geom_point()
  print(gp)
}



# GET return ggplotly with test result -------------
#' @serializer contentType list(type="application/octet-stream")
#' @get /get_plotly
function(res) {
  
  gp <- ggplot(mtcars, aes(cyl,mpg)) + geom_boxplot()
  
  
  tfile <- paste(getwd(),"/", "ggplotly.html", sep="")
  
  htmlwidgets::saveWidget(as_widget(ggplotly(gp)), tfile)
  
  res$setHeader("Content-Disposition", "attachment; filename=ggplotly_.html")
  
  readBin(tfile, "raw", n = file.info(tfile)$size)
  
}



#* Return interactive plot using plotly
#* @serializer htmlwidget
#* @get /plotly
function() {
  p <- ggplot(data = diamonds,
              aes(x = cut, fill = clarity)) +
    geom_bar(position = "dodge")
  
  ggplotly(p)
}



# Parse postBody into data.frame

#* Return an HTML table of the postBody data
#* @html
#* @post /data/post
function(req) {
  format_table(fromJSON(req$postBody))
}


# Parse data from attached file

#* Return an HTML table of input file
#* @html
#* @post /data/file
function(req) {
  format_table(fromJSON(req$postBody))
}




# POST  upload csv file -------------
#' parse csv file
#' @param requested_field the request object
#' @post /upload_file
function(req) {
  cat(as.character(Sys.time()), "-", 
      req$REQUEST_METHOD, req$PATH_INFO, "-", 
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")

  tempfile <- list(formContents = Rook::Multipart$parse(req))
  file <- Rook::Multipart$parse(req)$req$tempfile
  result <- read.csv(file)
  file_path <- paste(getwd(),"/app/")
  file_to_write <- paste0(file_path, "file_",Sys.Date(),".csv", sep="")
  cat(paste("File", file_to_write, "uploaded\n"))
  write.csv2(result, file = file_to_write)
  
  return(paste(Sys.time(), "------------- FILE was UPLOAD SUCCESSfully ---------------------"))
}

#' Endpoint that bypasses serialization
#' @serializer contentType list(type="application/html")
#' @get /download_html_test
function(res){
  res$setHeader("Content-Disposition", "attachment; filename=small_report.html")
  res$body <- generate_test_report
  res
}

#' render rmd file to html
#* @serializer contentType list(type="application/html")
#* @get /render_rmd_to_browser
function(res){
  include_rmd("test.Rmd", res)
}

#' render rmd file to html
#* @serializer contentType list(type="text/html; charset=utf-8")
#* @get /render_rmd_to_browser_second_variant
function(){
  generate_test_report
}


#' get html table
#' @serializer htmlwidget
#' @get /get_simple_html_table
function(res){
  res$body <- mtcars
  res
}




