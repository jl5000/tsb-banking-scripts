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