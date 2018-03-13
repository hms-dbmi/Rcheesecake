#' @title Query on Hail
#' @param env  The URL of the environment
#' @param key The key or the token to log in your environment
#' @return Returns a data.frame
#' @author Gregoire Versmee, Laura Versmee
#' @export queryhail
#' @import httr

queryhail <- function(env, key, chromosome, start, stop, verbose = FALSE) {
  
  # Is it a key or a token?
  if (nchar(key) < 27)  {
    if (verbose)  message(paste("Key detected, starting a session on", env))
    status <- new.session(env, key, verbose)
    token <- NULL
  }  else  token <- key
  
  # Say hello!
  username <- data.frame(content.get(paste0(env, "/rest/v1/systemService/about"), token), stringsAsFactors = FALSE)$userid
  username <- unlist(strsplit(username, "@"))[1]
  message(paste("\nHi", username, "thank you for using Rcheesecake!"))
  
  
  # build the "where" part of the query
  body <- paste0('{"where": [{
                  "field": {"pui": "/hail-dev/jackson_full"},
                  "predicate": "exportSamples",
                  "fields": {"contig":"',chromosome,'",
                  "start":"',start,'",
                  "end":"',stop,'",
                  "columns":"SAMPLE=s, VARIANT=v, rsId=va.rsid, contig=v.contig, start=v.start, ref=v.ref, alt=v.altAlleles[0].alt, ad=g.ad, dp=g.dp, gq=g.gq,gt=g.gt,pl=g.pl"}}]}')
  
  # run the query
  # get the result ID
  resultID <- result.ID(env, body, token, verbose)
  
  # wait for the result to be available
  available.result(env, resultID, token, verbose)
  
  # get the response
  result <- get.result(env, resultID, token, verbose)
  
  message("\nEnjoy!")
  
  return(result)
}
