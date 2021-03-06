context("Tool: ROCR")
# Test ToolROCR
#      create_toolset
#

test_that("ToolROCR - R6ClassGenerator", {
  expect_true(is(ToolROCR, "R6ClassGenerator"))
  expect_equal(attr(ToolROCR, "name"), "ToolROCR_generator")

  expect_equal(grep("ROCR", body(ToolROCR$private_methods$f_wrapper))[[1]], 2)
})

test_that("ToolROCR - R6", {
  toolset <- ToolROCR$new()

  expect_true(is(toolset, "ToolROCR"))
  expect_true(is(toolset, "ToolIFBase"))
  expect_true(is(toolset, "R6"))
})

test_that("create_toolset", {
  toolset1 <- create_toolset("ROC")[[1]]
  expect_true(is(toolset1, "ToolROCR"))
  expect_equal(toolset1$get_toolname(), "ROCR")

  toolset2 <- create_toolset("roc")[[1]]
  expect_true(is(toolset2, "ToolROCR"))
  expect_equal(toolset2$get_toolname(), "ROCR")
})

test_that("create_toolset: calc_auc", {
  toolset1 <- create_toolset("ROCR")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_calc_auc, TRUE)

  toolset2 <- create_toolset("ROCR", calc_auc = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_calc_auc, FALSE)
})

test_that("create_toolset: store_res", {
  toolset1 <- create_toolset("ROCR")[[1]]
  expect_equal(environment(toolset1$clone)$private$def_store_res, TRUE)

  toolset2 <- create_toolset("ROCR", store_res = FALSE)[[1]]
  expect_equal(environment(toolset2$clone)$private$def_store_res, FALSE)
})

test_that(".rocr_wrapper", {
  testset <- create_testset("curve", "c1")[[1]]
  res <- .rocr_wrapper(testset)

  expect_equal(res$x, c(0.0, 0.5, 1.0, 1.0))
  expect_equal(res$y, c(NA, 1.0, 0.6666667, 0.5), tolerance = .001)
  expect_true(is.na(res$auc))

  res2 <- .rocr_wrapper(testset, store_res = FALSE)
  expect_true(is.null(res2))

  res3 <- .rocr_wrapper(testset, calc_auc = TRUE)
  expect_equal(res3$x, c(0.0, 0.5, 1.0, 1.0))
  expect_equal(res3$y, c(NA, 1.0, 0.6666667, 0.5), tolerance = .001)
  expect_equal(res3$auc, 0.9166667, tolerance = .001)
})
