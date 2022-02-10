# remotes::install_github("rstudio/plumber", force = TRUE)
library(plumber)
# remotes::install_github("rstudio/swagger")
library(swagger)


root <- pr()
web_requests <- pr("api.R")
support_requests <- pr("service_functions.R")

root %>%
  pr_mount("/api", web_requests) %>%
  pr_mount("/service", support_requests)

root$set404Handler(function(req, res) {
    cat(req$PATH_INFO)
    res$setHeader("Content-Type", "application/json")
    res$status <- 200L
    res$body <- jsonlite::toJSON(
      paste0("ha-ha ","your path   " ,req$PATH_INFO," DOES NOT WORK"), auto_unbox = TRUE, null = "null", force = TRUE
    )
    res
  })

root$setErrorHandler(function(req, res, err) {
    message("Found error: ")
    str(err)
  })

root$handle("GET", "/_methodinfo", function(req, res) {
    res$setHeader("Content-Type", "application/json")
    res$status <- 200L
    res$body <- jsonlite::toJSON(
      names(web_requests$routes), auto_unbox = TRUE, null = "null", force = TRUE
    )
    res
  })




# root$run(port=8000, host='127.0.0.1', swagger = TRUE)
root$run(port=8000, host='0.0.0.0', swagger = TRUE)



