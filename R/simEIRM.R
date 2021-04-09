#' @title Simulate data for explanatory item response modeling
#' @importFrom stats rbinom rnorm
#' @description
#' This function simulates a dichotomous response data set based on item-level and person-level predictors.
#' There are two predictors: an item-level (itemtype: 0 or 1) and a person-level (group: 0 or 1).
#' Dichotomous responses are generated for user-defined numbers of items and persons. This simple data set can
#' be used for simulating and testing different EIRM model with item, person, and item-by-person predictors.
#' @param nitem Number of items to be simulated.
#' @param nperson Number of persons to be simulated.
#' @param theta.mean Mean of a normal distribution to be used for generating theta values (default is 0).
#' @param theta.sd Standard deviation of a normal distribution to be used for generating theta values (default is 1).
#' @param difficulty.mean Mean of a normal distribution to be used for generating item difficulty values (default is 0).
#' @param difficulty.sd Standard deviation of a normal distribution to be used for generating item difficulty values (default is 1).
#' @param group.size The number of persons for each group (i.e., Group 0 vs. Group 1). The sum of these numbers
#' should be equal to nperson. If NULL, the first half of the persons becomes Group 0 and the other half becomes Group 1.
#' @param itemtype.size The number of items for each itemtype (i.e., itemtype 0 vs. itemtype 1). The sum of these numbers
#' should be equal to nitem. If NULL, the first half of the items becomes itemtype 0 and the other half becomes itemtype 1.
#' @param group.effect The magnitudes of person group effect  (in logits) for Group 0 and Group 1, respectively.
#' @param itemtype.effect The magnitudes of item type effect (in logits) for itemtype 0 and item type 1, respectively.
#' @param dif The magnitude of differential item functioning (DIF) for the items. Either a single value to create DIF
#' for all items or a vector with the length of nitem that specifies the amount of DIF for each item.
#' @param seed A number to be used as a seed in the random number generator. Especially in simulation studies, setting the
#' seed would ensure reproducibility of the results.
#' @return A long-format response data set is returned, with the following components:
#' \itemize{
#' \item person: A pseudo person ID from 1 to nperson.
#' \item item: A pseudo item ID from 1 to nitem.
#' \item theta: Ability (i.e., theta) values used for generating responses.
#' \item difficulty: Item difficulty (i.e., b parameter) values used for generating responses.
#' \item group: Person groups (either 0 or 1).
#' \item group.effect: The magnitude of person group effect used for generating responses.
#' \item itemtype: Item groups (either 0 or 1).
#' \item itemtype.effect: The magnitude of itemtype effect used for generating responses.
#' \item dif: The magnitude of DIF used for generating responses.
#' \item response: Dichotomous responses generated based on theta and difficulty.
#' }
#'
#' @examples
#' # A Linear Logistic Test Model (LLTM) with item group effects with 10 items and 1000 persons
#' # First 4 items will be itemtype = 0 and the rest will be itemtype = 1
#' # Items with itemtype = 1 will be 0.3 logit more difficult.
#' data.lltm <- simEIRM(nitem = 10, nperson = 1000, itemtype.size = c(4, 6),
#' itemtype.effect = c(0, 0.3))
#'
#' # A latent regression model (LRM) with person group effects with 10 items and 1000 persons
#' # The first half of the persons will be group = 0 and the other half will be group = 1 (Default)
#' # The average ability for persons with group = 1 will be 0.5 logit higher.
#' data.lrm <- simEIRM(nitem = 10, nperson = 1000, group.effect = c(0, 0.5))
#'
#' # A differential item functioning (DIF) scenario with 15 items and 1000 persons
#' # The last five items will have DIF with 0.3 logit. Group 0 will have 700 persons (reference group)
#' # and Group 1 will have 300 persons (focal group)
#' data.dif <- simEIRM(nitem = 15, nperson = 1000, group.size = c(700, 300),
#' dif = c(rep(0, 10), rep(0.3, 5)))
#' @export

simEIRM <- function(nitem, nperson, theta.mean = 0, theta.sd = 1,
                    difficulty.mean = 0, difficulty.sd = 1,
                    group.size = NULL, itemtype.size = NULL,
                    group.effect = c(0, 0), itemtype.effect = c(0, 0),
                    dif = 0, seed = NULL) {

  # Set the seed
  if(!is.null(seed)) {
    set.seed(seed)
  }

  if(length(dif) == 1) {
    dif.effect <- rep(dif, nitem)
  } else {
    dif.effect <- dif
  }

  # Define person groups
  if(is.null(group.size)) {
    g1 <- round(nperson/2, 0)
    g2 <- nperson - g1
  } else {
    g1 <- group.size[1]
    g2 <- group.size[2]
  }

  # Define item groups
  if(is.null(itemtype.size)) {
    it1 <- round(nitem/2, 0)
    it2 <- nitem - it1
  } else {
    it1 <- itemtype.size[1]
    it2 <- itemtype.size[2]
  }

  # Generate data
  data <- data.frame(
    # Person ID
    person=sort(rep(1:nperson, nitem)),
    # Item ID
    item=(rep(1:nitem, nperson)),
    # Ability
    theta=c(sort(rep(rnorm(g1, mean = theta.mean, sd = theta.sd), nitem)),
            sort(rep(rnorm(g2, mean = theta.mean, sd = theta.sd), nitem))),
    # Item difficulty
    difficulty=rep(c(rnorm(it1, mean = difficulty.mean, sd = difficulty.sd),
                     rnorm(it2, mean = difficulty.mean, sd = difficulty.sd)), nperson),
    # Person groups
    group=c(rep(0, g1*nitem), rep(1, g2*nitem)),
    # Person group effect
    group.effect=c(rep(group.effect[1], g1*nitem), rep(group.effect[2], g2*nitem)),
    # Item type
    itemtype=rep(c(rep(0, it1),rep(1, it2)), nperson),
    # Item type effect
    itemtype.effect=rep(c(rep(itemtype.effect[1], it1), rep(itemtype.effect[2], it2)), nperson),
    # DIF effect
    dif=rep(dif.effect, nperson)
    )

  # Person group effect adjustment
  data$theta <- data$theta + (data$group*data$group.effect)

  # Item type effect adjustment
  data$difficulty <- data$difficulty + (data$itemtype*data$itemtype.effect)

  # DIF effect adjustment
  data$difficulty <- data$difficulty + (data$dif*data$group)

  # Generate responses
  data$response <- rbinom(length(data$person), 1,
                          exp(data$theta-data$difficulty)/(1+ exp(data$theta-data$difficulty)))

  # Turn item and person IDs into factors
  data$item <- as.factor(data$item)
  data$person <- as.factor(data$person)

  return(data)
}











