#' @author Gregoire Versmee

get.result <- function(env, resultID, token, verbose = FALSE) {


  if (verbose == TRUE)  message("\nDownloading the data frame")

  df <- content.get(paste0(env, "/rest/v1/resultService/result/", resultID, "/CSV"), token)

  if (!is.na(df$errorType))  {
    stop("Internal server error, please check with the developpers\nProcess stopped", call. = FALSE)
  } else {
    suppressMessages(data.frame(df), check.names = FALSE)
  }

}

