#' @author Gregoire Versmee

get.result <- function(env, resultID, token, verbose = FALSE) {


  if (verbose)  message("\nDownloading the data frame")

  df <- suppressMessages(content.get(paste0(env, "/rest/v1/resultService/result/", resultID, "/CSV"), token))

  if (class(df) != "data.frame")  {
    stop("Internal server error, please check with the developpers\nProcess stopped", call. = FALSE)
  } else {
    data.frame(df, check.names = FALSE)
  }

}

