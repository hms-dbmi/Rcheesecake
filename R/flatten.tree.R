#' @author Mikael Dusenne, Gregoire Versmee
#' @export flatten.tree

flatten.tree <- function(env, nodelist, token, verbose = FALSE)  {

  fetchNode <- function(e)  content.get(paste0(env, "/rest/v1/resourceService/path", e), token)

  f <- function(l)  {
    unlist(sapply(l,
                  function(e)  {node <- fetchNode(e)
                                if(length(node) == 0) return(e)
                                else return(f(sapply(node, function(n) n$pui)))},
                  USE.NAMES = FALSE))
  }

  return(as.vector(f((nodelist))))
}
