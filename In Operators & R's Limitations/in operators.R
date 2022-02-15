if(!require(pryr)) install.packages("pryr")

# How to use %in%
"grape" %in% c("banana", "orange", "grape")
"apple" %in% c("banana", "orange", "grape")
c("grape", "apple") %in% c("banana", "orange", "grape")




# %in% checks for SCALAR in LIST
body(`%in%`)
body(match)
?.Internal
pryr::show_c_source(.Internal(match()))


# You could equivalently say any(LIST == SCALAR):
`%any_in%` <- function(scalar, vector) any(vector == scalar)
`%sum_in%` <- function(scalar, vector) sum(vector == scalar) != 0L





# The Test --------------------------------------------------------------------
greetings <- c("hi", "hello", "hey", "bonjour", "ciao", "salut", "gutenberg bible")
scalar <- "felicitations"

# Different inputs to test
input_vectors <- list(
  vec_with_match_at_beginning = c(scalar, rep(greetings, times = 300000)),
  vec_with_match_in_middle = c(rep(greetings, times = 150000), scalar, rep(greetings, times = 150000)),
  vec_with_match_at_end = c(rep(greetings, times = 300000), scalar),
  vec_with_no_match = rep(greetings, times = 300000)
)

# This may take up to five minutes to run
benchmark_results <- vector("list", 4)
names(benchmark_results) <- names(input_vectors)
for(test in names(input_vectors)){
  benchmark_results[[test]] <- bench::mark(
    base = scalar %in% input_vectors[[test]],
    any_in = scalar %any_in% input_vectors[[test]],
    sum_in = scalar %sum_in% input_vectors[[test]],
    
    check = TRUE, iterations = 100, time_unit = "ms"
  )
}
benchmark_results



# We cannot speed up LIST == VECTOR in R
c("banana", "orange", "grape") == "apple"
c("banana", "orange", "grape", "apple") == "apple"
c("apple", "banana", "orange", "grape", "apple") == "apple"


as.logical(c(55, 0, -1, 1))
as.integer(c(TRUE, FALSE, FALSE, TRUE))
