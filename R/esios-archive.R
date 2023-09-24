
#' Retrieve archives from ESIOS
#'
#' Check which archives are available.
#' @return A data.frame with the information of what is available and where.
#' @export
#' @examples
#' \donttest{
#' archives <- esios_archives()
#' }
esios_archives <- function() {
  arch <- req_perform(prep_esios("archives"))
  out <- resp_body_json(arch)
  resp <- as.data.frame(t(list2DF(out$archives)))
  colnames(resp) <- names(out$archives[[1]])
  out <- resp[, 1:4]

  download <- do.call(rbind, lapply(resp$download, list2DF))
  download$url <- paste("https://esios", download$url)
  colnames(download) <- paste0("download.", colnames(download))
  out <- cbind(out, download)
  out$date <- unlist(resp$date)

  out$date_time1 <- sapply(resp$date_times, function(x){
    if (length(x) >= 1) x[[1]] else {NA}})
  out$date_time2 <- sapply(resp$date_times, function(x){
    if (length(x) > 1) x[[2]] else {NA}})
  out$publication_date <- sapply(resp$publication_date, function(x){min(unlist(x, FALSE, FALSE))})
  out$taxonomy_terms <- lapply(seq_len(NROW(resp)), function(x) {
                           do.call(rbind, lapply(resp$taxonomy_terms[[x]], list2DF))
    })
  out$name <- unlist(out$name, FALSE, FALSE)
  out$id <- unlist(out$id, FALSE, FALSE)
  out$horizon <- unlist(out$horizon, FALSE, FALSE)
  out$archive_type <- unlist(out$archive_type, FALSE, FALSE)
  out$date <- strptime(out$date, format = "%Y-%m-%dT%H:%M:%OS")
  out$date_time1 <- strptime(out$date_time1, format = "%Y-%m-%d")
  out$date_time2 <- strptime(out$date_time2, format = "%Y-%m-%d")

  rownames(out) <- NULL
  out

}
