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

}


#' Generic reading function for Thembisa excel files
#'
#' @param filename path to the Thembisa excel file
#' @param sheets_to_exclude sheets to exclude from reading, default is Notes, Comparison and Abbreviations
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   read_prov_output(filename, sheets_to_exclude)
#' }
#'
read_prov_output <- function(filename, sheets_to_exclude = c("Notes", "Comparison", "Abbreviations")){
    sheet_names <- readxl::excel_sheets(filename)
    sheet_names <- dplyr::setdiff(readxl::excel_sheets(filename), sheets_to_exclude)

    temp <- sheet_names %>%
        purrr::set_names() %>%  # keep sheet names as list names
        purrr::map(~ {
            df <- readxl::read_xlsx(filename, sheet = .x)      # step 1: read sheet
            df <- thembisaR::clean_prov_output(df)      # step 2: clean the data
            df <- df %>% dplyr::mutate(sheet_name = .x)       # step 3: store sheet name
            df
        }) %>%
        dplyr::bind_rows()  %>%
        dplyr::rename(country_province = sheet_name) %>%
        thembisaR::add_country_province_name()

        return(temp)

}
