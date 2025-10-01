# thembisaR

An R package for loading, cleaning, and reshaping Thembisa model outputs for use in downstream analysis and visualisation.

This package cleans the sex_age_specific excel data available from [Thembisa.org](thembisa.org).

## Installation

``` r
remotes::install_github("KirstinLyon/thembisaR")
```

## Usage

``` r
library(thembisaR)

your_local_file <- "path/filename"

#Any sheets that should be excluded from your dataset

sheets_to_exclude <- c("Notes")

#Read and clean all tabs in the excel sheet. Default is to exclude the "Notes" tab

all_thembisa_data <- read_sex_age_sepcific(your_local_file, sheets_to_exclude)

#Clean one sheet

one_sheet <- readxl::read_xlsx(your_local_file,
                             sheet = "name_of_sheet")

one_tab_thembisa_data <- clean_sex_age_specific(one_sheet)
```

## Demo / App

This package is used in a Shiny app, which you can try here: [Clean my Thembisa Data](https://kirstinlyon.shinyapps.io/clean_thembisa_data/)

## Support / Contributing

If you find bugs or want features, open an issue or submit a pull request.
