## eirm: [e]xplanatory [i]tem [r]esponse [m]odeling for dichotomous and polytomous item responses

### Installing the `eirm` package

The development version can be installed by:

```R
devtools::install_github(repo = "okanbulut/eirm")
```


**IMPORTANT (1):** If you see the following output on your console, please choose `3: None` from this list. You can simply type **3** in your `R` console and hit "enter". 


```R
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

If this also fails, you can run the following lines all together and select `3: None` by typing **3** in your ~R~ console:

```R
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS=TRUE)
devtools::install_github(repo = "okanbulut/eirm")
```
***

### Example 1: EIRM for dichotomous responses 

The following example shows how to use item-related and person-related explanatory variables to explain dichotomous responses in the verbal aggression data set:

```R
data("VerbAgg")
mod0 <- eirm(formula = "r2 ~ -1 + situ + btype + (1|id)", data = VerbAgg)
print(mod0)

EIRM formula: "r2 ~ -1 + situ + btype + (1|id)" 

Number of persons: 316 

Number of observations: 7584 

Number of predictors: 4 

Parameter Estimates:

           Easiness   S.E. z-value   p-value
situother     1.376 0.0941   14.62  2.06e-48
situself      0.371 0.0913    4.06  4.85e-05
btypescold   -1.031 0.0671  -15.35  3.32e-53
btypeshout   -1.996 0.0718  -27.80 4.19e-170

Note: The estimated parameters above represent 'easiness'.
```

By default, the `eirm` function returns the **easiness** parameters because the function essentially uses a regression-like parameterization where positive parameters indicate positive contribution to the dependent variable. In order to print the difficulty parameters (instead of easiness), `difficulty = TRUE` must be used:

```R
print(mod0, difficulty = TRUE)

EIRM formula: "r2 ~ -1 + situ + btype + (1|id)" 

Number of persons: 316 

Number of observations: 7584 

Number of predictors: 4 

Parameter Estimates:

           Difficulty   S.E. z-value   p-value
situother      -1.376 0.0941   14.62  2.06e-48
situself       -0.371 0.0913    4.06  4.85e-05
btypescold      1.031 0.0671  -15.35  3.32e-53
btypeshout      1.996 0.0718  -27.80 4.19e-170

Note: The estimated parameters above represent 'difficulty'.
```
