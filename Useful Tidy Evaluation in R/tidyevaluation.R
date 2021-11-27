# Packages ---------------------------------------------------------------
library(rlang)
library(ggplot2)


# Regular Code -----------------------------------------------------------
# Normally, R code is evaluated as soon as the interpreter sees it:
2 - 99


# Quoting Code -----------------------------------------------------------
# What if we want to save the code for evaluation in the future?
# We instead quote the code to defuse it
# (defuse, capture, delay, and suspend are all synonymous)

# There are two cases for quoting code:
#
#     Function parameters
#
#     Everything else
#
# To quote function parameters, use rlang::enexpr()
# To quote everything else, use rlang::expr()
rlang::expr(2 - 99)

f <- function(param){
  # use enexpr() for function parameters
  my_expression <- rlang::enexpr(param)
  
  # use expr() for everything else--even within functions
  my_other_expression <- expr(2 - 99)
  
  return(my_expression)
}


# Evaluating Quoted Code -------------------------------------------------
# When we are ready to evaluate our expressions, we simply
# use rlang::eval_tidy()
#
# eval_tidy() has three arguments:
#
#
# `expr =`, which is the input expression
#
# `data =`, which allows you to evaluate an expression
#           on a data structure, such as a data frame
#
# `env =`,  which denotes the environment where the data
#           or expression should be evaluated (defaults
#           to the global environment)
df <- data.frame(x = 1:5,
                 y = -(1:5),
                 z = 1001:1005)
x <- 1:5
y <- 1:5
z <- seq(.1, .5, by = .1)
my_expression <- expr(x * y)


# Uses the x and y vectors in the global environment
eval_tidy(expr = my_expression)

# Uses the x and y columns in the data frame `df` (`df` is also
# stored in the global environment)
eval_tidy(expr = my_expression, data = df)

# We can use variables from both:
# (be sure to specify where the data is coming from with `.data` and `.env`)
#
# Multiplies column y from `df` by the vector z from the global environment
another_expression <- expr(.data[["y"]] * .env[["z"]])
eval_tidy(expr = another_expression, data = df, env = global_env())


# The Quote and Unquote Pattern ------------------------------------------
# If you want to pass a value stored in a variable to a function, you use
# the bang-bang operator, !!, on an expression wrapped in a second expression.
g <- function(df, x, y, geom){
  x_expression <- enexpr(x)
  y_expression <- enexpr(y)
  geom_expression <- enexpr(geom)
  
  # x and y as character strings
  x_varname <- expr_text(x_expression)
  y_varname <- expr_text(y_expression)
  
  
  plot_expr <- expr(
    ggplot(df) +
      (!!geom_expression)(mapping = aes(x = !!x_expression,
                                        y = !!y_expression)) +
      xlab(x_varname) +
      ylab(y_varname)
  )
  
  eval_tidy(plot_expr)
}

g(df = iris, x = Sepal.Length, y = Sepal.Width, geom = geom_point)