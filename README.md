<!-- README.md is generated from README.Rmd. Please edit that file -->

sequenceR
=========

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/sequenceR)](https://CRAN.R-project.org/package=sequenceR)
[![R-CMD-check](https://github.com/JamiePlace/sequenceR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JamiePlace/sequenceR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of sequenceR is to identify sequences of 1’s in a vector of 1’s
and 0’s. The problem stems from needing to find such sequences
efficiently in a simulation environment.

seqeunceR utilises the efficient convolution processes from the base R
`stats` package

Installation
------------

You can install the released version of sequenceR from
[github](https://github.com/JamiePlace/sequenceR) with:

    install.packages("remotes")
    remotes::install_github("JamiePlace/sequenceR")

Example
-------

This is a basic example which shows you how to solve a common problem:

    library(sequenceR)

    sequence_data <- c(0,0,0,1,1,1,0,1,0,1,0,1,1,1)

    window <- 3

    find_sequences(sequence_data, window = window)
    #>  [1] 0 0 0 1 0 0 0 0 0 0 0 1 0 0

The output is a vector with length equal to that of the given vector
with 1’s in the location where a sequence matching the requirements
begins
