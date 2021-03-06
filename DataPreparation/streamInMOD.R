#
# Modificated stream_in() function (jsonlite package)
#

fun <- function (con, handler, pagesize = 500, verbose = TRUE, ...) 
{
  bind_pages <- missing(handler) || is.null(handler)
  if (!is(con, "connection")) {
    stop("Argument 'con' must be a connection.")
  }
  if (bind_pages) {
    loadpkg("plyr")
  }
  else {
    stopifnot(is.function(handler))
    if (verbose) 
      message("using a custom handler function.")
  }
  if (!isOpen(con, "r")) {
    if (verbose) 
      message("opening ", is(con), " input connection.")
    open(con, "rb")
    on.exit({
      if (verbose) message("closing ", is(con), " input connection.")
      close(con)
    })
  }
  if (bind_pages) {
    dfstack <- list()
  }
  i <- 1L
  while (length(page <- readLines(con, n = pagesize, encoding = "UTF-8"))) {
    if (verbose) 
      message("Reading ", length(page), " lines (", i, 
              ").")
    flag <- FALSE
    # If error, skip iteration
    tryCatch( mydf <- simplify(lapply(page, parseJSON), ...), error = function(e) flag <- TRUE )
    
    if(flag){
      i <- i + 1L
      next
    } 
    
    if (bind_pages) {
      dfstack[[i]] <- mydf
    }
    else {
      handler(mydf)
    }
    i <- i + 1L
  }
  if (bind_pages) {
    if (verbose) 
      message("binding pages together (no custom handler).")
    rbind.pages(dfstack)
  }
  else {
    invisible()
  }
}

environment(fun) <- asNamespace('jsonlite')
