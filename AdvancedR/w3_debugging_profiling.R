# Debugging in R is facilitated with the functions browser,debug, trace, recover, and traceback.

check_n_value <- function(n) {
  if( n > 0 ) {
    #browser()
    stop("n should be <= 0")
  }
}

error_if_n_is_pos <- function(n) {
  check_n_value(n)
}

error_if_n_is_pos(2)

trace("check_n_value")
error_if_n_is_pos(2)

as.list(body(check_n_value))
as.list(body(check_n_value)[[2]])
trace("check_n_value", browser, at = list(c(2, 3)))
check_n_value
body(check_n_value)

trace("check_n_value", quote({
  if(n == 5) {
    message("invoking the browser")
    browser()
  }
}), at = 2)
body(check_n_value)
check_n_value(5)


trace("glm", browser, at = 4, where = asNamespace("stats"))
body(stats::glm)


debug(lm)
undebug(lm)


options(error = recover)
error_if_n_is_pos(5)


# Profiling can help you identify bottlenecks in R code.
library(microbenchmark)
library(dplyr)

microbenchmark(a <- rnorm(1000), 
               b <- mean(rnorm(1000)))

find_hot_records_1 <- function(dataset, thresh) {
  hottest <- dataset$temp[1]
  is_hot <- c()
  for(i in 1:nrow(dataset)) {
    next_temp <- dataset$temp[i]
    is_hot <- c(is_hot, next_temp >= thresh && next_temp >= hottest)
    hottest <- max(hottest, next_temp)
  }
  
  dataset$record_temp <- is_hot
  dataset
}

find_hot_records_2 <- function(datafr, threshold){
  datafr <- datafr %>%
    mutate_(over_threshold = ~ temp >= threshold,
            cummax_temp = ~ temp == cummax(temp),
            record_temp = ~ over_threshold & cummax_temp) %>%
    select_(.dots = c("-over_threshold", "-cummax_temp"))
  return(as.data.frame(datafr))
}

example_data <- data.frame(date = c("2015-07-01", "2015-07-02",
                                    "2015-07-03", "2015-07-04",
                                    "2015-07-05", "2015-07-06",
                                    "2015-07-07", "2015-07-08"),
                           temp = c(26.5, 27.2, 28.0, 26.9, 
                                    27.5, 25.9, 28.0, 28.2))

test1 <- find_hot_records_1(example_data, 27)
test2 <- find_hot_records_2(example_data, 27)
all.equal(test1, test2)


record_temp_perf <- microbenchmark(find_hot_records_1(example_data, 27), 
                                   find_hot_records_2(example_data, 27))
record_temp_perf

library(dlnm)
data("chicagoNMMAPS")
record_temp_perf2 <- microbenchmark(find_hot_records_1(chicagoNMMAPS, 27), 
                                   find_hot_records_2(chicagoNMMAPS, 27))
record_temp_perf2

library(ggplot2)
autoplot(record_temp_perf2)
