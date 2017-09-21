# *********** The Role of Physical Memory ************
library(pryr)
# how much memory your current R session is using
mem_used()

ls()
# object_size() function will print the number of bytes (or kilobytes, or megabytes) that a given object is using in your R session
object_size(state_tbl)

# largest 5 objects in your workspace
library(magrittr)
sapply(ls(), function(x) object_size(get(x))) %>% sort %>% tail(5)


rm(state_tbl)
mem_used()

mem_change(rm(pasted_states, two_s))


# *********** Back of the Envelope Calculations ************
# When reading in large datasets or creating large R objects, it’s often useful to do a back of the envelope calculation 
# of how much memory the object will occupy in the R session (ideally before creating the object).
# - integers are 32 bits (4 bytes)
# - double-precision floating point numbers (numerics in R) are 64 bits (8 bytes)
# - character data are usually 1 byte per character

# integer vector is roughly 4 bytes times the number of elements
object_size(integer(0))
object_size(integer(1000))
object_size(numeric(1000))  ## 8 bytes per numeric


# If you are reading in tabular data of integers and floating point numbers, you can roughly estimate the memory requirements for that table
# by multiplying the number of rows by the memory required for each of the columns.

# how your computer/operation system stores different types of data
str(.Machine)


# *********** Internal Memory Management************
# R will periodically cycle through all of the objects that have been created and see if there are still any references to the object somewhere in the session.
# If there are no references, the object is garbage-collected and the memory returned
gc()

