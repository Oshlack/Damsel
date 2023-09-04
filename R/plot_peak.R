geom_peak.new <- function(bed.file = NULL, peak.df = NULL, peak.color = "black", peak.size = 5,
                          plot.space = 0.1, plot.height = 0.1) {
  structure(list(
    bed.file = bed.file, peak.df = peak.df, peak.color = peak.color, peak.size = peak.size,
    plot.space = plot.space, plot.height = plot.height
  ),
  class = "peak.new"
  )
}

ggplot_add.peak.new <- function(object, plot, object_name) {
  # get plot data
  # get plot data, plot data should contain bins
  if (("patchwork" %in% class(plot)) && length(plot[[1]]$layers) == 1) {
    plot.data <- plot[[1]]$layers[[1]]$data
  } else if ("patchwork" %in% class(plot) && length(plot[[1]]$layers) == 2) {
    plot.data <- plot[[1]]$layers[[2]]$data
    colnames(plot.data) <- c("start", "end", "y1", "y2", "seqnames")
  } else if (!("patchwork" %in% class(plot)) && length(plot$layers) == 1) {
    plot.data <- plot$layers[[1]]$data
  } else if (!("patchwork" %in% class(plot)) && length(plot$layers) == 2) {
    plot.data <- plot$layers[[2]]$data
    colnames(plot.data) <- c("start", "end", "y1", "y2", "seqnames")
  }
  # prepare plot range
  # the plot region are not normal, so start is minimum value
  plot.chr <- as.character(plot.data[1, "seqnames"])
  plot.region.start <- min(plot.data[, "start"])
  plot.region.end <- max(plot.data[, "end"])

  # get parameters
  bed.file <- object$bed.file
  peak.df <- object$peak.df
  peak.color <- object$peak.color
  peak.size <- object$peak.size
  plot.space <- object$plot.space
  plot.height <- object$plot.height

  # prepare peak dataframe
  if (!is.null(bed.file)) {
    bed.info <- utils::read.table(file = bed.file, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
  } else if (!is.null(peak.df)) {
    bed.info <- peak.df
  }
  bed.info <- bed.info[c(1, 2, 3)]
  colnames(bed.info) <- c("seqnames", "start", "end")
  # convert to 1-based
  bed.info$start <- as.numeric(bed.info$start) + 1

  # get valid bed
  valid.bed <- GetRegion_hack(chr = plot.chr, df = bed.info, start = plot.region.start, end = plot.region.end)

  peak.plot <- ggplot() +
    geom_segment(
      data = valid.bed,
      mapping = aes_string(
        x = "start",
        y = "1",
        xend = "end",
        yend = "1"
      ),
      size = peak.size,
      color = peak.color
    ) +
    labs(y = "Peak")

  # add theme
  peak.plot <- peak.plot + theme_peak_hack(margin.len = plot.space, x.range = c(plot.region.start, plot.region.end))
  # assemble plot
  patchwork::wrap_plots(plot + theme(plot.margin = margin(t = plot.space, b = plot.space)),
                        peak.plot,
                        ncol = 1, heights = c(1, plot.height)
  )
}


GetRegion_hack <- function(df, chr, start, end = NULL) {
  # subset used chromosome
  df <- df[df$seqnames == chr, ] %>% dplyr::arrange(start)
  rownames(df) <- NULL

  df.select <- df[df$end >= start & df$start <= end, ]
  init.start <- df.select[1, "start"]
  if (init.start < start) {
    df.select[1, "start"] <- start
  }
  if (!is.null(end)) {
    final.end <- df.select[nrow(df.select), "end"]
    if (final.end > end) {
      df.select[nrow(df.select), "end"] <- end
    }
  }
  return(df.select)
}

theme_peak_hack <- function(margin.len, x.range) {
  list(
    theme_classic(),
    theme(
      axis.line.y = element_blank(),
      axis.text.y = element_blank(),
      axis.title.y.right = element_text(color = "black", angle = 90, vjust = 0.5),
      axis.ticks.y = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank(),
      axis.ticks.x = element_blank(),
      panel.border = element_rect(colour = "black", fill = NA, size = 1),
      plot.margin = margin(t = margin.len, b = margin.len)
    ),
    scale_y_continuous(
      limits = c(1 - 0.1, 1 + 0.1),
      expand = c(0, 0), position = "right"
    ),
    scale_x_continuous(expand = c(0, 0)),
    coord_cartesian(xlim = x.range)
  )
}