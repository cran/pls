%% $Id: oliveoil.Rd 92 2006-09-20 17:44:25Z bhm $
\encoding{latin1}
\name{oliveoil}
\alias{oliveoil}
\docType{data}
\title{Sensory and physico-chemical data of olive oils}
\description{
  A data set with scores on 6 attributes from a sensory panel and
  measurements of 5 physico-chemical quality parameters on 16 olive oil
  samples.  The first five oils are Greek, the next five are Italian and
  the last six are Spanish.
}
\usage{data(oliveoil)}
\format{A data frame with 16 observations on the following 2 variables.
  \describe{
    \item{\code{sensory}}{a matrix with 6 columns.  Scores for
      attributes \sQuote{yellow}, \sQuote{green}, \sQuote{brown},
      \sQuote{glossy}, \sQuote{transp}, and \sQuote{syrup}.}
    \item{\code{chemical}}{a matrix with 5 columns.  Measurements of
      acidity, peroxide, K232, K270, and DK.}
  }
}
\source{
  Massart, D. L., Vandeginste, B. G. M., Buydens, L. M. C., de Jong, S.,
  Lewi, P. J., Smeyers-Verbeke, J. (1998)  \emph{Handbook of
    Chemometrics and Qualimetrics: Part B}.  Elsevier. Tables 35.1 and 35.4.
}
\keyword{datasets}