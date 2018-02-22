#' @param env  The URL of the environment
#' @param var  A vector with the variables of interest
#' @param key The key to log in your environment
#' function
#' @param url  The url.
#' @author Gregoire Versmee
#' @export cheesecake

cheesecake <- function(env, key, var, subset = "ALL", verbose = FALSE) {

  # Is it a key or a token?
  if (nchar(key) == 26)  {
    if (verbose == TRUE)  message(paste("Key detected, starting a session on", env))
    status <- new.session(env, key)

    if (status == 200)  {
      if (verbose == TRUE)  message(paste("Succesfully started the session on", env))
    }

    if (status == 500)  {
      stop(paste0("Invalid key\nPlease revise your key, go to ", env, "/transmart/user"), call. = FALSE)
    }

    token <- NULL
  }  else  {
    token <- key
  }



  # build the query
    # build the "select" part of the query
      # Get the list of "full path"
      pathlist <- path.list(env, var, token) #returns a list of path

      # Get all children for each path
      allpaths <- flatten.tree(env, pathlist, token)

      # build the "select" part of the query
      select <- query.select(allpaths)

    # build the "where" part of the query
      where <- query.where(env, allpaths, subset, token)

    # combine select and where
      body <- paste0(select, where)

      write.csv(body, "body.csv")

  # run the query
      # get the result ID
      resultID <- result.ID(env, body, token)

      # wait for the result to be available
      available.result(env, resultID, token)

      # get the response
      result <- get.result(env, resultID, token)

  # make the table pretty!!
      # order the columns
      result <- order.col(result, allpaths)

      # check if categorical, and combine them
      result <- nicer.result(result)

      # make valid column names
      result <- name.cols(result)

      return(result)
}

