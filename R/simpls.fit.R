### simpls.fit.R: SimPLS fit algorithm.
###
### Implements an adapted version of the SIMPLS algorithm described in
###   de Jong, S. (1993) SIMPLS: an alternative approach to partial least
###   squares regression.  \emph{Chemometrics and Intelligent Laboratory
###   Systems}, \bold{18}, 251--263.



#' @title Sijmen de Jong's SIMPLS
#'
#' @description Fits a PLSR model with the SIMPLS algorithm.
#'
#' @details This function should not be called directly, but through the generic
#' functions \code{plsr} or \code{mvr} with the argument
#' \code{method="simpls"}.  SIMPLS is much faster than the NIPALS algorithm,
#' especially when the number of X variables increases, but gives slightly
#' different results in the case of multivariate Y.  SIMPLS truly maximises the
#' covariance criterion.  According to de Jong, the standard PLS2 algorithms
#' lie closer to ordinary least-squares regression where a precise fit is
#' sought; SIMPLS lies closer to PCR with stable predictions.
#'
#' @param X a matrix of observations.  \code{NA}s and \code{Inf}s are not
#' allowed.
#' @param Y a vector or matrix of responses.  \code{NA}s and \code{Inf}s are
#' not allowed.
#' @param ncomp the number of components to be used in the modelling.
#' @param center logical, determines if the \eqn{X} and \eqn{Y} matrices are
#' mean centered or not. Default is to perform mean centering.
#' @param stripped logical.  If \code{TRUE} the calculations are stripped as
#' much as possible for speed; this is meant for use with cross-validation or
#' simulations when only the coefficients are needed.  Defaults to
#' \code{FALSE}.
#' @param \dots other arguments.  Currently ignored.
#' @return A list containing the following components is returned:
#' \item{coefficients}{an array of regression coefficients for 1, \ldots{},
#' \code{ncomp} components.  The dimensions of \code{coefficients} are
#' \code{c(nvar, npred, ncomp)} with \code{nvar} the number of \code{X}
#' variables and \code{npred} the number of variables to be predicted in
#' \code{Y}.} \item{scores}{a matrix of scores.} \item{loadings}{a matrix of
#' loadings.} \item{Yscores}{a matrix of Y-scores.} \item{Yloadings}{a matrix
#' of Y-loadings.} \item{projection}{the projection matrix used to convert X to
#' scores.} \item{Xmeans}{a vector of means of the X variables.}
#' \item{Ymeans}{a vector of means of the Y variables.} \item{fitted.values}{an
#' array of fitted values.  The dimensions of \code{fitted.values} are
#' \code{c(nobj, npred, ncomp)} with \code{nobj} the number samples and
#' \code{npred} the number of Y variables.} \item{residuals}{an array of
#' regression residuals.  It has the same dimensions as \code{fitted.values}.}
#' \item{Xvar}{a vector with the amount of X-variance explained by each
#' component.} \item{Xtotvar}{Total variance in \code{X}.}
#'
#' If \code{stripped} is \code{TRUE}, only the components \code{coefficients},
#' \code{Xmeans} and \code{Ymeans} are returned.
#' @author Ron Wehrens and Bjørn-Helge Mevik
#' @seealso \code{\link{mvr}} \code{\link{plsr}} \code{\link{pcr}}
#' \code{\link{kernelpls.fit}} \code{\link{widekernelpls.fit}}
#' \code{\link{oscorespls.fit}}
#' @references de Jong, S. (1993) SIMPLS: an alternative approach to partial
#' least squares regression.  \emph{Chemometrics and Intelligent Laboratory
#' Systems}, \bold{18}, 251--263.
#' @keywords regression multivariate
#' @export
simpls.fit <- function(X, Y, ncomp, center = TRUE, stripped = FALSE, ...) {
    Y <- as.matrix(Y)
    if (!stripped) {
        ## Save dimnames:
        dnX <- dimnames(X)
        dnY <- dimnames(Y)
    }
    ## Remove dimnames during calculation (doesn't seem to matter; in fact,
    ## as far as it has any effect, it hurts a tiny bit in most situations).
    dimnames(X) <- dimnames(Y) <- NULL

    nobj  <- dim(X)[1] # n in paper
    npred <- dim(X)[2] # p in paper
    nresp <- dim(Y)[2]

    V <- R <- matrix(0, nrow = npred, ncol = ncomp)
    tQ <- matrix(0, nrow = ncomp, ncol = nresp) # Y loadings; transposed
    B <- array(0, dim = c(npred, nresp, ncomp))
    if (!stripped) {
        P <- R
        U <- TT <- matrix(0, nrow = nobj, ncol = ncomp)
        fitted <- array(0, dim = c(nobj, nresp, ncomp))
    }

    ## Center variables:
    if (center) {
        Xmeans <- colMeans(X)
        X <- X - rep(Xmeans, each = nobj) # This is not strictly neccessary
                                        # (but might be good for accuracy?)!
        Ymeans <- colMeans(Y)
        Y <- Y - rep(Ymeans, each = nobj)
    } else {
        ## Set means to zero. Will ensure that predictions do not take the
        ## mean into account.
        Xmeans <- rep_len(0, npred)
        Ymeans <- rep_len(0, nresp)
    }

    S <- crossprod(X, Y)

    for (a in 1:ncomp) {
        ## A more efficient way of calculating the Y block factor weights
        ## q.a <- svd(S)$v[,1]:
        if (nresp == 1) {
            q.a <- 1
        } else {
            if (nresp < npred) {
                q.a <- eigen(crossprod(S), symmetric = TRUE)$vectors[,1]
            } else {
                q.a <- c(crossprod(S, eigen(S %*% t(S),
                                            symmetric = TRUE)$vectors[,1]))
                q.a <- q.a / sqrt(c(crossprod(q.a)))
            }
        }
        r.a <- S %*% q.a                 # X block factor weights
        t.a <- X %*% r.a
        if (center) {
            t.a <- t.a - mean(t.a)       # center scores
        }
        tnorm <- sqrt(c(crossprod(t.a)))
        t.a <- t.a / tnorm               # normalize scores
        r.a <- r.a / tnorm               # adapt weights accordingly
        p.a <- crossprod(X, t.a)         # X block factor loadings
        q.a <- crossprod(Y, t.a)         # Y block factor loadings
        v.a <- p.a			 # init orthogonal loadings
        if (a > 1) {
            v.a <- v.a - V %*% crossprod(V, p.a) # v.a orth to previous loadings
        }
        v.a <- v.a / sqrt(c(crossprod(v.a))) # normalize orthogonal loadings
        S <- S - v.a %*% crossprod(v.a, S) # deflate S

        R[,a]  <- r.a
        tQ[a,] <- q.a
        V[,a]  <- v.a

        B[,,a] <- R[,1:a, drop=FALSE] %*% tQ[1:a,, drop=FALSE]

        if (!stripped) {
            u.a <- Y %*% q.a # Y block factor scores
            if (a > 1)
                u.a <- u.a - TT %*% crossprod(TT, u.a) # u.a orth to previous t.a values
            P[,a]  <- p.a
            TT[,a] <- t.a
            U[,a]  <- u.a
            ## (For very tall, slim X and Y, X %*% B[,,a] is slightly faster,
            ## due to less overhead.)
            fitted[,,a] <- TT[,1:a] %*% tQ[1:a,, drop=FALSE]
        }
    }

    if (stripped) {
        ## Return as quickly as possible
        list(coefficients = B, Xmeans = Xmeans, Ymeans = Ymeans)
    } else {
        residuals <- - fitted + c(Y)
        fitted <- fitted + rep(Ymeans, each = nobj) # Add mean

        ## Add dimnames and classes:
        objnames <- dnX[[1]]
        if (is.null(objnames)) objnames <- dnY[[1]]
        prednames <- dnX[[2]]
        respnames <- dnY[[2]]
        compnames <- paste("Comp", 1:ncomp)
        nCompnames <- paste(1:ncomp, "comps")
        dimnames(TT) <- dimnames(U) <- list(objnames, compnames)
        dimnames(R) <- dimnames(P) <- list(prednames, compnames)
        dimnames(tQ) <- list(compnames, respnames)
        dimnames(B) <- list(prednames, respnames, nCompnames)
        dimnames(fitted) <- dimnames(residuals) <-
            list(objnames, respnames, nCompnames)
        class(TT) <- class(U) <- "scores"
        class(P) <- class(tQ) <- "loadings"

        list(coefficients = B,
             scores = TT, loadings = P,
             Yscores = U, Yloadings = t(tQ),
             projection = R,
             Xmeans = Xmeans, Ymeans = Ymeans,
             fitted.values = fitted, residuals = residuals,
             Xvar = colSums(P * P), Xtotvar = sum(X * X))
    }
}
