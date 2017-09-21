# Error handling
# error: stop(), warning: warning(), message: message()
# stopifnot(logical expression(s))
sqrt2 <- function(x) {
  stopifnot(x >= 0)
  sqrt(x)
}
sqrt2(-1)
sqrt2(0)

# handling errors: tryCatch()
beera <- function(expr) {
  tryCatch(expr,
           error = function(e) {
             message("An error occurred:\n", e)
           },
           warning = function(w) {
             message("A warning occurred:\n", w)
           },
           finally = {
             message("Finally done!")
           })
}

beera(sqrt(-1))
beera(2 + 2)
beera("2" + "2")

# Limit number of errors generated and try-catch-es. For example:
is_even_error <- function(n) {
  tryCatch(n%%2 == 0,
           error = function(e) {
             FALSE
           })
}

is_even_check <- function(n) {
  is.numeric(n) && n%%2 == 0
}

library(microbenchmark)
microbenchmark(sapply(letters, is_even_error), unit = "ms")
microbenchmark(sapply(letters, is_even_check), unit = "ms")
