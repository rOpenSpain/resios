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
