#' @author Gregoire Versmee
#' @export available.result

available.result <- function(env, resultID, token, verbose = FALSE) {

  status <- content.get(paste0(env, "/rest/v1/resultService/resultStatus/", resultID), token)$status

  while (status != 'AVAILABLE')  {

    if (status == 'ERROR')  {
      message("Query Failed")
      break

    }  else  {
       Sys.sleep(0.5);
       status <- content.get(paste0(env, "/rest/v1/resultService/resultStatus/", resultID), token)$status
    }
  }
}

