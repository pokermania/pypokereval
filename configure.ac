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

# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.54)
AC_INIT(pypoker-eval, 126.0)
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE()
AC_CONFIG_SRCDIR([pypokereval.c])

# Checks for programs.
AC_PROG_MAKE_SET
AC_GNU_SOURCE
AC_LANG(C)
AC_PROG_CPP
AC_PROG_LIBTOOL

# Check for python
#
# GCC specific debug and optimization flags
#
AC_ARG_ENABLE(debug,
    [  --enable-debug          build in debug mode (the default is to build in optimized mode)],
    [enable_debug=yes])

if test "$GCC" = "yes" -a "$ac_test_CFLAGS" != set ; then
  if test "$enable_debug" = "yes" ; then
    CFLAGS="-pipe -g -Wall -Wpointer-arith -Wstrict-prototypes"
  else
    CFLAGS="-pipe -O3 -Wall -Wpointer-arith -Wstrict-prototypes"
  fi
fi

AM_PATH_PYTHON([2.3])
AM_CC_PYTHON(2.3, yes)
CPPFLAGS="${CPPFLAGS} ${PYTHON_CFLAGS}"
LIBS="${LIBS} ${PYTHON_LIBS}"

# Check for poker-eval
PKG_CHECK_MODULES(POKER_EVAL, poker-eval >= 124.0)
CPPFLAGS="$CPPFLAGS $POKER_EVAL_CFLAGS"
LIBS="$LIBS $POKER_EVAL_LIBS"

# Generate files
AC_CONFIG_FILES([Makefile
                 pypoker-eval.spec])
AC_OUTPUT
