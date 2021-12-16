
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eirm: Explanatory Item Response Modeling <img src="man/figures/eirm_logo.png" align="right" width="120" />

[![R build
status](https://github.com/okanbulut/eirm/workflows/R-CMD-check/badge.svg)](https://github.com/okanbulut/eirm/actions)
[![CodeFactor](https://www.codefactor.io/repository/github/okanbulut/eirm/badge)](https://www.codefactor.io/repository/github/okanbulut/eirm)
[![](https://www.r-pkg.org/badges/version/eirm?color=orange)](https://cran.r-project.org/package=eirm)
[![](https://img.shields.io/badge/devel%20version-0.6-yellow.svg)](https://github.com/okanbulut/eirm)
[![](http://cranlogs.r-pkg.org/badges/grand-total/eirm?color=blue)](https://cran.r-project.org/package=eirm)
[![](http://cranlogs.r-pkg.org/badges/eirm)](https://cranlogs.r-pkg.org/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4556285.svg)](https://doi.org/10.5281/zenodo.4556285)
[![Rbadge](https://img.shields.io/badge/Build%20with-♥%20and%20R-red)](https://github.com/okanbulut/eirm)

The `eirm` package, which is essentially a wrapper around the `lme4` and
`blme` packages, provides a simple and easy-to-use set of tools for
preparing data, estimating **explanatory** item response theory (IRT)
models, extracting model output, and visualizing model results. The
primary goal of `eirm` is to streamline the processes of data
preparation, model estimation, and model interpretation for various
explanatory IRT models. The functions in the `eirm` package enable
researchers to leverage the power of `lme4` and `blme` for the
estimation of explanatory IRT models while providing additional helper
functions and visualization tools to better interpret the model output.

### Installing `eirm`

The latest version on CRAN can be installed by:

``` r
install.packages("eirm")
```

The development version can be installed by:

``` r
devtools::install_github(repo = "okanbulut/eirm")
```

**Note:** If you download the Github version and see the following
output on your console (or something similar), please choose `3: None`
from this list. You can simply type **3** in your `R` console and hit
“enter”.

``` r
Downloading GitHub repo okanbulut/eirm@master
These packages have more recent versions available.
Which would you like to update?

1: All                                      
2: CRAN packages only                       
3: None                                     
4: Rcpp      (1.0.1     -> 1.0.3    ) [CRAN]
5: RcppEigen (0.3.3.5.0 -> 0.3.3.7.0) [CRAN]
6: plyr      (1.8.4     -> 1.8.5    ) [CRAN]
7: stringi   (1.4.3     -> 1.4.5    ) [CRAN]

Enter one or more numbers, or an empty line to skip updates:
```

If this also fails, you can run the following lines all together and
select `3: None` by typing **3** in your `R` console:

``` r
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS=TRUE)
devtools::install_github(repo = "okanbulut/eirm")
```

### Citing `eirm`

To cite `eirm` in your work, please use the following APA-style
citation:

> Bulut, O. (2021). *eirm: Explanatory item response modeling for
> dichotomous and polytomous item responses*, R package version 0.4.
> doi: 10.5281/zenodo.4556285 Available from
> <https://CRAN.R-project.org/package=eirm>.

> Bulut, O., Gorgun, G., & Yildirim-Erbasli, S. N. (2021). Estimating
> explanatory extensions of dichotomous and polytomous Rasch models: The
> eirm package in R. *Psych, 3*(3), 308-321. <doi:10.3390/psych3030023>

You can also `print(citation("eirm"), bibtex = TRUE)` to view the
citations in BibTeX format.

------------------------------------------------------------------------

### Shiny GUI for `eirm`

You can use `eirmShiny()` to open the Shiny GUI for the `eirm` function:

![](man/figures/eirmGIF.gif)

I plan to expand the Shiny GUI with additional features in the future.
Please let me know if you have any suggestions or comments.

------------------------------------------------------------------------

### Examples

Please visit <https://okanbulut.github.io/eirm> for documentation and
vignettes. For questions about the functionality, you may either contact
me via email or also file an issue.

On the package [website](https://okanbulut.github.io/eirm), you can
access two vignettes demonstrating how to use `eirm` for:

1.  [Estimating dichotomous explanatory IRT
    models](https://okanbulut.github.io/eirm/vignettes/dich_vignette.html)
    with binary data (e.g., 0 = Wrong, 1 = Right)
2.  [Estimating polytomous explanatory IRT
    models](https://okanbulut.github.io/eirm/vignettes/poly_vignette.html)
    with ordinal data (e.g., 1 = No, 2 = Maybe, 3 = Yes)
