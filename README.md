[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6624125.svg)](https://doi.org/10.5281/zenodo.6624125)

[![:name status badge](https://uzh-peg.r-universe.dev/badges/:name)](https://uzh-peg.r-universe.dev)
[![microxanox status badge](https://uzh-peg.r-universe.dev/badges/microxanox)](https://uzh-peg.r-universe.dev)
[![:registry status badge](https://uzh-peg.r-universe.dev/badges/:registry)](https://uzh-peg.r-universe.dev)

[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)


# The `microxanox` R Package

Microxanox is an R package to simulate a three functional group system (cyanobacteria, phototrophic sulfur bacteria, and sulfate-reducing bacteria) with four chemical substrates (phosphorus, oxygen, reduced sulfur, and oxidized sulfur) using a set of ordinary differential equations. Simulations can be run individually or over a parameter range, to find stable states. The model features multiple species per functional group, where the number is only limited by computational constraints. The R package is constructed in such a way, that the results contain the input parameter used, so that a saved results can be loaded again and the
simulation be repeated.

# Installation
The easiest way (and the recommented way) to install `microxanox` is by using the [R-Universe](http://uzh-peg.r-universe.dev/ui/#package:microxanox):

```{r, eval = FALSE}
install.packages("microxanox", repos = c("https://uzh-peg.r-universe.dev", "https://cloud.r-project.org"))
```

The bleeding edge version can be installed from github:

You can also install the bleeding edge (sometimes non-stable) version fromthe [github](https://github.com/UZH-PEG/microxanox) repository by using

```{r}
remotes::install_github( "UZH-PEG/microxanox", ref = "dev", build_vignettes = TRUE, upgrade = FALSE)
```

For more details see the [User Guide](https://uzh-peg.r-universe.dev/articles/microxanox/User-guide.html) and [Reproducing some Results of Bush et al 2017](https://uzh-peg.r-universe.dev/articles/microxanox/partial-reproduction-Bushetal2017.html)

