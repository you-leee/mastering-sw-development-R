library(purrr)
library(dplyr)

dataset <- 8:1e4
first_7 <- data.frame(num = 1:7, prime = c(T, T, T, F, T, F, T))

is_prime <- function(x) {
  x%%2 != 0 && x%%3 != 0 && x%%5 != 0 && x%%7 != 0
}

dataset <- data.frame(num = dataset, prime = map(dataset, is_prime) %>% unlist)
dataset <- rbind(first_7, dataset)

density_10 <- dataset %>%
  mutate(group = ceiling(num/10)) %>%
  group_by(group) %>%
  summarise(prime_count = sum(prime)) %>%
  ungroup


square_range <- function(x) {
  range <- x:x^2
}


density_140 <- density_10 %>%
  mutate(eq_group = ceiling(group/14)) %>%
  group_by(eq_group) %>%
  summarise(prime_count = sum(prime_count)) %>%
  ungroup
