% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene_ontology.R
\name{testGeneOntology}
\alias{testGeneOntology}
\title{Gene ontology analysis}
\usage{
testGeneOntology(
  annotation,
  genes,
  regions,
  extend_by = 2000,
  fdr_threshold = 0.05,
  bias = NULL
)
}
\arguments{
\item{annotation}{A data.frame of annotated genes and peaks as `annotate_peaks()$all`.}

\item{genes}{A data.frame of gene data as outputted from `get_biomart_genes()`.}

\item{regions}{A data.frame of GATC regions.}

\item{extend_by}{A number to extend the start and end of the genes. We recommend leaving to the default of 2000 bp.
* This is done to incorporate the acceptable distance of a peak to a gene.
* This also allows for consistency across significant and non-significant genes}

\item{fdr_threshold}{The FDR threshold used for significance in the ontology. Default is 0.05}

\item{bias}{Alternatively, the bias can be input by itself.}
}
\value{
3 objects
 * Plot of goodness of fit of model
 * Data frame of significant GO category results
 * Probability weights for each gene
}
\description{
`testGeneOntology` identifies the over-represented GO terms from the peak data, correcting for the number of GATC regions matching to each gene.
}
\examples{
library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
library(org.Dm.eg.db)
set.seed(123)
example_regions <- random_regions()
peaks <- identifyPeaks(random_edgeR_results())

txdb <- TxDb.Dmelanogaster.UCSC.dm6.ensGene
genes <- collateGenes(genes = txdb, regions = example_regions, org.Db = org.Dm.eg.db)
annotation <- annotatePeaksGenes(peaks, genes, example_regions)$all

ontology <- testGeneOntology(annotation, genes, example_regions)
ontology$signif_results
ontology$prob_weights
}
\references{
Young MD, Wakefield MJ, Smyth GK, Oshlack A (2010). “Gene ontology analysis for RNA-seq: accounting for selection bias.” Genome Biology, 11, R14.
}
