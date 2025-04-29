# <https://api.esios.ree.es/doc/index.html>
prep_esios <- function(path, ..., token = NULL) {
  token <- get_token(token)
  if (!there_is_token(token)) {
    return(FALSE)
    warning("No token available")
  }
  accept <- c("application/json",
              "application/vnd.esios-api-v2+json",
              "application/vnd.esios-api-v1+json")
  request("https://api.esios.ree.es") |>
    req_user_agent(agent) |>
    req_url_path_append(path) |>
    req_url_query(...) |>
    req_method("GET") |>
    req_error(body = esios_error) |>
    req_headers(
      Accept = paste0(accept, collapse = "; "),
      `Content-Type` = "application/json",
      `x-api-key` = token,
      .redact = "x-api-key"
    ) |>
    req_throttle(10 / 60)
}

# <https://www.ree.es/en/apidatos>
prep_ree <- function(path, ...) {
  request("https://apidatos.ree.es") |>
    req_user_agent(agent) |>
    req_url_query(...) |>
    req_url_path_append(path) |>
    req_method("GET") |>
    req_headers(Accept = "application/json;",
                `Content-Type` = "application/json") |>
    req_error(body = ree_error) |>
    req_throttle(10 / 60)
}

ree_error <- function(resp) {

  type <- resp_content_type(resp)
  if (identical(type, "text/html")) {
    errors <- resp_body_html(resp)

    if (requireNamespace("xml2", quietly = TRUE)) {
      body <- xml2::xml_find_all(errors, xpath = "body/div/p")
      errors_msg <- paste0(trimws(xml2::xml_text(body)))
    }
    return(errors_msg)
  }
  errors <- resp_body_json(resp)$errors
  errors_msgs <- vapply(errors, function(x) {
    paste0(x["title"], " (", x["code"], "): ", x["detail"])
  }, character(1L))
  errors_msgs
}

esios_error <- function(resp) {
  errors <- resp_body_json(resp)$errors
  errors_msgs <- vapply(errors, function(x) {
    paste0(x["title"], " (", x["code"], "): ", x["detail"])
  }, character(1L))
  errors_msgs
}
