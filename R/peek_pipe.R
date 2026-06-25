#' Peek in a pipe sequence
#'
#' A convenience function for viewing the intermediate results in a piped sequence without interrupting the pipe.
#'
#' @param x an **R** object, typically a data frame.
#' @param view A character value selecting either `"glimpse"`, `"str"`, or `"print"`. Defaults to `"glimpse"`.
#'
#' @returns Blah
#'
#' @examples
#' mtcars |>
#'   peek_pipe() |>
#'   dplyr::mutate(double_mpg = mpg * 2) |>
#'   peek_pipe() |>
#'   dplyr::select(mpg, double_mpg, cyl) |>
#'   peek_pipe() |>
#'   dplyr::arrange(mpg) |>
#'   head()
#'
#' @export
peek_pipe <- function(x, view = glimpse, ...) {
  view_str <- rlang::as_string(rlang::ensym(view)) # for quoted or unquoted
  if (view_str == "str") {
    str(x, ...)
  } else if (view_str == "print") {
    print(x, ...)
  } else {
    dplyr::glimpse(x, ...)
  }
  cat("\n")
  invisible(x)
}

# peek_pipe <- function(x, view = c("glimpse", "str", "print")[1], ...) {
#   if (view == "str") {
#     str(x, ...)
#   } else if (view == "print") {
#     print(x, ...)
#   } else {
#     dplyr::glimpse(x, ...)
#   }
#   cat("\n")
#   invisible(x) # return x invisibly, to continue in pipe
# }

