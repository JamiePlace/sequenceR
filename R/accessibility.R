#' Find sequences of a given window size
#' in a given vector of 1s and 0s
#'
#' @param data 1d vector of 1s and 0s
#' @param window size of sequence
#' @param continuous sequence of continuous 1s or
#' 1s either end with 0s between
#' @param required_pad if non-continuous how many 1s at either end
#'
#' @return vector of indices were criteria is met
#' @export
find_sequences <- function(data, window = 1, continuous = TRUE, required_pad = 1){
  if (!(is.vector(data)) | !(is.numeric(data))) {
    rlang::abort("data must be a numeric vector")
  }

  if (!(is.numeric(window)) | !(length(window) == 1)){
    rlang::abort("window must be a single numeric value")
  }

  if (!(is.logical(continuous))) {
    rlang::abort("continuous flag must be logical")
  }

  if (!(is.numeric(required_pad)) | !(length(required_pad) == 1)){
    rlang::abort("required_pad must be a single numeric value")
  }


  if (window > length(data)) {
    outputs <- rep(0, length(data))

    return(outputs)
  }

  data <- torch::torch_tensor(data)
  data <- data$view(c(1,1,length(data)))

  weights <- .generate_weights(window, continuous, required_pad)

  f_pass <- .forward(data, weights, window)

  if(length(f_pass$nonzero()) > 0) {
    a_pos <- .accessible_pos(f_pass, window, rm_overlap)

    outputs <- torch::torch_zeros(data$shape[3])
    outputs[a_pos] <- 1

    outputs <- torch::as_array(outputs)
  } else {
    outputs <- rep(0, data$shape[3])
  }

  return(outputs)
}

#' function to generate the weight vector
#' for the convolution step
.generate_weights <- function(window, continuous, required_pad) {
  if (continuous) {
    weights <- torch::torch_ones(window, requires_grad = FALSE)/window
    weights <- weights$view(c(1,1,weights$shape))
  } else {
    weights <- torch::torch_zeros(window, requires_grad = FALSE)
    weights[1:required_pad] <- 1
    weights[(window-required_pad + 1):window] <- 1
    weights <- weights/sum(weights)
    weights <- weights$view(c(1,1,weights$shape))
  }
}

#' forward pass to perform convolution
.forward <- function(x, weights, window) {
  # if the window is going to be too big we curtail
  # how many times to we iterate

  max_pos <- 2*window
  if (max_pos > x$shape[3]) {
    max_pos <- x$shape[3] - window
  } else {
    max_pos <- window
  }

  accessible_times <- torch::torch_zeros(c(max_pos, x$shape[3]), requires_grad = FALSE)

  for (start in 1:max_pos){
    x1 <- torch::nnf_conv1d(input = x[, , start:x$shape[3]], weight = weights, stride = window)

    # pad the result with 0
    x1 <- torch::nnf_pad(input = x1, pad = c(0, x$shape[3] - x1$shape[3]), mode = 'constant', value = 0)
    x1$squeeze_()
    x1$add_(0.0001)
    x1$floor_()

    accessible_times[start, ] <- x1
  }

  return(accessible_times)
}

#' find nonzero pos in the results of the conv
.accessible_pos <- function(dat, window) {
  idx <- torch::torch_nonzero(
    torch::torch_transpose(dat, 1, 2)
  )

  idx <- torch::as_array(idx)

  pos <- idx[,1]*window + idx[,2] + 1

  return(pos)
}
