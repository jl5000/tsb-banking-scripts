library(tidyverse)
library(lubridate)
source("functions.R")

tsb <- import_files("./personal_files", "tsb")
halifax <- import_files("./personal_files", "halifax")

df_combine <- bind_rows(halifax, tsb) %>%
      mutate(t_month = t_month %>% factor(levels = unique(.)))

# remove credit/debit lines I don't want to include (ensure they sum to zero)
df_combine_clean <- df_combine %>% remove_transaction(9000, "21/08/2017", "25/08/2017") %>%
                                  remove_transaction(1000, "08/01/2018", "08/01/2018") %>%
                                  remove_transaction(5000, "19/02/2016", "24/02/2016")

#add expense groupings
df_combine_clean_classified <- df_combine_clean %>% 
                                mutate(t_class = map_chr(t_desc, classify_expense))

# add manual expenses for one-off big expenditures
df <- df_combine_clean_classified %>% custom_expense()

rm(df_combine, df_combine_clean, df_combine_clean_classified)

#check misc entries to see if any additions need to be made to personal.R - focus on high value
df %>%
  filter(t_class == "Misc") %>%
  filter(amount < 0) %>%
  group_by(t_desc) %>%
  summarise(total = sum(amount)) %>%
  arrange(total) %>%
  View()

#core plot - balance over time
  df %>% 
    ggplot(aes(x=t_date,y=balance)) + 
    geom_line() + 
    geom_smooth()
  
  # View transactions containing string
  df %>% filter(str_detect(t_desc, "SIGNATURE")) %>% View()

  #breakdown each month - stacked bar
  df %>%
    filter(amount < 0) %>%
    filter(t_class != "Special" & t_class != "Holidays") %>%
    ggplot(aes(x=t_month,y=abs(amount),fill=t_class)) + 
      geom_bar(stat="identity") +
    theme(axis.text.x = element_text(angle = 45))
  
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
    filter(t_class == "Restaurants") %>%
    group_by(t_month) %>%
    summarise(total = abs(sum(amount))) %>%
    ggplot(aes(x=t_month, y=total)) +
    geom_bar(stat = "identity") +
    theme(axis.text.x = element_text(angle = 45))
  
  
##########TESTING GOOGLEDRIVE LIBRARY
  library(googledrive)
  