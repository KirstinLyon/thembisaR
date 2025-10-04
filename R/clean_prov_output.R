#' Clean provincial output
#'
#' @param nat_prov_sheet a sheet from the provincial output excel file
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   clean_prov_output(nat_prov_sheet)
#' }
#'

clean_prov_output <- function(nat_prov_sheet){

    temp <- nat_prov_sheet |>
        janitor::clean_names() |>
        dplyr::rename(category_indicator = x1,
                      statistic = x2) |>
        dplyr::mutate(category = dplyr::case_when(is.na(statistic) ~ category_indicator,
                                                  TRUE ~ NA_character_),
                      indicator = dplyr::case_when(!is.na(statistic) ~ category_indicator,
                                                   TRUE ~ NA_character_)
        ) |>
        tidyr::fill(category, .direction = "down") %>%
        tidyr::fill(indicator, .direction = "down") %>%
        tidyr::drop_na(statistic) |>
        dplyr::select(-category_indicator) |>
        dplyr::select_if(~ !all(is.na(.x))) |>  # removes all empty columns


        tidyr::pivot_longer(cols = -c(category, indicator, statistic),
                            names_to = "year",

                            values_to = "value") |>
        dplyr::mutate(year = stringr::str_remove(year, "x"),
                      year = as.integer(year)) |>
        tidyr::pivot_wider(names_from = statistic,
                           values_from = value)

    return(temp)


}




