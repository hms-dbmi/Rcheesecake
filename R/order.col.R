#' @author Gregoire Versmee, Laura Versmee

order.col <- function(result, allpaths, verbose = FALSE)  {

  if (verbose)  message("\nMaking the dataframe pretty\n  ordering the columns according to the order of the variables you selected")

  return(result[c(1, sapply(allpaths, grep, colnames(result), fixed = TRUE))])

}
