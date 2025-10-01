#' Read in all data from Thembisa excel file
#'
#' @param filename path to the Thembisa excel file
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   read_sex_age_specific_file(filename)
#' }
#'
read_sex_age_specific_file <- function(filename){

    sheet_names <- readxl::excel_sheets(filename)
    sheet_names <- dplyr::setdiff(readxl::excel_sheets(filename), "Notes")

    all_data <- sheet_names %>%
        purrr::set_names() %>%  # keep sheet names as list names
        purrr::map(~ {
            df <- readxl::read_xlsx(filename, sheet = .x)      # step 1: read sheet
            df <- thembisaR::clean_sex_age_specific(df)      # step 2: clean the data
            df <- df %>% dplyr::mutate(sheet_name = .x)       # step 3: store sheet name
            df
        }) %>%
        dplyr::bind_rows()  %>%
        dplyr::rename(country_province = sheet_name) %>%
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
