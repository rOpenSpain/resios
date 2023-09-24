
#' List ESIOS indicators
#'
#' Find which indicators are available.
#' @param text Text to search indicators
#' @param taxonomy_terms Terms of indicators
#' @param taxonomy_ids Ids of the indicators
#'
#' @return A data.frame with four columns: name, description, short_name and id.
#' @export
#' @seealso [esios_indicators()]
#' @examples
#' \donttest{
#' ei <- esios_search_indicators()
#' mercados <- esios_search_indicators(text = "Mercados y precios")
#' }
esios_search_indicators <- function(text = NULL, taxonomy_terms = NULL, taxonomy_ids = NULL) {
  check_taxonomy_ids(taxonomy_ids)
  check_taxonomy_terms(taxonomy_terms)
  ind <- prep_esios("indicators",
                    text = text,
                    taxonomy_terms = taxonomy_terms,
                    taxonomy_ids = taxonomy_ids) |>
    req_perform()
  out <- resp_body_json(ind)
  indic <- do.call(rbind, lapply(out$indicators, list2DF))
  # Extract hour from the text
  s <- strsplit(indic$description, split = "Publicaci(&oacute;|\u00F3)n:")
  v <- mapply(getElement, s, lengths(s))
  r <- extract_hour(v)

  if (length(r) != NROW(indic)) {
    browser()
  }
  indic$renew <- r
  indic
}


#' Retrieve an indicator
#'
#' Retrieve the information of any indicator based on the id.
#' @param indicator ID code for an indicator
#' @param locale Get translations for sources (es, en). Default language: es
#' @param datetime A certain date to filter values by (iso8601 format)
#' @param start_date Beginning of the date range to filter indicator values
#' (iso8601 format)
#' @param end_date End of the date range to filter indicator values
#'  (iso8601 format)
#' @param time_agg How to aggregate indicator values when grouping them by time.
#' Accepted values: 'sum', 'average'. Default value: 'sum'.
#' @param time_trunc Tells the API how to trunc data time series. Accepted
#' values: 'five_minutes', 'ten_minutes', 'fifteen_minutes', 'hour', 'day', 'month', 'year'.
#' @param geo_agg How to aggregate indicator values when grouping them by geo_id.
#'  Accepted values: 'sum', 'average'. Default value: 'sum'.
#' @param geo_ids Tells the API the geo ids to filter the date.
#' @param geo_trunc Tells the API how to group data at geolocalization level
#' when the geo_agg is informed. Accepted values: 'country', 'electric_system',
#' 'autonomous_community', 'province', 'electric_subsystem', 'town' and
#' 'drainage_basin'.
#' @export
#' @seealso [esios_search_indicators()]
#' @references <https://api.esios.ree.es/>
#' @examples
#' \donttest{
#' ei10001 <- esios_indicators(10001)
#' ei1700 <- esios_indicators(1700)
#' }
esios_indicators <- function(indicator, locale = NULL, datetime = NULL,
                             start_date =  NULL, end_date =  NULL,
                             time_agg = NULL, time_trunc = NULL, geo_agg = NULL,
                             geo_ids = NULL, geo_trunc = NULL) {
  stopifnot((is.numeric(indicator) || is.character(indicator)) &&
              length(indicator) == 1 && !is.na(indicator))
  path <- paste0("indicators/", indicator)
  resp <- prep_esios(path,
                     locale = locale,
                     datetime = datetime,
                     start_date = start_date,
                     end_date = end_date,
                     time_agg = time_agg,
                     time_trunc = time_trunc,
                     geo_agg = geo_agg,
                     `geo_ids[ ]` = geo_ids,
                     geo_trunc = geo_trunc) |>
    req_perform()
  resp_body_json(resp)
}


#' Prediction of electricity prices using indicator 1001
#'
#' This is a shortcut for `esios_indicators("1001")` with some parsing.
#'
#' @inheritParams esios_indicators
#'
#' @return A data.frame with value ( €/MWh), datetime, datetime_utc, tz_time,
#' geo_id and geo_name.
#' @seealso [esios_indicators()]
#' @export
#' @examples
#' e <- esios_pvp()
esios_pvp <- function(locale = NULL, datetime = NULL,
                      start_date =  NULL, end_date =  NULL,
                      time_agg = NULL, time_trunc = NULL, geo_agg = NULL,
                      geo_ids = NULL, geo_trunc = NULL) {
  out <- esios_indicators(indicator = "1001",
                          locale = locale,
                          datetime = datetime,
                          start_date = start_date,
                          end_date = end_date,
                          time_agg = time_agg,
                          time_trunc = time_trunc,
                          geo_agg = geo_agg,
                          geo_ids = geo_ids,
                          geo_trunc = geo_trunc)
  val <- do.call(rbind, lapply(out$indicator$values, list2DF))
  if ("datetime" %in% colnames(val)) {
    # Assumes that it is in the right locale and timezone
    val$datetime <- as.POSIXct(strptime(val$datetime,
                                        format = "%Y-%m-%dT%H:%M:%OS"))}
  if ("datetime_utc" %in% colnames(val)) {
    val$datetime_utc <- as.POSIXct(strptime(val$datetime_utc,
                                            tz = "UTC", format = "%Y-%m-%dT%H:%M:%SZ"))
  }
  if ("tz_time" %in% colnames(val)) {
    val$tz_time <- as.POSIXct(strptime(val$tz_time,
                                       tz = "Europe/Madrid", format = "%Y-%m-%dT%H:%M:%OSZ"))
  }
  val
}
