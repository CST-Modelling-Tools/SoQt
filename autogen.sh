#!/bin/sh

# Author: Morten Eriksen, <mortene@sim.no>. Loosely based on Ralph
# Levien's script for Gnome.

DIE=0

PROJECT=SoQt

echo "Checking the installed configuration tools..."

# FIXME: check for minimum version number? 19990822 mortene.
(autoconf --version) < /dev/null > /dev/null 2>&1 || {
        echo
        echo "You must have autoconf installed to generate"
	echo "configure information and Makefiles for $PROJECT."
        echo "Get ftp://ftp.gnu.org/pub/gnu/autoconf-*.tar.gz"
        DIE=1
}

# FIXME: check for minimum version number? 19990822 mortene.
(libtool --version) < /dev/null > /dev/null 2>&1 || {
        echo
        echo "You must have libtool installed to generate"
	echo "configure information and Makefiles for $PROJECT."
        echo "Get ftp://ftp.gnu.org/pub/gnu/libtool-*.tar.gz"
        DIE=1
}

# FIXME: check for minimum version number? 19990822 mortene.
(automake --version) < /dev/null > /dev/null 2>&1 || {
        echo
        echo "You must have automake installed to generate"
	echo "configure information and Makefiles for $PROJECT."
        echo "Get ftp://ftp.gnu.org/pub/gnu/automake-*.tar.gz"
        DIE=1
}

# FIXME: check for more tools? 19990822 mortene.

if test "$DIE" -eq 1; then
        exit 1
fi

echo "Running aclocal (generating aclocal.m4)..."
aclocal

echo "Running autoheader (generating config.h.in)..."
autoheader

echo "Running automake (generating the Makefile.in files)..."
echo "(NB: if you're compiling without g++, you probably need to"
echo "manually run automake with the --include-deps argument to"
echo "avoid setting up dependency tracking. 19991006 mortene.)"
automake

echo "Running autoconf (generating ./configure and the Makefile files)..."
autoconf

echo "Done: Now run './configure' and 'make install' to build $PROJECT."

