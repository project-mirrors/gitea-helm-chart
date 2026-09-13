SHELL := /usr/bin/env bash -O globstar

# MISSING DOT
# ==============================================================================
PHONY+=missing-dot
missing-dot:
	grep --perl-regexp '## @(param|skip).*[^.]$$' values.yaml

# README
# ==============================================================================
PHONY+=readme
readme: readme/link readme/lint readme/parameters

PHONY+=readme/link
readme/link:
	npm install && npm run readme:link

PHONY+=readme/lint
readme/lint:
	npm install && npm run readme:lint

PHONY+=readme/parameters
readme/parameters:
	npm install && npm run readme:parameters

# HELM DEPENDENCIES
# ==============================================================================
PHONY+=helm/dependency-update
helm/dependency-update:
	helm dependency update

# HELM UNITTESTS
# ==============================================================================
PHONY+=helm/unittest
helm/unittest:
	helm unittest --strict --file 'unittests/helm/**/*.yaml' --file 'unittests/helm/values-conflicting-checks.yaml' ./

# BASH UNITTESTS
# ==============================================================================
PHONY+=bash/unittest
bash/unittest:
	./unittests/bash/bats/bin/bats --pretty ./unittests/bash/tests/**/*.bats

# YAML LINT
# ==============================================================================
PHONY+=yamllint
yamllint:
	yamllint -c .yamllint.yaml .

# PHONY
# ==============================================================================
# Declare the contents of the PHONY variable as phony. We keep that information
# in a variable so we can use it in if_changed.
.PHONY: ${PHONY}
