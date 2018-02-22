#' @author Gregoire Versmee
#' @export query.select

query.select <- function(pathlist)  {

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
