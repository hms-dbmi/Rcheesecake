#' @title TEST
#' @param env  The URL of the environment
#' @param var  A vector with the variables of interest
#' @param key The key to log in your environment
#' function
#' @param url  The url.
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne
#' @export picsure
#' @import httr

picsure <- function(env, key, var, subset = "ALL", verbose = FALSE) {

  # Is it a key or a token?
  if (nchar(key) == 26)  {
    if (verbose == TRUE)  message(paste("Key detected, starting a session on", env))
    status <- new.session(env, key, verbose)

    token <- NULL
  }  else  {
    token <- key
    if (verbose == TRUE)  message("Token detected")
  }

  # build the query
    # build the "select" part of the query
      # Get the list of "full path"
      pathlist <- path.list(env, var, token, verbose) #returns a list of path

      # Get all children for each path
      allpaths <- flatten.tree(env, pathlist, token, verbose)

      # build the "select" part of the query
      select <- query.select(allpaths, verbose)

    # build the "where" part of the query
      where <- query.where(env, allpaths, subset, token, verbose)

    # combine select and where
      if (verbose == TRUE)  message('\nCombining the "select" and "where" part of the query to build the json body')
      body <- paste0(select, where)

  # run the query
      # get the result ID
      resultID <- result.ID(env, body, token, verbose)

      # wait for the result to be available
      available.result(env, resultID, token, verbose)

      # get the response
      result <- get.result(env, resultID, token, verbose)

  # make the table pretty!!
      # order the columns
      result <- order.col(result, allpaths, verbose)

      # check if categorical, and combine them
      result <- nicer.result(result, verbose)

      # make valid column names
      result <- name.cols(result, verbose)

      return(result)
}










