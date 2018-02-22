#' @author Gregoire Versmee
#' @export path.list

path.list <- function(env, var, token, verbose = FALSE) {

  # return the list  of all paths corresponding to the variables selected

  pathlist <- c()
  # Standardize the path name "/path/to/the/node
  for (i in 1:length(var))  {
    var[i] <- trimws(var[i])
    if (substr(var[i], 1, 1) != "/")  var[i] <- paste0("/", var[i])
    end <- nchar(var[i])
    if (substr(var[i], end, end) == "/")  var[i] <- substr(var[i], 1, end-1)

    # Get the 1st arg of the variable path
    st <- unlist(strsplit(var[i], "/"))[2]

    # Get the 1rst node of the environment, until reaching the 1st arg of the variable path
    path1 <- paste0(env, "/rest/v1/resourceService/path")
    ind <- content.get(path1, token)

    # If node is i2b2, look at the next one
    for(j in 1:length(ind))  {
      pui <- ind[[j]][["pui"]]
      if (!grepl("i2b2", pui))  break
    }

    while (!any(grepl (st, pui)))  {
      path2 <- paste0(path1, pui[1])
      listpui <- content.get(path2, token)
      pui <- c()
        for (j in 1:length(listpui))  {
          pui <- c(pui, listpui[[j]][["pui"]])
        }
    }
    pui <- pui[which(grepl (st, pui))]

    # Concat 1st node with the path to create the full path
    path <- paste0(pui, sub(paste0("/", st, "/"), "", var[i]))

    # Add to pathlist
    pathlist <- c(pathlist, path)
  }
  return(pathlist)
}
