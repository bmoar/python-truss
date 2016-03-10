#!/usr/bin/make
# WARN: gmake syntax
########################################################
#
# useful targets:
#   make test   - run the unit tests
#   make flake8 - linting and pep8
#   make docs 	- create manpages and html documentation
#   make loc 	- stats about loc

########################################################
# variable section

NAME = python_truss
OS = $(shell uname -s)
PYTHON = $(shell which python3)
VIRTUALENV_PATH = $(shell echo $$HOME/.virtualenvs)

MANPAGES=$(wildcard docs/man/**/*.*.ronn)
MANPAGES_GEN=$(patsubst %.ronn,%,$(MANPAGES))
MANPAGES_HTML=$(patsubst %.ronn,%.html,$(MANPAGES))
ifneq ($(shell which ronn 2>/dev/null),)
RONN2MAN = ronn
else
RONN2MAN = @echo "ERROR: 'ronn' command is not installed but is required to build $(MANPAGES)" && exit 1
endif

UNITTESTS=unittest
COVERAGE=coverage

########################################################


docs: $(MANPAGES)
	$(RONN2MAN) $^

.PHONY: clean
clean:
	rm -f $(MANPAGES_GEN) $(MANPAGES_HTML)
	rm -rf ./build
	rm -rf ./dist
	rm -rf ./*.egg-info
	rm -rf ./*.deb
	rm -rf .tox 
	rm -rf .coverage 
	rm -rf .sloccount 
	find . -name '*.pyc.*' -delete
	find . -name '*.pyc' -delete

loc:
	mkdir -p .sloccount
	sloccount --datadir .sloccount $(NAME)/lib $(NAME)/cli | grep -v SLOCCount | grep -v license | grep -v "see the documentation"

flake8:
	@echo "#############################################"
	@echo "# Running flake8 Compliance Tests"
	@echo "#############################################"
	-flake8 --ignore=E501,E221,W291,W391,E302,E251,E203,W293,E231,E303,E201,E225,E261,E241 $(NAME)/lib $(NAME)/cli

test:
	PYTHONPATH=./$(NAME)/lib $(COVERAGE) run --source=$(NAME) -m $(UNITTESTS) discover -s ./tests
	$(COVERAGE) report --omit=./tests/* -m

virtualenv:
	mkdir -p $(VIRTUALENV_PATH)
	rm -rf $(VIRTUALENV_PATH)/$(NAME)
	virtualenv -p $(PYTHON) --system-site-packages $(VIRTUALENV_PATH)/$(NAME)

virtualenv-develop: virtualenv
	$(VIRTUALENV_PATH)/$(NAME)/bin/python setup.py develop

all: docs flake8 test loc