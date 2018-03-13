#' @author Gregoire Versmee, Laura Versmee
#' @import openssl


new.session <- function(env, key, verbose = FALSE)  {

  newsession <- httr::GET(paste0(env, "/rest/v1/securityService/startSession?key=", key))
  status <- httr::status_code(newsession)
  content <- httr::content(newsession)
  if (is.null(content$status))  content$status <- "NULL"

  if (status == 200 & content$status == "success")  {

    if (verbose)  message(paste("Succesfully started the session on", env))
  } else {

    if (status == 200 & content$status == "error")  {
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

  if (!is.null(content$token))  {
    parse <- rawToChar(openssl::base64_decode(unlist(strsplit(content$token, "\\."))[2]))
    name <- substr(parse, regexpr("email", parse) + 8, max(gregexpr("@", parse)[[1]])-1)
    message(paste("\nHi", name, "thank you for using Rcheesecake!\nNext time, try using the token instead of the key. If you want a demo, ask the developpers."))
  }

}
