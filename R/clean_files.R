#' clean data from the sex_age specific file
#'
#' @param excel_tab a tab in excel
#'
#' @returns cleaned dataset
#' @export
#'
#' @examples
#' \dontrun{
#'   clean_sex_age_specific(excel_tab)
#' }
#'

clean_sex_age_specific <- function(excel_tab) {
    temp <- excel_tab %>%
        janitor::clean_names() %>%

        #if it's an age it will be less than 4 chars
        dplyr::mutate(type = dplyr::case_when(stringr::str_length(x1) < 4 ~ "age", TRUE ~ "indicator")) %>%

        # separate age from the generic column
        dplyr::mutate(age = dplyr::case_when(type == "age" ~ x1, TRUE ~ NA)) %>%

        #create a separate indicator column
        dplyr::mutate(indicator = dplyr::case_when(type == "indicator" ~ x1, TRUE ~ NA),
                      indicator = dplyr::na_if(indicator, "")
        ) %>%
        tidyr::fill(indicator, .direction = "down") %>%
        tidyr::drop_na(age) %>%

        #Create a separate sex column
        dplyr::mutate(sex = dplyr::case_when(stringr::str_detect(indicator, "\\bMale") ~ "Male", TRUE ~ "Female")) %>%
        dplyr::select(-c(x1, type)) %>%
        tidyr::pivot_longer(cols = tidyr::starts_with("x"),
                     names_to = "year",
                     values_to = "value") %>%
        dplyr::mutate(year = stringr::str_remove(year, "x"),
               indicator = dplyr::if_else(
                   stringr::str_detect(stringr::str_to_lower(indicator), "^(male|female)"),
                   stringr::str_remove(indicator, "^\\S+\\s+"),  # drop first word + spaces
                   indicator                            # leave unchanged
               ),
               indicator = stringr::str_to_sentence(indicator)
        )

    return(temp)

}


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

    temp <- nat_prov_sheet %>%
        janitor::clean_names() %>%
        dplyr::rename(category_indicator = x1,
                      statistic = x2) %>%
        dplyr::mutate(category = dplyr::case_when(is.na(statistic) ~ category_indicator,
                                                  TRUE ~ NA_character_),
                      indicator = dplyr::case_when(!is.na(statistic) ~ category_indicator,
                                                   TRUE ~ NA_character_)
        ) %>%
        tidyr::fill(category, .direction = "down") %>%
        tidyr::fill(indicator, .direction = "down") %>%
        tidyr::drop_na(statistic) %>%
        dplyr::select(-category_indicator) %>%
        dplyr::select_if(~ !all(is.na(.x))) %>%  # removes all empty columns


        tidyr::pivot_longer(cols = -c(category, indicator, statistic),
                            names_to = "year",

                            values_to = "value") %>%
        dplyr::mutate(year = stringr::str_remove(year, "x"),
                      year = as.integer(year)) %>%
        tidyr::pivot_wider(names_from = statistic,
                           values_from = value)

    return(temp)


}
