#' Retrieve data from Red Electrica Española.
#'
#' @param lang Language: either "es" or "en".
#' @param category Type of data, one of c("balance", "demanda", "generacion", "intercambios",
#' "transporte").
#' @param widget Defines what to retrieve.
#' @param start_date Date
#' @param end_date Date
#' @param time_trunc One of `c("hour", "day", "month", "year")`
#' @param geo_trunc Only accepts "electric_system".
#' @param region One of `c("peninsular", "canarias", "baleares", "ceuta",
#' "melilla")` or the official name of a CCAA (one of `get_ree_ccaa()`).
#' @param ... Other arguments passed to `httr2::req_url_query()`.
#'
#' @return
#' @export
#'
#' @examples
#' rc <- ree_call(start_date = as.Date("2018-01-01"),
#'                end_date = "2018-12-31T23:59",
#'                time_trunc = "month",
#'                region = "peninsular", lang = "en",
#'                category = "demanda", widget = "ire-general")
#' rc2 <- ree_call(category = "balance", widget = "balance-electrico",
#'                 start_date = "2022-12-31T23:59",
#'                 region = "peninsular", lang = "en", time_trunc = "day")
#' rc3 <- ree_call(lang = "es",
#'                 category = "generacion",
#'                 widget = "estructura-generacion",
#'                 start_date = "2014-01-01T00:00",
#'                 end_date = "2018-12-31T23:59",
#'                 time_trunc = "year",
#'                 geo_trunc = "electric_system",
#'                 region = "Castilla la Mancha")
ree_call <- function(category, widget,
                     start_date = end_date - 1,
                     end_date = Sys.Date(),
                     time_trunc = NULL,
                     geo_trunc = NULL,
                     region = "peninsular",
                     lang = "es",
                     parse = TRUE,
                     ...){
  path <- paste0(check_lang(lang), "/datos/", check_category(category), "/",
                 check_category_widget(category, widget))
  time_trunc <- match.arg(time_trunc, c("hour", "day", "month", "year"))
  start_date <- ree_date(start_date)
  end_date <- ree_date(end_date)
  region <- ree_region(region)
  if (!is.null(geo_trunc) && !geo_trunc == "electric_system") {
    stop("geo_trunc can only be used with")
  } else {
    geo_trunc <- "electric_system"
  }
  params <- list(start_date = start_date,
                 end_date = end_date,
                 time_trunc = time_trunc,
                 geo_trunc = geo_trunc,
                 geo_limit = region$geo_limit,
                 geo_ids = region$geo_id)
  resp <- req_perform(prep_ree(path, !!!params, ...))
  r <- resp_body_json(resp)

  if (isFALSE(parse)) {
    return(r)
  }

  values_all <- lapply(r$included, function(x){
    values <- do.call(rbind, lapply(x$attributes$values, list2DF))
    values$datetime <- gsub(":00$", "00", values$datetime)
    values$datetime <- as.POSIXct(strptime(values$datetime, "%FT%H:%M:%OS%z",
                                           tz = "Europe/Madrid"))
    attr(values, "updated") <- as.POSIXct(strptime(
      gsub(":00$", "00", x$attributes[["last-update"]]),
      "%FT%H:%M:%OS", tz = "Europe/Madrid"))
    attr(values, "title") <- x$attributes$title
    attr(values, "type") <- x$type
    values
  })

  attr(values_all, "description") <- r$data$attributes$description
  attr(values_all, "last-update") <- as.POSIXct(r$data$attributes$`last-update`, "%FT%H:%M:%OS%z")
  message("Last updated: ", format(attr(values_all, "last-update"), "%F %T %Z"))
  names(values_all) <- vapply(values_all, attr, which = "title", character(1L))
  values_all
}

#' Get all the CCAA available
#'
#' @return A vector with the regions
#' @export
#' @seealso [ree_call()]
#' @examples
#' get_ree_ccaa()
get_ree_ccaa <- function() {
  ree_geo$region[ree_geo$geo_limit == "ccaa"]
}
