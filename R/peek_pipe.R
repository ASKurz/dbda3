#' Peek in a pipe sequence
#'
#' A convenience function for viewing the intermediate results in a piped sequence without interrupting the pipe.
#'
#' @param x an **R** object, typically a data frame.
#' @param view Either `glimpse`, `str`, or `print` (quoted or unquoted, via non-standard evaluation), selecting which function is used to display `x`. Defaults to `glimpse`.
#' @param ... Additional arguments passed to the function selected by `view` (i.e., `dplyr::glimpse()`, `str()`, or `print()`).
#'
#' @returns `x`, unchanged and invisibly. As a side effect, `peek_pipe()` prints a view of `x` to the console (via `dplyr::glimpse()`, `str()`, or `print()`, depending on `view`), followed by a blank line, before returning.
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
#' @importFrom rlang as_string ensym
#' @importFrom utils str
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

