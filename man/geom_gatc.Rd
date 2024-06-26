% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_gatc_track.R
\name{geom_gatc}
\alias{geom_gatc}
\title{Plot for a GATC track}
\usage{
geom_gatc(
  gatc_sites.df = NULL,
  gatc.color = "red",
  gatc.size = 5,
  plot.space = 0.2,
  plot.height = 0.05
)
}
\arguments{
\item{gatc_sites.df}{A data.frame of positions of GATC sites - can be made from `gatc_track()$sites`.}

\item{gatc.color}{Specify colour of lines. Default is red.}

\item{gatc.size}{Specify size of the line. Default is 5.}

\item{plot.space}{Specify gap to next plot. Recommend leaving to the default: 0.2.}

\item{plot.height}{Specify overall height of the plot. Recommend leaving to the default: 0.05.}
}
\value{
A `ggplot_add` object.
}
\description{
`geom_gatc` is a ggplot2 layer that visualises the positions of GATC sites across a given region.
* cannot be plotted by itself, must be added to an existing ggplot2 object - see examples.
}
\examples{
set.seed(123)
example_regions <- random_regions()
counts.df <- random_counts()
gatc_sites <- dplyr::mutate(example_regions,
    start = start - 3, end = start + 4, width = end - start + 1
)

plotCounts(counts.df,
    seqnames = "chr2L",
    start_region = 1,
    end_region = 40000,
    log2_scale = FALSE
) +
    geom_gatc(gatc_sites)
# The plots can be layered -------------------------------------------------
}
\references{
ggcoverage - Visualise and annotate omics coverage with ggplot2. https://github.com/showteeth/ggcoverage/tree/main
}
\seealso{
[plotCounts()] [geom_peak()] [geom_dm()] [geom_genes.tx()] [plotWrap()] [ggplot2::ggplot_add()]
}
