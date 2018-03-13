#' @author Gregoire Versmee, Laura Versmee

query.select <- function(pathlist, verbose = FALSE)  {

  if (verbose)  message('\nBuilding the "select" part of the query')

  return(paste0('{"select": [',

                   paste0('{"field": {"pui": "',
                          pathlist,
                          '","dataType": "STRING"},"alias": "',
                          pathlist,
                          '"}', collapse = ","),

                   '],'))

}
