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


#' returns "normal" or "percentage" depending on format of current year data
#'
#' @param a_file Excel file created by Thembisa Project
#' @param a_sheet sheet name, default is "SA"
#' @param a_col column number to check for formatting, default is 43 (column AQ)
#'
#' @returns a tibble with indicators and their formatting type
#' @export
#'
#' @examples
#' \dontrun{
#'   add_formatting_label_cells(a_file, a_sheet = "SA", a_col = 43)
#' }
#'

add_formatting_label_cells <- function(a_file, a_sheet = "SA", a_col = 43){

    a_data <- readxl::read_xlsx(a_file, sheet = a_sheet) %>%
        dplyr::select(1, 2, a_col)

    wb <- openxlsx2::wb_load(a_file)

    temp <- a_data %>%
        dplyr::mutate(
            col_format = purrr::map(dplyr::row_number(), \(i) {
                if (thembisaR::is_percentage(wb, "SA", i)) "Percentage" else "Number"
            }) %>%
                unlist(use.names = FALSE)
        ) %>%
        dplyr::rename(
            indicator = 1,
            type = 2,
            value = 3
        ) %>%
        dplyr::filter(type == "Mean") %>%
        dplyr::select(-type, -value)

    return(temp)

}

#' returns "normal" or "percentage" depending on keyword of an indicator
#'
#' @param a_file Excel file created by Thembisa Project
#' @param a_sheet sheet name, default is "SA"
#'
#' @returns a tibble with indicators and their formatting type
#' @export
#'
#' @examples
#' \dontrun{
#'   add_formatting_label_keywords(a_file, a_sheet = "SA")
#' }
#'
add_formatting_label_keywords <- function(a_file, a_sheet = "SA") {

    df <- readxl::read_xlsx(a_file, a_sheet) |>
        dplyr::select(1,2) |>
        dplyr::rename(indicator = 1,
                      type = 2) |>
        dplyr::filter(type == "Mean") |>
        dplyr::select(-type)

    # List words that indicate percentage
    patterns <- c(
        "incidence",
        "rate",
        "prevalence",
        "coverage",
        "%",
        "suppression",
        "fraction",
        "Percent"
    )

    # Select indicators that contain any of the above words
    # Rule 1: if 100 000 then it's a number
    # Rule 2: if 1000 and rate then it's a number


    temp <- df |>
        dplyr::mutate(format = dplyr::case_when(
            grepl(
                paste(patterns, collapse = "|"),
                stringr::str_to_lower(indicator)
            ) ~ "Percentage",
            TRUE ~ "Number"
        ),
        format = dplyr::case_when(
            grepl("100 000", indicator) ~ "Number",
            TRUE ~ format
        ),

        format = dplyr::case_when(
            grepl("1000", indicator, fixed = TRUE) &
                grepl("rate", indicator, ignore.case = TRUE) ~ "Number",
            TRUE ~ format
        )

        )

    return(temp)

}


#' Returns if a cell is formatted as percentage
#'
#' @param wb workbook object
#' @param sheet sheet name
#' @param row row number (0-indexed)
#' @param col column number (1-indexed, default is 43 which is column AQ)
#'
#' @returns TRUE if the cell is formatted as percentage, FALSE otherwise
#' @export
#'
#' @examples
#' \dontrun{
#'   is_percentage(wb, sheet, row, col = 43)
#' }
#'

is_percentage <- function(wb, sheet, row, col = 43) {
    cell_ref <- paste0(openxlsx::int2col(col), row + 1)
    cell_style <- openxlsx2::wb_get_cell_style(wb, sheet, cell_ref)

    style_idx <- as.numeric(cell_style[[1]]) + 1
    has_style <- length(cell_style) > 0
    is_percent <- grepl('numFmtId="10"|numFmtId="166"', wb$styles_mgr$styles$cellXfs[style_idx])

    has_style && is_percent
}


