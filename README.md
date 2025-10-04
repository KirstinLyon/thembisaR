# thembisaR

An R package for loading, cleaning, and reshaping Thembisa model outputs for use in downstream analysis and visualisation.

This package cleans the [age-specific national and provincial model outputs](https://thembisa.org/content/downloadPage/AgeOutput4_82) excel data available from [Thembisa.org](thembisa.org). It was tested on version 4.8.

## Installation

``` r
remotes::install_github("KirstinLyon/thembisaR")
```

## Usage

``` r
library(thembisaR)
library(dplyr) #only if you want one sheet cleaned and need to add the sheet name
library(readlxl) #only if you want one sheet cleaned

your_local_file <- "path/filename"

#Read and clean all tabs in the excel sheet. Default is to exclude the "Notes" tab

all_thembisa_age_data <- read_sex_age_specific_file(your_local_file)

#Clean one sheet
one_sheet <- readxl::read_xlsx(your_local_file,
                             sheet = "name_of_sheet")

one_tab_thembisa_data <- clean_sex_age_specific(one_sheet) |> 
    dplyr::mutate(country_province = "name_of_sheet")



# Provincial Example - either HIV or TB estimates
your_provincial_file <-"path/filename"

# All data. Default is to exclude Notes, Comparison and Abbreviations tabs.

all_thembisa_prov_data <- read_prov_output(your_local_file)

# One sheet exmaple

one_sheet <- readxl::read_xlsx(your_local_file,
                             sheet = "name_of_sheet")

one_tab_thembisa_prov_data <- clean_prov_output(one_sheet) |> 
    dplyr::mutate(country_province = "name_of_sheet")

```

## Demo / App

This package is used in a Shiny app, which you can try here: [Clean my Thembisa Data](https://kirstinlyon.shinyapps.io/clean_thembisa_data/)

## Support / Contributing

If you find bugs or want features, open an issue or submit a pull request.
