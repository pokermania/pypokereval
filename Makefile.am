#
# Copyright (C) 2004 Mekensleep
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
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# Authors:
#  Loic Dachary <loic@gnu.org>
#
# 
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
pypokereval_la_LDFLAGS = -module

EXTRA_DIST = bootstrap config/python.m4 test.py

# The python interpreter needs to find the binary modules in the
# current directory and is using a search mechanism (based on
# PYTHONPATH) that can't cope with a directory hierarchy including a
# .libs
#
all-local:
	rm -f *.so ; ln -s .libs/*.so .

clean-local:
	rm -f *.so *.pyc

