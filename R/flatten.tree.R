#' @author Gregoire Versmee, Mikael Dusenne, Laura Versmee


flatten.tree <- function(env, nodelist, token, verbose = FALSE)  {


  if (verbose == TRUE)  message("\nRetrieving all variables associated with those pathways:")
  fetchNode <- function(e)  content.get(paste0(env, "/rest/v1/resourceService/path", gsub("\\?", "%3F", e)), token)

  f <- function(l)  {
    unlist(sapply(l,
                  function(e)  {node <- fetchNode(e)
                                  if(length(node) == 0)  {
                                    if (verbose == TRUE)  message(e)
                                    return(e)
                                  } else {
                                    if (!is.null(node$status)) {
                                      stop(paste0('There is an issue in the database with the path:\n"', e, '"\nProcess stopped. Please contact the developpers regarding this issue'), call. = FALSE)
                                    } else return(f(sapply(node, function(n) n$pui)))
                                  }
                                },
                  USE.NAMES = FALSE))
  }

  return(as.vector(f((nodelist))))
}


