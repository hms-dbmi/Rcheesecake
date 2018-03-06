#' @author Gregoire Versmee
#' @export path.list

path.list <- function(env, var, token, verbose = FALSE) {

  # return the list  of all paths corresponding to the variables selected
  if (verbose == TRUE)  message("\nRetrieving the selected pathways:")

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
      pui <- ind[[1]][["pui"]]
      if (grepl("i2b2", pui))  pui <- ind[[2]][["pui"]]

    while (!any(grepl (st, pui, fixed = TRUE)))  {
      path2 <- paste0(path1, pui[1])
      listpui <- content.get(path2, token)
      pui <- c()
      if (length(listpui) > 0)  {
        for (j in 1:length(listpui))  {
          pui <- c(pui, listpui[[j]][["pui"]])
        }
      } else {
          stop(paste0("Can't find the path ", '"', var[i], '", please check the spelling\nProcess stopped'), call. = FALSE)
      }
    }
    pui <- pui[which(grepl (st, pui, fixed = TRUE))]

    # Concat 1st node with the path to create the full path
    path <- paste0(pui, sub(paste0("/", st, "/"), "", var[i], fixed = TRUE))

    if (verbose == TRUE)  message(path)

    # Add to pathlist
    pathlist <- c(pathlist, path)
  }
  return(pathlist)
}
