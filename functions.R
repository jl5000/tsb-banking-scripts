
# Define term vectors that define sub-classes and put them in a terms list, e.g.:
# telephone <- c("bt","three","vodafone","talktalk")
# terms <- list("Telephone" = telephone)
# This is contained in my own personal.R file, you can create your own based on your own transactions
source("personal.R")

classify_expense <- function(expense) {
  
  # returns logical vector indicating which classes the expense has been classified
  matches <- map_lgl(terms, match_exists, string_to_classify = expense)
  
  if (sum(matches)==0) {
    #No match - stick under Misc
    return("Misc")
  } else if (sum(matches) == 1) {
    # Ideal case
    return(names(matches)[matches == 1])
  } else {
      # Two or more matches - go to deconflict function to choose one expense class
      # These are special cases unique to the vectors you set up, hence this function
      # is defined in personal.R
      return(deconflict_expense(expense))
  }
}

# function returns a vector of search patterns to use in a regular expression
# by taking a vector of terms to look for
search_pattern <- function(terms) {
  return(paste0("^.*", terms, ".*$"))
}

# function returns a logical value determining whether the string to classify
# exists within the vector of terms provided - if it exists in any of the terms
# it returns TRUE
match_exists <- function(string_to_classify, terms) {
  return(any(map_lgl(search_pattern(terms),
                     grepl,
                     string_to_classify, 
                     ignore.case = TRUE)))
}


import_files <- function(filepath) {
  
  files <- list.files(filepath)
  filenames <- paste(filepath, files, sep = "/")
  
  #read data; row field is a way of preserving row order of files
  #get rid of account number/sort code, rename fields, replace NA with 0, combine credit and debit,
  #sort by date order, remove unnecessary fields
  map_df(filenames, function(x) {read_csv(x,col_types="cccccddd") %>% rownames_to_column("row")}) %>%
    select(-4,-5) %>%
    rename(t_date = `Transaction Date`,
           t_type = `Transaction Type`,
           t_desc = `Transaction Description`,
           balance = Balance) %>%
    replace_na(list(`Debit Amount` = 0, `Credit Amount` = 0)) %>%
    mutate(row = as.integer(row),
           t_date = as.Date(t_date, "%d/%m/%Y"),
           t_month = format(t_date, "%Y/%m"),
           amount = `Credit Amount` - `Debit Amount`) %>%
    arrange(t_date, desc(row)) %>%
    select(t_date, t_month, t_type, t_desc, amount, balance)
}


remove_transaction <- function(df, threshold, from, to) {
  
  tr_rows <- which(abs(df$amount) >= threshold & 
                    df$t_date >= as.Date(from, "%d/%m/%Y") & 
                     df$t_date <= as.Date(to, "%d/%m/%Y"))
  
  # go through each row in turn
  for (row in tr_rows) {
    
    df$balance[row:nrow(df)] <- df$balance[row:nrow(df)] - df$amount[row]
    
    msg_start <- ifelse(df$amount[row] < 0,
                        "Debit row removed for £",
                        "Credit row removed for £")
    message(msg_start, abs(df$amount[row]), " on ", df$t_date[row])
  }
  
  if (length(tr_rows) > 0) {df <- df[-tr_rows,]}
  
  return(df)
  
}
