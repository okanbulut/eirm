
.onAttach <- function(libname, pkgname) {
    version <- read.dcf(file = system.file("DESCRIPTION", package = pkgname), fields = "Version")
    packageStartupMessage(" ")
    packageStartupMessage("#-----------------------------------------------------------------------------#")
    packageStartupMessage("This is ", paste(pkgname, version), "\n")
    packageStartupMessage("To cite eirm in your research, please use the following APA-style citations:\n")
    packageStartupMessage("Bulut, O., Gorgun, G., & Yildirim-Erbasli, S. N. (2021). Estimating explanatory extensions of dichotomous and polytomous Rasch models: The eirm package in R. Psych, 3(3), 308-321. doi:10.3390/psych3030023\n")
    packageStartupMessage("For tutorials, see https://okanbulut.github.io/eirm/")
    packageStartupMessage("#-----------------------------------------------------------------------------#")
}

