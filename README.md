
# Introducing Rcheesecake, the simplest R package to export dataframes from the PIC-SURE API


The PIC_Sure API has been created in order to be able to "cherry-pick" variables and observations from very large datasets. So far, 2 "methods" have been presented to document the utilization of PIC-SURE. The original can be found here : https://pic-sure.org/products/nhanes-unified-dataset/pic-sure-restful-api-way. The second one is an R package called "Rcupcake", intended to extract data, and to create a specific R object (data2cupcake) to run specifics analysis.

Our goal was to create a tool being able to retrieve a data frame with 1 step and 3 arguments: the name of the transmart environment, the key and a vector with the list of the desired variables. A fourth argument can be added in order to subset the population.

For this beta version, it is only possible to query phenotypics data. Soon, the package will be upgraded to be able to query genotypics data from Hail.

Here is an example based on the first use-case published for pic-sure.




### 1. Install the package
The installation is very easy and fast, since there is only 2 dependent packages to install (httr and openssl).


```R
remove.packages("Rcheesecake")
devtools::install_github("gversmee/Rcheesecake", force = TRUE)
library(Rcheesecake)
```

### 2. First example: get the variables age, gender and PCBS level from the nhanes database
Here, we just set up the environment, the key, and we choose the path to the variables of interest.


```R
environment <- "https://nhanes.hms.harvard.edu"

key <- as.character(read.table("key.csv", sep=",")[1,1])

pcb <- "laboratory/pcbs/PCB153 (ng per g)"
age <- "demographics/AGE/"
sex <- "demographics/SEX"
variables <- c(pcb, sex, age)
```

Then, we use the newly created `picsure` function to get our data.frame.


```R
test1 <- picsure(environment, key, variables, verbose = FALSE)
# Set the verbose to TRUE if you want to get the log info

head(test1)
nrow(test1)
```

It's as simple as that. You can see that the columns are ordered in the same order as the one we selected our variables. By default, it will return all patients having one of the variables.

### 3. Subset our dataframe
From the previous example, imagine that we want to get only the results for the patients that have a dosage of PCB153. We just have to set up the argument `subset`.


```R
subset <- "(laboratory/pcbs/PCB153 (ng per g))"
test2 <- picsure(environment, key, variables, subset)

head(test2)
nrow(test2)
```

Similarly, if we want to get only the young patients (age <20 y/o), and the elder ones (age > 60y/o), we can set up the `subset` argument as shown.


```R
subset <- "(/demographics/AGE > 60) | (/demographics/AGE < 20)"
test3 <- picsure(environment, key, variables, subset)

head(test3)
nrow(test3)
```


```R

```
