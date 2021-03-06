% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compat-raster.R, R/compat-sf.R,
%   R/qgis-arguments.R
\name{as_qgis_argument.RasterLayer}
\alias{as_qgis_argument.RasterLayer}
\alias{as_qgis_argument.sf}
\alias{as_qgis_argument}
\alias{as_qgis_argument.default}
\alias{as_qgis_argument.character}
\alias{as_qgis_argument.logical}
\alias{as_qgis_argument.numeric}
\alias{qgis_clean_argument}
\alias{qgis_clean_argument.default}
\alias{qgis_clean_argument.qgis_tempfile_arg}
\title{Type coercion for arguments to QGIS processing algorithms}
\usage{
\method{as_qgis_argument}{RasterLayer}(x, qgis_type)

\method{as_qgis_argument}{sf}(x, qgis_type)

as_qgis_argument(x, qgis_type = NA)

\method{as_qgis_argument}{default}(x, qgis_type = NA)

\method{as_qgis_argument}{character}(x, qgis_type = NA)

\method{as_qgis_argument}{logical}(x, qgis_type = NA)

\method{as_qgis_argument}{numeric}(x, qgis_type = NA)

qgis_clean_argument(value, qgis_type = NA)

\method{qgis_clean_argument}{default}(value, qgis_type = NA)

\method{qgis_clean_argument}{qgis_tempfile_arg}(value, qgis_type = NA)
}
\arguments{
\item{x}{An object passed to a QGIS processing algorithm}

\item{qgis_type}{A character vector of length 1 (e.g., "source").}

\item{value}{The result of \code{\link[=as_qgis_argument]{as_qgis_argument()}} after the QGIS processing
algorithm has been run.}
}
\description{
Type coercion for arguments to QGIS processing algorithms
}
