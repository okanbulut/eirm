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
mod <- eirm(formula = "r2 ~ -1 + situ + btype + mode + (1|id)", data = VerbAgg)
print(mod) # To get easiness parameters

EIRM formula: "r2 ~ -1 + situ + btype + mode + (1|id)" 

Number of persons: 316 

Number of observations: 7584 

Number of predictors: 5 

Parameter Estimates:

           Easiness   S.E. z-value   p-value
situother     1.744 0.1015   17.19  3.29e-66
situself      0.716 0.0978    7.32  2.43e-13
btypescold   -1.055 0.0680  -15.51  3.02e-54
btypeshout   -2.042 0.0729  -28.00 1.51e-172
modedo       -0.672 0.0562  -11.95  6.69e-33

Note: The estimated parameters above represent 'easiness'. Use difficulty = TRUE to get difficulty parameters.
```

By default, the `eirm` function returns the **easiness** parameters because the function essentially uses a regression-like parameterization where positive parameters indicate positive contribution to the dependent variable. In order to print the difficulty parameters (instead of easiness), `print(mod, difficulty = TRUE)` must be used:

```R
EIRM formula: "r2 ~ -1 + situ + btype + mode + (1|id)" 

Number of persons: 316 

Number of observations: 7584 

Number of predictors: 5 

Parameter Estimates:

           Difficulty   S.E. z-value   p-value
situother      -1.744 0.1015   17.19  3.29e-66
situself       -0.716 0.0978    7.32  2.43e-13
btypescold      1.055 0.0680  -15.51  3.02e-54
btypeshout      2.042 0.0729  -28.00 1.51e-172
modedo          0.672 0.0562  -11.95  6.69e-33

Note: The estimated parameters above represent 'difficulty'.
```
