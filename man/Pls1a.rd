\name{pls1a}
\alias{pls1a}
\title{
Univariate Partial Least Squares Regression
}
\description{
Performs univariate partial least squares (PLS) regression of a vector on a
matrix of explanatory variables using the Orthogonal Scores Algorithm.
}
\usage{
pls1a(X, y, K=min(dx[1]-1,dx[2]))
}
\arguments{
\item{X}{
Matrix of explanatory variables. Each column represents a variable and
each row an observation. The columns of this matrix are assumed to have been 
centred. The number of rows of \code{X} should equal the number of observations in
\code{y}. \code{NA}s and \code{Inf}s are not allowed. 
}
\item{y}{
Vector of responses. \code{y} is assumed to have been centred.
\code{NA}s and \code{Inf}s are not allowed.
}
\item{K}{
Number of PLS factors to fit in the PLS regression. This must
be less than or equal to the rank of \code{X}.
}}
\value{
a vector of regression coefficients
}
\details{
Univariate Partial Least Squares Regression is an example of a
regularised regression method. It creates a lower dimensional
representation of the original explanatory variables and uses this
representation in an ordinary least squares regression of the response
variables. (cf. Principal Components Regression). Unlike Principal
Components Regression, PLS regression chooses the lower dimensional
representation of the original explanatory variables with reference to
the response variable \code{y}.
}
\references{
Denham, M. C. (1994).
Implementing partial least squares.
Statistics and Computing (to appear)

Helland, I. S. (1988).
On the Structure of partial least squares regression,
Communications in Statistics, 17, pp. 581-607

Martens, H.  and Naes, T. (1989).
Multivariate Calibration.
Wiley, New York.
}
\seealso{
pls1b,pls1c,svdpls1a,svdpls1b,svdpls1c
}
\examples{
data(crimes)
attach(crimes)
pls1a(scale(cbind(Murder, Assault, UrbanPop),scale=FALSE), 
      scale(Rape,scale=FALSE), 2)
}
# The function is currently defined as
#function(X, y, K=min(dx[1]-1,dx[2]))
#{
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
#        X <- as.matrix(X)
#        dx <- dim(X)
#        W <- matrix(0, dx[2], K)
#        P <- matrix(0, dx[2], K)
#        Q <- numeric(K)
#        for(i in 1:K) {
#                w <- crossprod(X, y)
#                w <- w/sqrt(crossprod(w)[1])
#                W[, i] <- w
#                tee <- X \%*\% w
#                cee <- crossprod(tee)[1]
#                p <- crossprod(X, (tee/cee))
#                P[, i] <- p
#                q <- crossprod(y, tee)[1]/cee
#                Q[i] <- q
#                X <- X - tee \%*\% t(p)
#                y <- y - q * tee
#        }
#        W \%*\% solve(crossprod(P, W), Q)
#}
#}
\keyword{regression}
% Converted by Sd2Rd version 0.3-2.
