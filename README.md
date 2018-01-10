# tsb-banking-scripts
Scripts to analyse TSB bank transaction data downloaded in CSV format.

You will need your statements downloaded from your TSB account in CSV format within a /personal_files folder. I download each month of transaction data to a separate CSV file. This code will read in all CSV files with the folder. The sample.csv file contains the format of these files.

You will also need a `personal.R` file defining the vectors that will help classify your transactions. These will need to be combined into a list called `terms` which is used by the script. A template for this has been created in `personal_template.R`.