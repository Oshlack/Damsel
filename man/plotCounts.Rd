% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_region_counts.R
\name{plotCounts}
\alias{plotCounts}
\title{Plot for counts for all samples across a given region}
\usage{
plotCounts(
  counts.df,
  seqnames,
  start_region = NULL,
  end_region = NULL,
  layout = c("stacked", "spread"),
  log2_scale = FALSE,
  colours = NULL,
  ...
)
}
\arguments{
\item{counts.df}{A data.frame of counts as outputted from [process_bams()].}

\item{seqnames}{A character string of the chromosome of interest.}

\item{start_region}{A number providing the start of region to plot.}

\item{end_region}{A number providing the end of region to plot.}

\item{layout}{Determines the layout of the plot. Default is "stacked" collapsing the Dam samples into one plot, and the Fusion samples into another. Samples can be plotted separately using "spread".}

\item{log2_scale}{Determines whether or not to display the counts on a log2 scale. Default is FALSE.}

\item{colours}{Specify colours for the replicates.}

\item{...}{Arguments passed to ggplot2}
}
\value{
A `ggplot2` object.
}
\description{
`plotCounts` plots a ggplot2 object visualising the raw counts from the bam files across a given region.
* this can be used as the base layer (set n_col = 1) for additional plot layers (geom_peak.new, geom_gatc, geom_de.res.lfc etc)
}
\examples{
set.seed(123)
counts.df <- random_counts()
plotCounts(counts.df,
    seqnames = "chr2L",
    start_region = 1,
    end_region = 40000,
    layout = "stacked",
    log2_scale = FALSE
)
plotCounts(counts.df,
    seqnames = "chr2L",
    start_region = 1,
    end_region = 40000,
    layout = "spread",
    log2_scale = FALSE
)
# Can use this plot to layer other plots -----------------------------
dm_results <- random_edgeR_results()
plotCounts(counts.df,
    seqnames = "chr2L",
    start_region = 1,
    end_region = 40000,
    log2_scale = FALSE
) +
    geom_dm(dm_results)
}
\references{
ggcoverage - Visualise and annotate omics coverage with ggplot2. https://github.com/showteeth/ggcoverage/tree/main
}
\seealso{
[geom_peak()] [geom_dm()] [geom_genes.tx()] [geom_gatc()] [plot_wrap()]
}
