
#' Verbal Aggression Data in a Wide Format
#'
#' The Verbal Aggression data set is a wide-format version of the  \link[lme4]{VerbAgg} data set in the \pkg{lme4} package (Bates, Maechler, Bolker, & Walker, 2015) in R.
#'
#' @docType data
#' @keywords dataset
#' @format A data frame with 316 participants and 27 variables.
#' \describe{The original Verbal Agression data set was in a long format where items are nested within respondents. \code{VerbAggWide} is a wide-format version of the original data set. The first three variables are 'id' as the respondent ID, 'Anger' as the respondents' anger scores, and 'Gender' is the respondents' gender (M: male; F: Female). The remaining columns are the respondents' responses to the Verbal aggression items (0: No; 1: Perhaps; 2: Yes). For more information about the data set, see \url{http://bear.soe.berkeley.edu/EIRM/}.
#' }
#' @source Bates, D., Maechler, M., Bolker, B., & Walker, S. (2015). Fitting linear mixed-effects models using lme4. Journal of Statistical Software, 67(1), 1-48. doi:10.18637/jss.v067.i01.
"VerbAggWide"

#' Fabricated Short Quiz with Explanatory Variables
#'
#' This dataset contains examinees' responses to a short quiz with 10 items.The data set has been fabricated to
#' demonstrate Explanatory Item Response Modeling.
#'
#' @docType data
#' @keywords dataset
#' @format A long format data frame containing 1000 examinees' responses to 10 items and additional variables.
#' \describe{
#' \item{person}{Examinee ID}
#' \item{item}{Item ID}
#' \item{response}{Dichotomous item responses}
#' \item{gender}{Examinees' gender where F is female and M is male}
#' \item{itemtype}{A variable to define whether the items on the quiz have a visual component}
#' }
"testdata"

