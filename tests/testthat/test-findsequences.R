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

test_that("long sequences can be found continuous", {

  wind <- 123

  x <- rep(1, wind)
  x <- c(rep(0, wind*3), x)

  y <- find_sequences(x, window = wind, continuous = TRUE)

  y_ <- rep(0,length(x))

  min_x <- min(which(x==1))
  y_[min_x] <- 1

  expect_equal(y, y_)
})

test_that("very long sequences can be found continuous", {

  wind <- 12345

  x <- rep(1, wind)
  x <- c(rep(0, wind*3), x)

  y <- find_sequences(x, window = wind, continuous = TRUE)

  y_ <- rep(0,length(x))

  min_x <- min(which(x==1))
  y_[min_x] <- 1

  expect_equal(y, y_)
})


test_that("large windows are accurate", {

  wind <- 123

  x <- rep(1, wind)
  x <- c(rep(0, wind*3), x)
  x[length(x)] <- 0

  y <- find_sequences(x, window = wind, continuous = TRUE)

  y_ <- rep(0,length(x))

  expect_equal(y, y_)
})

test_that("very large windows are accurate", {

  wind <- 12345

  x <- rep(1, wind)
  x <- c(rep(0, wind*3), x)
  x[length(x)] <- 0

  y <- find_sequences(x, window = wind, continuous = TRUE)

  y_ <- rep(0,length(x))

  expect_equal(y, y_)
})
