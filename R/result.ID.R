#' @author Gregoire Versmee
#' @export result.ID

result.ID <- function(env, body, token, verbose = FALSE) {

  ID <- httr::content(httr::POST(paste0(env, "/rest/v1/queryService/runQuery"), body = body))$resultId

  if (is.null(ID))  {
    body <- gsub("ENCOUNTER", "ENOUNTER", body)
    ID <- httr::content(httr::POST(paste0(env, "/rest/v1/queryService/runQuery"), body = body))$resultId
    if (!is.null(ID))  message(paste("OK, but please tell the developpers that there is still a ENOUNTER issue on", env))
  }

  return(ID)
}