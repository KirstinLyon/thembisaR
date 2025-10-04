#' Read in all data from Thembisa excel file
#'
#' @param filename path to the Thembisa excel file
#' @param sheets_to_exclude sheets to exclude from reading, default is "Notes"
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   read_sex_age_specific_file(filename, sheets_to_exclude)
#' }
#'
read_sex_age_specific_file <- function(filename, sheets_to_exclude = "Notes"){

   temp <- read_file(filename, sheets_to_exclude)

   return(temp)

}


#' Generic reading function for Thembisa excel files
#'
#' @param filename path to the Thembisa excel file
#' @param sheets_to_exclude sheets to exclude from reading, default is "Notes"
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   read_file(filename, sheets_to_exclude)
#' }
#'
read_file <- function(filename, sheets_to_exclude = "Notes"){
    sheet_names <- readxl::excel_sheets(filename)
    sheet_names <- dplyr::setdiff(readxl::excel_sheets(filename), sheets_to_exclude)

    temp <- sheet_names %>%
        purrr::set_names() %>%  # keep sheet names as list names
        purrr::map(~ {
            df <- readxl::read_xlsx(filename, sheet = .x)      # step 1: read sheet
            df <- thembisaR::clean_sex_age_specific(df)      # step 2: clean the data
            df <- df %>% dplyr::mutate(sheet_name = .x)       # step 3: store sheet name
            df
        }) %>%
        dplyr::bind_rows()  %>%
        dplyr::rename(country_province = sheet_name) %>%
        thembisaR::add_country_province_name()

        return(temp)
   #     dplyr::mutate(country_province_name = dplyr::case_when(
#            country_province == "SA" ~ "South Africa",
#            country_province == "EC" ~ "Eastern Cape",
#            country_province == "FS" ~ "Free State",
#            country_province == "GT" ~ "Gauteng",
#            country_province == "KZ" ~ "KwaZulu-Natal",
#            country_province == "LM" ~ "Limpopo",
#            country_province == "MP" ~ "Mpumalanga",
#            country_province == "NC" ~ "Northern Cape",
#            country_province == "NW" ~ "North West",
#            country_province == "WC" ~ "Western Cape",
#            TRUE ~ country_province
#        ))

}

#' Function to add full names of provinces and country to data
#'
#' @param data data with country_province column
#'
#' @returns cleaned dataset with country_province_name column
#' @export
#'
#' @examples
#' \dontrun{
#'   add_country_province_name(data)
#' }
#'

add_country_province_name <- function(data){

    temp <- data %>%
     #   dplyr::rename(country_province = sheet_name) %>%
        dplyr::mutate(country_province_name = dplyr::case_when(
            country_province == "SA" ~ "South Africa",
            country_province == "EC" ~ "Eastern Cape",
            country_province == "FS" ~ "Free State",
            country_province == "GT" ~ "Gauteng",
            country_province == "KZ" ~ "KwaZulu-Natal",
            country_province == "LM" ~ "Limpopo",
            country_province == "MP" ~ "Mpumalanga",
            country_province == "NC" ~ "Northern Cape",
            country_province == "NW" ~ "North West",
            country_province == "WC" ~ "Western Cape",
            TRUE ~ country_province
        ))



}




