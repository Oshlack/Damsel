#' Plotting results from differential methylation testing
#'
#' `geom_dm.res.lfc` is a ggplot2 layer that visualises the dm_results and logFC across a given region.
#'
#' * regions are coloured by dm result: 1, 0, NA (grey for NA)
#' * cannot be plotted by itself, must be added to an existing plot - see examples.
#'
#' @param dm_results.df A data.frame of differential testing results as outputted from `testDmRegions()`.
#' @param plot.space Specify gap to next plot. Recommend leaving to the default: 0.1.
#' @param plot.height Specify overall height of plot. Recommend leaving to the default: 0.1.
#'
#' @return A `ggplot_add` object.
#' @export
#' @references ggcoverage - Visualise and annotate omics coverage with ggplot2. https://github.com/showteeth/ggcoverage/tree/main
#' @seealso [geom_peak()] [plotCounts()] [geom_genes()] [geom_gatc()] [plotWrap()] [ggplot2::ggplot_add()]
#' @examples
#' set.seed(123)
#' counts.df <- random_counts()
#' dm_results <- random_edgeR_results()
#' plotCounts(counts.df,
#'     seqnames = "chr2L",
#'     start_region = 1,
#'     end_region = 40000,
#'     log2_scale = FALSE
#' ) +
#'     geom_dm(dm_results)
geom_dm <- function(dm_results.df, plot.space=0.1, plot.height=0.1) {
    structure(list(dm_results.df = dm_results.df, plot.space = plot.space,
        plot.height = plot.height),
        class = "dm"
    )
}

#' @export
ggplot_add.dm <- function(object, plot, object_name) {
    if (!is.data.frame(object$dm_results.df)) {
        stop("data.frame of dm results is required")
    }
    plot2 <- plot
    while (inherits(plot2, "patchwork")) {
        plot2 <- plot2[[1]]
    }
    plot.data <- plot2$labels$title
    plot.data <- stringr::str_split_1(plot.data, ":")
    # prepare plot range
    # the plot region are not normal, so start is minimum value
    plot.chr <- plot.data[1]
    plot.data <- stringr::str_split_1(plot.data[2], "-")
    plot.region.start <- plot.data[1] %>% as.numeric()
    plot.region.end <- plot.data[2] %>% as.numeric()

    # get parameters
    dm_results.df <- object$dm_results.df
    plot.space <- object$plot.space
    plot.height <- object$plot.height

    df_regions <- dm_results.df %>% dplyr::filter(
        .data$seqnames == plot.chr,
        .data$start >= plot.region.start,
        .data$end <= plot.region.end
    )
    df_regions <- df_regions %>%
        dplyr::mutate(
            dm = ifelse(.data$dm == -1, 0, .data$dm),
            meth_status = ifelse(.data$meth_status == "Downreg", "No_sig", .data$meth_status)
        )
    df_colour <- ..dmReshape(df_regions)

    df_fc <- ..dmMax(df_regions)

    colours_list <- c("Upreg" = "red", "Not_included" = "grey", "No_sig" = "black")

    dm_res.plot <- df_regions %>%
        ggplot2::ggplot(ggplot2::aes(x = .data$start, y = .data$logFC, colour = factor(.data$meth_status, levels = c("Upreg", "No_sig", "Not_included")))) +
        ggplot2::geom_polygon(data = df_colour, ggplot2::aes(x = .data$Position, y = .data$y_axis_2, fill = factor(.data$meth_status, levels = c("Upreg", "No_sig", "Not_included")))) +
        ggplot2::geom_segment(ggplot2::aes(xend = .data$start, yend = 0)) +
        ggplot2::geom_segment(ggplot2::aes(x = .data$end, xend = .data$end, y = .data$logFC, yend = 0)) +
        ggplot2::geom_segment(ggplot2::aes(x = .data$start, xend = .data$end, y = .data$logFC, yend = .data$logFC)) +
        ggplot2::geom_segment(ggplot2::aes(x = .data$start, xend = .data$end, y = 0, yend = 0)) +
        ..dmTheme(margin.len = plot.space, colours = colours_list, x.range = c(plot.region.start, plot.region.end)) +
        ggplot2::scale_y_continuous(
            limits = c(-(df_fc$abs_fc) - 0.5, df_fc$abs_fc + 0.5),
            expand = c(0, 0), breaks = c(-round(df_fc$abs_fc), 0, round(df_fc$abs_fc)), position = "right"
            )

    # assemble plot
    patchwork::wrap_plots(plot + ggplot2::theme(plot.margin = ggplot2::margin(t = plot.space, b = plot.space)),
        dm_res.plot,
        ncol = 1, heights = c(1, plot.height)
    )
}


..dmReshape <- function(df_regions) {
    df <- ..regionRectangle(df_regions)
    df <- df %>%
        dplyr::mutate(
            y_axis_2 = dplyr::case_when(
                .data$num == 1 ~ 0,
                .data$num == 2 ~ .data$logFC,
                .data$num == 3 ~ .data$logFC,
                TRUE ~ 0
            )
        )
    df
}

..dmMax <- function(df_regions) {
    df <- df_regions %>%
        dplyr::summarise(
            abs_max = max(.data$logFC),
            abs_min = abs(min(.data$logFC))
        ) %>%
        dplyr::mutate(
            abs_fc = pmax(.data$abs_max, .data$abs_min),
            abs_fc = round(.data$abs_fc)
        )
    df
}

..dmTheme <- function(margin.len, colours, x.range) {
    list(
        ggplot2::theme_classic(),
        ggplot2::theme(
            axis.title.y.right = ggplot2::element_text(color = "black", angle = 90, vjust = 0.5),
            axis.text.x = ggplot2::element_blank(),
            axis.title.x = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank(),
            panel.border = ggplot2::element_rect(colour = "black", fill = NA, linewidth = 1),
            plot.margin = ggplot2::margin(t = margin.len, b = margin.len)
        ),
        ggplot2::scale_colour_manual(values = colours, name = "dm_result"),
        ggplot2::scale_fill_manual(values = colours, name = "dm_result"),
        ggplot2::scale_x_continuous(expand = c(0, 0)),
        ggplot2::coord_cartesian(xlim = x.range)
    )
}
