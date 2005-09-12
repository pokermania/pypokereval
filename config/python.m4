#
# Copyright (C) 2002 Loic Dachary <loic@gnu.org>
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
# =========================================================================
# AM_CC_PYTHON : Python checking macros

AC_DEFUN([AM_CC_PYTHON],
[ python_version_required="$1"

is_mandatory="$2"

AC_REQUIRE_CPP()

dnl Get from the user option the path to the Python files location
AC_ARG_WITH( python,
    [  --with-python=<path>    path to the Python prefix installation directory.
                          e.g. /usr/local],
    [ PYTHON_PREFIX=$with_python ]
)

AC_ARG_WITH( python-version,
    [  --with-python-version=<version>
                          Python version to use, e.g. 2.2],
    [ PYTHON_VERSION=$with_python_version ]
)

if test ! "$PYTHON_PREFIX" = ""
then
    PATH="$PYTHON_PREFIX/bin:$PATH"
fi

if test ! "$PYTHON_VERSION" = ""
then
    PYTHON_EXEC="python$PYTHON_VERSION"
else
    PYTHON_EXEC="python python2.2 python2.3"
fi

AC_PATH_PROGS(PYTHON, $PYTHON_EXEC, no, $PATH)

if test "$PYTHON" != "no"
then
  dnl Use the values of $prefix and $exec_prefix for the corresponding
  dnl values of PYTHON_PREFIX and PYTHON_EXEC_PREFIX.  These are made
  dnl distinct variables so they can be overridden if need be.  However,
  dnl general consensus is that you shouldn't need this ability.

  AC_SUBST(PYTHON_PREFIX)
  PYTHON_PREFIX='${prefix}'

  AC_SUBST(PYTHON_EXEC_PREFIX)
  PYTHON_EXEC_PREFIX='${exec_prefix}'
    PYTHON_VERSION=`$PYTHON -c 'import sys; print "%s" % (sys.version[[:3]])'`

    INSTALLED_PYTHON_PREFIX=`$PYTHON -c 'import sys; print "%s" % (sys.prefix)'`
    INSTALLED_PYTHON_EXEC_PREFIX=`$PYTHON -c 'import sys; print "%s" % (sys.exec_prefix)'`
    is_python_version_enough=`expr $python_version_required \<= $PYTHON_VERSION`
fi


if test "$PYTHON" = "no" || test "$is_python_version_enough" != "1"
then

    if test "$is_mandatory" = "yes"
    then
        AC_MSG_ERROR([Python $python_version_required must be installed (http://www.python.org)])
    else
        have_python="no"
    fi

else

    python_includes="$INSTALLED_PYTHON_PREFIX/include/python$PYTHON_VERSION"
    python_libraries="$INSTALLED_PYTHON_PREFIX/lib/python$PYTHON_VERSION/config"
    python_lib="python$PYTHON_VERSION"

    PYTHON_CFLAGS="-I$python_includes"
    PYTHON_LIBS="-L$python_libraries -l$python_lib"

    _CPPFLAGS="$CPPFLAGS"
    CPPFLAGS="$CFLAGS ${PYTHON_CFLAGS}"

    AC_MSG_NOTICE([Searching python includes in $python_includes])

    AC_CHECK_HEADER([Python.h],
      have_python_headers="yes",
      have_python_headers="no" )

    dnl Test the libraries
    AC_MSG_CHECKING(for Python libraries)

    CPPFLAGS="$CFLAGS $PYTHON_CFLAGS"

    AC_TRY_LINK( , , have_python_libraries="yes", have_python_libraries="no")

    CPPFLAGS="$_CPPFLAGS"

    if test "$have_python_libraries" = "yes"
    then
        if test "$python_libraries"
        then
            AC_MSG_RESULT([$python_libraries])
        else
            AC_MSG_RESULT(yes)
        fi
    else
        AC_MSG_RESULT(no)
    fi

    if test "$have_python_headers" = "yes" \
       && test "$have_python_libraries" = "yes"
    then
        have_python="yes"
    else
        have_python="no"
    fi

    if test "$have_python" = "no" -a "$is_mandatory" = "yes"
    then
        AC_MSG_ERROR([Python is required to produce C++ based interpreter.])
    fi

    AC_SUBST(PYTHON_CFLAGS)
    AC_SUBST(PYTHON_LIBS)

  dnl At times (like when building shared libraries) you may want
  dnl to know which OS platform Python thinks this is.

  AC_SUBST(PYTHON_PLATFORM)
  PYTHON_PLATFORM=`$PYTHON -c "import sys; print sys.platform"`


  dnl Set up 4 directories:

  dnl pythondir -- where to install python scripts.  This is the
  dnl   site-packages directory, not the python standard library
  dnl   directory like in previous automake betas.  This behaviour
  dnl   is more consistent with lispdir.m4 for example.
  dnl
  dnl Also, if the package prefix isn't the same as python's prefix,
  dnl then the old $(pythondir) was pretty useless.

  AC_SUBST(pythondir)
  pythondir=$PYTHON_PREFIX"/lib/python"$PYTHON_VERSION/site-packages

  dnl pkgpythondir -- $PACKAGE directory under pythondir.  Was
  dnl   PYTHON_SITE_PACKAGE in previous betas, but this naming is
  dnl   more consistent with the rest of automake.
  dnl   Maybe this should be put in python.am?

  AC_SUBST(pkgpythondir)
  pkgpythondir=\${pythondir}/$PACKAGE

  dnl pyexecdir -- directory for installing python extension modules
  dnl   (shared libraries)  Was PYTHON_SITE_EXEC in previous betas.

  AC_SUBST(pyexecdir)
  pyexecdir=$PYTHON_EXEC_PREFIX"/lib/python"$PYTHON_VERSION/site-packages

  dnl pkgpyexecdir -- $(pyexecdir)/$(PACKAGE)
  dnl   Maybe this should be put in python.am?

  AC_SUBST(pkgpyexecdir)
  pkgpyexecdir=\${pyexecdir}/$PACKAGE

fi

])

## ------------------------
## Python file handling
## From Andrew Dalke
## Updated by James Henstridge
## Updated by Ludovic Heyberger, Loic Dachary (2005)
## ------------------------

# Copyright 1999, 2000, 2001, 2002, 2003, 2005  Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# AM_PATH_PYTHON([VERSION-CONSTRAINT])

# Adds support for distributing Python modules and packages.  To
# install modules, copy them to $(pythondir), using the python_PYTHON
# automake variable.  To install a package with the same name as the
# automake package, install to $(pkgpythondir), or use the
# pkgpython_PYTHON automake variable.

# The variables $(pyexecdir) and $(pkgpyexecdir) are provided as
# locations to install python extension modules (shared libraries).
# Another macro is required to find the appropriate flags to compile
# extension modules.

# If your package is configured with a different prefix to python,
# users will have to add the install directory to the PYTHONPATH
# environment variable, or create a .pth file (see the python
# documentation for details).

# If the VERSION-CONSTRAINT argument is passed, AM_PATH_PYTHON will
# cause an error if the version of python installed on the system
# doesn't meet the requirement. VERSION-CONSTRAINT should consist of
# an operator (>=, <=, =, >, <) followed by a version (1, 2, 2.3, 2.4, 1.5.2 etc.)
# Examples: >2.3, =2.2, >=1.5.1 ... If the operator is omited, it defaults
# to >= (i.e. 2.3 is equivalent to >=2.3)

AC_DEFUN([AM_PATH_PYTHON],
 [
  dnl Find a Python interpreter.  Python versions prior to 1.5 are not
  dnl supported because the default installation locations changed from
  dnl $prefix/lib/site-python in 1.4 to $prefix/lib/python1.5/site-packages
  dnl in 1.5.
  m4_define([_AM_PYTHON_INTERPRETER_LIST],
	    [python python2 python2.3 python2.2 python2.1 python2.0 python1.6 python1.5])

  m4_if([$1],[],[
    dnl No version check is needed.
    # Find any Python interpreter.
    AC_PATH_PROGS([PYTHON], _AM_PYTHON_INTERPRETER_LIST)
    am_display_PYTHON=python
  ], [
    dnl A version check is needed.
    if expr "$1" : "[[<>=]]" > /dev/null
    then
      required_version="$1"
    else
      required_version=">=$1"
    fi
	
    if test -n "$PYTHON"; then
      # If the user set $PYTHON, use it and don't search something else.
      AC_MSG_CHECKING([whether $PYTHON version $required_version])
      AM_PYTHON_CHECK_VERSION([$PYTHON], [$required_version],
			      [AC_MSG_RESULT(yes)],
			      [AC_MSG_ERROR(too old)])
    else
      # Otherwise, try each interpreter until we find one that satisfies
      # VERSION.
      AC_CACHE_CHECK([for a Python interpreter with version $required_version],
	[am_cv_pathless_PYTHON],[
	for am_cv_pathless_PYTHON in _AM_PYTHON_INTERPRETER_LIST : ; do
          if test "$am_cv_pathless_PYTHON" = : ; then
            AC_MSG_ERROR([no suitable Python interpreter found])
	  fi
          AM_PYTHON_CHECK_VERSION([$am_cv_pathless_PYTHON], [$required_version], [break])
        done])
      # Set $PYTHON to the absolute path of $am_cv_pathless_PYTHON.
      AC_PATH_PROG([PYTHON], [$am_cv_pathless_PYTHON])
      am_display_PYTHON=$am_cv_pathless_PYTHON
    fi
  ])

  dnl Query Python for its version number.  Getting [:3] seems to be
  dnl the best way to do this; it's what "site.py" does in the standard
  dnl library.

  AC_CACHE_CHECK([for $am_display_PYTHON version], [am_cv_python_version],
    [am_cv_python_version=`$PYTHON -c "import sys; print sys.version[[:3]]"`])
  AC_SUBST([PYTHON_VERSION], [$am_cv_python_version])

  dnl Use the values of $prefix and $exec_prefix for the corresponding
  dnl values of PYTHON_PREFIX and PYTHON_EXEC_PREFIX.  These are made
  dnl distinct variables so they can be overridden if need be.  However,
  dnl general consensus is that you shouldn't need this ability.

  AC_SUBST([PYTHON_PREFIX], ['${prefix}'])
  AC_SUBST([PYTHON_EXEC_PREFIX], ['${exec_prefix}'])

  dnl At times (like when building shared libraries) you may want
  dnl to know which OS platform Python thinks this is.

  AC_CACHE_CHECK([for $am_display_PYTHON platform], [am_cv_python_platform],
    [am_cv_python_platform=`$PYTHON -c "import sys; print sys.platform"`])
  AC_SUBST([PYTHON_PLATFORM], [$am_cv_python_platform])


  dnl Set up 4 directories:

  dnl pythondir -- where to install python scripts.  This is the
  dnl   site-packages directory, not the python standard library
  dnl   directory like in previous automake betas.  This behavior
  dnl   is more consistent with lispdir.m4 for example.
  dnl Query distutils for this directory.  distutils does not exist in
  dnl Python 1.5, so we fall back to the hardcoded directory if it
  dnl doesn't work.
  AC_CACHE_CHECK([for $am_display_PYTHON script directory],
    [am_cv_python_pythondir],
    [am_cv_python_pythondir=`$PYTHON -c "from distutils import sysconfig; print sysconfig.get_python_lib(0,0,prefix='$PYTHON_PREFIX')" 2>/dev/null ||
     echo "$PYTHON_PREFIX/lib/python$PYTHON_VERSION/site-packages"`])
  AC_SUBST([pythondir], [$am_cv_python_pythondir])

  dnl pkgpythondir -- $PACKAGE directory under pythondir.  Was
  dnl   PYTHON_SITE_PACKAGE in previous betas, but this naming is
  dnl   more consistent with the rest of automake.

  AC_SUBST([pkgpythondir], [\${pythondir}/$PACKAGE])

  dnl pyexecdir -- directory for installing python extension modules
  dnl   (shared libraries)
  dnl Query distutils for this directory.  distutils does not exist in
  dnl Python 1.5, so we fall back to the hardcoded directory if it
  dnl doesn't work.
  AC_CACHE_CHECK([for $am_display_PYTHON extension module directory],
    [am_cv_python_pyexecdir],
    [am_cv_python_pyexecdir=`$PYTHON -c "from distutils import sysconfig; print sysconfig.get_python_lib(1,0,prefix='$PYTHON_EXEC_PREFIX')" 2>/dev/null ||
     echo "${PYTHON_EXEC_PREFIX}/lib/python${PYTHON_VERSION}/site-packages"`])
  AC_SUBST([pyexecdir], [$am_cv_python_pyexecdir])

  dnl pkgpyexecdir -- $(pyexecdir)/$(PACKAGE)

  AC_SUBST([pkgpyexecdir], [\${pyexecdir}/$PACKAGE])
])


# AM_PYTHON_CHECK_VERSION(PROG, VERSION-CONSTRAINT, [ACTION-IF-TRUE], [ACTION-IF-FALSE])
# ---------------------------------------------------------------------------
# Run ACTION-IF-TRUE if the Python interpreter PROG has version that 
# satifies VERSION-CONSTRAINT.
# Run ACTION-IF-FALSE otherwise.
# This test uses sys.hexversion instead of the string equivalent (first
# word of sys.version), in order to cope with versions such as 2.2c1.
# hexversion has been introduced in Python 1.5.2; it's probably not
# worth to support older versions (1.5.1 was released on October 31, 1998).
# Do *not* use the operator as it is not available in every supported 
# python versions
AC_DEFUN([AM_PYTHON_CHECK_VERSION],
 [prog="import sys, string
spec = string.replace('$2', ' ', '')
if spec[[:2]] == '<=':
  version_string = spec[[2:]]
elif spec[[:2]] == '>=':
  version_string = spec[[2:]]
elif spec[[:1]] == '=':
  version_string = spec[[1:]]
elif spec[[:1]] == '>':
  version_string = spec[[1:]]
elif spec[[:1]] == '<':
  version_string = spec[[1:]]
ver = map(int, string.split(version_string, '.'))
syshexversion = sys.hexversion >> (8 * (4 - l""en(ver)))
verhex = 0
for i in xrange(0, l""en(ver)): verhex = (verhex << 8) + ver[[i]]
print 'sys.hexversion = 0x%08x, verhex = 0x%08x' % (syshexversion, verhex)
if spec[[:2]] == '<=':
  status = syshexversion <= verhex
elif spec[[:2]] == '>=':
  status = syshexversion >= verhex
elif spec[[:1]] == '=':
  status = syshexversion == verhex
elif spec[[:1]] == '>':
  status = syshexversion > verhex
elif spec[[:1]] == '<':
  status = syshexversion < verhex
else:
  status = syshexversion >= verhex

if status:
  sys.exit(0)
else:
  sys.exit(1)"
  AS_IF([AM_RUN_LOG([$1 -c "$prog"])], [$3], [$4])])
