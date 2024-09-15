#' Get ESIOS token
#'
#' To get a token you need to ask for it.
#'
#' @param token The character string as a token
#'
#' @return Invisible the token
#' @export
#' @examples
#' token <- get_token("aahdahgagdadfsafd")
get_token <- function(token = NULL) {
  if (is.null(token)) {
    token <- check_token()
  }

  if (is.na(token)) {
    stop("No token is provided and it couldn't find it as 'ESIOS_TOKEN'.")
  }

  if (!is.character(token) || length(token) > 1 || nchar(token) < 10) {
    stop("Token should be a single element of at least 10 characters.")
  }

  .state$token <- token
  invisible(token)
}


check_token <- function() {
  Sys.getenv("ESIOS_TOKEN", NA_character_)
}


there_is_token <- function(token = NULL) {
  !is.na(get_token(token))
}
