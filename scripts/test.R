x = function(input, upload) {
    result <- input * upload
    #b = upload * 2
    #c = a + b
    return(result)
}

y <- function(data) {
    #rm(list=ls())
    data = 2 * data
    return(data)
}

z <- function(algorithm, trees) {
    a <- trees[1]
    b <- trees[2]
    a + b
}