pcks <- c(
  "torch",
  "rlang"
)

sapply(pcks, function(x){
  usethis::use_package(
    x,
    type = "imports",
    min_version = TRUE
  )
})
