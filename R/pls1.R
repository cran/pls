"pls1a"<-
function(X, y, K=min(dx[1]-1,dx[2]))
{
# Copyright (c) October 1993, Mike Denham.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Orthogonal Scores Algorithm for PLS (Martens and Naes, pp. 121--123)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#
        X <- as.matrix(X)
        dx <- dim(X)
        W <- matrix(0, dx[2], K)
        P <- matrix(0, dx[2], K)
        Q <- numeric(K)
        for(i in 1:K) {
                w <- crossprod(X, y)
                w <- w/sqrt(crossprod(w)[1])
                W[, i] <- w
                tee <- X %*% w
                cee <- crossprod(tee)[1]
                p <- crossprod(X, (tee/cee))
                P[, i] <- p
                q <- crossprod(y, tee)[1]/cee
                Q[i] <- q
                X <- X - tee %*% t(p)
                y <- y - q * tee
        }
        W %*% solve(crossprod(P, W), Q)
}
"pls1b"<-
function(X, y, K=min(dx[1]-1,dx[2]))
{
# Copyright Mike Denham, October 1993.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Orthogonal Loadings Algorithm for PLS (Martens and Naes, pp. 123--125)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#
# tol is set as the tolerance for the QR decomposition in determining
# rank deficiency
#
        tol <- 1e-10
        X <- as.matrix(X)
        dx <- dim(X)
        W <- matrix(0, dx[2], K)
        Tee <- matrix(0, dx[1], K)
        y0 <- y
        for(i in 1:K) {
                w <- crossprod(X, y)
                w <- w/sqrt(crossprod(w)[1])
                W[, i] <- w
                tee <- X %*% w
                Tee[, i] <- tee
                Q <- qr.coef(qr(Tee[, 1:i], tol = tol), y0)
                X <- X - tee %*% t(w)
                y <- y0 - Tee[, 1:i, drop = F] %*% Q
        }
        W %*% Q
}

"pls1c"<-
function(X, y, K=min(dx[1]-1,dx[2]))
{
# Copyright Mike Denham, October 1994.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Modified Helland Algorithm (Helland 1988 + Denham 1994)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#
# tol is set as the tolerance for the QR decomposition in determining
# rank deficiency
#
        tol <- 1e-10
        X <- as.matrix(X)
        dx <- dim(X)
        W <- matrix(0, dx[2], K)
        XW <- matrix(0, dx[1], K)
        s <- crossprod(X, y)
        W[, 1] <- s
        XW[, 1] <- X %*% s
        QR <- qr(XW[, 1], tol = tol)
        r <- qr.resid(QR, y)
        if(K > 1) {
                for(i in 2:K) {
                        w <- crossprod(X, r)
                        W[, i] <- w
                        XW[, i] <- X %*% w
                        QR <- qr(XW[, 1:i], tol = tol)
                        r <- qr.resid(QR, y)
                }
        }
        W %*% qr.coef(QR, y)
}
"svdpls1a"<-
function(X, y, K = r)
{
# Copyright Mike Denham, October 1993.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Orthogonal Scores Algorithm for PLS (Martens and Naes, pp. 121--123)
# using Singular Value Decomposition. (Uses a replacement version of svd
# which is more efficient when the number of columns is large relative to
# the number of rows.)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#

	X <- as.matrix(X)
	r <- min(dim(X) - c(1, 0))
	X <- my.svd(X)
	X$v[, 1:r] %*% pls1a(diag(X$d[1:r]), crossprod(X$u[, 1:r], y), K)
}
"svdpls1b"<-
function(X, y, K = r)
{
# Copyright Mike Denham, October 1993.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Orthogonal Loadings Algorithm for PLS (Martens and Naes, pp. 123--125)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#
# tol is set as the tolerance for the QR decomposition in determining
# rank deficiency
#

	X <- as.matrix(X)
	r <- min(dim(X) - c(1, 0))
	X <- svd(X)
	X$v[, 1:r] %*% pls1b(diag(X$d[1:r]), crossprod(X$u[, 1:r], y), K)
}
"svdpls1c"<-
function(X, y, K = r)
{
# Copyright Mike Denham, October 1994.
# Comments and Complaints to: snsdenhm@reading.ac.uk
#
# Modified Helland Algorithm (Helland 1988 + Denham 1994)
#
# X: A matrix which is assumed to have been centred so that columns
#    sum to zero.
#
# y: A vector assumed to sum to zero.
#
# K: The number of PLS factors in the model which must be less than or
#    equal to the  rank of X.
#
# Returned Value is the vector of PLS regression coefficients
#
# tol is set as the tolerance for the QR decomposition in determining
# rank deficiency
#

	X <- as.matrix(X)
	r <- min(dim(X) - c(1, 0))
	X <- svd(X)
	X$v[, 1:r] %*% pls1c(diag(X$d[1:r]), crossprod(X$u[, 1:r], y), K)
}
"my.svd"<-
function(x, nu = min(n, p), nv = min(n, p))
{
# Alternative to Singular Value Decomposition function svd
# Examines matrix n by p matrix x and if n < p obtains the svd 
# by applying svd the transpose of x.
	x <- as.matrix(x)
	dmx <- dim(x)
	n <- dmx[1]
	p <- dmx[2]
	transpose.x <- n < p
	if(transpose.x) {
		x <- t(x)
		hold <- nu
		nu <- nv
		nv <- hold
	}
	cmplx <- mode(x) == "complex"
	if(!(is.numeric(x) || cmplx))
		stop("x must be numeric or complex")
	if(!cmplx)
		storage.mode(x) <- "double"
	dmx <- dim(x)
	n <- dmx[1]
	p <- dmx[2]
	mm <- min(n + 1, p)
	mn <- min(dmx)
	job <- (if(nv) 1 else 0) + 10 * (if(nu == 0) 0 else if(nu == mn)
		2
	else if(nu == n)
		1
	else stop("Invalid value for nu (must be 0, number of rows, or number of cols)"
			))
	z <- .Fortran(if(!cmplx) "dsvdcs" else "zsvdcs",
		x,
		as.integer(n),
		as.integer(n),
		as.integer(p),
		d = if(!cmplx) double(mm) else complex(mm),
		if(!cmplx) double(p) else complex(p),
		u = if(!cmplx) if(nu)
				matrix(0, n, nu)
			else 0 else if(nu)
			matrix(as.complex(0), n, nu)
		else as.complex(0),
		as.integer(n),
		v = if(!cmplx) if(nv)
				matrix(0, p, p)
			else 0 else if(nv)
			matrix(as.complex(0), p, p)
		else as.complex(0),
		as.integer(p),
		if(!cmplx) double(n) else complex(n),
		as.integer(job),
		info = integer(1))[c("d", "u", "v", "info")]
	if(z$info)
		stop(paste("Numerical error (code", z$info, ") in algorithm"))
	if(cmplx) {
		if(all(Im(z$d) == 0))
			z$d <- Re(z$d)
		else stop("a singular value has a nonzero imaginary part")
	}
	length(z$d) <- mn
	if(nv && nv < p)
		z$v <- z$v[, seq(nv)]
	if(transpose.x) {
		z <- z[c("d", if(nu) "u" else NULL, if(nv) "v" else NULL)]
		names(z) <- names(z)[c(1, 3, 2)]
		z
	}
	else {
		z[c("d", if(nv) "v" else NULL, if(nu) "u" else NULL)]
	}
}
