test_that("sequences can be found continuous", {

  x <- c(0,0,1,1,1,0,0,1,1,1)
  y <- find_sequences(x, window = 3)

  expect_equal(y, c(0,0,1,0,0,0,0,1,0,0))
})

test_that("sequences can be found non-continuous", {

  x <- c(0,0,1,1,1,0,1,1,1)
  y <- find_sequences(x, window = 3, continuous = FALSE, required_pad = 1)

  expect_equal(y, c(0,0,1,0,1,0,1,0,0))
})
