### mvr_wrappers.R: plsr, pls and pcr wrappers for mvr
### $Id: mvr_wrappers.R 132 2007-08-24 09:21:05Z bhm $

plsr <- function(..., method = pls.options()$plsralg)
{
    cl <- match.call()
    cl$method <- match.arg(method, c("kernelpls", "widekernelpls", "simpls",
                                     "oscorespls", "model.frame"))
    cl[[1]] <- as.name("mvr")
    res <- eval(cl, parent.frame())
    res$call <- match.call()            # Fix call component
    res
}

pcr <- function(..., method = pls.options()$pcralg)
{
    cl <- match.call()
    cl$method <- match.arg(method, c("svdpc", "model.frame"))
    cl[[1]] <- as.name("mvr")
    res <- eval(cl, parent.frame())
    res$call <- match.call()            # Fix call component
    res
}
