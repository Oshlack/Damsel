##geom_peak

test_that("geom_peak: output is ggplot", {
  expect_s3_class(plot_counts_all_bams(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)], seqnames = "chr2L", start_region = 1, end_region = 10000, n_col = 1) +
                    geom_peak.new(aggregate_peaks(edgeR_results(edgeR_set_up(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)])))), c("patchwork", "gg", "ggplot"))
})

test_that("geom_peak: Output is error", {
  expect_error(geom_peak.new())
  expect_error(plot_counts_all_bams(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)], seqnames = "chr2L", start_region = 1, end_region = 10000, n_col = 1) +
                 geom_peak.new())
  expect_error(plot_counts_all_bams(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)], seqnames = "chr2L", start_region = 1, end_region = 10000, n_col = 1) +
                 geom_peak.new(2), "data.frame of peaks is required")
  expect_error(plot_counts_all_bams(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)], seqnames = "chr2L", start_region = 1, end_region = 10000, n_col = 1) +
                 geom_peak.new(list(c("A", "B", 23))), "data.frame of peaks is required")
})

test_that("geom_peak: Output is no error", {
  plot_counts_all_bams(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)], seqnames = "chr2L", start_region = 1, end_region = 10000, n_col = 1) +
    geom_peak.new(aggregate_peaks(edgeR_results(edgeR_set_up(process_bams(system.file("extdata", package = "Damsel"))[,c(1:6,7,10,8,11,9,12)]))))
})