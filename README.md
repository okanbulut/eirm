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

### Citing ``eirm`` 

To cite ``eirm`` in your work, please use the following APA-style citation:

> Bulut, O. (2019). *eirm: Explanatory item response modeling for dichotomous and polytomous item responses* [Computer software]. Available from <https://github.com/okanbulut/eirm>. 

***

### Example 1: EIRM for dichotomous responses 

The following example shows how to use item-related and person-related explanatory variables to explain dichotomous responses in the verbal aggression data set:

```R
data("VerbAgg")
mod <- eirm(formula = "r2 ~ -1 + situ + btype + mode + (1|id)", data = VerbAgg)
print(mod)

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

It is also possible to visualize the parameters using an item-person map using `plot(mod)`, which returns the following plot:

![](https://github.com/okanbulut/eirm/blob/master/item-person-map.png)

It is possible to further edit the plot with additional features. For example:

```R
plot(mod, difficulty = TRUE, main = "Verbal Aggression Example", latdim = "Verbal Aggression")
```
which will show the difficulty parameters (instead of easiness), change the main title above the plot, and change the x-axis -- the name for the latent trait being measured. 

**Note:** This plot is a modified version of the `plotPImap` function from the eRm package ([(Mair, Hatzinger, Maier, Rusch, & Debelak, 2020)](https://cran.r-project.org/web/packages/eRm/index.html)). 
***

### Example 2: EIRM for polytomous responses 

It is also possible to use the `eirm` function with polytomous item responses as well. Because the function only accepts dichotomous responses (i.e., binomial distribution), polytomous data must be reformatted first. To reformat the data, the `polyreformat` function can be used. The following example demonstrates how polytomous responses (yes, maybe, and no) in the verbal aggression data set can be reformatted into a dichotomous form:

```R
VerbAgg2 <- polyreformat(data=VerbAgg, id.var = "id", long.format = FALSE, var.name = "item", val.name = "resp")
head(VerbAgg2)

  Anger Gender        item    resp id btype  situ mode r2 polycategory polyresponse                polyitem
1    20      M S1WantCurse      no  1 curse other want  N  cat_perhaps            0 S1WantCurse.cat_perhaps
2    11      M S1WantCurse      no  2 curse other want  N  cat_perhaps            0 S1WantCurse.cat_perhaps
3    17      F S1WantCurse perhaps  3 curse other want  Y  cat_perhaps            1 S1WantCurse.cat_perhaps
4    21      F S1WantCurse perhaps  4 curse other want  Y  cat_perhaps            1 S1WantCurse.cat_perhaps
5    17      F S1WantCurse perhaps  5 curse other want  Y  cat_perhaps            1 S1WantCurse.cat_perhaps
6    21      F S1WantCurse     yes  6 curse other want  Y  cat_perhaps           NA S1WantCurse.cat_perhaps
```

In the reformatted data, `polyresponse` is the new dependent variable (i.e., pseudo-dichotomous version of the original response variable `resp`) and `polycategory` represents the response categories. Based on the reformatted data, each item has two rows based on the following rules (see [Stanke and Bulut (2019)](https://dergipark.org.tr/en/download/article-file/716984) for further details on this parameterization):

* If `polycategory` = "cat_perhaps" and `resp` = "no", then `polyresponse` = 0
* If `polycategory` = "cat_perhaps" and `resp` = "perhaps", then `polyresponse` = 1
* If `polycategory` = "cat_perhaps" and `resp` = "yes", then `polyresponse` = NA

and

* If `polycategory` = "cat_yes" and `resp` = "no", then `polyresponse` = NA
* If `polycategory` = "cat_yes" and `resp` = "perhaps", then `polyresponse` = 0
* If `polycategory` = "cat_yes" and `resp` = "yes", then `polyresponse` = 1


**NOTE:** Although `polyreformat` is capable of reshaping wide-format data into long-format and reformat the long data for the analysis with `eirm`, a safer option is to transform the data from wide to long format before using `polyreformat`. The `melt` function from the `reshape2` package can easily transform wide data to long data. 

Several polytomous models can be estimated using the reformatted data:

**Model 1:** It explains only the first threshold (i.e., threshold from no to maybe) based on explanatory variables:

```R
mod1 <- eirm(formula = "polyresponse ~ -1 + situ + btype + mode + (1|id)", data = VerbAgg2)
```
**Model 2:** It explains the first threshold (i.e., threshold from no to maybe) and second threshold (maybe to yes) based on explanatory variables:

```R
mod2 <- eirm(formula = "polyresponse ~ -1 + btype + situ + mode + polycategory + polycategory:btype + (1|id)", 
             data = VerbAgg2)
```

