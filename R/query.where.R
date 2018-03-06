#' @author Gregoire Versmee, Laura Versmee

query.where <- function(env, pathlist, subset = "ALL", token, verbose = FALSE)  {

  if (verbose == TRUE)  message('\nBuilding the "where" part of the query')

  where <- '"where": ['

  if (subset == "ALL")  {

    if (verbose == TRUE)  message('  default subset = "ALL"\n  -> will look for all the patients that have a value for at list one of the variable selected')

    where <- paste0(where,
             paste0('{"field": {"pui": "',
                    pathlist[1],
                    '","dataType": "STRING"},"predicate": "CONTAINS","fields": {"ENCOUNTER": "YES"}},'))

    if (length(pathlist)>1)  {
      for (i in 2:(length(pathlist)))  {
        where <- paste0(where,
                        paste0('{"field": {"pui": "',
                               pathlist[i],
                               '","dataType": "STRING"}, "logicalOperator": "OR", "predicate": "CONTAINS","fields": {"ENCOUNTER": "YES"}},'))

      }
    }
  }  else  {

    if (verbose == TRUE)  message("Complex subset detected")

    ## Working on where clause, struct = "(path/to/var1) & (path/to/var2 > x) ! (path/to/var3 <= y)"
    #1. substitue AND, OR, NOT by &,|, !
    subset <- gsub("\\) AND \\(", "\\) & \\(", gsub("\\) OR \\(", "\\) \\| \\(", gsub("\\) NOT \\(", "\\) ! \\(", subset)))

    # 2. How many args? -> grep for logical operator between ) ( +1
    and <- unlist(gregexpr ("\\) & \\(", subset))
    and <- and[which(and > 0)]
    or <- unlist(gregexpr ("\\) \\| \\(", subset))
    or <- or[which(or >0)]
    not <- unlist(gregexpr ("\\) ! \\(", subset))
    not <- not[which(not>0)]

    sep <- c(1, and, or, not, nchar(subset))
    nargs <- length(sep)-1

    if (verbose == TRUE)  message(paste(nargs, "argument(s) detected"))

    ## 2.1 start building the dataframe
    df <- data.frame(matrix(nrow = nargs, ncol = 7))
    colnames(df) <- c("logicalOperator", "pui", "dataType", "OPERATOR", "CONSTRAINT", "ENCOUNTER", "predicate")
    df[,6] <- "YES"

    #3. Separate each args
    arg <- c()

    arg[1] <- substr(subset, 2, sep[2]-1)
    if (nargs > 1)  {
      for (i in 2:nargs)  {
        arg[i] <- substr(subset, sep[i], sep[i+1]-1)
        arg[i] <- substr(arg[i], regexpr("\\(", arg[i]) + 1, nchar(arg[i]))
        df[i,1] <- substr(subset, sep[i]+2, sep[i]+2)
        df[i,1] <- gsub("&", "AND", gsub("\\|", "OR", gsub("!", "NOT", df[i,1])))
      }
    }

    for (i in 1:nargs)  {
      #4. look for logical operator in the first arg
      logicaleq1 <- regexpr("== ", arg[i])
      logicaleq <- c(logicaleq1, regexpr("= ", arg[i]))
      logicaleq <- logicaleq[which(logicaleq > 0)]
      logicalne <- regexpr("!= ", arg[i])
      logicalne <- logicalne[which(logicalne > 0)]
      logicalgt <- regexpr("> ", arg[i])
      logicalgt <- logicalgt[which(logicalgt > 0)]
      logicalge <- regexpr(">= ", arg[i])
      logicalge <- logicalge[which(logicalge > 0)]
      logicallt <- regexpr("< ", arg[i])
      logicallt <- logicallt[which(logicallt > 0)]
      logicalle <- regexpr("<= ", arg[i])
      logicalle <- logicalle[which(logicalle > 0)]

      logical <- c(logicaleq, logicalne, logicalgt, logicalge, logicallt, logicalle)

      #5. if logical operator, split
      if (length(logical) > 0)  {
        df[i,2] <- path.list(env, trimws(substr(arg[i], 1, logical-2)), token)
        df[i,3] <- "FLOAT"
        df[i,4] <- trimws(substr(arg[i], logical, logical+1))
        df[i,4] <- gsub("=", "EQ", gsub("==", "EQ", gsub("!=", "NE", gsub(">", "GT", gsub(">=", "GE", gsub("<", "LT", gsub("<=", "LE", df[i,4])))))))
        df[i,5] <- trimws(substr(arg[i], logical+2, nchar(arg[i])))
        df[i,7] <- "CONSTRAIN_VALUE"
      }  else  {
        df[i,2] <- path.list(env, trimws(arg[i]), token)
        df[i,3] <- "STRING"
        df[i,7] <- "CONTAINS"
      }
    }

    #6. Build the query

      if (is.na(df[1,4]))  {
      where <- paste0(where,
                      paste0('{"field": {"pui": "',
                             df[1,2],
                             '","dataType": "STRING"},"predicate": "CONTAINS","fields": {"ENCOUNTER": "YES"}},'))
      } else  {
        where <- paste0(where,
                        paste0('{"field": {"pui": "',
                               df[1,2],
                               '","dataType": "INTEGER"},"predicate": "CONSTRAIN_VALUE","fields": {"OPERATOR": "',
                               df[1,4],
                               '", "CONSTRAINT": "',
                               df[1,5],
                                '","ENCOUNTER": "YES"}},'))
      }

      if (nrow(df)>1)  {
        for (i in 2:nrow(df))  {
          if (is.na(df[i,4]))  {
            where <- paste0(where,
                            paste0('{"logicalOperator":"',
                                    df[i,1],
                                    '","field": {"pui": "',
                                    df[i,2],
                                    '","dataType": "STRING"},"predicate": "CONTAINS","fields": {"ENCOUNTER": "YES"}},'))
          } else  {
            where <- paste0(where,
                            paste0('{"logicalOperator":"',
                                   df[i,1],
                                   '","field": {"pui": "',
                                   df[i,2],
                                   '","dataType": "INTEGER"},"predicate": "CONSTRAIN_VALUE","fields": {"OPERATOR": "',
                                   df[i,4],
                                   '", "CONSTRAINT": "',
                                   df[i,5],
                                   '","ENCOUNTER": "YES"}},'))
          }
        }
      }
    }

  where <- paste0(substr(where, 1, (nchar(where)-1)), "]}")

  return(where)
}

