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
find_sequences <- function(data, window = 1, continuous = TRUE, required_pad = 1) {
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

  w <- .generate_weights(window, continuous, required_pad)

  f_pass <- .forward(data, w, window)

  f_pass <- floor(f_pass + 1e-9)

  return(f_pass)
}

#' function to generate the weight vector
#' for the convolution step
#' @param window the window size
#' @param continuous bool, continuous or non-continuous
#' @param required_pad the padding for non-continuous windows
.generate_weights <- function(window, continuous, required_pad) {
  if (continuous) {
    weights <- rep(1, window)/window
  } else {
    weights <- rep(0, window)
    weights[1:required_pad] <- 1
    weights[(window-required_pad + 1):window] <- 1
    weights <- weights/sum(weights)
  }
}

#' forward pass to perform convolution
#' @param x the vector of data to find sequences in
#' @param weights the weights tensor to be passed to the conv layer
#' @param window the window size
.forward <- function(x, weights, window) {

  c <- stats::convolve(x, weights, type = 'filter')
  c <- c(c, rep(0, (length(weights) - 1)))

  return(c)
}
