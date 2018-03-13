#' @author Gregoire Versmee, Laura Versmee

name.cols <- function(result, verbose = FALSE) {

  if (verbose)  message("  making the columns' name pretty")

  cnames <- colnames(result)
  cnames <- gsub(" ", "_", cnames)
  for (i in 1:length(cnames))  {
    if (grepl("0|1|2|3|4|5|6|7|8|9", substr(cnames[i], 1, 1)))  {
      cnames[i] <- paste0("x", cnames[i])
    }
  }
  cnames[1] <- "patient_id"
  cnames <- make.names(cnames, unique = TRUE)
  colnames(result) <- cnames
  return(result)

}
