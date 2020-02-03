### eirm: [E]xplanatory [I]tem [R]esponse [M]odeling for Dichotomous and Polytomous Item Responses

### Type: R Package

The development version can be installed by:

```R
devtools::install_github(repo = "okanbulut/eirm")
```


**IMPORTANT (1):** If you see the following output on your console, please choose **option 3** from this list. You can simply type "3" in your `R` console and hit "enter". 


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


If this also fails, you can run the following lines all together and select **option 3** (i.e., `3: None`):

```R
Sys.setenv(R_REMOTES_NO_ERRORS_FROM_WARNINGS=TRUE)
devtools::install_github(repo = "okanbulut/eirm")
```

