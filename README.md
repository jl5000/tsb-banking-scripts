# tsb-banking-scripts
Scripts to analyse TSB bank transaction data downloaded in CSV format.

You will need your statements downloaded from your TSB account in CSV format within a /personal_files folder. I download each month of transaction data to a separate CSV file. This code will read in all CSV files with the folder. The sample.csv file contains the format of these files.

You will also need a 'personal.R' file defining the vectors that will help classify your transactions. These will need to be combined into a list called 'terms' which is used by the script, e.g.:

telephone <- c("bt","three","vodafone","talktalk")
terms <- list("Telephone" = telephone)

A template for the 'personal.R' file can be found below:

```{r}
library(stringr)

# Define vectors
restaurants <- c("mcdonalds")
shopping <- c("tesco")

terms <- list("Restaurants" = restaurants, 
              "Shopping" = shopping)

rm(restaurants, shopping)

deconflict_expense <- function(expense) {
  #for special cases where the transaction has been classified under two or more classes
  
  if (str_detect(expense, "INSERT SPECIFIC TRANSACTION DESCRIPTION HERE")) {
    return("Restaurants")
  } else if (str_detect(expense, "INSERT ANOTHER SPECIFIC TRANSACTION DESCRIPTION HERE")) {
    return("Shopping")
  } else {
    # print any expenses to the console which have unresolved conflicts
    message(expense, " not classified.")
    return("")
  }
  
}
```