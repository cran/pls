% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plots.R
\name{scoreplot}
\alias{scoreplot}
\alias{scoreplot.default}
\alias{plot.scores}
\alias{loadingplot}
\alias{loadingplot.default}
\alias{plot.loadings}
\alias{corrplot}
\title{Plots of Scores, Loadings and Correlation Loadings}
\usage{
scoreplot(object, ...)

\method{scoreplot}{default}(
  object,
  comps = 1:2,
  labels,
  identify = FALSE,
  type = "p",
  xlab,
  ylab,
  ...
)

\method{plot}{scores}(x, ...)

loadingplot(object, ...)

\method{loadingplot}{default}(
  object,
  comps = 1:2,
  scatter = FALSE,
  labels,
  identify = FALSE,
  type,
  lty,
  lwd = NULL,
  pch,
  cex = NULL,
  col,
  legendpos,
  xlab,
  ylab,
  pretty.xlabels = TRUE,
  xlim,
  ...
)

\method{plot}{loadings}(x, ...)

corrplot(
  object,
  comps = 1:2,
  labels,
  plotx = TRUE,
  ploty = FALSE,
  radii = c(sqrt(1/2), 1),
  identify = FALSE,
  type = "p",
  xlab,
  ylab,
  col,
  ...
)
}
\arguments{
\item{object}{an object.  The fitted model.}

\item{\dots}{further arguments sent to the underlying plot function(s).}

\item{comps}{integer vector.  The components to plot.}

\item{labels}{optional.  Alternative plot labels or \eqn{x} axis labels.
See Details.}

\item{identify}{logical.  Whether to use \code{identify} to interactively
identify points.  See below.}

\item{type}{character.  What type of plot to make.  Defaults to \code{"p"}
(points) for scatter plots and \code{"l"} (lines) for line plots.  See
\code{\link{plot}} for a complete list of types (not all types are
possible/meaningful for all plots).}

\item{xlab, ylab}{titles for \eqn{x} and \eqn{y} axes.  Typically character
strings, but can be expressions or lists.  See \code{\link{title}} for
details.}

\item{x}{a \code{scores} or \code{loadings} object.  The scores or loadings
to plot.}

\item{scatter}{logical.  Whether the loadings should be plotted as a scatter
instead of as lines.}

\item{lty}{vector of line types (recycled as neccessary).  Line types can be
specified as integers or character strings (see \code{\link{par}} for the
details).}

\item{lwd}{vector of positive numbers (recycled as neccessary), giving the
width of the lines.}

\item{pch}{plot character.  A character string or a vector of single
characters or integers (recycled as neccessary).  See \code{\link{points}}
for all alternatives.}

\item{cex}{numeric vector of character expansion sizes (recycled as
neccessary) for the plotted symbols.}

\item{col}{character or integer vector of colors for plotted lines and
symbols (recycled as neccessary).  See \code{\link{par}} for the details.}

\item{legendpos}{Legend position.  Optional.  Ignored if \code{scatter} is
\code{TRUE}.  If present, a legend is drawn at the given position.  The
position can be specified symbolically (e.g., \code{legendpos =
"topright"}).  This requires >= 2.1.0.  Alternatively, the position can be
specified explicitly (\code{legendpos = t(c(x,y))}) or interactively
(\code{legendpos = \link{locator}()}).}

\item{pretty.xlabels}{logical.  If \code{TRUE}, \code{loadingplot} tries to
plot the \eqn{x} labels more nicely.  See Details.}

\item{xlim}{optional vector of length two, with the \eqn{x} limits of the
plot.}

\item{plotx}{locical.  Whether to plot the \eqn{X} correlation loadings.
Defaults to \code{TRUE}.}

\item{ploty}{locical.  Whether to plot the \eqn{Y} correlation loadings.
Defaults to \code{FALSE}.}

\item{radii}{numeric vector, giving the radii of the circles drawn in
\code{corrplot}.  The default radii represent 50\% and 100\% explained
variance of the \eqn{X} variables by the chosen components.}
}
\value{
The functions return whatever the underlying plot function (or
\code{identify}) returns.
}
\description{
Functions to make scatter plots of scores or correlation loadings, and
scatter or line plots of loadings.
}
\details{
\code{plot.scores} is simply a wrapper calling \code{scoreplot}, passing all
arguments.  Similarly for \code{plot.loadings}.

\code{scoreplot} is generic, currently with a default method that works for
matrices and any object for which \code{\link{scores}} returns a matrix.
The default \code{scoreplot} method makes one or more scatter plots of the
scores, depending on how many components are selected.  If one or two
components are selected, and \code{identify} is \code{TRUE}, the function
\code{\link{identify}} is used to interactively identify points.

Also \code{loadingplot} is generic, with a default method that works for
matrices and any object where \code{\link{loadings}} returns a matrix.  If
\code{scatter} is \code{TRUE}, the default method works exactly like the
default \code{scoreplot} method.  Otherwise, it makes a lineplot of the
selected loading vectors, and if \code{identify} is \code{TRUE}, uses
\code{\link{identify}} to interactively identify points.  Also, if
\code{legendpos} is given, a legend is drawn at the position indicated.

\code{corrplot} works exactly like the default \code{scoreplot} method,
except that at least two components must be selected.  The
\dQuote{correlation loadings}, i.e. the correlations between each variable
and the selected components (see References), are plotted as pairwise
scatter plots, with concentric circles of radii given by \code{radii}.  Each
point corresponds to a variable.  The squared distance between the point and
origin equals the fraction of the variance of the variable explained by the
components in the panel.  The default \code{radii} corresponds to 50\% and
100\% explained variance.  By default, only the correlation loadings of the
\eqn{X} variables are plotted, but if \code{ploty} is \code{TRUE}, also the
\eqn{Y} correlation loadings are plotted.

\code{scoreplot}, \code{loadingplot} and \code{corrplot} can also be called
through the plot method for \code{mvr} objects, by specifying
\code{plottype} as \code{"scores"}, \code{"loadings"} or
\code{"correlation"}, respectively.  See \code{\link{plot.mvr}}.

The argument \code{labels} can be a vector of labels or one of
\code{"names"} and \code{"numbers"}.

If a scatter plot is produced (i.e., \code{scoreplot}, \code{corrplot}, or
\code{loadingplot} with \code{scatter = TRUE}), the labels are used instead
of plot symbols for the points plotted.  If \code{labels} is \code{"names"}
or \code{"numbers"}, the row names or row numbers of the matrix (scores,
loadings or correlation loadings) are used.

If a line plot is produced (i.e., \code{loadingplot}), the labels are used
as \eqn{x} axis labels.  If \code{labels} is \code{"names"} or
\code{"numbers"}, the variable names are used as labels, the difference
being that with \code{"numbers"}, the variable names are converted to
numbers, if possible.  Variable names of the forms \samp{"number"} or
\samp{"number text"} (where the space is optional), are handled.

The argument \code{pretty.xlabels} is only used when \code{labels} is
specified for a line plot.  If \code{TRUE} (default), the code tries to use
a \sQuote{pretty} selection of labels.  If \code{labels} is
\code{"numbers"}, it also uses the numerical values of the labels for
horisontal spacing.  If one has excluded parts of the spectral region, one
might therefore want to use \code{pretty.xlabels = FALSE}.
}
\note{
\code{\link{legend}} has many options.  If you want greater control
over the appearance of the legend, omit the \code{legendpos} argument and
call \code{legend} manually.

Graphical parametres (such as \code{pch} and \code{cex}) can also be used
with \code{scoreplot} and \code{corrplot}.  They are not listed in the
argument list simply because they are not handled specifically in the
function (unlike in \code{loadingplot}), but passed directly to the
underlying plot functions by \code{\dots{}}.

Tip: If the labels specified with \code{labels} are too long, they get
clipped at the border of the plot region.  This can be avoided by supplying
the graphical parameter \code{xpd = TRUE} in the plot call.

The handling of \code{labels} and \code{pretty.xlabels} in \code{coefplot}
is experimental.
}
\examples{

data(yarn)
mod <- plsr(density ~ NIR, ncomp = 10, data = yarn)
## These three are equivalent:
\dontrun{
scoreplot(mod, comps = 1:5)
plot(scores(mod), comps = 1:5)
plot(mod, plottype = "scores", comps = 1:5)

loadingplot(mod, comps = 1:5)
loadingplot(mod, comps = 1:5, legendpos = "topright") # With legend
loadingplot(mod, comps = 1:5, scatter = TRUE) # Plot as scatterplots

corrplot(mod, comps = 1:2)
corrplot(mod, comps = 1:3)
}

}
\references{
Martens, H., Martens, M. (2000) Modified Jack-knife Estimation
of Parameter Uncertainty in Bilinear Modelling by Partial Least Squares
Regression (PLSR).  \emph{Food Quality and Preference}, \bold{11}(1--2),
5--16.
}
\seealso{
\code{\link{mvr}}, \code{\link{plot.mvr}}, \code{\link{scores}},
\code{\link{loadings}}, \code{\link{identify}}, \code{\link{legend}}
}
\author{
Ron Wehrens and Bjørn-Helge Mevik
}
\keyword{hplot}
\keyword{multivariate}
\keyword{regression}
