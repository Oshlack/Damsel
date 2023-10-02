##plot_wrap

test_that("plot_wrap: output is ggplot", {
  expect_s3_class(plot_wrap(seqnames = "chr2L", start_region = 1, end_region = 10000,
                            counts = readRDS(test_path("fixtures", "test_counts_df.rds")),
                            de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                            peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                            genes = readRDS(test_path("fixtures", "test_genes.rds")),
                            gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)), c("patchwork", "gg", "ggplot"))
})

test_that("plot_wrap: output is error", {
  expect_error(plot_wrap(counts = readRDS(test_path("fixtures", "test_counts_df.rds")),
                         de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                         peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                         genes = readRDS(test_path("fixtures", "test_genes.rds")),
                         gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)))
    expect_error(plot_wrap(peak_id = "abs",
                              counts = readRDS(test_path("fixtures", "test_counts_df.rds")),
                              de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                              peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                              genes = readRDS(test_path("fixtures", "test_genes.rds")),
                              gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)), "Peak_id is not in provided peaks data.frame")
    expect_error(plot_wrap(gene_id = "ENSG12ab",
                           counts = readRDS(test_path("fixtures", "test_counts_df.rds")),
                           de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                           peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                           genes = readRDS(test_path("fixtures", "test_genes.rds")),
                           gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)), "Gene_id is not in provided genes data.frame")
    expect_error(plot_wrap(peak_id = "8",
                           de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                           peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                           genes = readRDS(test_path("fixtures", "test_genes.rds")),
                           gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)))

})


test_that("plot_wrap: output is no error", {
  expect_no_error(plot_wrap(seqnames = "chr2L", start_region = 1, end_region = 10000,
                            counts = readRDS(test_path("fixtures", "test_counts_df.rds")),
                            de_results = add_de(readRDS(test_path("fixtures", "test_results.rds")), regions_gatc_drosophila_dm6),
                            peaks = readRDS(test_path("fixtures", "test_peaks.rds")),
                            genes = readRDS(test_path("fixtures", "test_genes.rds")),
                            gatc_sites = dplyr::mutate(regions_gatc_drosophila_dm6, seqnames = paste0("chr", seqnames), start = start - 3, end = start + 4)))
})
