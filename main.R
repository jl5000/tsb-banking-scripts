library(tidyverse)
source("functions.R")

df <- import_files("./personal_files")

#add expense groupings
df <- df %>% mutate(t_class = map_chr(t_desc, classify_expense))

# remove credit lines I don't want to include
df <- df %>% remove_transaction(9000, "01/08/2017", "31/08/2017")
# remove debit lines  I don't want to include
df <- df %>% remove_transaction(1000, "05/01/2018", "09/01/2018")


#check misc entries
df %>%
  filter(t_class == "Misc") %>%
  filter(amount < 0) %>%
  distinct(t_desc) %>%
  View()

#balance over time
  df %>% 
    ggplot(aes(x=t_date,y=balance)) + geom_line() + geom_smooth(se=FALSE)

  #breakdown each month - stacked bar
  df %>%
    filter(amount < 0) %>%
    filter(t_class != "Special" & t_class != "Holidays") %>%
    ggplot(aes(x=t_month,y=abs(amount),fill=t_class)) + 
      geom_bar(stat="identity") + 
      geom_hline(yintercept = 2626)
  
  #breakdown each month - class facets
  df %>%
    filter(amount < 0) %>%
    filter(t_class != "Special" & t_class != "Holidays") %>%
    ggplot(aes(x=t_month,y=abs(amount))) + 
    geom_bar(stat="identity") + 
    facet_wrap(~ t_class)

  #top 3 expenses each month
  df %>% 
    filter(amount < 0) %>%
    group_by(t_month) %>%
    top_n(3, wt=abs(amount)) %>%
    select(t_month, t_desc, amount, t_class) %>%
    View()
  
  #eating out spend per month
  df %>%
    filter(t_class == "Shopping") %>%
    group_by(t_month) %>%
    summarise(total = abs(sum(amount))) %>%
    ggplot(aes(x=t_month, y=total)) +
    geom_bar(stat = "identity")
  