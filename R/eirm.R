#' @title Estimating explanatory item response modeling using the GLMM framework
#' @import lme4
#' @import blme
#' @import optimx
#' @importFrom stats as.formula binomial
#' @description
#' The eirm function estimates explanatory item response models with item-related and
#' person-related covariates. The function requires the data to be in a long format where
#' items are nested within persons. If item responses are polytomous, then the data has to
#' be reformatted using the \code{\link{polyreformat}} function.
#'
#' @param formula A regression-like formula that defines item responses as a dependent
#' variable and explanatory predictors as independent predictors.
#' For example, "response ~ -1 + predictor1 + predictor2". Use -1 in the formula
#' to avoid the estimation of an intercept parameter.
#' @param data A data frame in a long format where there are multiple rows for
#' each person (i.e., nested data). The data should involve a variable that represents
#' item responses, a variable that represents persons, and additional predictors to be
#' used for 'explaining' item responses.
#' @param engine Estimation engine with the options of either "lme4" (default) or "blme".
#' @param na.action How missing data should be handled (default: "na.omit").
#' @param weights Weights to be used in the estimation.
#' @param mustart,etastart Model specification arguments for glmer. See \code{\link[lme4]{glmer}} for details.
#' @param cov.prior A BLME prior or list of priors with the options of "wishart" (default), "invwishart",
#' "gamma", "invgamma", or NULL to impose a prior over the covariance of the random effects.
#' @param fixef.prior A BLME prior of family "normal", "t", "horseshoe", or NULL (default) to impose a prior over
#' the fixed effects.
#' @param control Control settings for the glmer function in lme4. Note that the optimx
#' package is used by default to speed up the estimation. For higher accuracy in the
#' results, the default lme4 optimizers can be used.
#'
#' @return An eirm-class list that includes the EIRM formula used for the estimation, estimated
#' parameters in the model, ability estimates for persons and other random effects (if any), and
#' the complete set of results returned from the glmer function. These results can be used for
#' further analysis and graphics based on lme4.
#'
#' @examples
#' \donttest{
#' data("VerbAgg")
#' mod0 <- eirm(formula = "r2 ~ -1 + situ + btype + (1|id)", data = VerbAgg)
#' print(mod0) # To get easiness parameters
#' print(mod0, difficulty = TRUE) # To get difficulty parameters
#' plot(mod0)
#' mod1 <- eirm(formula = "r2 ~ -1 + situ + btype + mode + (1|id)", data = VerbAgg)
#' print(mod1) # To get easiness parameters
#' print(mod1, difficulty = TRUE) # To get difficulty parameters
#' plot(mod1)
#' }
#' @export

eirm <- function(formula, data, engine = "lme4", na.action = "na.omit", weights = NULL,
                 mustart = NULL, etastart = NULL,  cov.prior = "wishart", fixef.prior = NULL,
                 control = glmerControl(optimizer = "optimx", calc.derivs = FALSE,
                 optCtrl = list(method = "nlminb", starttests = FALSE, kkt = FALSE))) {

  # Reset the option settings once the analysis is done
  current_options <- options()
  on.exit(options(current_options))

  # Set the number of digits to 3
  options(digits=3)

  # Set the formula
  eirm_formula <- as.formula(formula)

  if(engine == "lme4") {
    if(is.null(weights)) {
      mod <- glmer(formula = eirm_formula, data = data, family=binomial("logit"), control = control,
                   na.action = na.action)
    } else

      mod <- glmer(formula = eirm_formula, data = data, family=binomial("logit"), control = control,
                   weights = weights, na.action = na.action)

    # Save results
    results <- list()

    # Formula
    results$eirm_formula <- formula

    # Item and item-related variables
    summary_parameters <- summary(mod)
    results$parameters <- as.data.frame(summary_parameters$coefficients)
    colnames(results$parameters) <- c("Easiness", "S.E.", "z-value", "p-value")

    # Random effects for persons and items (if any)
    results$persons <- ranef(mod)

    # Save lme4 object for other results
    results$model <- mod
  } else {
    stop("blme is not supported yet.")
  }


  class(results) <- "eirm"

  return(results)
}


