test_conv <- function(x){
  window <- 3

  weights <- torch::torch_ones(c(window,1,1,window), requires_grad = FALSE)/window

  x_ <- torch::torch_zeros(c(1,  window, 1, length(x)))

  for (i in 1:window){
    a <- length(x)-i+1
    x_[, i, , 1:a] <- x[i:length(x)]
  }

  x1 <- torch::nnf_conv2d(input = x_, weight = weights, stride = window, groups = 3)

  x1$squeeze_()
  x1$add_(0.0001)
  x1$floor_()

  accessible_times <- torch::torch_zeros(length(x), requires_grad = FALSE)

  pos <- .accessible_pos(x1, window = window)

  accessible_times[pos] <- 1
  accessible_times <- torch::as_array(accessible_times)
  return(accessible_times)
}

