library(purrr)
library(dplyr)

# Map
map_chr(c(1,2,3,4,5), function(num) {
 c("egy", "ketto", "harom", "negy", "ot")[num] 
})

1:15 %>% 
  map_if(.%%2 == 0, 
         ~.^2) %>% 
  unlist

1:15 %>%
  map_at(5:length(.),
         ~.-20) %>% 
  unlist

map2_chr(letters, 1:26, ~ paste(.x, .y, sep = "-"))

pmap_chr(list(
  list(1, 2, 3),
  list("one", "two", "three"),
  list("uno", "dos", "tres")
), paste)


# Reduce
adder <- function(x, y) x + y
reduce(1:10, adder)
concatenater <- function(a, b) paste0(a, b)
reduce(letters, concatenater)
reduce_right(letters, concatenater)


# Search
purrr::contains(letters, "a")
detect_index(letters, function(letter) letter == "j")
detect(20:40, function(x) {
  x%%2 == 0 & x%%3 == 0 & x%%5 == 0
})


# Filter
keep(20:40, function(x) {
  x%%2 == 0 & x%%3 == 0 & x > 25
})
discard(10:100, function(x) {
  x%%5 == 0 | x%%3 == 0 | x%%2 == 0 | x%%7 == 0
})
every(seq(10, 100, by = 10), function(x) {
  x%%10 == 0
})


# Compose: compose function of functions
n_unique <- compose(length, unique)   # n_unique <- function(x){
                                      #   length(unique(x))
                                      # }
n_unique(c(1:10, 5:10, 2:11))


# Partial application
mult_three_n <- function(x, y, z) {
    x * y * z
}
mult_by_5 <- partial(mult_three_n, x = 1, y = 5)
mult_by_15(4)


# Walk (like map)
walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,", 
       "not to praise him."), message)


# Recursion
vector_sum <- function(xs) {
  l <- length(xs)
  inner_sum <- function(acc, i) {
    if(i == 0) {
      acc
    } else {
      inner_sum(xs[i] + acc, i - 1)
    }
  }
  
  inner_sum(0, l)
}

fib <- function(n) {
  stopifnot(n > 0)
  if(n == 1) {
    0
  } else if(n == 2){
    1
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

fib_tbl <- c(0, 1, rep(NA, 50))

fib_mem <- function(n){
  stopifnot(n > 0)
  
  if(!is.na(fib_tbl[n])){
    fib_tbl[n]
  } else {
    fib_tbl[n - 1] <<- fib_mem(n - 1)
    fib_tbl[n - 2] <<- fib_mem(n - 2)
    fib_tbl[n - 1] + fib_tbl[n - 2]
  }
}

# Compare memorized and simply fib function
library(microbenchmark)
library(tidyr)

fib_data <- map(1:10, function(x){microbenchmark(fib(x), times = 100)$time})
names(fib_data) <- paste0(letters[1:10], 1:10)
fib_data <- as.data.frame(fib_data)

fib_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = mean(time/1000))

memo_data <- map(1:10, function(x){microbenchmark(fib_mem(x))$time})
names(memo_data) <- paste0(letters[1:10], 1:10)
memo_data <- as.data.frame(memo_data)

memo_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = mean(time/1000))

plot(1:10, fib_data$med_time, xlab = "Fibonacci Number", ylab = "Median Time (Microseconds)",
     pch = 18, bty = "n", xaxt = "n", yaxt = "n")
axis(1, at = 1:10)
axis(2, at = seq(0, 350000, by = 50000))
points(1:10 + .1, memo_data$med_time, col = "blue", pch = 18)
legend(1, 300000, c("Not Memorized", "Memoized"), pch = 18, 
       col = c("black", "blue"), bty = "n", cex = 1, y.intersp = 1.5)