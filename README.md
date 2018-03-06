
# Introducing Rcheesecake, the simplest R package to export dataframes from the PIC-SURE API


The PIC_Sure API has been created in order to be able to "cherry-pick" variables and observations from very large datasets. So far, 2 "methods" have been presented to document the utilization of PIC-SURE. The original can be found here : https://pic-sure.org/products/nhanes-unified-dataset/pic-sure-restful-api-way. The second one is an R package called "Rcupcake", intended to extract data, and to create a specific R object (data2cupcake) to run specifics analysis.

Those 2 methods suffer from some inconveniences. The most important is the number of steps and the number of arguments needed to get your data.frame. Our goal was to create a tool being able to retrieve a data frame with 1 step and 3 arguments: the name of the transmart environment, the key and a vector with the list of the desired variables. A fourth argument can be added in order to subset the population.
Here is an example based on the first use-case published for pic-sure.


### 1. Install the package
The installation is very easy and fast, since there is only 1 dependant package to install (httr), compared to Rcupcake who needs 70 dependant packages and 8 minutes to install initially.


```R
remove.packages("Rcheesecake")
devtools::install_github("gversmee/Rcheesecake", force = TRUE)
library(Rcheesecake)
```

    Removing package from ‘/opt/conda/lib/R/library’
    (as ‘lib’ is unspecified)
    Updating HTML index of packages in '.Library'
    Making 'packages.html' ... done
    Downloading GitHub repo gversmee/Rcheesecake@master
    from URL https://api.github.com/repos/gversmee/Rcheesecake/zipball/master
    Installing Rcheesecake
    '/opt/conda/lib/R/bin/R' --no-site-file --no-environ --no-save --no-restore  \
      --quiet CMD INSTALL  \
      '/tmp/Rtmpn1iOI6/devtools15038d6ccb8/gversmee-Rcheesecake-b02f493'  \
      --library='/opt/conda/lib/R/library' --install-tests 
    
    Reloading installed Rcheesecake


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
test <- picsure(environment, key, variables)

head(test)
nrow(test)
```

    results OK https://nhanes.hms.harvard.edu



<table>
<thead><tr><th></th><th scope=col>patient_id</th><th scope=col>PCB153_.ng_per_g.</th><th scope=col>SEX</th><th scope=col>AGE</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2   </td><td>NA  </td><td>male</td><td>85  </td></tr>
	<tr><th scope=row>2</th><td>3     </td><td>NA    </td><td>female</td><td>0     </td></tr>
	<tr><th scope=row>3</th><td>4     </td><td>0.109 </td><td>female</td><td>49    </td></tr>
	<tr><th scope=row>4</th><td>5   </td><td>NA  </td><td>male</td><td>18  </td></tr>
	<tr><th scope=row>5</th><td>6     </td><td>NA    </td><td>female</td><td>4     </td></tr>
	<tr><th scope=row>6</th><td>7   </td><td>NA  </td><td>male</td><td>31  </td></tr>
</tbody>
</table>




41474


It's as simple as that. You can see that the columns are ordered in the same order as the one we selected our variables, instead of the 2 previous methods. By default, it will return all patients having one of the variables. That's why the number of patient can be slightly different from Rcupcake, who will only retrieve the patient that have the first variable you selected.

### 3. Subset our dataframe
From the previous example, imagine that we want to get only the results for the patients that have a dosage of PCB153. We just have to set up the argument `subset`.


```R
subset <- "(laboratory/pcbs/PCB153 (ng per g))"
test2 <- picsure(environment, key, variables, subset)

head(test2)
nrow(test2)
```

    results OK https://nhanes.hms.harvard.edu



<table>
<thead><tr><th></th><th scope=col>patient_id</th><th scope=col>PCB153_.ng_per_g.</th><th scope=col>SEX</th><th scope=col>AGE</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>4     </td><td>0.109 </td><td>female</td><td>49    </td></tr>
	<tr><th scope=row>2</th><td>8     </td><td>0.105 </td><td>female</td><td>40    </td></tr>
	<tr><th scope=row>3</th><td>15    </td><td>0.137 </td><td>female</td><td>40    </td></tr>
	<tr><th scope=row>4</th><td>25    </td><td>0.035 </td><td>female</td><td>18    </td></tr>
	<tr><th scope=row>5</th><td>31    </td><td>0.323 </td><td>female</td><td>72    </td></tr>
	<tr><th scope=row>6</th><td>35   </td><td>0.107</td><td>male </td><td>62   </td></tr>
</tbody>
</table>




6128


Similarly, if we want to get only the young patients (age <20 y/o), and the elder ones (age > 60y/o), we can set up the `subset` argument as shown.


```R
subset <- "(/demographics/AGE > 60) | (/demographics/AGE < 20)"
test3 <- picsure(environment, key, variables, subset)

head(test3)
nrow(test3)
```

    results OK https://nhanes.hms.harvard.edu



<table>
<thead><tr><th></th><th scope=col>patient_id</th><th scope=col>PCB153_.ng_per_g.</th><th scope=col>SEX</th><th scope=col>AGE</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2   </td><td>NA  </td><td>male</td><td>85  </td></tr>
	<tr><th scope=row>2</th><td>3     </td><td>NA    </td><td>female</td><td>0     </td></tr>
	<tr><th scope=row>3</th><td>5   </td><td>NA  </td><td>male</td><td>18  </td></tr>
	<tr><th scope=row>4</th><td>6     </td><td>NA    </td><td>female</td><td>4     </td></tr>
	<tr><th scope=row>5</th><td>11    </td><td>NA    </td><td>female</td><td>17    </td></tr>
	<tr><th scope=row>6</th><td>12    </td><td>NA    </td><td>female</td><td>71    </td></tr>
</tbody>
</table>




27961



```R

```
