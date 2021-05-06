# h/t to @jimhester and @yihui for this parse block:
# https://github.com/yihui/knitr/blob/dc5ead7bcfc0ebd2789fe99c527c7d91afb3de4a/Makefile#L1-L4
# Note the portability change as suggested in the manual:
# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
PKGNAME = `sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION`
PKGVERS = `sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION`


####################################

all: check

####################################

build: install_deps
	R CMD build .

####################################

check: build
	R CMD check --no-manual $(PKGNAME)_$(PKGVERS).tar.gz

####################################

install_deps:
	Rscript \
	-e 'if (!requireNamespace("remotes")) install.packages("remotes")' \
	-e 'remotes::install_deps(dependencies = TRUE)'

####################################

install: build
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

####################################

clean:
	@rm -rf $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck

########################################
############### Readme #################
########################################

####

readme: $(READMEMD)
Readme.md: $(READMERMD)
	@Rscript -e "rmarkdown::render('$(READMERMD)', output_format = 'rmarkdown::github_document')"
	rm -f $(READMEHTML)

clean_readme:
	rm -f $(READMEMD)

########################################
############### pkgdown ################
########################################

pkgdown: readme
	@Rscript -e "pkgdown::build_site()"
	cp dep_graph.png ./docs/dep_graph.png

clean_pkgdown:
	@Rscript -e "pkgdown::clean_site()"

####


########################################
############ Documentation #############
########################################

docs:
	Rscript -e "devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))"
	Rscript -e "codemetar::write_codemeta()"

########################################
################ Tests #################
########################################

test:
	@Rscript -e "devtools::test()"
	
########################################
############## Vignettes ###############
########################################

vignettes: $(VIGHTML)

$(VIGHTML): $(VIGRMD)
	@Rscript -e "devtools::build_vignettes()"

clean_vignettes:
	@Rscript -e "devtools::clean_vignettes()"


########################################
############# Help targets #############
########################################

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

########################################
################ PHONY #################
########################################

.PHONY: list files clean docs
