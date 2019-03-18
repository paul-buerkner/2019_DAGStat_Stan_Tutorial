# install rstan
# Quite a few other packages will be installed as well
if (!require("rstan")) {
  install.packages("rstan")
}

# The following explains how to install a C++ compiler 
# which is required for Stan


# -------- FOR WINDOWS -------
# This requires using R from Rstudio 1.1 or higher!
library(rstan)
example("stan_model", run.dontrun = TRUE)
# RStudio will ask if you want to install Rtools, 
# in which case you should say Yes and click through the installer
# If this doesn't work, go to download and install Rtools 3.5
# manually from https://cran.r-project.org/bin/windows/Rtools/
# make sure to check the box to change the System PATH 


# -------- FOR MAC ----------
# Please install Xcode, which you can download from the App-Store for free.
# Installing Xcode may take some time and you may restart your machine afterwards
# Make sure that a C++ compiler is installed and can be called within R via
system("clang++ -v")
# If no warning occurs and a few lines of difficult to read system code 
# are printed out, the compiler should work correctly


# -----------------------
# try to run a demo model
example("stan_model")

