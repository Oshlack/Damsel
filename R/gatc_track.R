
#' Extract GATC regions
#'
#' `gatc_region_fn` identifies and extracts the GATC sites and regions from a BSgenome object or a fasta file.
#'
#' @param BSgenome_object A BSgenome package.
#' @param path_to_fasta An ensembl
#'
#' @return A list object composed of two data.frames
#' * GATC regions for use in analysis
#' * GATC sites, can be used in plotting of results
#' @export
#' @examples
#'
#'
gatc_region_fn <- function(BSgenome_object=NULL, path_to_fasta=NULL) {
  if(!is.null(BSgenome_object)) {
    fasta <- BSgenome_object
    names_fasta <- GenomeInfoDb::seqnames(BSgenome_object)
    length_names <- stringr::str_detect(names_fasta, "M")
  } else {
    fasta <- Biostrings::readDNAStringSet(path_to_fasta)
    names_fasta <- names(fasta)
    length_names <- stringr::str_detect(names_fasta, "mito")
  }

  length_names <- length_names %>%
    grep("TRUE", .) %>%
    .[1] - 1
  i <- 1
  df <- cbind(start = 1, end = 1, width = 1, seq = "GATC", seqnames = "chr0") %>%
    data.frame() %>%
    dplyr::mutate(start = as.numeric(.data$start),
                  end = as.numeric(.data$end),
                  width = as.numeric(.data$width))

  for(i in 1:length_names) {
    df <- rbind(df, dplyr::mutate(data.frame(Biostrings::matchPattern("GATC", fasta[[i]])),
                                  seqnames = sub(" .*", "", names_fasta[[i]])))
  }

  df <- df[2:nrow(df), c("seqnames", "start", "end", "width")]
  df$strand <- as.factor("*")
  rownames(df) <- NULL
  df$start <- df$start - 1
  df$width <- 5

  regions <- df %>%
    dplyr::group_by(.data$seqnames) %>%
    dplyr::mutate(start = .data$start + 3,
                  end = dplyr::lead(.data$start) - 1) %>%
    dplyr::filter(!is.na(.data$end)) %>%
    dplyr::mutate(width = .data$end - .data$start + 1) %>%
    dplyr::ungroup()

  list(regions = regions, sites = df)
}