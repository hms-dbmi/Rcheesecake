#' @author Gregoire Versmee
#' @export nicer.result

nicer.result <- function(result, verbose = FALSE)  {

  i <- 2
  while (i <= ncol(result))  {
    split <- unlist(strsplit(colnames(result)[i], "/"))
    code <- split[length(split)]
    label <- split[length(split)-1]

    if (length(unique(result[,i])) == 2  & any(is.na(unique(result[,i]))))  {
      result[,i][is.na(result[,i])] <- ""
      colnames(result)[i] <- label
      i <- i+1
      while (length(unique(result[,i])) == 2  &
             any(is.na(unique(result[,i] )))  &
             unlist(strsplit(colnames(result)[i], "/"))[length(unlist(strsplit(colnames(result)[i], "/")))-1] == label)
      {
         result[,i][is.na(result[,i])] <- ""
         result[,i-1] <- paste0(result[,i-1], result[,i])
         result <- result[,-i]
      }
      result[,i-1] <- as.factor(result[,i-1])
    }  else  {
      colnames(result)[i] <- code
      i <- i+1
    }
  }
  return(result)
}

