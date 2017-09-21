# *********** In-memory strategies ************
library(data.table)

brazil_zika <- fread("data/COES_Microcephaly-2016-06-25.csv")
head(brazil_zika, 2)
class(brazil_zika)

# reading in certain columns
fread("data/COES_Microcephaly-2016-06-25.csv",
      select = c("location", "value", "unit")) %>%
  dplyr::slice(1:3)

# A data.table object also has the class data.frame; 
# this means that you can use all of your usual methods for manipulating a data frame with a data.table object

# There are more details on profiling and optimizing code in a later chapter, but one strategy for speeding up R code is to write some of the code in C++ and connect it to R using the Rcpp package. 
# Since C++ is a compiled rather than an interpreted language, it runs much faster than similar code written in R. 

# Parallel computing: https://cran.r-project.org/web/views/HighPerformanceComputing.html



# *********** Out-of-memory strategies ************
# Use DBs
# The bigmemory and associated packages can be used to access and work with large matrices stored on hard drive rather than in RAM,
#   by storing the data in a C++ matrix structure and loading to R pointers to the data, rather than the full dataset. -> only work with matrices, not data frames
# For example, the h2o package allows you to write R code to load and fit machine learning models in H2O, 
#     which is open-source software that facilitates distributed machine learning. 
#   H2O includes functions to fit and evaluate numerous machine learning models, including ensemble models, 
#     which would take quite a while to fit within R with a large training dataset. 
#   Since processing is done using compiled code, models can be fit on large datasets more quickly. 
#   However, while the h2o package allows you to use R-like code from within an R console to explore and model your data, it is not actually running R, 
#     but instead is using the R code, through the R API, to run Java-encoded functions. 
#   As a result, you only have access to a small subset of R’s total functionality, since you can only run the R-like functions written into H2O’s own software.
