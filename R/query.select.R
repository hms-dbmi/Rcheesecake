#' @author Gregoire Versmee, Laura Versmee

query.select <- function(pathlist, verbose = FALSE)  {

  if (verbose)  message('\nBuilding the "select" part of the query')
  ind <- length(pathlist)
  select <- '{"select": ['

  for (i in 1:(ind-1))  {
    select <- paste0(select,
              paste0('{"field": {"pui": "',
                  pathlist[i],
                  '","dataType": "STRING"},"alias": "',
                  pathlist[i],
                  '"},'))
  }

  select <- paste0(select,
            paste0('{"field": {"pui": "',
                   pathlist[ind],
                   '","dataType": "STRING"},"alias": "',
                   pathlist[ind],
                   '"}],'))

  return(select)
}
