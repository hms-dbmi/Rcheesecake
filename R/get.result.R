#' @author Gregoire Versmee

get.result <- function(env, resultID, token, verbose = FALSE) {


  if (verbose == TRUE)  message("\nDownloading the data frame")

  suppressMessages(data.frame(content.get(paste0(env, "/rest/v1/resultService/result/", resultID, "/CSV"), token), check.names = FALSE))

}

