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

custom_expense <- function(df) {
  
  # specify by date and threshold (like remove_transaction)
  # the expense column isn't actually used, it's just for your own reference
  custom <- tribble(
    ~expense,           ~threshold,      ~from,         ~to,
    #=============================================================
    "One off payment 1",      50,     "08/12/2016", "09/12/2016",
    "One off payment 2",     200,     "16/12/2016", "16/12/2016"
  )
  
  tr_rows <- map(1:nrow(custom), ~which(abs(df$amount) >= custom$threshold[.] & 
                                          df$t_date >= dmy(custom$from[.]) & 
                                          df$t_date <= dmy(custom$to[.]))) %>% unlist()
  
  df$t_class[tr_rows] <- "Special"
  return(df)
}