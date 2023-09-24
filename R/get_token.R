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
    token <- Sys.getenv("ESIOS_TOKEN", NA_character_)
  }

  if (!is.character(token) || length(token) > 1 || nchar(token) < 10) {
    stop("Token should be a single element of at least 10 characters.")
  }

  if (is.na(token)) {
    stop("No token is provided and it couldn't find it as 'ESIOS_TOKEN'.")
  }
  .state$token <- token
  invisible(token)
}


