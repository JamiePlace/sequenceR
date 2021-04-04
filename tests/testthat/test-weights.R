test_that("weights work continuous", {

  w <- .generate_weights(window = 5, continuous = TRUE)

  expect_equal(w, c(1/5,1/5,1/5,1/5,1/5))
})

test_that("weights work non-continuous", {

  w <- .generate_weights(window = 5, continuous = FALSE, required_pad = 1)

  expect_equal(w, c(1/2,0,0,0,1/2))
})

test_that("weights work non-continuous", {

  w <- .generate_weights(window = 5, continuous = FALSE, required_pad = 2)

  expect_equal(w, c(1/4,1/4,0,1/4,1/4))
})

test_that("weights work long continuous", {

  w <- .generate_weights(window = 243, continuous = TRUE)

  demo_w <- rep(1, 243)/243

  expect_equal(w, demo_w)
})
