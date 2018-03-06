#' @author Gregoire Versmee
#' @export order.col

order.col <- function(result, allpaths, verbose = FALSE)  {


  if (verbose == TRUE)  message("\nMaking the dataframe pretty\n  ordering the columns according to the order of the variables you selected")

  order <- c(1)
  for (i in 1:length(allpaths))  {
    order <- c(order, grep(make.names(allpaths[i]), make.names(colnames(result))))
  }

  result <- result[order]

}

