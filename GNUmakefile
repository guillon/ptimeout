#
# Copyright (c) STMicroelectronics 2012
#
# This file is part of ptimeout.
#
# ptimeout is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License v2.0
# as published by the Free Software Foundation
#
# ptimeout is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# v2.0 along with ptimeout. If not, see <http://www.gnu.org/licenses/>.
#

SHELL=/bin/sh
PREFIX=/usr/local

PUBLIC_TARGETS=help all check clean distclean install uninstall distclean-local distclean-tests release release-upload release-upload-pypi release-py3 release-py2
PRIVATE_TARGETS_BASE=_sdist _bdist _upload-requirements _upload
PRIVATE_TARGETS=$(PRIVATE_TARGETS_BASE:%=_venv2-%) $(PRIVATE_TARGETS_BASE:%=_venv3-%) _venv2 _venv3 _release-venv2 _release-venv3

help:
	@echo "usage: make TARGET [PARAMETERS]"
	@echo
	@echo "where TARGET is one of:"
	@echo "make all       : build all (no-op for this software)"
	@echo "make check     : run unit tests"
	@echo "make install   : install into PREFIX"
	@echo "make clean     : clean build and tests"
	@echo "make distclean : clean everything"
	@echo "make uninstall : uninstall from PREFIX"
	@echo "make release : create py2 and py3 python packages releases"
	@echo "make release-upload : upload py2 and py3 package releases to PyPI"
	@echo
	@echo "where PAREMETERS is one of (current values):"
	@echo "PREFIX=$(PREFIX)"


all:

check: all
	$(MAKE) -C tests check

clean:
	$(MAKE) -C tests clean

distclean: distclean-local distclean-tests

distclean-local:
	rm -rf dist build __pycache__ *.egg-info .venv*

distclean-tests:
	$(MAKE) -C tests distclean

install: all
	mkdir -p $(PREFIX)/bin
	cp ptimeout $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/ptimeout

uninstall:
	rm -f $(PREFIX)/bin/ptimeout

release:
	$(MAKE) distclean
	$(MAKE) _venv3 _venv2
	$(MAKE) _release-venv3 _release-venv2

release-py3:
	$(MAKE) distclean
	$(MAKE) _venv3
	$(MAKE) _release-venv3

release-py2:
	$(MAKE) distclean
	$(MAKE) _venv2
	$(MAKE) _release-venv2

release-upload:
	$(MAKE) release-upload-pypi

release-upload-pypi:
	$(MAKE) _venv3-_upload-requirements
	$(MAKE) _venv3-_upload

_sdist:
	python ./setup.py sdist

_bdist:
	python ./setup.py bdist_wheel

_upload-requirements:
	pip install twine

_upload:
	twine upload dist/ptimeout-*.tar.gz dist/ptimeout-*.whl

_release-venv3 _release-venv2: _release-%:
	$(MAKE) _$*-_bdist
	[ "$*" != "venv3" ] || $(MAKE) _venv3-_sdist

$(PRIVATE_TARGETS_BASE:%=_venv2-%): _venv2-%:
	env VIRTUAL_ENV="$$PWD/.venv2/bin" \
	PATH="$$PWD/.venv2/bin:$$PATH" \
	$(MAKE) $*

$(PRIVATE_TARGETS_BASE:%=_venv3-%): _venv3-%:
	env VIRTUAL_ENV="$$PWD/.venv3/bin" \
	PATH="$$PWD/.venv3/bin:$$PATH" \
	$(MAKE) $*

_venv3:
	virtualenv -p python3 .venv3
	.venv3/bin/pip install --upgrade pip setuptools wheel certifi

_venv2:
	virtualenv -p python2 .venv2
	.venv2/bin/pip install --upgrade pip setuptools wheel

.PHONY:
.PHONY: $(PUBLIC_TARGETS) $(PRIVATE_TARGETS)
.SUFFIXES:

