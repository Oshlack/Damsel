#' Create example regions
#'
#' @param size number of rows to create
#'
#' @return example data.frame with output similar to `gatc_track()$regions`
#' @export
#' @examples
#' head(random_regions(size = 50))
random_regions <- function(size=50) {
    df <- list(start = 50, end = 85, width = 36) %>% data.frame()
    size_n <- size - 1
    random_width <- floor(stats::runif(size_n, 5, 1000))
    for (i in seq_len(size_n)) {
        new_start <- df[i, "end"] + 1
        df[nrow(df) + 1, ] <- list(start = new_start, end = (new_start + random_width[i] - 1), width = random_width[i])
    }
    df$seqnames <- "2L"
    df$strand <- "*"
    row.names(df) <- NULL
    df$Position <- paste0("chr", df$seqnames, "-", df$start)
    df[, c("Position", "seqnames", "start", "end", "width", "strand"), drop = FALSE]
}



#' Create example counts
#'
#' @param size number of rows to create
#'
#' @return example data.frame of counts similar to `process_bams()`
#' @export
#' @examples
#' head(random_counts(size = 50))
random_counts <- function(size=50) {
    counts <- random_regions(size)
    size <- nrow(counts)
    counts$Dam_1.bam <- stats::rnorm(size, 100)
    counts$Fusion_1.bam <- stats::rnorm(size, 400)
    counts$Dam_2.bam <- counts$Dam_1.bam + 7
    counts$Fusion_2.bam <- counts$Fusion_1.bam - 2
    counts$seqnames <- paste0("chr", counts$seqnames)
    counts
}


#' Create example edgeR results
#'
#' @param size number of rows to create
#'
#' @return example data.frame of edgeR results, output similar to `edgeR_results()`
#' @export
#' @examples
#' head(random_edgeR_results(size = 50))
random_edgeR_results <- function(size=50) {
    results <- random_regions(size)
    results$seqnames <- paste0("chr", results$seqnames)
    results$number <- seq_len(size)
    dm_options <- c(0, 1, NA, -1)
    peak <- rep(1, each = 4)
    zero <- rep(0, each = 2)
    pairs <- rep(dm_options, each = 2)
    threes <- rep(dm_options, each = 3)
    all <- c(dm_options, dm_options, dm_options, dm_options, peak, pairs, peak, zero, threes, peak)
    results$dm <- all
    results$logFC <- dplyr::case_when(
        results$dm == 1 ~ runif(1, 1, 5),
        results$dm == 0 ~ runif(1, -1.5, 1.5),
        results$dm == -1 ~ runif(1, -7, -1),
        TRUE ~ 0
    )
    results$PValue <- dplyr::case_when(
        results$dm == 1 ~ runif(1, 5.58e-07, 0.05),
        results$dm == 0 ~ runif(1, 9.4e-02, 1),
        results$dm == -1 ~ runif(1, 2.93e-06, 0.05),
        TRUE ~ 1
    )
    results$adjust.p <- stats::p.adjust(results$PValue, method = "BH")
    results$meth_status <- dplyr::case_when(
        results$dm == 1 ~ "Upreg",
        results$dm == 0 ~ "No_signal",
        results$dm == -1 ~ "Downreg",
        TRUE ~ "Not_included"
    )
    results
}


..changeStyle <- function(df, style, seq_names=NULL) {
    df_ <- plyranges::as_granges(df)
    if(is.null(seq_names)) {
        seq_names <- GenomeInfoDb::seqlevels(df_)
    }
    newStyle <- GenomeInfoDb::mapSeqlevels(seqnames = seq_names, style = {{style}})
    newStyle <- newStyle[stats::complete.cases(newStyle)]
    df_ <- GenomeInfoDb::renameSeqlevels(x = df_, value = newStyle)
    df_ <- data.frame(df_)
    df_
}
