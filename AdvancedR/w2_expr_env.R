# Expressions: use quote() and eval()
two_plus_two <- quote(2 + 2)
two_plus_two
eval(two_plus_two)

tpt_string <- "2 + 2"
eval(parse(text = tpt_string))


sum_expr <- quote(sum(1, 5))
sum_expr[[1]]
sum_expr[[2]]
sum_expr[[3]] <- 1
eval(sum_expr)

# call()
sum_40_50_expr <- call("sum", 40, 50)
eval(sum_40_50_expr)

# capture the the expression an R user typed into the R console when they executed a function 
# by including match.call() in the function the user executed
return_expression <- function(...){
  match.call()
}
return_expression(2, col = "blue", FALSE)

first_arg <- function(...) {
  expr <- match.call()
  first_arg <- eval(expr[[2]])
  
  if(is.numeric(first_arg)) {
    paste0("The first argument is ", first_arg, ".")
  } else {
    "The first argument is not numeric."
  }
}

first_arg(1, "asd")
first_arg("asd", "asd")



# Envs: create, assign, get
my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x

assign("y", 9, envir = my_new_env)
get("y", envir = my_new_env)

# get all and remove
ls(my_new_env)
rm(x,envir = my_new_env)
exists("x", envir = my_new_env)

# Env: parent-child structure: child knows parent. get parents:
search()

library(ggplot2)
search()


# Execution env: exists temporarily within the scope of a function that is being executed
x <- 10
my_func <- function(){
  x <- 5
  return(x)
}
my_func()

# Complex operator(<<-): assign values to variables in parent envs (if not found, it will be created in global env) 
x <- 10
x

assign1 <- function(){
  x <<- "Wow!"
}

assign1()
x