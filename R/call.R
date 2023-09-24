# <https://api.esios.ree.es/doc/index.html>
prep_esios <- function(path, ..., token = NULL) {
  token <- get_token(token)
  accept <- c("application/json",
              "application/vnd.esios-api-v2+json",
              "application/vnd.esios-api-v1+json")
  request("https://api.esios.ree.es") |>
    req_user_agent(agent) |>
    req_url_path_append(path) |>
    req_url_query(...) |>
    req_method("GET") |>
    req_headers(
      Accept = paste0(accept, collapse = "; "),
      `x-api-key` = token
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
    req_throttle(10 / 60)
}
