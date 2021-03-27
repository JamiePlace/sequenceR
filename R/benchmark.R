library(microbenchmark)
library(sequenceR)
source('R/test_code.R')

x <- sample(c(0,1), size = 1e7, replace = TRUE)

mbm <- microbenchmark("package" = { a <- find_sequences(x, window = 3)},
                      "new_algo" = { a <- test_conv(x)})
