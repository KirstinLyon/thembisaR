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
