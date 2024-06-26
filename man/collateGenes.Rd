% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene_annotation.R
\name{collateGenes}
\alias{collateGenes}
\title{Get list of genes}
\usage{
collateGenes(genes, regions, org.Db = NULL, version = NULL)
}
\arguments{
\item{genes}{A Txdb object, path to file, or a species for accessing biomaRt.}

\item{regions}{GATC region file.}

\item{org.Db}{Required if using a Txdb object so to access gene names.}

\item{version}{Required for using biomaRt.}
}
\value{
A GRanges object of genes and available supplementary information - specifically the TSS, and number of GATC regions overlapping the gene.
}
\description{
Takes a Txdb object, path to a gff file, or a species (biomaRt) and returns a GRanges of genes.
}
\examples{
library(TxDb.Dmelanogaster.UCSC.dm6.ensGene)
library(org.Dm.eg.db)
set.seed(123)
example_regions <- random_regions()
txdb <- TxDb.Dmelanogaster.UCSC.dm6.ensGene
genes <- collateGenes(genes = txdb, regions = example_regions, org.Db = org.Dm.eg.db)
head(genes)
}
\references{
Carlson M (2019). org.Dm.eg.db: Genome wide annotation for Fly. R package version 3.8.2.
Durinck S, Spellman P, Birney E, Huber W (2009). “Mapping identifiers for the integration of genomic datasets with the R/Bioconductor package biomaRt.” Nature Protocols, 4, 1184–1191.
Durinck S, Moreau Y, Kasprzyk A, Davis S, De Moor B, Brazma A, Huber W (2005). “BioMart and Bioconductor: a powerful link between biological databases and microarray data analysis.” Bioinformatics, 21, 3439–3440.
Lee, Stuart, Cook, Dianne, Lawrence, Michael (2019). “plyranges: a grammar of genomic data transformation.” Genome Biol., 20(1), 4. http://dx.doi.org/10.1186/s13059-018-1597-8.
Team BC, Maintainer BP (2019). TxDb.Dmelanogaster.UCSC.dm6.ensGene: Annotation package for TxDb object(s). R package version 3.4.6.
}
