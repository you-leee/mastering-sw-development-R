# *********** Text manupulation ************
paste("Square", "Circle", "Triangle")
paste("Square", "Circle", "Triangle", sep = "+")

# Add vector of strings to paste as argument
shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes)

two_cities <- c("best", "worst")
paste("It was the", two_cities, "of times.")

# Collapse strings into 1
paste(shapes, collapse = " ")

# Num of characters
nchar("Supercalifragilisticexpialidocious")

# Lower uppercase
cases <- c("CAPS", "low", "Title")
tolower(cases)

toupper(cases)


# *********** Regular exressions ************
# The grepl() function: grep logical -> search within a text with a regex -> ret True/False
regular_expression <- "a"
string_to_search <- "Maryland"

grepl(regular_expression, string_to_search)

regular_expression <- "u"
grepl(regular_expression, string_to_search)

grepl("land", "Maryland")
grepl("Marly", "Maryland")

# Let’s build a regular expression for identifying names of states that both start and end with a vowel
head(state.name, 20)
vowels <- "aeiouyAEIOUY"
regular_expression <- paste0("^[", vowels, "].*[", vowels, "]$")
vowel.state <- grepl(regular_expression, state.name)
state.name[vowel.state]


# *********** Regex functions in R ************
#  grep() function -> returns the indices of the vector that match the regex:
grep("[Ii]", c("Hawaii", "Illinois", "Kentucky"))

# sub() function takes as arguments a regex, a “replacement,” and a vector of strings
sub("[Ii]", "l", c("Hawaii", "Illinois", "Kentucky"))

# gsub() function is nearly the same as sub() except it will replace every instance of the regex that is matched 
gsub("[Ii]", "l", c("Hawaii", "Illinois", "Kentucky"))

# strsplit() function will split up strings according to the provided regex
two_s <- state.name[grep("ss", state.name)]
strsplit(two_s, "ss")


# *********** The stringr package ************
library(stringr)
state_tbl <- paste(state.name, state.area, state.abb)
head(state_tbl)

# str_extract() function returns the sub-string of a string that matches the providied regular expression
str_extract(state_tbl, "[0-9]+")

# str_order() function returns a numeric vector that corresponds to the alphabetical order of the strings
str_order(state.abb)

# str_pad() function pads strings with other characters
str_pad("Thai", width = 8, side = "left", pad = "-")
str_pad("Thai", width = 7, side = "both", pad = "-")

# str_to_title() function acts just like tolower() andtoupper() except it puts strings into Title Case
str_to_title(cases)

# str_trim() function deletes whitespace from both sides of a string.
to_trim <- c("   space", "the    ", "    final frontier  ")
str_trim(to_trim)

# str_wrap() function inserts newlines in strings so that when the string is printed each line’s length is limited
pasted_states <- paste(state.name[1:20], collapse = " ")
cat(str_wrap(pasted_states, width = 40))

# word() function allows you to index each word in a string as if it were a vector
a_tale <- "It was the best of times it was the worst of times it was the age of wisdom it was the age of foolishness"
word(a_tale, 2)
word(a_tale, end = 3)
word(a_tale, start = 2, end = 13)
