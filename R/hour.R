extract_hour <- function(text) {
  g <- gregexec("([[:digit:]]+(:[[:digit:]]+)?)", text, perl = TRUE)
  hours <- regmatches(text, g)
  for (i in seq_along(hours)) {
    hour <- hours[[i]]
    if (length(hour) == 0) {
      am <- NA
      hours[[i]] <- am
    } else {
      am <- hour[1, which(nchar(hour[1, ]) >= 3 & grepl(":", hour[1, ], fixed = TRUE))[1]]
      hours[[i]] <- am
    }

    if (length(am) != 0)  {
      next
    }

    if (NCOL(hour) > 1 && hour[1, NCOL(hour)] == "1") {
      am <- hour[1, NCOL(hour) - 1]
    } else if (NCOL(hour) > 1 && hour[1, NCOL(hour)] != "1") {
      am <- hour[1, NCOL(hour)]
    } else if (NCOL(hour) == 1) {
      am <- hour[1, 1]
    }

    # Some minutes might have slipped through
    if (nchar(am) == 2 && as.numeric(am) > 24) {
      am <- NA
    }
    if (!is.na(am) && nchar(am) > 2 && !grepl(":", am, fixed = TRUE)) {
      am <- NA
    }
    if (!is.na(am) && !nzchar(am)) {
      am <- NA
    }
    hours[[i]] <- am
  }
  hours <- unlist(hours, FALSE, FALSE)
  hours[!grep(":", hours, fixed = TRUE)] <- NA
  nr <- nchar(hours)
  # Have uniform formatting HH:MM
  hours[!is.na(nr) & nr == 1] <- paste0("0",hours[!is.na(nr) & nr == 1], ":00")
  hours[!is.na(nr) & nr == 2] <- paste0(hours[!is.na(nr) & nr == 2], ":00")
  hours[!is.na(nr) & nr == 4] <- paste0("0", hours[!is.na(nr) & nr == 4])
  stopifnot(length(text) == length(hours))
  hours
}
