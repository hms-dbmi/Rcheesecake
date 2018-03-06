#' @author Gregoire Versmee, Laura Versmee
#' @import httr

content.get <- function(url, token, verbose = FALSE) {

  if (is.null(token))  return(httr::content(httr::GET(URLencode(url))))
  else  return(httr::content(httr::GET(URLencode(url), httr::add_headers(Authorization=paste("bearer", token)))))

}

