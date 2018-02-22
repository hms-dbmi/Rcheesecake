#' @author Gregoire Versmee
#' @export new.session


new.session <- function(env, key, verbose = FALSE)  {

  status <- httr::status_code(httr::GET(paste0(env, "/rest/v1/securityService/startSession?key=", key)))

}

