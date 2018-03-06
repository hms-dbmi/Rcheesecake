#' @author Gregoire Versmee
#' @export nicer.result

nicer.result <- function(result, verbose = FALSE)  {

  if (verbose == TRUE)  message("  combining the categorical variables")

  groups <- c()
  for (i in 1:ncol(result))  {
    split <- unlist(strsplit(colnames(result)[i], "/"))
    code <- split[length(split)]
    label <- split[length(split)-1]
    gr <- paste(split[1:length(split)-1], collapse = "/")
    groups <- c(groups, gr)
  }
  groups2 <- unique(groups)


  final <- result[1]
  cnames <- c("Patient_id")

  for (i in 2:length(groups2))  {
    subdf <- result[which(groups == groups2[i])]

    if (length(unique(subdf[,1])) == 2  & any(is.na(unique(subdf[,1]))))  {
      subdf[is.na(subdf)] <- ""
      col <- as.factor(apply(subdf, 1, paste0, collapse = ""))
      final <- cbind(final, col)
      split <- unlist(strsplit(colnames(subdf), "/"))
      code <- split[length(split)-1]
      cnames <- c(cnames, code)

    } else {
      final <- cbind(final, subdf)
      split <- strsplit(colnames(subdf), "/")
      label <- sapply(split, function(l)  return(l[length(l)]))
      cnames <- c(cnames, label)
    }
  }

  colnames(final) <- cnames

  return(final)
}

