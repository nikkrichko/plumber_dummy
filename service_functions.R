version <- paste("last deployment date:",format(Sys.Date(), "%Y_%m_%d"), sep="_")


# GET show information about service --------------
#' with parameters
#' @get /_msg
#' @param msg
function(res, msg="hello_world"){
  if (msg == ""){
    res$status <- 404 # Not found
    res$body <- list(msg = paste0("No external message"),
                     servername = req$SERVER_NAME)
  } else {
    res$status <- 500
    res$body <-  list(msg = paste0("The message is: '", msg, "'!!!!!!!!!!!"))
    
  }
}

#* show host system information
#* @serializer html
#* @get /_system_info
function(req, res) {
  
  #TODO filter by os TYPE
  
  
  if(.Platform$OS.type == "windows") {
    ### windows system info
    hostname <- system("hostname", intern = TRUE)
    result <- system("ipconfig", intern=TRUE)
    temp <- result[grep("IPv4", result)]
    ip_address <- sub(".*: ","",temp)
    res$body <- paste0("\n<br>","Service available - ", Sys.Date(),
                       "\n<br>","server name - ",hostname[1], 
                       "\n<br>","server ip - ",ip_address, 
                       "\n<br>---------------", sep = ""
    )
  } else {
    ### unix system info
    get_ip_shell <- "ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"
    ips <- system(get_ip_shell, intern = TRUE)
    hostname <- system("hostname", intern = TRUE)
    res$body <- paste0("Performance analysis service available - ", Sys.Date(),
                       "\n<br>","hostname - ",hostname[1], 
                       "\n<br>","ip - ", ips[2],
                       "\n<br>","working dir - ", getwd(),
                       "\n<br>","swagger info - ",swagger_index(),
                       "\n<br>", "sysenv - ", Sys.getenv("TEST_ENV"), 
                       "\n<br>"
                       
               )
  }
  
}

#TODO ADD list of files


#* Check service availability
#* @serializer html
#* @get /_ping
function(req, res){
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- sprintf('{it works}')
  res
}


#* returns version of api / last deployment date
#* @serializer html
#* @get /_version
function(req, res) {
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- sprintf('{"version":"%s"}', version)
  res
}

#* Show session info
#* @serializer html
#* @get /_session_info
function(req, res) {
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- jsonlite::toJSON(
    sessioninfo::session_info(), auto_unbox = TRUE, null = "null",force = TRUE
  )
  res
}


#* Show list of methods
#* @serializer html
#* @get /_methodinfo
function(req, res) {
  
  res$setHeader("Content-Type", "application/json")
  res$status <- 200L
  res$body <- jsonlite::toJSON(
    names(web_requests$routes), auto_unbox = TRUE, null = "null", force = TRUE
  )
  res
  
}

#* Log requests
#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-", 
      req$REQUEST_METHOD, req$PATH_INFO, "-", 
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  forward()
}






