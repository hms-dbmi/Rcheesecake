#' @author Gregoire Versmee
#' @export result.ID

result.ID <- function(env, body, token, verbose = FALSE) {

  if (verbose == TRUE)  message('\nGetting a result ID')

  ID <- httr::content(httr::POST(paste0(env, "/rest/v1/queryService/runQuery"), body = body))$resultId

  if (is.null(ID))  {
    body <- gsub("ENCOUNTER", "ENOUNTER", body)
    ID <- httr::content(httr::POST(paste0(env, "/rest/v1/queryService/runQuery"), body = body))$resultId
    if (!is.null(ID))  message(paste("!!!!! PLease, ask the developpers to fix the ENOUNTER issue on", env, "!!!!!"))
    else stop("\nInvalid query, process stopped", call. = FALSE)
  }

  if (verbose == TRUE)  message(paste0("  -> Query #", ID))
  return(ID)
}
