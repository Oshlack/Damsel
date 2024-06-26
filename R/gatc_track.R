#' Extract GATC regions
#'
#' `getGatcRegions` identifies and extracts the GATC sites and regions from a BSgenome object or a fasta file.
#'
#' @param object A BSgenome package OR the path to a FASTA file.
#'
#' @return A `GRangesList` object of two GRanges; regions - providing the coordinates between adjacent GATC sites, and sites - providing the coordinates of the GATC sites.
#' @export
#' @examples
#' if (require("BSgenome.Dmelanogaster.UCSC.dm6")) {
#'     gatc <- getGatcRegions(BSgenome.Dmelanogaster.UCSC.dm6::BSgenome.Dmelanogaster.UCSC.dm6)
#'
#'     head(gatc$regions)
#'
#'     head(gatc$sites)
#' }
getGatcRegions <- function(object) {
    if (missing(object)) {
        stop("Must have a BSgenome object such as BSgenome.Dmelanogaster.UCSC.dm6, OR the path to a FASTA file")
    }
    if (!inherits(object, "BSgenome")) {
        stop("Must have a BSgenome object such as BSgenome.Dmelanogaster.UCSC.dm6, OR the path to a FASTA file")
    }
    if (inherits(object, "BSgenome")) {
        fasta <- object
        names_fasta <- GenomeInfoDb::seqnames(object)
    } else if (inherits(object, "character")) {
        fasta <- Biostrings::readDNAStringSet(object)
        names_fasta <- names(fasta)
    }

    length_names <- stringr::str_detect(names_fasta, "Y") %>%
        grep("TRUE", ., ) %>%
        .[1]
    seq_names <- names_fasta[seq_len(length_names)]

    df <- lapply(seq_names, function(x) {
        cbind(data.frame(Biostrings::matchPattern("GATC", fasta[[x]])),
            seqnames = x
        )
    }) %>%
        dplyr::bind_rows()
    if(!"NCBI" %in% GenomeInfoDb::seqlevelsStyle(names_fasta)) {
        df <- ..changeStyle(df, "NCBI", names_fasta)
    }
    df <- df %>%
        dplyr::mutate(Position = paste0("chr", .data$seqnames, "-", start),
            strand = "*")

    df <- df[, c("Position", "seqnames", "start", "end", "width", "strand"), drop = FALSE]

    regions <- df %>%
        dplyr::group_by(.data$seqnames) %>%
        dplyr::mutate(
            start = .data$start + 2,
            end = dplyr::lead(.data$start - 1)
        ) %>%
        dplyr::filter(!is.na(.data$end)) %>%
        dplyr::mutate(width = .data$end - .data$start + 1) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(
            Position = paste0("chr", .data$seqnames, "-", .data$start)
        )

    GenomicRanges::GRangesList(regions = regions, sites = df)
}
