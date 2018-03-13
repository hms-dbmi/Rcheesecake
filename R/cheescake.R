#' @title Query your study via the PIC-SURE API
#' @description For this beta version, it is only possible to query phenotypics data. Soon, the package will be upgraded to be able to query genotypics data from Hail.
#' @param env  The URL of the environment
#' @param key The key or the token to log in your environment
#' @param var  A vector with the variables of interest (full paths with forward slashes). If an argument corresponds to a node, it will return all the variables below the node
#' @param subset  By default, subset = ALL and gives you back all the patients that have at least one variable of interest. See the examples for more complex subsets
#' @param verbose By default, {verbose = FALSE}. Set it to {verbose = TRUE} to get the log informations
#' @return Returns a data.frame
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne
#' @export picsure
#' @examples
#' Without any subset, will return all the patients that have at least one value for a variable of interest
#' environment <- "https://nhanes.hms.harvard.edu"
#' key <- "yourkeyortoken"
#' pcb <- "laboratory/pcbs/PCB153 (ng per g)"
#' age <- "demographics/AGE/"
#' sex <- "demographics/SEX"
#' variables <- c(pcb, sex, age)
#' picsure(environment, key, variables)
#'
#' Adding a variable as subset will return only the patient that have a value for this specific variable (can be combined with AND, OR, NOT)
#' subset <- "(laboratory/pcbs/PCB153 (ng per g))"
#' picsure(environment, key, variables, subset)
#'
#' The continuous variable can be filtered by <, >, ==, !=, <=, >=.
#' subset <- "(/demographics/AGE > 60) | (/demographics/AGE < 20)"
#' picsure(environment, key, variables, subset)
#'
#' @import httr
#' @import openssl

picsure <- function(env, key, var, subset = "ALL", verbose = FALSE) {

  # Is it a key or a token?
  if (nchar(key) == 26)  {
    if (verbose)  message(paste("Key detected, starting a session on", env))
    status <- new.session(env, key, verbose)

    token <- NULL
  }  else  {
    token <- key
    parse <- rawToChar(openssl::base64_decode(unlist(strsplit(token, "\\."))[2]))
    name <- substr(parse, regexpr("email", parse) + 8, max(gregexpr("@", parse)[[1]])-1)
    message(paste("\nHi", name, "thank you for using Rcheesecake!"))
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
      if (verbose)  message('\nCombining the "select" and "where" part of the query to build the json body')
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

      message("\nEnjoy!")

      return(result)
}


