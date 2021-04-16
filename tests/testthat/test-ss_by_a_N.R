test_that("multiplication works", {
expect_snapshot_output(
  x = 2 * 2,
  cran = FALSE
)
})
