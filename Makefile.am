#
# Copyright (C) 2004, 2005, 2006 Mekensleep
#
# Mekensleep
# 24 rue vieille du temple
# 75004 Paris
#       licensing@mekensleep.com
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
#
# Authors:
#  Loic Dachary <loic@gnu.org>
#
# 
ACLOCAL_AMFLAGS = -I config

MAINTAINERCLEANFILES = \
	INSTALL \
	py-compile \
	Makefile.in \
	aclocal.m4 \
	config.guess \
	config.h.in \
	config.sub \
	configure \
	depcomp \
	install-sh \
	ltmain.sh \
	missing \
	mkinstalldirs

pythondir = ${pyexecdir}
python_PYTHON = \
	pokereval.py

pkgpyexecdir=${pyexecdir}
pkgpyexec_LTLIBRARIES      = \
	pypokereval.la

pypokereval_la_SOURCES = pypokereval.c
pypokereval_la_LDFLAGS = -module -no-undefined

pkgconfigdir = ${libdir}/pkgconfig
pkgconfig_DATA = pypoker-eval.pc

EXTRA_DIST = bootstrap config/python.m4 config/ccpython.m4 test.py pypoker-eval.vcproj

# The python interpreter needs to find the binary modules in the
# current directory and is using a search mechanism (based on
# PYTHONPATH) that can't cope with a directory hierarchy including a
# .libs
#
all-local:
	if [ -f .libs/*.so ] ; then \
		rm -f *.so ; ln -s .libs/*.so . ; \
	else \
		rm -f *.dll ; ln -s .libs/*.dll pypokereval.dll ; \
	fi

clean-local:
	rm -f *.so *.pyc

install-data-hook:
	if [ "${MAYBE_PYTHON_VERSION}" ] ; then \
		cp ${DESTDIR}${pkgconfigdir}/pypoker-eval.pc ${DESTDIR}${pkgconfigdir}/pypoker-eval${MAYBE_PYTHON_VERSION}.pc ; \
	fi

install-exec-local:
	mkdir -p ${DESTDIR}/${pyexecdir}
	if [ -f pypokereval.dll ] ; then \
		cp pypokereval.dll ${DESTDIR}/${pyexecdir} ; \
	fi
	if [ -f pypokereval.so ] ; then \
		cp pypokereval.so ${DESTDIR}/${pyexecdir} ; \
	fi
