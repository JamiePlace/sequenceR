pcks <- c(
  "torch"
)

sapply(pcks, function(x){
  usethis::use_package(
    x,
    type = "Suggests"
  )
})
