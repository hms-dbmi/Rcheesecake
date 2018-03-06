#' @author Gregoire Versmee
#' @export available.result

available.result <- function(env, resultID, token, verbose = FALSE) {

  if (verbose == TRUE)  message("\nWaiting for PIC-SURE to return the query")

  status <- content.get(paste0(env, "/rest/v1/resultService/resultStatus/", resultID), token)$status

  while (status != 'AVAILABLE')  {

    if (status == 'ERROR')  {
      stop("Query Failed", call. = FALSE)

    }  else  {
      if (verbose == TRUE)  message("  ...still waiting")
      Sys.sleep(1);
      status <- content.get(paste0(env, "/rest/v1/resultService/resultStatus/", resultID), token)$status
    }
  }
  if (verbose == TRUE)  message("  Result available \\o/")
}

