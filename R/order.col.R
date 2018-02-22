#' @author Gregoire Versmee
#' @export order.col

order.col <- function(result, allpaths)  {

  order <- c(1)
  for (i in 1:length(allpaths))  {
    order <- c(order, grep(make.names(allpaths[i]), make.names(colnames(result))))
  }

  result <- result[order]

}

