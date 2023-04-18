## R parts based on https://github.com/yihui/knitr/blob/master/Makefile

PKGNAME := $(shell sed -n "s/^Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/^Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

# SRCDIR = source
# OUTDIR = docs
# DATADIR = $(OUTDIR)/data
# INSTDIR = inst

# VIGHTMLDIR = doc

# DOCDIR = doc

VIGDIR = vignettes
VIGRMD = $(wildcard $(VIGDIR)/*.Rmd)
TMP1  = $(VIGRMD:.Rmd=.html)
VIGHTML = ${subst $(VIGDIR),$(VIGHTMLDIR),$(TMP1)}
# VIGHTMLOUT = ${subst $(VIGDIR),$(OUTDIR),$(TMP1)}

# EXAMPLEXML = $(wildcard $(INSTDIR)/dmdScheme_example.xml)

# RMD = $(wildcard $(SRCDIR)/*.Rmd)
# TMP2  = $(RMD:.Rmd=.html)
# HTML = ${subst $(SRCDIR),$(OUTDIR),$(TMP2)}

READMERMD = Readme.Rmd
READMEMD = Readme.md
READMEHTML = Readme.html

MANSCRIPTRMD = ./inst/manuscript/manuscript_microxanox.Rmd
MANSCRIPTHTML = ./inst/manuscript/manuscript_microxanox.html
MANSCRIPTPDF = ./inst/manuscript/manuscript_microxanox.pdf
MANSCRIPTDOC = ./inst/manuscript/manuscript_microxanox.doc
MANSCRIPTLOG = ./inst/manuscript/manuscript_microxanox.log
MANSCRIPTR = ./inst/manuscript/manuscript_microxanox.R

#############

all: readme docs vignettes build

#############

clean: clean_check clean_readme clean_vignettes


########### Manuscript ###########

manuscript: html pdf

html: $(MANSCRIPTHTML)
$(MANSCRIPTHTML): $(MANSCRIPTRMD)
	@Rscript -e "rmarkdown::render('$(MANSCRIPTRMD)', output_format = 'bookdown::html_document2')"
	open $(MANSCRIPTHTML)
  
  
pdf: $(MANSCRIPTPDF)
$(MANSCRIPTPDF): $(MANSCRIPTRMD)
	@Rscript -e "rmarkdown::render('$(MANSCRIPTRMD)', output_format = 'bookdown::pdf_document2')"
	open $(MANSCRIPTPDF)
  
clean_manuscript:
	rm -f $(MANSCRIPTHTML)
	rm -f $(MANSCRIPTPDF)
	rm -f $(MANSCRIPTDOC)
	rm -f $(MANSCRIPTLOG)
	rm -f $(MANSCRIPTR)

########### Readme ###########

####

readme: $(READMEMD)
Readme.md: $(READMERMD)
	@Rscript -e "rmarkdown::render('$(READMERMD)', output_format = 'rmarkdown::github_document')"
	rm -f $(READMEHTML)

clean_readme:
	rm -f $(READMEMD)

####

########### Package  ###########

####

deps:
	Rscript -e 'if (!require("Rd2roxygen")) install.packages("Rd2roxygen", repos="http://cran.rstudio.com")'

####

doc:
	Rscript -e "devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette', 'roxyglobals::global_roclet'))"

metadata:
	Rscript -e "codemetar::write_codemeta()"

docs: docs metadata 

####

vignettes: $(VIGHTML)

$(VIGHTML): $(VIGRMD)
	@Rscript -e "devtools::build_vignettes()"

clean_vignettes:
	@Rscript -e "devtools::clean_vignettes()"

####


build: doc
	cd ..;\
	R CMD build $(PKGSRC)

####

drat:
	cd
	@Rscript -e "drat::insertPackage('./../$(PKGNAME)_$(PKGVERS).tar.gz', repodir = './../../drat/', commit = TRUE)"
	
####

build-cran: doc
	cd ..;\
	R CMD build $(PKGSRC)

####

install:
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

####

check: build-cran
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

clean_check:
	$(RM) -r ./../$(PKGNAME).Rcheck/

####

# check_rhub
# 	@Rscript -e "rhub::check_for_cran(".")

####

test:
	@Rscript -e "devtools::test()"

####

############# Help targets #############

list_variables:
	@echo
	@echo "#############################################"
	@echo "## Variables ################################"
	@$(MAKE) -pn | grep -A1 "^# makefile"| grep -v "^#\|^--" | sort | uniq
	@echo "#############################################"
	@echo ""

## from https://stackoverflow.com/a/26339924/632423
list_targets:
	@echo
	@echo "#############################################"
	@echo "## Targets    ###############################"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo "#############################################"
	@echo

list: list_variables list_targets

#############

.PHONY: list files clean docs
