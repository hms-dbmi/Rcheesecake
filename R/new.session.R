#' @author Gregoire Versmee
#' @export new.session


new.session <- function(env, key, verbose = FALSE)  {

  newsession <- httr::GET(paste0(env, "/rest/v1/securityService/startSession?key=", key))
  status <- httr::status_code(newsession)
  contentstatus <- httr::content(newsession)$status
  if (is.null(contentstatus))  contentstatus <- "NULL"

  if (status == 200 & contentstatus == "success")  {
    if (verbose == TRUE)  message(paste("Succesfully started the session on", env))
  } else {

    if (status == 200 & contentstatus == "error")  {
      stop(paste0("Invalid key\nPlease revise your key, go to ", env, "/transmart/user"), call. = FALSE)
    }

    if (status == (401))  {
      stop(paste0("Invalid key\nPlease revise your key, go to ", env, "/transmart/user"), call. = FALSE)
    }

    if (status == (404))  {
      stop(paste(env, "-> Invalid environment address or server issue"), call. = FALSE)
    }

    if (status == (500))  {
      stop(paste(env, "-> Internal server error, please contact the developpers"), call. = FALSE)
    }
  }

}
