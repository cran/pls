### mvr_wrappers.R: plsr, pls and pcr wrappers for mvr
### $Id: mvr_wrappers.R 6 2005-03-29 14:56:18Z  $

plsr <- function(..., method = c("kernelpls", "simpls", "oscorespls"))
{
    cl <- match.call()
    cl$method <- match.arg(method)
    cl[[1]] <- as.name("mvr")
    res <- eval(cl, parent.frame())
    res$call <- match.call()            # Fix call component
    res
}

pcr <- plsr
formals(pcr)$method <- "svdpc"
