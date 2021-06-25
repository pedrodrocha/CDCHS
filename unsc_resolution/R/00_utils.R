wait_load <- function(using, value) {
  el <- NULL
  while(is.null(el)){
    el <- suppressMessages(tryCatch(
      remDr$findElement(
        using = using, value = value
      ),
      error = function(e) {NULL}
    ))
  }
}
