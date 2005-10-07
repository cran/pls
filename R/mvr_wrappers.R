### mvr_wrappers.R: plsr, pls and pcr wrappers for mvr
### $Id: mvr_wrappers.R 44 2005-07-17 20:49:17Z bhm $

plsr <- function(..., method = c("kernelpls", "simpls", "oscorespls", "model.frame"))
{
    cl <- match.call()
    cl$method <- match.arg(method)
    cl[[1]] <- as.name("mvr")
    res <- eval(cl, parent.frame())
    res$call <- match.call()            # Fix call component
    res
}

pcr <- plsr
formals(pcr)$method <- c("svdpc", "model.frame")
