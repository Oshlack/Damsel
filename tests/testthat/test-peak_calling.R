## new peaks fn
test_that("peaks_new:Output is a data.frame", {
    expect_s3_class(identifyPeaks(testDmRegions(makeDGE(readRDS(test_path("fixtures", "test_counts_df.rds"))), regions = readRDS(test_path("fixtures", "regions.rds")))), "data.frame")
})

test_that("peaks_new:Output is error", {
    expect_error(identifyPeaks())
    expect_error(identifyPeaks(dm_results = list(a = c(1, 2), b = c("E", "F"))), "Must have data frame of differential_testing results from `testDmRegions`") # , ignore.case = TRUE)
})


test_that("peaks_new:Output is not error", {
    expect_no_error(identifyPeaks(testDmRegions(readRDS(test_path("fixtures", "test_dge.rds")), regions = readRDS(test_path("fixtures", "regions.rds")))))
})
