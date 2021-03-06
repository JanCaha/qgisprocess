
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qgisprocess

<!-- badges: start -->

[![R build
status](https://github.com/paleolimbot/qgisprocess/workflows/R-CMD-check/badge.svg)](https://github.com/paleolimbot/qgisprocess/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `qgisprocess` is to provide an R interface to the popular
and open source desktop geographic information system (GIS) program
[QGIS](https://qgis.org/en/site/). The package is a re-implementation of
functionality provided by the archived
[RQGIS](https://cran.r-project.org/package=RQGIS) package, which was
partially revived in the [RQGIS3](https://github.com/r-spatial/RQGIS3)
package.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("paleolimbot/qgisprocess")
```

The qgisprocess package wraps the `qgis_process` command-line utility,
which is available in QGIS \>=
[3.14.16](https://github.com/qgis/QGIS/releases/tag/final-3_14_16),
[released](https://qgis.org/en/site/getinvolved/development/roadmap.html)
in September 2020. MacOS users will have to install a [recent nightly
build](https://qgis.org/en/site/forusers/alldownloads.html#qgis-nightly-release)
until QGIS 3.16 has been released; download instructions for all
platforms are available at <https://download.qgis.org/>. If a recent
version of QGIS isn’t available for your OS, you can use one of the
[Geocomputation with R Docker
images](https://github.com/geocompr/docker) with QGIS installed.

## Example

The following example demonstrates the
[buffer](https://docs.qgis.org/testing/en/docs/user_manual/processing_algs/qgis/vectorgeometry.html#buffer)
algorithm in action. The passing of [sf](https://r-spatial.github.io/sf)
and [raster](https://cran.r-project.org/package=raster) objects is
experimentally supported (and will be well-supported in the future\!).

``` r
library(qgisprocess)
#> Using 'qgis_process' at '/Applications/QGIS.app/Contents/MacOS/bin/qgis_process'.
#> Run `qgis_configure()` for details.
input <- sf::read_sf(system.file("shape/nc.shp", package = "sf"))

result <- qgis_run_algorithm(
  "native:buffer",
  INPUT = input,
  DISTANCE = 1,
  SEGMENTS = 10,
  DISSOLVE = TRUE,
  END_CAP_STYLE = 0,
  JOIN_STYLE = 0,
  MITER_LIMIT = 10,
  OUTPUT = qgis_tmp_vector()
)
#> Running /Applications/QGIS.app/Contents/MacOS/bin/qgis_process run \
#>   'native:buffer' \
#>   '--INPUT=/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e12aabbdc.gpkg' \
#>   '--DISTANCE=1' '--SEGMENTS=10' '--DISSOLVE=TRUE' '--END_CAP_STYLE=0' \
#>   '--JOIN_STYLE=0' '--MITER_LIMIT=10' \
#>   '--OUTPUT=/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e2b6d447a.gpkg'
#> 
#> ----------------
#> Inputs
#> ----------------
#> 
#> DISSOLVE:    TRUE
#> DISTANCE:    1
#> END_CAP_STYLE:   0
#> INPUT:   /var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e12aabbdc.gpkg
#> JOIN_STYLE:  0
#> MITER_LIMIT: 10
#> OUTPUT:  /var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e2b6d447a.gpkg
#> SEGMENTS:    10
#> 
#> 
#> 0...10...20...30...40...50...60...70...80...90...
#> ----------------
#> Results
#> ----------------
#> 
#> OUTPUT:  /var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e2b6d447a.gpkg

result
#> <Result of `qgis_run_algorithm("native:buffer", ...)`>
#> List of 1
#>  $ OUTPUT: 'qgis_outputVector' chr "/var/folders/bq/2rcjstv90nx1_wrt8d3gqw6m0000gn/T//RtmpZfnsJA/file11f8e53c6f6ae/file11f8e2b6d447a.gpkg"

output_sf <- sf::read_sf(qgis_output(result, "OUTPUT"))
plot(sf::st_geometry(output_sf))
```

<img src="man/figures/README-buffer-1.png" width="100%" />

You can read the help associated with an algorithm using
`qgis_show_help()`:

``` r
qgis_show_help("native:buffer")
#> Buffer (native:buffer)
#> 
#> ----------------
#> Description
#> ----------------
#> This algorithm computes a buffer area for all the features in an input layer, using a fixed or dynamic distance.
#> 
#> The segments parameter controls the number of line segments to use to approximate a quarter circle when creating rounded offsets.
#> 
#> The end cap style parameter controls how line endings are handled in the buffer.
#> 
#> The join style parameter specifies whether round, miter or beveled joins should be used when offsetting corners in a line.
#> 
#> The miter limit parameter is only applicable for miter join styles, and controls the maximum distance from the offset curve to use when creating a mitered join.
#> 
#> ----------------
#> Arguments
#> ----------------
#> 
#> INPUT: Input layer
#>  Argument type:  source
#>  Acceptable values:
#>      - Path to a vector layer
#> DISTANCE: Distance
#>  Argument type:  distance
#>  Acceptable values:
#>      - A numeric value
#> SEGMENTS: Segments
#>  The segments parameter controls the number of line segments to use to approximate a quarter circle when creating rounded offsets.
#>  Argument type:  number
#>  Acceptable values:
#>      - A numeric value
#> END_CAP_STYLE: End cap style
#>  Argument type:  enum
#>  Available values:
#>      - 0: Round
#>      - 1: Flat
#>      - 2: Square
#>  Acceptable values:
#>      - Number of selected option, e.g. '1'
#>      - Comma separated list of options, e.g. '1,3'
#> JOIN_STYLE: Join style
#>  Argument type:  enum
#>  Available values:
#>      - 0: Round
#>      - 1: Miter
#>      - 2: Bevel
#>  Acceptable values:
#>      - Number of selected option, e.g. '1'
#>      - Comma separated list of options, e.g. '1,3'
#> MITER_LIMIT: Miter limit
#>  Argument type:  number
#>  Acceptable values:
#>      - A numeric value
#> DISSOLVE: Dissolve result
#>  Argument type:  boolean
#>  Acceptable values:
#>      - 1 for true/yes
#>      - 0 for false/no
#> OUTPUT: Buffered
#>  Argument type:  sink
#>  Acceptable values:
#>      - Path for new vector layer
#> 
#> ----------------
#> Outputs
#> ----------------
#> 
#> OUTPUT: <outputVector>
#>  Buffered
```

It may also be useful to run an algorithm in the QGIS GUI and examine
the console ‘Input parameters’ to determine how the various input values
are translated to string processing arguments:

![](man/figures/qgis-buffer.png)

A list of available algorithms can be found using `qgis_algorithms()`.
When using R interactively, it may be useful to use
`View(qgis_algorithms())` to search.

``` r
qgis_algorithms()
#> # A tibble: 971 x 5
#>    provider provider_title algorithm         algorithm_id    algorithm_title    
#>    <chr>    <chr>          <chr>             <chr>           <chr>              
#>  1 3d       QGIS (3D)      3d:tessellate     tessellate      Tessellate         
#>  2 gdal     GDAL           gdal:aspect       aspect          Aspect             
#>  3 gdal     GDAL           gdal:assignproje… assignprojecti… Assign projection  
#>  4 gdal     GDAL           gdal:buffervecto… buffervectors   Buffer vectors     
#>  5 gdal     GDAL           gdal:buildvirtua… buildvirtualra… Build virtual rast…
#>  6 gdal     GDAL           gdal:buildvirtua… buildvirtualve… Build virtual vect…
#>  7 gdal     GDAL           gdal:cliprasterb… cliprasterbyex… Clip raster by ext…
#>  8 gdal     GDAL           gdal:cliprasterb… cliprasterbyma… Clip raster by mas…
#>  9 gdal     GDAL           gdal:clipvectorb… clipvectorbyex… Clip vector by ext…
#> 10 gdal     GDAL           gdal:clipvectorb… clipvectorbypo… Clip vector by mas…
#> # … with 961 more rows
```

## Further reading

  - A
    [paper](https://journal.r-project.org/archive/2017/RJ-2017-067/index.html)
    on the original RQGIS package published in the R Journal
  - A [discussion](https://github.com/r-spatial/discuss/issues/41)
    options for running QGIS from R that led to this package
  - The [pull request](https://github.com/qgis/QGIS/pull/34617) in the
    QGIS repo that led to the development of the `qgis_process`
    command-line utility
