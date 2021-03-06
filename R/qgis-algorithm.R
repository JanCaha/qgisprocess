#' Run algorithms using 'qgis_process'
#'
#' Run QGIS algorithms.
#' See the [QGIS docs](https://docs.qgis.org/testing/en/docs/user_manual/processing_algs/qgis/index.html)
#' for a detailed description of the algorithms provided
#' 'out of the box' on QGIS (versions >= 3.14).
#'
#' @param algorithm A qualified algorithm name (e.g., "native:filedownloader") or
#'   a path to a QGIS model file.
#' @param provider A provider identifier (e.g., "native")
#' @param PROJECT_PATH,ELIPSOID Global values for QGIS project file and
#'   elipsoid name for distance calculations.
#' @param ... Named key-value pairs as arguments for each algorithm. Features of
#'   [rlang::list2()] are supported.
#' @param .quiet Use `TRUE` to suppress output from processing algorithms.
#'
#' @export
#'
#' @examples
#' if (has_qgis()) qgis_has_algorithm("native:filedownloader")
#' if (has_qgis()) qgis_has_provider("native")
#' if (has_qgis()) qgis_providers()
#'
qgis_run_algorithm <- function(algorithm, ..., PROJECT_PATH = rlang::zap(), ELIPSOID = rlang::zap(),
                               .quiet = FALSE) {
  assert_qgis()
  assert_qgis_algorithm(algorithm)

  # use list2 so that users can !!! argument lists
  # zap() means don't include (NULL may have meaning for some types)
  args <- rlang::list2(..., PROJECT_PATH = PROJECT_PATH, ELIPSOID = ELIPSOID)
  args <- args[!vapply(args, rlang::is_zap, logical(1))]

  if (length(args) > 0) {
    if (!rlang::is_named(args)) {
      abort("All arguments to `qgis_run_algorithm()` must be named.")
    }

    # get argument info for supplied args and run sanitizers
    arg_meta <- qgis_arguments(algorithm)
    arg_meta <- arg_meta[match(names(args), arg_meta$name), ]
    args <- Map(
      # have to do this omitting errors so that qgis_clean_argument()
      # is called on anything that succeeded regardless of other arg failures
      function(x, qgis_type) try(as_qgis_argument(x, qgis_type), silent = TRUE),
      args, arg_meta$qgis_type
    )

    # make sure cleanup is run on any temporary files created
    on.exit(Map(qgis_clean_argument, args, arg_meta$qgis_type))

    # look for sanitizer errors and stop() for them
    arg_errors <- vapply(args, inherits, "try-error", FUN.VALUE = logical(1))
    if (any(arg_errors)) {
      abort(args[arg_errors][[1]])
    }
  }

  args_str <- paste0("--", names(args), "=", vapply(args, as.character, character(1)))

  if (.quiet) {
    result <- qgis_run(args = c("run", algorithm, args_str))
  } else {
    result <- qgis_run(
      args = c("run", algorithm, args_str),
      echo_cmd = TRUE,
      stdout_callback = function(x, ...) cat(x),
      stderr_callback = function(x, ...) message(x, appendLF = FALSE)
    )
    cat("\n")
  }

  # return a custom object to keep as much information as possible
  # about the output
  structure(
    rlang::list2(
      # ... eventually, this will contain the parsed output values
      !!! qgis_parse_results(algorithm, result$stdout),
      .algorithm = algorithm,
      .args = args,
      .processx_result = result
    ),
    class = "qgis_result"
  )
}

#' @rdname qgis_run_algorithm
#' @export
qgis_has_algorithm <- function(algorithm) {
  assert_qgis()
  as.character(algorithm) %in% qgis_algorithms()$algorithm
}

#' @rdname qgis_run_algorithm
#' @export
qgis_has_provider <- function(provider) {
  assert_qgis()
  as.character(provider) %in% unique(qgis_algorithms()$provider)
}

#' @rdname qgis_run_algorithm
#' @export
qgis_providers <- function(provider) {
  assert_qgis()
  algs <- qgis_algorithms()
  algs[!duplicated(algs$provider), c("provider", "provider_title")]
}

#' @rdname qgis_run_algorithm
#' @export
assert_qgis_algorithm <- function(algorithm) {
  if (!is.character(algorithm) || length(algorithm) != 1) {
    abort("`algorithm` must be a character vector of length 1")
  } else if (!qgis_has_algorithm(algorithm)) {
    abort(
      glue(
        "Can't find QGIS algorithm '{ algorithm }'.\nRun `qgis_algorithms()` for a list of available algorithms."
      )
    )
  }

  invisible(algorithm)
}
