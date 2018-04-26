# tsb-banking-scripts
Scripts to analyse TSB bank transaction data downloaded in CSV format.

You will need your statements downloaded from your TSB account in CSV format within a `/personal_files/tsb` folder. I download each month of transaction data to a separate CSV file. This code will read in all CSV files with the folder. The `sample_tsb.csv` file contains the format of these files.

You will also need a `personal.R` file defining the vectors that will help classify your transactions. These will need to be combined into a list called `terms` which is used by the script. A template for this has been created in `personal_template.R`.

I have also adapted the code to read in csv files from halifax - but these have been transcribed by hand as CSV files are not available and OCR methods did not work. The `sample_halifax.csv` file contains the format of these files. These should be stored in the `/personal_files/halifax` folder. The code currently assumes that it will be reading files from both of these folders.