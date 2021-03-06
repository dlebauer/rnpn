
pkg.env <- new.env(parent = emptyenv())

#' Set Environment
#'
#' By default this library will call the NPN's production services
#' but in some cases it's preferable to access the development web services
#' so this function allows for manually setting the web service endpoints
#' to use DEV instead. Just pass in "dev" to this function to change the
#' endpoints to use.
#' @param env The environment to use. Should be "ops" or "dev"
#' @export
npn_set_env <- function (env = "ops"){
  pkg.env$remote_env <- env
}

get_test_env <- function(){
  return("dev")
}


base <- function(){

  if( !is.null(pkg.env$remote_env)){
    pkg.env$remote_env <- pkg.env$remote_env
  }else{
    pkg.env$remote_env <- "ops"
  }

  if(pkg.env$remote_env=="ops"){
      return('https://www.usanpn.org/npn_portal/')
  }else{
      return('https://www-dev.usanpn.org/npn_portal/')
  }
}

base_geoserver <- function(){

  if( !is.null(pkg.env$remote_env)){
    pkg.env$remote_env <- pkg.env$remote_env
  }else{
    pkg.env$remote_env <- "ops"
  }

  if(pkg.env$remote_env=="ops"){
    return('https://geoserver.usanpn.org/geoserver/wcs?service=WCS&version=2.0.1&request=GetCoverage&')
  }else{
    return('https://geoserver-dev.usanpn.org/geoserver/wcs?service=WCS&version=2.0.1&request=GetCoverage&')
  }
}

npnc <- function(l) Filter(Negate(is.null), l)

pop <- function(x, y) {
  x[!names(x) %in% y]
}

ldfply <- function(y){
  res <- lapply(y, function(x){
    x[ sapply(x, is.null) ] <- NA
    data.frame(x, stringsAsFactors = FALSE)
  })
  do.call(rbind.fill, res)
}

npn_GET <- function(url, args, parse = FALSE, ...) {
  tmp <- GET(url, query = args, ...)
  stop_for_status(tmp)
  tt <- content(tmp, as = "text", encoding = "UTF-8")
  if (nchar(tt) == 0) tt else jsonlite::fromJSON(tt, parse, flatten = TRUE)
}

#Utility function. Helps create URL strings for requests to NPN data services in the format variable_name[number]=Value
npn_createArgList <- function(arg_name, arg_list){
  args <- list()
  for (i in seq_along(arg_list)) {
    args[paste0(arg_name,'[',i,']')] <- URLencode(toString(arg_list[i]))
  }
  return(args)
}
