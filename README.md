
# phootbiologySensors <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![CRAN
version](https://www.r-pkg.org/badges/version-last-release/photobiologySensors)](https://cran.r-project.org/package=photobiologySensors)
[![cran
checks](https://cranchecks.info/badges/worst/photobiologySensors)](https://cran.r-project.org/web/checks/check_results_photobiologySensors.html)[![R-CMD-check](https://github.com/aphalo/photobiologySensors/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/aphalo/photobiologySensors/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Package **photobiologySensors** is a collection of spectral
responsiveness data for different broadband sensors and of angular
response data for some of the same sensors and for cosine diffusers and
other entrance optics used with spectrometers. It complements other
packages in the suite of R packages for photobiology ‘r4photobiology’.
This package contains only data.

## Code breaking renaming of data objects

In the update to version 0.5.0 several members of the collection of
filter spectra were renamed to ensure consistency and clarity. As of
version 0.5.0 all member names start with the name of the manufacturer
or supplier. In addition, several of the vectors of names of member
spectra were renamed to include the word “sensors” to avoid possible
name clashes with other packages and also to improve naming consistency.

## Examples

``` r
library(photobiologySensors)
```

How many spectra are included in the current version of
‘photobiologyFilters’?

``` r
length(sensors.mspct)
#> [1] 40
```

What are the names of available spectra? We use `head()` to limit the
output.

``` r
# list names of the first 10 filters
head(names(sensors.mspct), 10)
#>  [1] "Analytik_Jena_UVX25" "Analytik_Jena_UVX31" "Analytik_Jena_UVX36"
#>  [4] "Berger_UV_Biometer"  "DeltaT_BF5"          "flat_e"             
#>  [7] "flat_q"              "KIPP_CUV_5"          "KIPP_PQS1"          
#> [10] "KIPP_UVS_A"
```

To subset based on different criteria we can use predefined character
vectors of filter names. For example, vector `licor_sensors` lists the
names of the spectra for sensors from LI-COR.

``` r
licor_sensors
#> [1] "LICOR_LI_190SA" "LICOR_LI_200"   "LICOR_LI_210"   "LICOR_LI_190"  
#> [5] "LICOR_LI_190R"  "LICOR_LI_210R"
```

We can use the vector to extract all these spectra as a collection.

``` r
sensors.mspct[licor_sensors]
#> Object: response_mspct [6 x 1]
#> --- Member: LICOR_LI_190SA ---
#> Object: response_spct [755 x 2]
#> Wavelength range 365.614-742.99 nm, step 0.5004987 nm 
#> Time unit 1s
#> 
#> # A tibble: 755 × 2
#>    w.length s.q.response
#>       <dbl>        <dbl>
#>  1     366.      0.00181
#>  2     366.      0.00188
#>  3     367.      0.00195
#>  4     367.      0.00202
#>  5     368.      0.00209
#>  6     368.      0.00217
#>  7     369.      0.00224
#>  8     369.      0.00231
#>  9     370.      0.00238
#> 10     370.      0.00245
#> # … with 745 more rows
#> --- Member: LICOR_LI_200 ---
#> Object: response_spct [64 x 2]
#> Wavelength range 376.154-1106.97 nm, step 2.68-51.052 nm 
#> Time unit 1s
#> 
#> # A tibble: 64 × 2
#>    w.length s.e.response
#>       <dbl>        <dbl>
#>  1     376.       0.0272
#>  2     382.       0.0543
#>  3     392.       0.0788
#>  4     395.       0.106 
#>  5     400.       0.133 
#>  6     406.       0.160 
#>  7     414.       0.185 
#>  8     425.       0.209 
#>  9     435.       0.234 
#> 10     451.       0.255 
#> # … with 54 more rows
#> --- Member: LICOR_LI_210 ---
#> Object: response_spct [78 x 2]
#> Wavelength range 382.387-715.931 nm, step 1.683-10.516 nm 
#> Time unit 1s
#> 
#> # A tibble: 78 × 2
#>    w.length s.e.response
#>       <dbl>        <dbl>
#>  1     382.      0.00335
#>  2     387.      0.00670
#>  3     390.      0.00838
#>  4     395.      0.0101 
#>  5     403.      0.0101 
#>  6     411.      0.0117 
#>  7     414.      0.0117 
#>  8     417.      0.0134 
#>  9     420.      0.0151 
#> 10     424.      0.0168 
#> # … with 68 more rows
#> --- Member: LICOR_LI_190 ---
#> Object: response_spct [834 x 2]
#> Wavelength range 381.85375-798.83668 nm, step 0.5005798 nm 
#> Time unit 1s
#> 
#> # A tibble: 834 × 2
#>    w.length s.e.response
#>       <dbl>        <dbl>
#>  1     382.       0.0281
#>  2     382.       0.0298
#>  3     383.       0.0314
#>  4     383.       0.0331
#>  5     384.       0.0347
#>  6     384.       0.0363
#>  7     385.       0.0379
#>  8     385.       0.0391
#>  9     386.       0.0403
#> 10     386.       0.0415
#> # … with 824 more rows
#> --- Member: LICOR_LI_190R ---
#> Object: response_spct [834 x 2]
#> Wavelength range 380.76093-797.90271 nm, step 0.5007704 nm 
#> Time unit 1s
#> 
#> # A tibble: 834 × 2
#>    w.length s.q.response
#>       <dbl>        <dbl>
#>  1     381.      0.00469
#>  2     381.      0.00469
#>  3     382.      0.00468
#>  4     382.      0.00468
#>  5     383.      0.00468
#>  6     383.      0.00467
#>  7     384.      0.00467
#>  8     384.      0.00467
#>  9     385.      0.00466
#> 10     385.      0.00509
#> # … with 824 more rows
#> --- Member: LICOR_LI_210R ---
#> Object: response_spct [637 x 2]
#> Wavelength range 403.05175-721.67386 nm, step 0.5009782 nm 
#> Time unit 1s
#> 
#> # A tibble: 637 × 2
#>    w.length s.e.response
#>       <dbl>        <dbl>
#>  1     403.     0.00111 
#>  2     404.     0.00111 
#>  3     404.     0.00111 
#>  4     405.     0.00110 
#>  5     405.     0.00110 
#>  6     406.     0.00110 
#>  7     406.     0.00109 
#>  8     407.     0.000988
#>  9     407.     0.000171
#> 10     408.     0.000406
#> # … with 627 more rows
#> 
#> --- END ---
```

Please, see the *User Guide* or help pages for the names of other
vectors of names for materials, suppliers, and regions of the spectrum.
Summary calculations can be easily done with methods from package
‘photobiology’. Here we calculate mean photon response for two regions
of the spectrum given by wavelengths in nanometres.

``` r
q_response(sensors.mspct[["LICOR_LI_190"]], 
           waveband(c(500,600)))
#> R[/q]_range.500.600 
#>            16581880 
#> attr(,"time.unit")
#> [1] "second"
#> attr(,"radiation.unit")
#> [1] "total photon response"
```

The `autoplot()` methods from package ‘ggspectra’ can be used for
plotting one or more spectra at a time. The classes of the objects used
to store the spectral data are derived from `"data.frame"` making direct
use of the data easy with functions and methods from base R and various
packages.

## Installation

Installation of the most recent stable version from CRAN:

``` r
install.packages("photobiologySensors")
```

Installation of the current unstable version from Bitbucket:

``` r
# install.packages("devtools")
remotes::install_github("aphalo/photobiologySensors")
```

## Documentation

HTML documentation is available at
(<https://docs.r4photobiology.info/photobiologyFilters/>), including a
*User Guide*.

News on updates to the different packages of the ‘r4photobiology’ suite
are regularly posted at (<https://www.r4photobiology.info/>).

Two articles introduce the basic ideas behind the design of the suite
and its use: Aphalo P. J. (2015)
(<https://doi.org/10.19232/uv4pb.2015.1.14>) and Aphalo P. J. (2016)
(<https://doi.org/10.19232/uv4pb.2016.1.15>).

A book is under preparation, and the draft is currently available at
(<https://leanpub.com/r4photobiology/>).

A handbook written before the suite was developed contains useful
information on the quantification and manipulation of ultraviolet and
visible radiation: Aphalo, P. J., Albert, A., Björn, L. O., McLeod, A.
R., Robson, T. M., & Rosenqvist, E. (Eds.) (2012) Beyond the Visible: A
handbook of best practice in plant UV photobiology (1st ed., p. xxx +
174). Helsinki: University of Helsinki, Department of Biosciences,
Division of Plant Biology. ISBN 978-952-10-8363-1 (PDF),
978-952-10-8362-4 (paperback). PDF file available from
(<https://hdl.handle.net/10138/37558>).

## Support

Use (<https://stackoverflow.com/questions/tagged/r4photobiology>) to
access existing questions and answers.

(<https://stackoverflow.com/>) using tag \[r4photobiology\] plus any
other relevant tag to ask new questions.

## Bug reports and suggestions for enhancements

(<https://github.com/aphalo/photobiologySensors/issues>)

## Contributing

Pull requests, bug reports, and feature requests are welcome at
(<https://github.com/aphalo/photobiologySensors>).

## Citation

If you use this package to produce scientific or commercial
publications, please cite according to:

``` r
citation("photobiologySensors")
#> 
#> To cite package 'photobiologySensors' in publications, please use:
#> 
#>   Aphalo, Pedro J. (2015) The r4photobiology suite. UV4Plants Bulletin,
#>   2015:1, 21-29. DOI:10.19232/uv4pb.2015.1.14
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Article{,
#>     author = {Pedro J. Aphalo},
#>     title = {The r4photobiology suite},
#>     journal = {UV4Plants Bulletin},
#>     volume = {2015},
#>     number = {1},
#>     pages = {21-29},
#>     year = {2015},
#>     doi = {10.19232/uv4pb.2015.1.14},
#>   }
```

## License

© 2012-2022 Pedro J. Aphalo (<pedro.aphalo@helsinki.fi>). Released under
the GPL, version 2 or greater. This software carries no warranty of any
kind.
