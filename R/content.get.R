#' @author Gregoire Versmee
#' @import httr
#' @export content.get

content.get <- function(url, token, verbose = FALSE) {

  if (is.null(token))  return(httr::content(httr::GET(URLencode(url))))
  else  return(httr::content(httr::GET(URLencode(url), httr::add_headers(Authorization=paste("bearer", token)))))

}

