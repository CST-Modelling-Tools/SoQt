# generated automatically by aclocal 1.7.5 -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002
# Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

 **************************************************************************
# gendsp.m4
#
# macros:
#   SIM_AC_MSVC_DSP_ENABLE_OPTION
#   SIM_AC_MSVC_DSP_SETUP(PROJECT, Project, project, extra-args)
#
# authors:
#   Lars J. Aas <larsa@coin3d.org>

# **************************************************************************
AC_DEFUN([SIM_AC_MSVC_DSP_ENABLE_OPTION], [
AC_ARG_ENABLE([msvcdsp],
  [AC_HELP_STRING([--enable-msvcdsp], [build .dsp, not library])],
  [case $enableval in
  no | false) sim_ac_make_dsp=false ;;
  *)          sim_ac_make_dsp=true ;;
  esac],
  [sim_ac_make_dsp=false])

if $sim_ac_make_dsp; then
  enable_dependency_tracking=no
  enable_libtool_lock=no
fi
]) # SIM_AC_MSVC_DSP_ENABLE_OPTION

# **************************************************************************
AC_DEFUN([SIM_AC_MSVC_DSP_SETUP], [
AC_REQUIRE([SIM_AC_MSVC_DSP_ENABLE_OPTION])
$1_DSP_LIBDIRS=
$1_DSP_LIBS=
$1_DSP_INCS=
$1_LIB_DSP_DEFS=
$1_DSP_DEFS=

if $sim_ac_make_dsp; then
  SIM_AC_CONFIGURATION_SETTING([$2 build type], [msvc .dsp])

  # -DHAVE_CONFIG_H is set up in $DEFS too late for us to use, and some
  # include directives are usually set up in the Makefile.am files
  for arg in -DHAVE_CONFIG_H $4 $CPPFLAGS $LDFLAGS $LIBS; do
    case $arg in
    -L* )
      libdir=`echo $arg | cut -c3-`
      $1_DSP_LIBDIRS="[$]$1_DSP_LIBDIRS $libdir"
      ;;
    -l* )
      libname=`echo $arg | cut -c3-`
      for libdir in [$]$1_DSP_LIBDIRS; do
        if test -f $libdir/$libname.lib; then
          # lib is not in any standard location - use full path
          libname=`cygpath -w "$libdir/$libname" 2>/dev/null || echo "$libdir/$libname"`
          break
        fi
      done
      if test x"[$]$1_DSP_LIBS" = x""; then
        $1_DSP_LIBS="$libname.lib"
      else
        $1_DSP_LIBS="[$]$1_DSP_LIBS $libname.lib"
      fi
      ;;
    -I* )
      incdir=`echo $arg | cut -c3-`
      incdir=`cygpath -w "$incdir" 2>/dev/null || echo "$incdir"`
      if test x"[$]$1_DSP_INCS" = x""; then
        $1_DSP_INCS="/I \"$incdir\""
      else
        $1_DSP_INCS="[$]$1_DSP_INCS /I \"$incdir\""
      fi
      ;;
    -D$1_DEBUG* | -DNDEBUG )
      # Defines that vary between release/debug configurations can't be
      # set up dynamically in <lib>_DSP_DEFS - they must be static in the
      # gendsp.pl script.  We therefore catch them here so we can ignore
      # checking for them below.
      ;;
    -D*=* | -D* )
      define=`echo $arg | cut -c3-`
      if test x"[$]$1_DSP_DEFS" = x""; then
        $1_DSP_DEFS="/D \"$define\""
      else
        $1_DSP_DEFS="[$]$1_DSP_DEFS /D \"$define\""
      fi
      if (echo $define | grep _MAKE_DLL) >/dev/null 2>&1; then
        :
      else
        if test x"[$]$1_DSP_DEFS" = x""; then
          $1_LIB_DSP_DEFS="/D \"$define\""
        else
          $1_LIB_DSP_DEFS="[$]$1_LIB_DSP_DEFS /D \"$define\""
        fi
      fi
      ;;
    esac
  done

  CC=[$]$3_build_dir/cfg/gendsp.pl
  CXX=[$]$3_build_dir/cfg/gendsp.pl
  CXXLD=[$]$3_build_dir/cfg/gendsp.pl
  # Yes, this is totally bogus stuff, but don't worry about it.  As long
  # as gendsp.pl recognizes it...  20030219 larsa
  CPPFLAGS="$CPPFLAGS -Ddspfile=[$]$3_build_dir/$3[$]$1_MAJOR_VERSION.dsp"
  LDFLAGS="$LDFLAGS -Wl,-Ddspfile=[$]$3_build_dir/$3[$]$1_MAJOR_VERSION.dsp"
  LIBFLAGS="$LIBFLAGS -o $3[$]$1_MAJOR_VERSION.so.0"

  # this can't be set up at the point the libtool script is generated
  mv libtool libtool.bak
  sed -e "s%^CC=\"gcc\"%CC=\"[$]$3_build_dir/cfg/gendsp.pl\"%" \
      -e "s%^CC=\".*/wrapmsvc.exe\"%CC=\"[$]$3_build_dir/cfg/gendsp.pl\"%" \
      <libtool.bak >libtool
  rm -f libtool.bak
  chmod 755 libtool
fi

AC_SUBST([$1_DSP_LIBS])
AC_SUBST([$1_DSP_INCS])
AC_SUBST([$1_DSP_DEFS])
AC_SUBST([$1_LIB_DSP_DEFS])
])


# **************************************************************************
# configuration_summary.m4
#
# This file contains some utility macros for making it easy to have a short
# summary of the important configuration settings printed at the end of the
# configure run.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

# **************************************************************************
# SIM_AC_CONFIGURATION_SETTING( DESCRIPTION, SETTING )
#
# This macro registers a configuration setting to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_SETTING],
[ifelse($#, 2, [], [m4_fatal([SIM_AC_CONFIGURATION_SETTING: takes two arguments])])
if test x"${sim_ac_configuration_settings+set}" = x"set"; then
  sim_ac_configuration_settings="$sim_ac_configuration_settings|$1:$2"
else
  sim_ac_configuration_settings="$1:$2"
fi
]) # SIM_AC_CONFIGURATION_SETTING

# **************************************************************************
# SIM_AC_CONFIGURATION_WARNING( WARNING )
#
# This macro registers a configuration warning to be dumped by the
# SIM_AC_CONFIGURATION_SUMMARY macro.

AC_DEFUN([SIM_AC_CONFIGURATION_WARNING],
[ifelse($#, 1, [], [m4_fatal([SIM_AC_CONFIGURATION_WARNING: takes one argument])])
if test x"${sim_ac_configuration_warnings+set}" = x"set"; then
  sim_ac_configuration_warnings="$sim_ac_configuration_warnings|$1"
else
  sim_ac_configuration_warnings="$1"
fi
]) # SIM_AC_CONFIGURATION_WARNING

# **************************************************************************
# SIM_AC_CONFIGURATION_SUMMARY
#
# This macro dumps the settings and warnings summary.

AC_DEFUN([SIM_AC_CONFIGURATION_SUMMARY],
[ifelse($#, 0, [], [m4_fatal([SIM_AC_CONFIGURATION_SUMMARY: takes no arguments])])
sim_ac_settings="$sim_ac_configuration_settings"
sim_ac_num_settings=`echo "$sim_ac_settings" | tr -d -c "|" | wc -c`
sim_ac_maxlength=0
while test $sim_ac_num_settings -ge 0; do
  sim_ac_description=`echo "$sim_ac_settings" | cut -d: -f1`
  sim_ac_length=`echo "$sim_ac_description" | wc -c`
  if test $sim_ac_length -gt $sim_ac_maxlength; then
    sim_ac_maxlength=`expr $sim_ac_length + 0`
  fi
  sim_ac_settings=`echo $sim_ac_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

sim_ac_maxlength=`expr $sim_ac_maxlength + 3`
sim_ac_padding=`echo "                                             " |
  cut -c1-$sim_ac_maxlength`

sim_ac_num_settings=`echo "$sim_ac_configuration_settings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration settings:"
while test $sim_ac_num_settings -ge 0; do
  sim_ac_setting=`echo $sim_ac_configuration_settings | cut -d"|" -f1`
  sim_ac_description=`echo "$sim_ac_setting" | cut -d: -f1`
  sim_ac_status=`echo "$sim_ac_setting" | cut -d: -f2-`
  # hopefully not too many terminals are too dumb for this
  printf "$sim_ac_padding $sim_ac_status\r  $sim_ac_description:\n"
  sim_ac_configuration_settings=`echo $sim_ac_configuration_settings | cut -d"|" -f2-`
  sim_ac_num_settings=`expr $sim_ac_num_settings - 1`
done

if test x${sim_ac_configuration_warnings+set} = xset; then
sim_ac_num_warnings=`echo "$sim_ac_configuration_warnings" | tr -d -c "|" | wc -c`
echo ""
echo "$PACKAGE configuration warnings:"
while test $sim_ac_num_warnings -ge 0; do
  sim_ac_warning=`echo "$sim_ac_configuration_warnings" | cut -d"|" -f1`
  echo "  * $sim_ac_warning"
  sim_ac_configuration_warnings=`echo $sim_ac_configuration_warnings | cut -d"|" -f2-`
  sim_ac_num_warnings=`expr $sim_ac_num_warnings - 1`
done
fi
]) # SIM_AC_CONFIGURATION_SUMMARY


# **************************************************************************
# SIM_AC_SETUP_MSVC_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# This macro invokes IF-FOUND if the wrapmsvc wrapper can be run, and
# IF-NOT-FOUND if not.
#
# Authors:
#   Morten Eriksen <mortene@coin3d.org>
#   Lars J. Aas <larsa@coin3d.org>

# **************************************************************************

AC_DEFUN([SIM_AC_MSVC_DISABLE_OPTION], [
AC_ARG_ENABLE([msvc],
  [AC_HELP_STRING([--disable-msvc], [don't require MS Visual C++ on Cygwin])],
  [case $enableval in
  no | false) sim_ac_try_msvc=false ;;
  *)          sim_ac_try_msvc=true ;;
  esac],
  [sim_ac_try_msvc=true])
])

# **************************************************************************
# Usage:
#  SIM_AC_MSC_VERSION
#
# Find version number of the Visual C++ compiler. sim_ac_msc_version will
# contain the full version number string, and sim_ac_msc_major_version
# will contain only the Visual C++ major version number and
# sim_ac_msc_minor_version will contain the minor version number.

AC_DEFUN([SIM_AC_MSC_VERSION], [

AC_MSG_CHECKING([version of Visual C++ compiler])

cat > conftest.c << EOF
int VerMSC = _MSC_VER;
EOF

# The " *"-parts of the last sed-expression on the next line are necessary
# because at least the Solaris/CC preprocessor adds extra spaces before and
# after the trailing semicolon.
sim_ac_msc_version=`$CXXCPP $CPPFLAGS conftest.c 2>/dev/null | grep '^int VerMSC' | sed 's%^int VerMSC = %%' | sed 's% *;.*$%%'`

sim_ac_msc_minor_version=0
if test $sim_ac_msc_version -ge 1500; then
  sim_ac_msc_major_version=9
elif test $sim_ac_msc_version -ge 1400; then
  sim_ac_msc_major_version=8
elif test $sim_ac_msc_version -ge 1300; then
  sim_ac_msc_major_version=7
  if test $sim_ac_msc_version -ge 1310; then
    sim_ac_msc_minor_version=1
  fi
elif test $sim_ac_msc_version -ge 1200; then
  sim_ac_msc_major_version=6
elif test $sim_ac_msc_version -ge 1100; then
  sim_ac_msc_major_version=5
else
  sim_ac_msc_major_version=0
fi

# compatibility with old version of macro
sim_ac_msvc_version=$sim_ac_msc_major_version

rm -f conftest.c
AC_MSG_RESULT($sim_ac_msc_major_version.$sim_ac_msc_minor_version)
]) # SIM_AC_MSC_VERSION

# **************************************************************************
# Note: the SIM_AC_SETUP_MSVC_IFELSE macro has been OBSOLETED and
# replaced by the one below.
#
# If the Microsoft Visual C++ cl.exe compiler is available, set us up for
# compiling with it and to generate an MSWindows .dll file.

AC_DEFUN([SIM_AC_SETUP_MSVCPP_IFELSE],
[
AC_REQUIRE([SIM_AC_MSVC_DISABLE_OPTION])
AC_REQUIRE([SIM_AC_SPACE_IN_PATHS])

: ${BUILD_WITH_MSVC=false}
if $sim_ac_try_msvc; then
  if test -z "$CC" -a -z "$CXX"; then
    sim_ac_wrapmsvc=`cd $ac_aux_dir; pwd`/wrapmsvc.exe
    echo "$as_me:$LINENO: sim_ac_wrapmsvc=$sim_ac_wrapmsvc" >&AS_MESSAGE_LOG_FD
    AC_MSG_CHECKING([setup for wrapmsvc.exe])
    if $sim_ac_wrapmsvc >&AS_MESSAGE_LOG_FD 2>&AS_MESSAGE_LOG_FD; then
      m4_ifdef([$0_VISITED],
        [AC_FATAL([Macro $0 invoked multiple times])])
      m4_define([$0_VISITED], 1)
      CC=$sim_ac_wrapmsvc
      CXX=$sim_ac_wrapmsvc
      export CC CXX
      BUILD_WITH_MSVC=true
      AC_MSG_RESULT([working])

      # Robustness: we had multiple reports of Cygwin ''link'' getting in
      # the way of MSVC link.exe, so do a little sanity check for that.
      #
      # FIXME: a better fix would be to call link.exe with full path from
      # the wrapmsvc wrapper, to avoid any trouble with this -- I believe
      # that should be possible, using the dirname of the full cl.exe path.
      # 20050714 mortene.
      sim_ac_check_link=`type link`
      AC_MSG_CHECKING([whether Cygwin's /usr/bin/link shadows MSVC link.exe])
      case x"$sim_ac_check_link" in
      x"link is /usr/bin/link"* )
        AC_MSG_RESULT(yes)
        SIM_AC_ERROR([cygwin-link])
        ;;
      * )
        AC_MSG_RESULT(no)
        ;;
      esac

    else
      case $host in
      *-cygwin)
        AC_MSG_RESULT([not working])
        SIM_AC_ERROR([no-msvc++]) ;;
      *)
        AC_MSG_RESULT([not working (as expected)])
        ;;
      esac
    fi
  fi
fi
export BUILD_WITH_MSVC
AC_SUBST(BUILD_WITH_MSVC)

if $BUILD_WITH_MSVC; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_SETUP_MSVC_IFELSE

# **************************************************************************
# SIM_AC_SETUP_MSVCRT
#
# This macro sets up compiler flags for the MS Visual C++ C library of
# choice.

AC_DEFUN([SIM_AC_SETUP_MSVCRT],
[sim_ac_msvcrt_LDFLAGS=""
sim_ac_msvcrt_LIBS=""

AC_ARG_WITH([msvcrt],
  [AC_HELP_STRING([--with-msvcrt=<crt>],
                  [set which C run-time library to build against])],
  [case `echo "$withval" | tr "[A-Z]" "[a-z]"` in
  default | singlethread-static | ml | /ml | libc | libc\.lib )
    sim_ac_msvcrt=singlethread-static
    sim_ac_msvcrt_CFLAGS="/ML"
    sim_ac_msvcrt_CXXFLAGS="/ML"
    ;;
  default-debug | singlethread-static-debug | mld | /mld | libcd | libcd\.lib )
    sim_ac_msvcrt=singlethread-static-debug
    sim_ac_msvcrt_CFLAGS="/MLd"
    sim_ac_msvcrt_CXXFLAGS="/MLd"
    ;;
  multithread-static | mt | /mt | libcmt | libcmt\.lib )
    sim_ac_msvcrt=multithread-static
    sim_ac_msvcrt_CFLAGS="/MT"
    sim_ac_msvcrt_CXXFLAGS="/MT"
    ;;
  multithread-static-debug | mtd | /mtd | libcmtd | libcmtd\.lib )
    sim_ac_msvcrt=multithread-static-debug
    sim_ac_msvcrt_CFLAGS="/MTd"
    sim_ac_msvcrt_CXXFLAGS="/MTd"
    ;;
  multithread-dynamic | md | /md | msvcrt | msvcrt\.lib )
    sim_ac_msvcrt=multithread-dynamic
    sim_ac_msvcrt_CFLAGS="/MD"
    sim_ac_msvcrt_CXXFLAGS="/MD"
    ;;
  multithread-dynamic-debug | mdd | /mdd | msvcrtd | msvcrtd\.lib )
    sim_ac_msvcrt=multithread-dynamic-debug
    sim_ac_msvcrt_CFLAGS="/MDd"
    sim_ac_msvcrt_CXXFLAGS="/MDd"
    ;;
  *)
    SIM_AC_ERROR([invalid-msvcrt])
    ;;
  esac],
  [sim_ac_msvcrt=singlethread-static])

AC_MSG_CHECKING([MSVC++ C library choice])
AC_MSG_RESULT([$sim_ac_msvcrt])

$1
]) # SIM_AC_SETUP_MSVCRT

# **************************************************************************
# SIM_AC_SPACE_IN_PATHS

AC_DEFUN([SIM_AC_SPACE_IN_PATHS], [
sim_ac_full_builddir=`pwd`
sim_ac_full_srcdir=`cd $srcdir; pwd`
if test -z "`echo $sim_ac_full_srcdir | tr -cd ' '`"; then :; else
  AC_MSG_WARN([Detected space character in the path leading up to the Coin source directory - this will probably cause random problems later. You are advised to move the Coin source directory to another location.])
  SIM_AC_CONFIGURATION_WARNING([Detected space character in the path leading up to the Coin source directory - this will probably cause random problems later. You are advised to move the Coin source directory to another location.])
fi
if test -z "`echo $sim_ac_full_builddir | tr -cd ' '`"; then :; else
  AC_MSG_WARN([Detected space character in the path leading up to the Coin build directory - this will probably cause random problems later. You are advised to move the Coin build directory to another location.])
  SIM_AC_CONFIGURATION_WARNING([Detected space character in the path leading up to the Coin build directory - this will probably cause random problems later. You are advised to move the Coin build directory to another location.])
fi
]) # SIM_AC_SPACE_IN_PATHS

# EOF **********************************************************************

# **************************************************************************
# SIM_AC_ERROR_MESSAGE_FILE( FILENAME )
#   Sets the error message file.  Default is $ac_aux_dir/m4/errors.txt.
#
# SIM_AC_ERROR( ERROR [, ERROR ...] )
#   Fetches the error messages from the error message file and displays
#   them on stderr. The configure process will subsequently exit.
#
# SIM_AC_WARN( ERROR [, ERROR ...] )
#   As SIM_AC_ERROR, but will not exit after displaying the message(s).
#
# SIM_AC_WITH_ERROR( WITHARG )
#   Invokes AC_MSG_ERROR in a consistent way for problems with the --with-*
#   $withval argument.
#
# SIM_AC_ENABLE_ERROR( ENABLEARG )
#   Invokes AC_MSG_ERROR in a consistent way for problems with the --enable-*
#   $enableval argument.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>

AC_DEFUN([SIM_AC_ERROR_MESSAGE_FILE], [
sim_ac_message_file=$1
]) # SIM_AC_ERROR_MESSAGE_FILE

AC_DEFUN([SIM_AC_ONE_MESSAGE], [
: ${sim_ac_message_file=$ac_aux_dir/errors.txt}
if test -f $sim_ac_message_file; then
  sim_ac_message="`sed -n -e '/^!$1$/,/^!/ { /^!/ d; p; }' <$sim_ac_message_file`"
  if test x"$sim_ac_message" = x""; then
    AC_MSG_ERROR([no message named '$1' in '$sim_ac_message_file' - notify the $PACKAGE_NAME maintainer(s)])
  else
    eval "echo >&2 \"$sim_ac_message\""
  fi
else
  AC_MSG_ERROR([file '$sim_ac_message_file' not found - notify the $PACKAGE_NAME maintainer(s)])
fi
]) # SIM_AC_ONE_MESSAGE

AC_DEFUN([_SIM_AC_ERROR], [
SIM_AC_ONE_MESSAGE([$1])
ifelse([$2], , , [
echo >&2 ""
_SIM_AC_ERROR(m4_shift($@))])
]) # _SIM_AC_ERROR

AC_DEFUN([SIM_AC_ERROR], [
echo >&2 ""
_SIM_AC_ERROR($@)
echo >&2 ""
AC_MSG_ERROR([aborting])
]) # SIM_AC_ERROR

AC_DEFUN([SIM_AC_WARN], [
echo >&2 ""
_SIM_AC_ERROR($@)
echo >&2 ""
]) # SIM_AC_WARN

AC_DEFUN([SIM_AC_WITH_ERROR], [
AC_MSG_ERROR([invalid value "${withval}" for "$1" configure argument])
]) # SIM_AC_WITH_ERROR

AC_DEFUN([SIM_AC_ENABLE_ERROR], [
AC_MSG_ERROR([invalid value "${enableval}" for "$1" configure argument])
]) # SIM_AC_ENABLE_ERROR


# *******************************************************************
# SIM_AC_RELATIVE_SRC_DIR
#
# Sets $sim_ac_relative_src_dir to the relative path to the source
# directory, and $sim_ac_relative_src_dir_p to true or false depending
# on whether a relative path can be used or not (in case of different
# drives).
#
# Author:
#   Lars J. Aas <larsa@sim.no>


AC_DEFUN([SIM_AC_RELATIVE_SRC_DIR], [

temp_build_dir=`pwd`
temp_src_dir=`cd "$srcdir"; pwd`

temp_up=""
temp_down=""

while test "$temp_build_dir" != "$temp_src_dir"; do
  srclen=`echo "$temp_src_dir" | wc -c`
  buildlen=`echo "$temp_build_dir" | wc -c`
  if test $srclen -gt $buildlen; then
    # cut source tail, insert into temp_up
    temp_src_tail=`echo "$temp_src_dir" | sed -e 's,.*/,,g'`
    temp_src_dir=`echo "$temp_src_dir" | sed -e 's,/[[^/]]*\$,,g'`
    if test x"$temp_up" = "x"; then
      temp_up="$temp_src_tail"
    else
      temp_up="$temp_src_tail/$temp_up"
    fi
  else
    # cut build tail, increase temp_down
    temp_build_dir=`echo "$temp_build_dir" | sed -e 's,/[[^/]]*\$,,g'`
    if test x"$temp_down" = "x"; then
      temp_down=..
    else
      temp_down="../$temp_down"
    fi
  fi
done

if test x"$temp_down" = "x"; then
  if test x"$temp_up" = "x"; then
    sim_ac_relative_src_dir="."
  else
    sim_ac_relative_src_dir="$temp_up"
  fi
else
  if test x"$temp_up" = "x"; then
    sim_ac_relative_src_dir="$temp_down"
  else
    sim_ac_relative_src_dir="$temp_down/$temp_up"
  fi
fi

# this gives false positives on windows, but that's ok for now...
if test -f $sim_ac_relative_src_dir/$ac_unique_file; then
  sim_ac_relative_src_dir_p=true;
else
  sim_ac_relative_src_dir_p=false;
fi

AC_SUBST(ac_unique_file) # useful to have to check the relative path
AC_SUBST(sim_ac_relative_src_dir)
AC_SUBST(sim_ac_relative_src_dir_p)

]) # SIM_AC_RELATIVE_SRC_DIR


# **************************************************************************
# SIM_AC_MACOS10_DEPLOYMENT_TARGET

AC_DEFUN([SIM_AC_MACOS10_DEPLOYMENT_TARGET], [

# might not case on host_os here in case of crosscompiling in the future...
case "$host_os" in
darwin*)
  AC_MSG_CHECKING([OS X deployment target])
  cat > conftest.c << EOF
int VerOSX = __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__;
EOF
  # The " *"-parts of the last sed-expression on the next line are necessary
  # because at least the Solaris/CC preprocessor adds extra spaces before and
  # after the trailing semicolon.
  sim_ac_macos10_deployment_target_code=`$CXXCPP $CPPFLAGS conftest.c 2>/dev/null | grep '^int VerOSX' | sed 's%^int VerOSX = %%' | sed 's% *;.*$%%'`
  rm -f conftest.c

  case "$sim_ac_macos10_deployment_target_code" in
  10* )
    sim_ac_macos10_deployment_version_string=`echo $sim_ac_macos10_deployment_target_code | sed -e 's/^\(.\)\(.\)\(.\)\(.\)/\1\2.\3.\4/;'`
    sim_ac_macos10_deployment_target_major_version=`echo $sim_ac_macos10_deployment_target_code | cut -c1-2`
    sim_ac_macos10_deployment_target_minor_version=`echo $sim_ac_macos10_deployment_target_code | cut -c3`
    sim_ac_macos10_deployment_target_micro_version=`echo $sim_ac_macos10_deployment_target_code | cut -c4`
    AC_MSG_RESULT($sim_ac_macos10_deployment_target_version_string)
    ;;
  * )
    :
    AC_MSG_RESULT([-])
    ;;
  esac
  ;;
esac
]) # SIM_AC_MACOS10_DEPLOYMENT_TARGET

# **************************************************************************
# SIM_AC_MAC_CPP_ADJUSTMENTS
#
# Add --no-cpp-precomp if necessary. Without this option, the
# Apple preprocessor is used on Mac OS X platforms, and it is
# known to be very buggy.  It's better to use this option, so
# the GNU preprocessor is preferred.
#


AC_DEFUN([SIM_AC_MAC_CPP_ADJUSTMENTS],
[case $host_os in
darwin*)
  if test x"$GCC" = x"yes"; then
    # FIXME: create a SIM_AC_CPP_OPTION macro
    SIM_AC_CC_COMPILER_OPTION([-no-cpp-precomp], [CPPFLAGS="$CPPFLAGS -no-cpp-precomp"])
  fi
  ;;
esac
]) # SIM_AC_MAC_CPP_ADJUSTMENTS


# **************************************************************************
# This macro sets up the MAC_FRAMEWORK automake conditional, depending on
# the host OS and whether $sim_ac_prefer_framework has been overridden or
# not.

AC_DEFUN([SIM_AC_MAC_FRAMEWORK],
[case $host_os in
darwin*)
  : ${sim_ac_prefer_framework=true}
  ;;
esac
: ${sim_ac_prefer_framework=false}
# This AM_CONDITIONAL can be used to make Mac OS X specific make-rules
# related to installing proper Frameworks instead.
AM_CONDITIONAL([MAC_FRAMEWORK], [$sim_ac_prefer_framework])

if $sim_ac_prefer_framework; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_MAC_FRAMEWORK


# Usage:
#  SIM_AC_UNIVERSAL_BINARIES([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Determine whether we should build Universal Binaries. If yes, these
#  shell variables are set:
#
#    $sim_ac_enable_universal (true if we are building Universal Binaries)
#    $sim_ac_universal_flags (extra flags needed for Universal Binaries)
#
#  The CFLAGS and CXXFLAGS variables will also be modified accordingly.
#
#  Note that when building Universal Binaries, dependency tracking will
#  be turned off.
#
#  Important: This macro must be called _before_ AM_INIT_AUTOMAKE.
#
# Author: Karin Kosina <kyrah@sim.no>.

AC_DEFUN([SIM_AC_UNIVERSAL_BINARIES], [

sim_ac_enable_universal=false


case $host_os in
  darwin* )
    AC_ARG_ENABLE(
      [universal],
      AC_HELP_STRING([--enable-universal], [build Universal Binaries]), [
        case $enableval in
          yes | true) sim_ac_enable_universal=true ;;
          *) ;;
        esac])

    AC_MSG_CHECKING([whether we should build Universal Binaries])
    if $sim_ac_enable_universal; then
      AC_MSG_RESULT([yes])
      SIM_AC_CONFIGURATION_SETTING([Build Universal Binaries], [Yes])

      # need to build against Universal Binary SDK on PPC
      if test x"$host_cpu" = x"powerpc"; then
        sim_ac_universal_sdk_flags="-isysroot /Developer/SDKs/MacOSX10.4u.sdk"
      fi

      sim_ac_universal_flags="-arch i386 -arch ppc $sim_ac_universal_sdk_flags"

      CFLAGS="$sim_ac_universal_flags $CFLAGS"
      CXXFLAGS="$sim_ac_universal_flags $CXXFLAGS"

      # disable dependency tracking since we can't use -MD when cross-compiling
      enable_dependency_tracking=no
    else
      AC_MSG_RESULT([no])
      SIM_AC_CONFIGURATION_SETTING([Build Universal Binaries], [No (default)])
    fi
esac
]) # SIM_AC_UNIVERSAL_BINARIES


#   Use this file to store miscellaneous macros related to checking
#   compiler features.

# Usage:
#   SIM_AC_CC_COMPILER_OPTION(OPTION-TO-TEST, ACTION-IF-TRUE [, ACTION-IF-FALSE])
#   SIM_AC_CXX_COMPILER_OPTION(OPTION-TO-TEST, ACTION-IF-TRUE [, ACTION-IF-FALSE])
#
# Description:
#
#   Check whether the current C or C++ compiler can handle a
#   particular command-line option.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
#   * [mortene:19991218] improve macros by catching and analyzing
#     stderr (at least to see if there was any output there)?
#

AC_DEFUN([SIM_AC_COMPILER_OPTION], [
sim_ac_save_cppflags=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $1"
AC_TRY_COMPILE([], [], [sim_ac_accept_result=yes], [sim_ac_accept_result=no])
AC_MSG_RESULT([$sim_ac_accept_result])
CPPFLAGS=$sim_ac_save_cppflags
# This need to go last, in case CPPFLAGS is modified in arg 2 or arg 3.
if test $sim_ac_accept_result = yes; then
  ifelse([$2], , :, [$2])
else
  ifelse([$3], , :, [$3])
fi
])

AC_DEFUN([SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET], [
sim_ac_save_cppflags=$CPPFLAGS
CPPFLAGS="$CPPFLAGS $1"
AC_TRY_COMPILE([], [$2], [sim_ac_accept_result=yes], [sim_ac_accept_result=no])
CPPFLAGS=$sim_ac_save_cppflags
# This need to go last, in case CPPFLAGS is modified in arg 3 or arg 4.
if test $sim_ac_accept_result = yes; then
  ifelse([$3], , :, [$3])
else
  ifelse([$4], , :, [$4])
fi
])


AC_DEFUN([SIM_AC_CC_COMPILER_OPTION], [
AC_LANG_SAVE
AC_LANG(C)
AC_MSG_CHECKING([whether $CC accepts $1])
SIM_AC_COMPILER_OPTION([$1], [$2], [$3])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CC_COMPILER_BEHAVIOR_OPTION_QUIET], [
AC_LANG_SAVE
AC_LANG(C)
SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET([$1], [$2], [$3], [$4])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CXX_COMPILER_OPTION], [
AC_LANG_SAVE
AC_LANG(C++)
AC_MSG_CHECKING([whether $CXX accepts $1])
SIM_AC_COMPILER_OPTION([$1], [$2], [$3])
AC_LANG_RESTORE
])

AC_DEFUN([SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET], [
AC_LANG_SAVE
AC_LANG(C++)
SIM_AC_COMPILER_BEHAVIOR_OPTION_QUIET([$1], [$2], [$3], [$4])
AC_LANG_RESTORE
])

# AM_CONDITIONAL                                              -*- Autoconf -*-

# Copyright 1997, 2000, 2001 Free Software Foundation, Inc.

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

# serial 5

AC_PREREQ(2.52)

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[ifelse([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
        [$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])
AC_SUBST([$1_FALSE])
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.])
fi])])

# Do all the work for Automake.                            -*- Autoconf -*-

# This macro actually does too much some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003
# Free Software Foundation, Inc.

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

# serial 10

AC_PREREQ([2.54])

# Autoconf 2.50 wants to disallow AM_ names.  We explicitly allow
# the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
 AC_REQUIRE([AC_PROG_INSTALL])dnl
# test to see if srcdir already configured
if test "`cd $srcdir && pwd`" != "`pwd`" &&
   test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
 AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG(ACLOCAL, aclocal-${am__api_version})
AM_MISSING_PROG(AUTOCONF, autoconf)
AM_MISSING_PROG(AUTOMAKE, automake-${am__api_version})
AM_MISSING_PROG(AUTOHEADER, autoheader)
AM_MISSING_PROG(MAKEINFO, makeinfo)
AM_MISSING_PROG(AMTAR, tar)
AM_PROG_INSTALL_SH
AM_PROG_INSTALL_STRIP
# We need awk for the "check" target.  The system "awk" is bad on
# some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl

_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
                  [_AM_DEPENDENCIES(CC)],
                  [define([AC_PROG_CC],
                          defn([AC_PROG_CC])[_AM_DEPENDENCIES(CC)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
                  [_AM_DEPENDENCIES(CXX)],
                  [define([AC_PROG_CXX],
                          defn([AC_PROG_CXX])[_AM_DEPENDENCIES(CXX)])])dnl
])
])


# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $1 | $1:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $1" >`AS_DIRNAME([$1])`/stamp-h[]$_am_stamp_count])

# Copyright 2002  Free Software Foundation, Inc.

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

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
AC_DEFUN([AM_AUTOMAKE_VERSION],[am__api_version="1.7"])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION so it can be traced.
# This function is AC_REQUIREd by AC_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
	 [AM_AUTOMAKE_VERSION([1.7.5])])

# Helper functions for option handling.                    -*- Autoconf -*-

# Copyright 2001, 2002  Free Software Foundation, Inc.

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

# serial 2

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# ------------------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), 1)])

# _AM_SET_OPTIONS(OPTIONS)
# ----------------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[AC_FOREACH([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

#
# Check to make sure that the build environment is sane.
#

# Copyright 1996, 1997, 2000, 2001 Free Software Foundation, Inc.

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

# serial 3

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftest.file
# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt $srcdir/configure conftest.file 2> /dev/null`
   if test "$[*]" = "X"; then
      # -L didn't work.
      set X `ls -t $srcdir/configure conftest.file`
   fi
   rm -f conftest.file
   if test "$[*]" != "X $srcdir/configure conftest.file" \
      && test "$[*]" != "X conftest.file $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT(yes)])

#  -*- Autoconf -*-


# Copyright 1997, 1999, 2000, 2001 Free Software Foundation, Inc.

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

# serial 3

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])


# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it supports --run.
# If it does, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
test x"${MISSING+set}" = xset || MISSING="\${SHELL} $am_aux_dir/missing"
# Use eval to expand $SHELL
if eval "$MISSING --run true"; then
  am_missing_run="$MISSING --run "
else
  am_missing_run=
  AC_MSG_WARN([`missing' script is too old or missing])
fi
])

# AM_AUX_DIR_EXPAND

# Copyright 2001 Free Software Foundation, Inc.

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

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to `$srcdir/foo'.  In other projects, it is set to
# `$srcdir', `$srcdir/..', or `$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is `.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

# Rely on autoconf to set up CDPATH properly.
AC_PREREQ([2.50])

AC_DEFUN([AM_AUX_DIR_EXPAND], [
# expand $ac_aux_dir to an absolute path
am_aux_dir=`cd $ac_aux_dir && pwd`
])

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.

# Copyright 2001 Free Software Foundation, Inc.

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

AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
install_sh=${install_sh-"$am_aux_dir/install-sh"}
AC_SUBST(install_sh)])

# AM_PROG_INSTALL_STRIP

# Copyright 2001 Free Software Foundation, Inc.

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

# One issue with vendor `install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in `make install-strip', and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using `strip' when the user
# run `make install-strip'.  However `strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the `STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be `maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\${SHELL} \$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

#                                                          -*- Autoconf -*-
# Copyright (C) 2003  Free Software Foundation, Inc.

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

# serial 1

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# serial 5						-*- Autoconf -*-

# Copyright (C) 1999, 2000, 2001, 2002, 2003  Free Software Foundation, Inc.

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


# There are a few dirty hacks below to avoid letting `AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...



# _AM_DEPENDENCIES(NAME)
# ----------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX", "GCJ", or "OBJC".
# We try a few techniques and use that to set a single cache variable.
#
# We don't AC_REQUIRE the corresponding AC_PROG_CC since the latter was
# modified to invoke _AM_DEPENDENCIES(CC); we would have a circular
# dependency, and given that the user is not expected to run this macro,
# just rely on AC_PROG_CC.
AC_DEFUN([_AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
AC_REQUIRE([AM_MAKE_INCLUDE])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl

ifelse([$1], CC,   [depcc="$CC"   am_compiler_list=],
       [$1], CXX,  [depcc="$CXX"  am_compiler_list=],
       [$1], OBJC, [depcc="$OBJC" am_compiler_list='gcc3 gcc'],
       [$1], GCJ,  [depcc="$GCJ"  am_compiler_list='gcc3 gcc'],
                   [depcc="$$1"   am_compiler_list=])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named `D' -- because `-MD' means `put the output
  # in D'.
  mkdir conftest.dir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" conftest.dir
  cd conftest.dir

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list=`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`
  fi
  for depmode in $am_compiler_list; do
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    echo '#include "conftest.h"' > conftest.c
    echo 'int i;' > conftest.h
    echo "${am__include} ${am__quote}conftest.Po${am__quote}" > confmf

    case $depmode in
    nosideeffect)
      # after this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    none) break ;;
    esac
    # We check with `-c' and `-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle `-M -o', and we need to detect this.
    if depmode=$depmode \
       source=conftest.c object=conftest.o \
       depfile=conftest.Po tmpdepfile=conftest.TPo \
       $SHELL ./depcomp $depcc -c -o conftest.o conftest.c \
         >/dev/null 2>conftest.err &&
       grep conftest.h conftest.Po > /dev/null 2>&1 &&
       ${MAKE-make} -s -f confmf > /dev/null 2>&1; then
      # icc doesn't choke on unknown options, it will just issue warnings
      # (even with -Werror).  So we grep stderr for any message
      # that says an option was ignored.
      if grep 'ignoring option' conftest.err >/dev/null 2>&1; then :; else
        am_cv_$1_dependencies_compiler_type=$depmode
        break
      fi
    fi
  done

  cd ..
  rm -rf conftest.dir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
AC_SUBST([$1DEPMODE], [depmode=$am_cv_$1_dependencies_compiler_type])
AM_CONDITIONAL([am__fastdep$1], [
  test "x$enable_dependency_tracking" != xno \
  && test "$am_cv_$1_dependencies_compiler_type" = gcc3])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in _AM_DEPENDENCIES
AC_DEFUN([AM_SET_DEPDIR],
[AC_REQUIRE([AM_SET_LEADING_DOT])dnl
AC_SUBST([DEPDIR], ["${am__leading_dot}deps"])dnl
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE(dependency-tracking,
[  --disable-dependency-tracking Speeds up one-time builds
  --enable-dependency-tracking  Do not reject slow dependency extractors])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
AC_SUBST([AMDEPBACKSLASH])
])

# Generate code to set up dependency tracking.   -*- Autoconf -*-

# Copyright 1999, 2000, 2001, 2002 Free Software Foundation, Inc.

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

#serial 2

# _AM_OUTPUT_DEPENDENCY_COMMANDS
# ------------------------------
AC_DEFUN([_AM_OUTPUT_DEPENDENCY_COMMANDS],
[for mf in $CONFIG_FILES; do
  # Strip MF so we end up with the name of the file.
  mf=`echo "$mf" | sed -e 's/:.*$//'`
  # Check whether this is an Automake generated Makefile or not.
  # We used to match only the files named `Makefile.in', but
  # some people rename them; so instead we look at the file content.
  # Grep'ing the first line is not enough: some people post-process
  # each Makefile.in and add a new line on top of each file to say so.
  # So let's grep whole file.
  if grep '^#.*generated by automake' $mf > /dev/null 2>&1; then
    dirpart=`AS_DIRNAME("$mf")`
  else
    continue
  fi
  grep '^DEP_FILES *= *[[^ @%:@]]' < "$mf" > /dev/null || continue
  # Extract the definition of DEP_FILES from the Makefile without
  # running `make'.
  DEPDIR=`sed -n -e '/^DEPDIR = / s///p' < "$mf"`
  test -z "$DEPDIR" && continue
  # When using ansi2knr, U may be empty or an underscore; expand it
  U=`sed -n -e '/^U = / s///p' < "$mf"`
  test -d "$dirpart/$DEPDIR" || mkdir "$dirpart/$DEPDIR"
  # We invoke sed twice because it is the simplest approach to
  # changing $(DEPDIR) to its actual value in the expansion.
  for file in `sed -n -e '
    /^DEP_FILES = .*\\\\$/ {
      s/^DEP_FILES = //
      :loop
	s/\\\\$//
	p
	n
	/\\\\$/ b loop
      p
    }
    /^DEP_FILES = / s/^DEP_FILES = //p' < "$mf" | \
       sed -e 's/\$(DEPDIR)/'"$DEPDIR"'/g' -e 's/\$U/'"$U"'/g'`; do
    # Make sure the directory exists.
    test -f "$dirpart/$file" && continue
    fdir=`AS_DIRNAME(["$file"])`
    AS_MKDIR_P([$dirpart/$fdir])
    # echo "creating $dirpart/$file"
    echo '# dummy' > "$dirpart/$file"
  done
done
])# _AM_OUTPUT_DEPENDENCY_COMMANDS


# AM_OUTPUT_DEPENDENCY_COMMANDS
# -----------------------------
# This macro should only be invoked once -- use via AC_REQUIRE.
#
# This code is only required when automatic dependency tracking
# is enabled.  FIXME.  This creates each `.P' file that we will
# need in order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],
[AC_CONFIG_COMMANDS([depfiles],
     [test x"$AMDEP_TRUE" != x"" || _AM_OUTPUT_DEPENDENCY_COMMANDS],
     [AMDEP_TRUE="$AMDEP_TRUE" ac_aux_dir="$ac_aux_dir"])
])

# Check to see how 'make' treats includes.	-*- Autoconf -*-

# Copyright (C) 2001, 2002, 2003 Free Software Foundation, Inc.

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

# serial 2

# AM_MAKE_INCLUDE()
# -----------------
# Check to see how make treats includes.
AC_DEFUN([AM_MAKE_INCLUDE],
[am_make=${MAKE-make}
cat > confinc << 'END'
am__doit:
	@echo done
.PHONY: am__doit
END
# If we don't find an include directive, just comment out the code.
AC_MSG_CHECKING([for style of include used by $am_make])
am__include="#"
am__quote=
_am_result=none
# First try GNU make style include.
echo "include confinc" > confmf
# We grep out `Entering directory' and `Leaving directory'
# messages which can occur if `w' ends up in MAKEFLAGS.
# In particular we don't look at `^make:' because GNU make might
# be invoked under some other name (usually "gmake"), in which
# case it prints its new name instead of `make'.
if test "`$am_make -s -f confmf 2> /dev/null | grep -v 'ing directory'`" = "done"; then
   am__include=include
   am__quote=
   _am_result=GNU
fi
# Now try BSD make style include.
if test "$am__include" = "#"; then
   echo '.include "confinc"' > confmf
   if test "`$am_make -s -f confmf 2> /dev/null`" = "done"; then
      am__include=.include
      am__quote="\""
      _am_result=BSD
   fi
fi
AC_SUBST([am__include])
AC_SUBST([am__quote])
AC_MSG_RESULT([$_am_result])
rm -f confinc confmf
])

# Like AC_CONFIG_HEADER, but automatically create stamp file. -*- Autoconf -*-

# Copyright 1996, 1997, 2000, 2001 Free Software Foundation, Inc.

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

AC_PREREQ([2.52])

# serial 6

# AM_CONFIG_HEADER is obsolete.  It has been replaced by AC_CONFIG_HEADERS.
AU_DEFUN([AM_CONFIG_HEADER], [AC_CONFIG_HEADERS($@)])

# libtool.m4 - Configure libtool for the host system. -*-Autoconf-*-

# serial 48 AC_PROG_LIBTOOL


# AC_PROVIDE_IFELSE(MACRO-NAME, IF-PROVIDED, IF-NOT-PROVIDED)
# -----------------------------------------------------------
# If this macro is not defined by Autoconf, define it here.
m4_ifdef([AC_PROVIDE_IFELSE],
         [],
         [m4_define([AC_PROVIDE_IFELSE],
	         [m4_ifdef([AC_PROVIDE_$1],
		           [$2], [$3])])])


# AC_PROG_LIBTOOL
# ---------------
AC_DEFUN([AC_PROG_LIBTOOL],
[AC_REQUIRE([_AC_PROG_LIBTOOL])dnl
dnl If AC_PROG_CXX has already been expanded, run AC_LIBTOOL_CXX
dnl immediately, otherwise, hook it in at the end of AC_PROG_CXX.
  AC_PROVIDE_IFELSE([AC_PROG_CXX],
    [AC_LIBTOOL_CXX],
    [define([AC_PROG_CXX], defn([AC_PROG_CXX])[AC_LIBTOOL_CXX
  ])])
dnl And a similar setup for Fortran 77 support
  AC_PROVIDE_IFELSE([AC_PROG_F77],
    [AC_LIBTOOL_F77],
    [define([AC_PROG_F77], defn([AC_PROG_F77])[AC_LIBTOOL_F77
])])

dnl Quote A][M_PROG_GCJ so that aclocal doesn't bring it in needlessly.
dnl If either AC_PROG_GCJ or A][M_PROG_GCJ have already been expanded, run
dnl AC_LIBTOOL_GCJ immediately, otherwise, hook it in at the end of both.
  AC_PROVIDE_IFELSE([AC_PROG_GCJ],
    [AC_LIBTOOL_GCJ],
    [AC_PROVIDE_IFELSE([A][M_PROG_GCJ],
      [AC_LIBTOOL_GCJ],
      [AC_PROVIDE_IFELSE([LT_AC_PROG_GCJ],
	[AC_LIBTOOL_GCJ],
      [ifdef([AC_PROG_GCJ],
	     [define([AC_PROG_GCJ], defn([AC_PROG_GCJ])[AC_LIBTOOL_GCJ])])
       ifdef([A][M_PROG_GCJ],
	     [define([A][M_PROG_GCJ], defn([A][M_PROG_GCJ])[AC_LIBTOOL_GCJ])])
       ifdef([LT_AC_PROG_GCJ],
	     [define([LT_AC_PROG_GCJ],
		defn([LT_AC_PROG_GCJ])[AC_LIBTOOL_GCJ])])])])
])])# AC_PROG_LIBTOOL


# _AC_PROG_LIBTOOL
# ----------------
AC_DEFUN([_AC_PROG_LIBTOOL],
[AC_REQUIRE([AC_LIBTOOL_SETUP])dnl
AC_BEFORE([$0],[AC_LIBTOOL_CXX])dnl
AC_BEFORE([$0],[AC_LIBTOOL_F77])dnl
AC_BEFORE([$0],[AC_LIBTOOL_GCJ])dnl

# This can be used to rebuild libtool when needed
LIBTOOL_DEPS="$ac_aux_dir/ltmain.sh"

# Always use our own libtool.
LIBTOOL='$(SHELL) $(top_builddir)/libtool'
AC_SUBST(LIBTOOL)dnl

# Prevent multiple expansion
define([AC_PROG_LIBTOOL], [])
])# _AC_PROG_LIBTOOL


# AC_LIBTOOL_SETUP
# ----------------
AC_DEFUN([AC_LIBTOOL_SETUP],
[AC_PREREQ(2.50)dnl
AC_REQUIRE([AC_ENABLE_SHARED])dnl
AC_REQUIRE([AC_ENABLE_STATIC])dnl
AC_REQUIRE([AC_ENABLE_FAST_INSTALL])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_LD])dnl
AC_REQUIRE([AC_PROG_LD_RELOAD_FLAG])dnl
AC_REQUIRE([AC_PROG_NM])dnl

AC_REQUIRE([AC_PROG_LN_S])dnl
AC_REQUIRE([AC_DEPLIBS_CHECK_METHOD])dnl
# Autoconf 2.13's AC_OBJEXT and AC_EXEEXT macros only works for C compilers!
AC_REQUIRE([AC_OBJEXT])dnl
AC_REQUIRE([AC_EXEEXT])dnl
dnl

AC_LIBTOOL_SYS_MAX_CMD_LEN
AC_LIBTOOL_SYS_GLOBAL_SYMBOL_PIPE
AC_LIBTOOL_OBJDIR

AC_REQUIRE([_LT_AC_SYS_COMPILER])dnl
_LT_AC_PROG_ECHO_BACKSLASH

case $host_os in
aix3*)
  # AIX sometimes has problems with the GCC collect2 program.  For some
  # reason, if we set the COLLECT_NAMES environment variable, the problems
  # vanish in a puff of smoke.
  if test "X${COLLECT_NAMES+set}" != Xset; then
    COLLECT_NAMES=
    export COLLECT_NAMES
  fi
  ;;
esac

# Sed substitution that helps us do robust quoting.  It backslashifies
# metacharacters that are still active within double-quoted strings.
Xsed='sed -e 1s/^X//'
[sed_quote_subst='s/\([\\"\\`$\\\\]\)/\\\1/g']

# Same as above, but do not quote variable references.
[double_quote_subst='s/\([\\"\\`\\\\]\)/\\\1/g']

# Sed substitution to delay expansion of an escaped shell variable in a
# double_quote_subst'ed string.
delay_variable_subst='s/\\\\\\\\\\\$/\\\\\\$/g'

# Sed substitution to avoid accidental globbing in evaled expressions
no_glob_subst='s/\*/\\\*/g'

# Constants:
rm="rm -f"

# Global variables:
default_ofile=libtool
can_build_shared=yes

# All known linkers require a `.a' archive for static linking (except MSVC,
# which needs '.lib').
libext=a
ltmain="$ac_aux_dir/ltmain.sh"
ofile="$default_ofile"
with_gnu_ld="$lt_cv_prog_gnu_ld"

AC_CHECK_TOOL(AR, ar, false)
AC_CHECK_TOOL(RANLIB, ranlib, :)
AC_CHECK_TOOL(STRIP, strip, :)

old_CC="$CC"
old_CFLAGS="$CFLAGS"

# Set sane defaults for various variables
test -z "$AR" && AR=ar
test -z "$AR_FLAGS" && AR_FLAGS=cru
test -z "$AS" && AS=as
test -z "$CC" && CC=cc
test -z "$LTCC" && LTCC=$CC
test -z "$LTCFLAGS" && LTCFLAGS=$CFLAGS
test -z "$DLLTOOL" && DLLTOOL=dlltool
test -z "$LD" && LD=ld
test -z "$LN_S" && LN_S="ln -s"
test -z "$MAGIC_CMD" && MAGIC_CMD=file
test -z "$NM" && NM=nm
test -z "$SED" && SED=sed
test -z "$OBJDUMP" && OBJDUMP=objdump
test -z "$RANLIB" && RANLIB=:
test -z "$STRIP" && STRIP=:
test -z "$ac_objext" && ac_objext=o

# Determine commands to create old-style static archives.
old_archive_cmds='$AR $AR_FLAGS $oldlib$oldobjs$old_deplibs'
old_postinstall_cmds='chmod 644 $oldlib'
old_postuninstall_cmds=

if test -n "$RANLIB"; then
  case $host_os in
  openbsd*)
    old_postinstall_cmds="$old_postinstall_cmds~\$RANLIB -t \$oldlib"
    ;;
  *)
    old_postinstall_cmds="$old_postinstall_cmds~\$RANLIB \$oldlib"
    ;;
  esac
  old_archive_cmds="$old_archive_cmds~\$RANLIB \$oldlib"
fi

_LT_CC_BASENAME([$compiler])

# Only perform the check for file, if the check method requires it
case $deplibs_check_method in
file_magic*)
  if test "$file_magic_cmd" = '$MAGIC_CMD'; then
    AC_PATH_MAGIC
  fi
  ;;
esac

AC_PROVIDE_IFELSE([AC_LIBTOOL_DLOPEN], enable_dlopen=yes, enable_dlopen=no)
AC_PROVIDE_IFELSE([AC_LIBTOOL_WIN32_DLL],
enable_win32_dll=yes, enable_win32_dll=no)

AC_ARG_ENABLE([libtool-lock],
    [AC_HELP_STRING([--disable-libtool-lock],
	[avoid locking (might break parallel builds)])])
test "x$enable_libtool_lock" != xno && enable_libtool_lock=yes

AC_ARG_WITH([pic],
    [AC_HELP_STRING([--with-pic],
	[try to use only PIC/non-PIC objects @<:@default=use both@:>@])],
    [pic_mode="$withval"],
    [pic_mode=default])
test -z "$pic_mode" && pic_mode=default

# Use C for the default configuration in the libtool script
tagname=
AC_LIBTOOL_LANG_C_CONFIG
_LT_AC_TAGCONFIG
])# AC_LIBTOOL_SETUP


# _LT_AC_SYS_COMPILER
# -------------------
AC_DEFUN([_LT_AC_SYS_COMPILER],
[AC_REQUIRE([AC_PROG_CC])dnl

# If no C compiler was specified, use CC.
LTCC=${LTCC-"$CC"}

# If no C compiler flags were specified, use CFLAGS.
LTCFLAGS=${LTCFLAGS-"$CFLAGS"}

# Allow CC to be a program name with arguments.
compiler=$CC
])# _LT_AC_SYS_COMPILER


# _LT_CC_BASENAME(CC)
# -------------------
# Calculate cc_basename.  Skip known compiler wrappers and cross-prefix.
AC_DEFUN([_LT_CC_BASENAME],
[for cc_temp in $1""; do
  case $cc_temp in
    compile | *[[\\/]]compile | ccache | *[[\\/]]ccache ) ;;
    distcc | *[[\\/]]distcc | purify | *[[\\/]]purify ) ;;
    \-*) ;;
    *) break;;
  esac
done
cc_basename=`$echo "X$cc_temp" | $Xsed -e 's%.*/%%' -e "s%^$host_alias-%%"`
])


# _LT_COMPILER_BOILERPLATE
# ------------------------
# Check for compiler boilerplate output or warnings with
# the simple compiler test code.
AC_DEFUN([_LT_COMPILER_BOILERPLATE],
[ac_outfile=conftest.$ac_objext
printf "$lt_simple_compile_test_code" >conftest.$ac_ext
eval "$ac_compile" 2>&1 >/dev/null | $SED '/^$/d; /^ *+/d' >conftest.err
_lt_compiler_boilerplate=`cat conftest.err`
$rm conftest*
])# _LT_COMPILER_BOILERPLATE


# _LT_LINKER_BOILERPLATE
# ----------------------
# Check for linker boilerplate output or warnings with
# the simple link test code.
AC_DEFUN([_LT_LINKER_BOILERPLATE],
[ac_outfile=conftest.$ac_objext
printf "$lt_simple_link_test_code" >conftest.$ac_ext
eval "$ac_link" 2>&1 >/dev/null | $SED '/^$/d; /^ *+/d' >conftest.err
_lt_linker_boilerplate=`cat conftest.err`
$rm conftest*
])# _LT_LINKER_BOILERPLATE


# _LT_AC_SYS_LIBPATH_AIX
# ----------------------
# Links a minimal program and checks the executable
# for the system default hardcoded library path. In most cases,
# this is /usr/lib:/lib, but when the MPI compilers are used
# the location of the communication and MPI libs are included too.
# If we don't find anything, use the default library path according
# to the aix ld manual.
AC_DEFUN([_LT_AC_SYS_LIBPATH_AIX],
[AC_LINK_IFELSE(AC_LANG_PROGRAM,[
aix_libpath=`dump -H conftest$ac_exeext 2>/dev/null | $SED -n -e '/Import File Strings/,/^$/ { /^0/ { s/^0  *\(.*\)$/\1/; p; }
}'`
# Check for a 64-bit object if we didn't find anything.
if test -z "$aix_libpath"; then aix_libpath=`dump -HX64 conftest$ac_exeext 2>/dev/null | $SED -n -e '/Import File Strings/,/^$/ { /^0/ { s/^0  *\(.*\)$/\1/; p; }
}'`; fi],[])
if test -z "$aix_libpath"; then aix_libpath="/usr/lib:/lib"; fi
])# _LT_AC_SYS_LIBPATH_AIX


# _LT_AC_SHELL_INIT(ARG)
# ----------------------
AC_DEFUN([_LT_AC_SHELL_INIT],
[ifdef([AC_DIVERSION_NOTICE],
	     [AC_DIVERT_PUSH(AC_DIVERSION_NOTICE)],
	 [AC_DIVERT_PUSH(NOTICE)])
$1
AC_DIVERT_POP
])# _LT_AC_SHELL_INIT


# _LT_AC_PROG_ECHO_BACKSLASH
# --------------------------
# Add some code to the start of the generated configure script which
# will find an echo command which doesn't interpret backslashes.
AC_DEFUN([_LT_AC_PROG_ECHO_BACKSLASH],
[_LT_AC_SHELL_INIT([
# Check that we are running under the correct shell.
SHELL=${CONFIG_SHELL-/bin/sh}

case X$ECHO in
X*--fallback-echo)
  # Remove one level of quotation (which was required for Make).
  ECHO=`echo "$ECHO" | sed 's,\\\\\[$]\\[$]0,'[$]0','`
  ;;
esac

echo=${ECHO-echo}
if test "X[$]1" = X--no-reexec; then
  # Discard the --no-reexec flag, and continue.
  shift
elif test "X[$]1" = X--fallback-echo; then
  # Avoid inline document here, it may be left over
  :
elif test "X`($echo '\t') 2>/dev/null`" = 'X\t' ; then
  # Yippee, $echo works!
  :
else
  # Restart under the correct shell.
  exec $SHELL "[$]0" --no-reexec ${1+"[$]@"}
fi

if test "X[$]1" = X--fallback-echo; then
  # used as fallback echo
  shift
  cat <<EOF
[$]*
EOF
  exit 0
fi

# The HP-UX ksh and POSIX shell print the target directory to stdout
# if CDPATH is set.
(unset CDPATH) >/dev/null 2>&1 && unset CDPATH

if test -z "$ECHO"; then
if test "X${echo_test_string+set}" != Xset; then
# find a string as large as possible, as long as the shell can cope with it
  for cmd in 'sed 50q "[$]0"' 'sed 20q "[$]0"' 'sed 10q "[$]0"' 'sed 2q "[$]0"' 'echo test'; do
    # expected sizes: less than 2Kb, 1Kb, 512 bytes, 16 bytes, ...
    if (echo_test_string=`eval $cmd`) 2>/dev/null &&
       echo_test_string=`eval $cmd` &&
       (test "X$echo_test_string" = "X$echo_test_string") 2>/dev/null
    then
      break
    fi
  done
fi

if test "X`($echo '\t') 2>/dev/null`" = 'X\t' &&
   echo_testing_string=`($echo "$echo_test_string") 2>/dev/null` &&
   test "X$echo_testing_string" = "X$echo_test_string"; then
  :
else
  # The Solaris, AIX, and Digital Unix default echo programs unquote
  # backslashes.  This makes it impossible to quote backslashes using
  #   echo "$something" | sed 's/\\/\\\\/g'
  #
  # So, first we look for a working echo in the user's PATH.

  lt_save_ifs="$IFS"; IFS=$PATH_SEPARATOR
  for dir in $PATH /usr/ucb; do
    IFS="$lt_save_ifs"
    if (test -f $dir/echo || test -f $dir/echo$ac_exeext) &&
       test "X`($dir/echo '\t') 2>/dev/null`" = 'X\t' &&
       echo_testing_string=`($dir/echo "$echo_test_string") 2>/dev/null` &&
       test "X$echo_testing_string" = "X$echo_test_string"; then
      echo="$dir/echo"
      break
    fi
  done
  IFS="$lt_save_ifs"

  if test "X$echo" = Xecho; then
    # We didn't find a better echo, so look for alternatives.
    if test "X`(print -r '\t') 2>/dev/null`" = 'X\t' &&
       echo_testing_string=`(print -r "$echo_test_string") 2>/dev/null` &&
       test "X$echo_testing_string" = "X$echo_test_string"; then
      # This shell has a builtin print -r that does the trick.
      echo='print -r'
    elif (test -f /bin/ksh || test -f /bin/ksh$ac_exeext) &&
	 test "X$CONFIG_SHELL" != X/bin/ksh; then
      # If we have ksh, try running configure again with it.
      ORIGINAL_CONFIG_SHELL=${CONFIG_SHELL-/bin/sh}
      export ORIGINAL_CONFIG_SHELL
      CONFIG_SHELL=/bin/ksh
      export CONFIG_SHELL
      exec $CONFIG_SHELL "[$]0" --no-reexec ${1+"[$]@"}
    else
      # Try using printf.
      echo='printf %s\n'
      if test "X`($echo '\t') 2>/dev/null`" = 'X\t' &&
	 echo_testing_string=`($echo "$echo_test_string") 2>/dev/null` &&
	 test "X$echo_testing_string" = "X$echo_test_string"; then
	# Cool, printf works
	:
      elif echo_testing_string=`($ORIGINAL_CONFIG_SHELL "[$]0" --fallback-echo '\t') 2>/dev/null` &&
	   test "X$echo_testing_string" = 'X\t' &&
	   echo_testing_string=`($ORIGINAL_CONFIG_SHELL "[$]0" --fallback-echo "$echo_test_string") 2>/dev/null` &&
	   test "X$echo_testing_string" = "X$echo_test_string"; then
	CONFIG_SHELL=$ORIGINAL_CONFIG_SHELL
	export CONFIG_SHELL
	SHELL="$CONFIG_SHELL"
	export SHELL
	echo="$CONFIG_SHELL [$]0 --fallback-echo"
      elif echo_testing_string=`($CONFIG_SHELL "[$]0" --fallback-echo '\t') 2>/dev/null` &&
	   test "X$echo_testing_string" = 'X\t' &&
	   echo_testing_string=`($CONFIG_SHELL "[$]0" --fallback-echo "$echo_test_string") 2>/dev/null` &&
	   test "X$echo_testing_string" = "X$echo_test_string"; then
	echo="$CONFIG_SHELL [$]0 --fallback-echo"
      else
	# maybe with a smaller string...
	prev=:

	for cmd in 'echo test' 'sed 2q "[$]0"' 'sed 10q "[$]0"' 'sed 20q "[$]0"' 'sed 50q "[$]0"'; do
	  if (test "X$echo_test_string" = "X`eval $cmd`") 2>/dev/null
	  then
	    break
	  fi
	  prev="$cmd"
	done

	if test "$prev" != 'sed 50q "[$]0"'; then
	  echo_test_string=`eval $prev`
	  export echo_test_string
	  exec ${ORIGINAL_CONFIG_SHELL-${CONFIG_SHELL-/bin/sh}} "[$]0" ${1+"[$]@"}
	else
	  # Oops.  We lost completely, so just stick with echo.
	  echo=echo
	fi
      fi
    fi
  fi
fi
fi

# Copy echo and quote the copy suitably for passing to libtool from
# the Makefile, instead of quoting the original, which is used later.
ECHO=$echo
if test "X$ECHO" = "X$CONFIG_SHELL [$]0 --fallback-echo"; then
   ECHO="$CONFIG_SHELL \\\$\[$]0 --fallback-echo"
fi

AC_SUBST(ECHO)
])])# _LT_AC_PROG_ECHO_BACKSLASH


# _LT_AC_LOCK
# -----------
AC_DEFUN([_LT_AC_LOCK],
[AC_ARG_ENABLE([libtool-lock],
    [AC_HELP_STRING([--disable-libtool-lock],
	[avoid locking (might break parallel builds)])])
test "x$enable_libtool_lock" != xno && enable_libtool_lock=yes

# Some flags need to be propagated to the compiler or linker for good
# libtool support.
case $host in
ia64-*-hpux*)
  # Find out which ABI we are using.
  echo 'int i;' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case `/usr/bin/file conftest.$ac_objext` in
    *ELF-32*)
      HPUX_IA64_MODE="32"
      ;;
    *ELF-64*)
      HPUX_IA64_MODE="64"
      ;;
    esac
  fi
  rm -rf conftest*
  ;;
*-*-irix6*)
  # Find out which ABI we are using.
  echo '[#]line __oline__ "configure"' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
   if test "$lt_cv_prog_gnu_ld" = yes; then
    case `/usr/bin/file conftest.$ac_objext` in
    *32-bit*)
      LD="${LD-ld} -melf32bsmip"
      ;;
    *N32*)
      LD="${LD-ld} -melf32bmipn32"
      ;;
    *64-bit*)
      LD="${LD-ld} -melf64bmip"
      ;;
    esac
   else
    case `/usr/bin/file conftest.$ac_objext` in
    *32-bit*)
      LD="${LD-ld} -32"
      ;;
    *N32*)
      LD="${LD-ld} -n32"
      ;;
    *64-bit*)
      LD="${LD-ld} -64"
      ;;
    esac
   fi
  fi
  rm -rf conftest*
  ;;

x86_64-*linux*|ppc*-*linux*|powerpc*-*linux*|s390*-*linux*|sparc*-*linux*)
  # Find out which ABI we are using.
  echo 'int i;' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case `/usr/bin/file conftest.o` in
    *32-bit*)
      case $host in
        x86_64-*linux*)
          LD="${LD-ld} -m elf_i386"
          ;;
        ppc64-*linux*|powerpc64-*linux*)
          LD="${LD-ld} -m elf32ppclinux"
          ;;
        s390x-*linux*)
          LD="${LD-ld} -m elf_s390"
          ;;
        sparc64-*linux*)
          LD="${LD-ld} -m elf32_sparc"
          ;;
      esac
      ;;
    *64-bit*)
      case $host in
        x86_64-*linux*)
          LD="${LD-ld} -m elf_x86_64"
          ;;
        ppc*-*linux*|powerpc*-*linux*)
          LD="${LD-ld} -m elf64ppc"
          ;;
        s390*-*linux*)
          LD="${LD-ld} -m elf64_s390"
          ;;
        sparc*-*linux*)
          LD="${LD-ld} -m elf64_sparc"
          ;;
      esac
      ;;
    esac
  fi
  rm -rf conftest*
  ;;

*-*-sco3.2v5*)
  # On SCO OpenServer 5, we need -belf to get full-featured binaries.
  SAVE_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS -belf"
  AC_CACHE_CHECK([whether the C compiler needs -belf], lt_cv_cc_needs_belf,
    [AC_LANG_PUSH(C)
     AC_TRY_LINK([],[],[lt_cv_cc_needs_belf=yes],[lt_cv_cc_needs_belf=no])
     AC_LANG_POP])
  if test x"$lt_cv_cc_needs_belf" != x"yes"; then
    # this is probably gcc 2.8.0, egcs 1.0 or newer; no need for -belf
    CFLAGS="$SAVE_CFLAGS"
  fi
  ;;
sparc*-*solaris*)
  # Find out which ABI we are using.
  echo 'int i;' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case `/usr/bin/file conftest.o` in
    *64-bit*)
      case $lt_cv_prog_gnu_ld in
      yes*) LD="${LD-ld} -m elf64_sparc" ;;
      *)    LD="${LD-ld} -64" ;;
      esac
      ;;
    esac
  fi
  rm -rf conftest*
  ;;

AC_PROVIDE_IFELSE([AC_LIBTOOL_WIN32_DLL],
[*-*-cygwin* | *-*-mingw* | *-*-pw32*)
  AC_CHECK_TOOL(DLLTOOL, dlltool, false)
  AC_CHECK_TOOL(AS, as, false)
  AC_CHECK_TOOL(OBJDUMP, objdump, false)
  ;;
  ])
esac

need_locks="$enable_libtool_lock"

])# _LT_AC_LOCK


# AC_LIBTOOL_COMPILER_OPTION(MESSAGE, VARIABLE-NAME, FLAGS,
#		[OUTPUT-FILE], [ACTION-SUCCESS], [ACTION-FAILURE])
# ----------------------------------------------------------------
# Check whether the given compiler option works
AC_DEFUN([AC_LIBTOOL_COMPILER_OPTION],
[AC_REQUIRE([LT_AC_PROG_SED])
AC_CACHE_CHECK([$1], [$2],
  [$2=no
  ifelse([$4], , [ac_outfile=conftest.$ac_objext], [ac_outfile=$4])
   printf "$lt_simple_compile_test_code" > conftest.$ac_ext
   lt_compiler_flag="$3"
   # Insert the option either (1) after the last *FLAGS variable, or
   # (2) before a word containing "conftest.", or (3) at the end.
   # Note that $ac_compile itself does not contain backslashes and begins
   # with a dollar sign (not a hyphen), so the echo should work correctly.
   # The option is referenced via a variable to avoid confusing sed.
   lt_compile=`echo "$ac_compile" | $SED \
   -e 's:.*FLAGS}\{0,1\} :&$lt_compiler_flag :; t' \
   -e 's: [[^ ]]*conftest\.: $lt_compiler_flag&:; t' \
   -e 's:$: $lt_compiler_flag:'`
   (eval echo "\"\$as_me:__oline__: $lt_compile\"" >&AS_MESSAGE_LOG_FD)
   (eval "$lt_compile" 2>conftest.err)
   ac_status=$?
   cat conftest.err >&AS_MESSAGE_LOG_FD
   echo "$as_me:__oline__: \$? = $ac_status" >&AS_MESSAGE_LOG_FD
   if (exit $ac_status) && test -s "$ac_outfile"; then
     # The compiler can only warn and ignore the option if not recognized
     # So say no if there are warnings other than the usual output.
     $echo "X$_lt_compiler_boilerplate" | $Xsed -e '/^$/d' >conftest.exp
     $SED '/^$/d; /^ *+/d' conftest.err >conftest.er2
     if test ! -s conftest.er2 || diff conftest.exp conftest.er2 >/dev/null; then
       $2=yes
     fi
   fi
   $rm conftest*
])

if test x"[$]$2" = xyes; then
    ifelse([$5], , :, [$5])
else
    ifelse([$6], , :, [$6])
fi
])# AC_LIBTOOL_COMPILER_OPTION


# AC_LIBTOOL_LINKER_OPTION(MESSAGE, VARIABLE-NAME, FLAGS,
#                          [ACTION-SUCCESS], [ACTION-FAILURE])
# ------------------------------------------------------------
# Check whether the given compiler option works
AC_DEFUN([AC_LIBTOOL_LINKER_OPTION],
[AC_CACHE_CHECK([$1], [$2],
  [$2=no
   save_LDFLAGS="$LDFLAGS"
   LDFLAGS="$LDFLAGS $3"
   printf "$lt_simple_link_test_code" > conftest.$ac_ext
   if (eval $ac_link 2>conftest.err) && test -s conftest$ac_exeext; then
     # The linker can only warn and ignore the option if not recognized
     # So say no if there are warnings
     if test -s conftest.err; then
       # Append any errors to the config.log.
       cat conftest.err 1>&AS_MESSAGE_LOG_FD
       $echo "X$_lt_linker_boilerplate" | $Xsed -e '/^$/d' > conftest.exp
       $SED '/^$/d; /^ *+/d' conftest.err >conftest.er2
       if diff conftest.exp conftest.er2 >/dev/null; then
         $2=yes
       fi
     else
       $2=yes
     fi
   fi
   $rm conftest*
   LDFLAGS="$save_LDFLAGS"
])

if test x"[$]$2" = xyes; then
    ifelse([$4], , :, [$4])
else
    ifelse([$5], , :, [$5])
fi
])# AC_LIBTOOL_LINKER_OPTION


# AC_LIBTOOL_SYS_MAX_CMD_LEN
# --------------------------
AC_DEFUN([AC_LIBTOOL_SYS_MAX_CMD_LEN],
[# find the maximum length of command line arguments
AC_MSG_CHECKING([the maximum length of command line arguments])
AC_CACHE_VAL([lt_cv_sys_max_cmd_len], [dnl
  i=0
  teststring="ABCD"

  case $build_os in
  msdosdjgpp*)
    # On DJGPP, this test can blow up pretty badly due to problems in libc
    # (any single argument exceeding 2000 bytes causes a buffer overrun
    # during glob expansion).  Even if it were fixed, the result of this
    # check would be larger than it should be.
    lt_cv_sys_max_cmd_len=12288;    # 12K is about right
    ;;

  gnu*)
    # Under GNU Hurd, this test is not required because there is
    # no limit to the length of command line arguments.
    # Libtool will interpret -1 as no limit whatsoever
    lt_cv_sys_max_cmd_len=-1;
    ;;

  cygwin* | mingw*)
    # On Win9x/ME, this test blows up -- it succeeds, but takes
    # about 5 minutes as the teststring grows exponentially.
    # Worse, since 9x/ME are not pre-emptively multitasking,
    # you end up with a "frozen" computer, even though with patience
    # the test eventually succeeds (with a max line length of 256k).
    # Instead, let's just punt: use the minimum linelength reported by
    # all of the supported platforms: 8192 (on NT/2K/XP).
    lt_cv_sys_max_cmd_len=8192;
    ;;

  amigaos*)
    # On AmigaOS with pdksh, this test takes hours, literally.
    # So we just punt and use a minimum line length of 8192.
    lt_cv_sys_max_cmd_len=8192;
    ;;

  netbsd* | freebsd* | openbsd* | darwin* | dragonfly*)
    # This has been around since 386BSD, at least.  Likely further.
    if test -x /sbin/sysctl; then
      lt_cv_sys_max_cmd_len=`/sbin/sysctl -n kern.argmax`
    elif test -x /usr/sbin/sysctl; then
      lt_cv_sys_max_cmd_len=`/usr/sbin/sysctl -n kern.argmax`
    else
      lt_cv_sys_max_cmd_len=65536	# usable default for all BSDs
    fi
    # And add a safety zone
    lt_cv_sys_max_cmd_len=`expr $lt_cv_sys_max_cmd_len \/ 4`
    lt_cv_sys_max_cmd_len=`expr $lt_cv_sys_max_cmd_len \* 3`
    ;;

  interix*)
    # We know the value 262144 and hardcode it with a safety zone (like BSD)
    lt_cv_sys_max_cmd_len=196608
    ;;

  osf*)
    # Dr. Hans Ekkehard Plesser reports seeing a kernel panic running configure
    # due to this test when exec_disable_arg_limit is 1 on Tru64. It is not
    # nice to cause kernel panics so lets avoid the loop below.
    # First set a reasonable default.
    lt_cv_sys_max_cmd_len=16384
    #
    if test -x /sbin/sysconfig; then
      case `/sbin/sysconfig -q proc exec_disable_arg_limit` in
        *1*) lt_cv_sys_max_cmd_len=-1 ;;
      esac
    fi
    ;;
  sco3.2v5*)
    lt_cv_sys_max_cmd_len=102400
    ;;
  sysv5* | sco5v6* | sysv4.2uw2*)
    kargmax=`grep ARG_MAX /etc/conf/cf.d/stune 2>/dev/null`
    if test -n "$kargmax"; then
      lt_cv_sys_max_cmd_len=`echo $kargmax | sed 's/.*[[ 	]]//'`
    else
      lt_cv_sys_max_cmd_len=32768
    fi
    ;;
  *)
    # If test is not a shell built-in, we'll probably end up computing a
    # maximum length that is only half of the actual maximum length, but
    # we can't tell.
    SHELL=${SHELL-${CONFIG_SHELL-/bin/sh}}
    while (test "X"`$SHELL [$]0 --fallback-echo "X$teststring" 2>/dev/null` \
	       = "XX$teststring") >/dev/null 2>&1 &&
	    new_result=`expr "X$teststring" : ".*" 2>&1` &&
	    lt_cv_sys_max_cmd_len=$new_result &&
	    test $i != 17 # 1/2 MB should be enough
    do
      i=`expr $i + 1`
      teststring=$teststring$teststring
    done
    teststring=
    # Add a significant safety factor because C++ compilers can tack on massive
    # amounts of additional arguments before passing them to the linker.
    # It appears as though 1/2 is a usable value.
    lt_cv_sys_max_cmd_len=`expr $lt_cv_sys_max_cmd_len \/ 2`
    ;;
  esac
])
if test -n $lt_cv_sys_max_cmd_len ; then
  AC_MSG_RESULT($lt_cv_sys_max_cmd_len)
else
  AC_MSG_RESULT(none)
fi
])# AC_LIBTOOL_SYS_MAX_CMD_LEN


# _LT_AC_CHECK_DLFCN
# ------------------
AC_DEFUN([_LT_AC_CHECK_DLFCN],
[AC_CHECK_HEADERS(dlfcn.h)dnl
])# _LT_AC_CHECK_DLFCN


# _LT_AC_TRY_DLOPEN_SELF (ACTION-IF-TRUE, ACTION-IF-TRUE-W-USCORE,
#                           ACTION-IF-FALSE, ACTION-IF-CROSS-COMPILING)
# ---------------------------------------------------------------------
AC_DEFUN([_LT_AC_TRY_DLOPEN_SELF],
[AC_REQUIRE([_LT_AC_CHECK_DLFCN])dnl
if test "$cross_compiling" = yes; then :
  [$4]
else
  lt_dlunknown=0; lt_dlno_uscore=1; lt_dlneed_uscore=2
  lt_status=$lt_dlunknown
  cat > conftest.$ac_ext <<EOF
[#line __oline__ "configure"
#include "confdefs.h"

#if HAVE_DLFCN_H
#include <dlfcn.h>
#endif

#include <stdio.h>

#ifdef RTLD_GLOBAL
#  define LT_DLGLOBAL		RTLD_GLOBAL
#else
#  ifdef DL_GLOBAL
#    define LT_DLGLOBAL		DL_GLOBAL
#  else
#    define LT_DLGLOBAL		0
#  endif
#endif

/* We may have to define LT_DLLAZY_OR_NOW in the command line if we
   find out it does not work in some platform. */
#ifndef LT_DLLAZY_OR_NOW
#  ifdef RTLD_LAZY
#    define LT_DLLAZY_OR_NOW		RTLD_LAZY
#  else
#    ifdef DL_LAZY
#      define LT_DLLAZY_OR_NOW		DL_LAZY
#    else
#      ifdef RTLD_NOW
#        define LT_DLLAZY_OR_NOW	RTLD_NOW
#      else
#        ifdef DL_NOW
#          define LT_DLLAZY_OR_NOW	DL_NOW
#        else
#          define LT_DLLAZY_OR_NOW	0
#        endif
#      endif
#    endif
#  endif
#endif

#ifdef __cplusplus
extern "C" void exit (int);
#endif

void fnord() { int i=42;}
int main ()
{
  void *self = dlopen (0, LT_DLGLOBAL|LT_DLLAZY_OR_NOW);
  int status = $lt_dlunknown;

  if (self)
    {
      if (dlsym (self,"fnord"))       status = $lt_dlno_uscore;
      else if (dlsym( self,"_fnord")) status = $lt_dlneed_uscore;
      /* dlclose (self); */
    }
  else
    puts (dlerror ());

    exit (status);
}]
EOF
  if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext} 2>/dev/null; then
    (./conftest; exit; ) >&AS_MESSAGE_LOG_FD 2>/dev/null
    lt_status=$?
    case x$lt_status in
      x$lt_dlno_uscore) $1 ;;
      x$lt_dlneed_uscore) $2 ;;
      x$lt_dlunknown|x*) $3 ;;
    esac
  else :
    # compilation failed
    $3
  fi
fi
rm -fr conftest*
])# _LT_AC_TRY_DLOPEN_SELF


# AC_LIBTOOL_DLOPEN_SELF
# ----------------------
AC_DEFUN([AC_LIBTOOL_DLOPEN_SELF],
[AC_REQUIRE([_LT_AC_CHECK_DLFCN])dnl
if test "x$enable_dlopen" != xyes; then
  enable_dlopen=unknown
  enable_dlopen_self=unknown
  enable_dlopen_self_static=unknown
else
  lt_cv_dlopen=no
  lt_cv_dlopen_libs=

  case $host_os in
  beos*)
    lt_cv_dlopen="load_add_on"
    lt_cv_dlopen_libs=
    lt_cv_dlopen_self=yes
    ;;

  mingw* | pw32*)
    lt_cv_dlopen="LoadLibrary"
    lt_cv_dlopen_libs=
   ;;

  cygwin*)
    lt_cv_dlopen="dlopen"
    lt_cv_dlopen_libs=
   ;;

  darwin*)
  # if libdl is installed we need to link against it
    AC_CHECK_LIB([dl], [dlopen],
		[lt_cv_dlopen="dlopen" lt_cv_dlopen_libs="-ldl"],[
    lt_cv_dlopen="dyld"
    lt_cv_dlopen_libs=
    lt_cv_dlopen_self=yes
    ])
   ;;

  *)
    AC_CHECK_FUNC([shl_load],
	  [lt_cv_dlopen="shl_load"],
      [AC_CHECK_LIB([dld], [shl_load],
	    [lt_cv_dlopen="shl_load" lt_cv_dlopen_libs="-dld"],
	[AC_CHECK_FUNC([dlopen],
	      [lt_cv_dlopen="dlopen"],
	  [AC_CHECK_LIB([dl], [dlopen],
		[lt_cv_dlopen="dlopen" lt_cv_dlopen_libs="-ldl"],
	    [AC_CHECK_LIB([svld], [dlopen],
		  [lt_cv_dlopen="dlopen" lt_cv_dlopen_libs="-lsvld"],
	      [AC_CHECK_LIB([dld], [dld_link],
		    [lt_cv_dlopen="dld_link" lt_cv_dlopen_libs="-dld"])
	      ])
	    ])
	  ])
	])
      ])
    ;;
  esac

  if test "x$lt_cv_dlopen" != xno; then
    enable_dlopen=yes
  else
    enable_dlopen=no
  fi

  case $lt_cv_dlopen in
  dlopen)
    save_CPPFLAGS="$CPPFLAGS"
    test "x$ac_cv_header_dlfcn_h" = xyes && CPPFLAGS="$CPPFLAGS -DHAVE_DLFCN_H"

    save_LDFLAGS="$LDFLAGS"
    wl=$lt_prog_compiler_wl eval LDFLAGS=\"\$LDFLAGS $export_dynamic_flag_spec\"

    save_LIBS="$LIBS"
    LIBS="$lt_cv_dlopen_libs $LIBS"

    AC_CACHE_CHECK([whether a program can dlopen itself],
	  lt_cv_dlopen_self, [dnl
	  _LT_AC_TRY_DLOPEN_SELF(
	    lt_cv_dlopen_self=yes, lt_cv_dlopen_self=yes,
	    lt_cv_dlopen_self=no, lt_cv_dlopen_self=cross)
    ])

    if test "x$lt_cv_dlopen_self" = xyes; then
      wl=$lt_prog_compiler_wl eval LDFLAGS=\"\$LDFLAGS $lt_prog_compiler_static\"
      AC_CACHE_CHECK([whether a statically linked program can dlopen itself],
    	  lt_cv_dlopen_self_static, [dnl
	  _LT_AC_TRY_DLOPEN_SELF(
	    lt_cv_dlopen_self_static=yes, lt_cv_dlopen_self_static=yes,
	    lt_cv_dlopen_self_static=no,  lt_cv_dlopen_self_static=cross)
      ])
    fi

    CPPFLAGS="$save_CPPFLAGS"
    LDFLAGS="$save_LDFLAGS"
    LIBS="$save_LIBS"
    ;;
  esac

  case $lt_cv_dlopen_self in
  yes|no) enable_dlopen_self=$lt_cv_dlopen_self ;;
  *) enable_dlopen_self=unknown ;;
  esac

  case $lt_cv_dlopen_self_static in
  yes|no) enable_dlopen_self_static=$lt_cv_dlopen_self_static ;;
  *) enable_dlopen_self_static=unknown ;;
  esac
fi
])# AC_LIBTOOL_DLOPEN_SELF


# AC_LIBTOOL_PROG_CC_C_O([TAGNAME])
# ---------------------------------
# Check to see if options -c and -o are simultaneously supported by compiler
AC_DEFUN([AC_LIBTOOL_PROG_CC_C_O],
[AC_REQUIRE([_LT_AC_SYS_COMPILER])dnl
AC_CACHE_CHECK([if $compiler supports -c -o file.$ac_objext],
  [_LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)],
  [_LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)=no
   $rm -r conftest 2>/dev/null
   mkdir conftest
   cd conftest
   mkdir out
   printf "$lt_simple_compile_test_code" > conftest.$ac_ext

   lt_compiler_flag="-o out/conftest2.$ac_objext"
   # Insert the option either (1) after the last *FLAGS variable, or
   # (2) before a word containing "conftest.", or (3) at the end.
   # Note that $ac_compile itself does not contain backslashes and begins
   # with a dollar sign (not a hyphen), so the echo should work correctly.
   lt_compile=`echo "$ac_compile" | $SED \
   -e 's:.*FLAGS}\{0,1\} :&$lt_compiler_flag :; t' \
   -e 's: [[^ ]]*conftest\.: $lt_compiler_flag&:; t' \
   -e 's:$: $lt_compiler_flag:'`
   (eval echo "\"\$as_me:__oline__: $lt_compile\"" >&AS_MESSAGE_LOG_FD)
   (eval "$lt_compile" 2>out/conftest.err)
   ac_status=$?
   cat out/conftest.err >&AS_MESSAGE_LOG_FD
   echo "$as_me:__oline__: \$? = $ac_status" >&AS_MESSAGE_LOG_FD
   if (exit $ac_status) && test -s out/conftest2.$ac_objext
   then
     # The compiler can only warn and ignore the option if not recognized
     # So say no if there are warnings
     $echo "X$_lt_compiler_boilerplate" | $Xsed -e '/^$/d' > out/conftest.exp
     $SED '/^$/d; /^ *+/d' out/conftest.err >out/conftest.er2
     if test ! -s out/conftest.er2 || diff out/conftest.exp out/conftest.er2 >/dev/null; then
       _LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)=yes
     fi
   fi
   chmod u+w . 2>&AS_MESSAGE_LOG_FD
   $rm conftest*
   # SGI C++ compiler will create directory out/ii_files/ for
   # template instantiation
   test -d out/ii_files && $rm out/ii_files/* && rmdir out/ii_files
   $rm out/* && rmdir out
   cd ..
   rmdir conftest
   $rm conftest*
])
])# AC_LIBTOOL_PROG_CC_C_O


# AC_LIBTOOL_SYS_HARD_LINK_LOCKS([TAGNAME])
# -----------------------------------------
# Check to see if we can do hard links to lock some files if needed
AC_DEFUN([AC_LIBTOOL_SYS_HARD_LINK_LOCKS],
[AC_REQUIRE([_LT_AC_LOCK])dnl

hard_links="nottested"
if test "$_LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)" = no && test "$need_locks" != no; then
  # do not overwrite the value of need_locks provided by the user
  AC_MSG_CHECKING([if we can lock with hard links])
  hard_links=yes
  $rm conftest*
  ln conftest.a conftest.b 2>/dev/null && hard_links=no
  touch conftest.a
  ln conftest.a conftest.b 2>&5 || hard_links=no
  ln conftest.a conftest.b 2>/dev/null && hard_links=no
  AC_MSG_RESULT([$hard_links])
  if test "$hard_links" = no; then
    AC_MSG_WARN([`$CC' does not support `-c -o', so `make -j' may be unsafe])
    need_locks=warn
  fi
else
  need_locks=no
fi
])# AC_LIBTOOL_SYS_HARD_LINK_LOCKS


# AC_LIBTOOL_OBJDIR
# -----------------
AC_DEFUN([AC_LIBTOOL_OBJDIR],
[AC_CACHE_CHECK([for objdir], [lt_cv_objdir],
[rm -f .libs 2>/dev/null
mkdir .libs 2>/dev/null
if test -d .libs; then
  lt_cv_objdir=.libs
else
  # MS-DOS does not allow filenames that begin with a dot.
  lt_cv_objdir=_libs
fi
rmdir .libs 2>/dev/null])
objdir=$lt_cv_objdir
])# AC_LIBTOOL_OBJDIR


# AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH([TAGNAME])
# ----------------------------------------------
# Check hardcoding attributes.
AC_DEFUN([AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH],
[AC_MSG_CHECKING([how to hardcode library paths into programs])
_LT_AC_TAGVAR(hardcode_action, $1)=
if test -n "$_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)" || \
   test -n "$_LT_AC_TAGVAR(runpath_var, $1)" || \
   test "X$_LT_AC_TAGVAR(hardcode_automatic, $1)" = "Xyes" ; then

  # We can hardcode non-existant directories.
  if test "$_LT_AC_TAGVAR(hardcode_direct, $1)" != no &&
     # If the only mechanism to avoid hardcoding is shlibpath_var, we
     # have to relink, otherwise we might link with an installed library
     # when we should be linking with a yet-to-be-installed one
     ## test "$_LT_AC_TAGVAR(hardcode_shlibpath_var, $1)" != no &&
     test "$_LT_AC_TAGVAR(hardcode_minus_L, $1)" != no; then
    # Linking always hardcodes the temporary library directory.
    _LT_AC_TAGVAR(hardcode_action, $1)=relink
  else
    # We can link without hardcoding, and we can hardcode nonexisting dirs.
    _LT_AC_TAGVAR(hardcode_action, $1)=immediate
  fi
else
  # We cannot hardcode anything, or else we can only hardcode existing
  # directories.
  _LT_AC_TAGVAR(hardcode_action, $1)=unsupported
fi
AC_MSG_RESULT([$_LT_AC_TAGVAR(hardcode_action, $1)])

if test "$_LT_AC_TAGVAR(hardcode_action, $1)" = relink; then
  # Fast installation is not supported
  enable_fast_install=no
elif test "$shlibpath_overrides_runpath" = yes ||
     test "$enable_shared" = no; then
  # Fast installation is not necessary
  enable_fast_install=needless
fi
])# AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH


# AC_LIBTOOL_SYS_LIB_STRIP
# ------------------------
AC_DEFUN([AC_LIBTOOL_SYS_LIB_STRIP],
[striplib=
old_striplib=
AC_MSG_CHECKING([whether stripping libraries is possible])
if test -n "$STRIP" && $STRIP -V 2>&1 | grep "GNU strip" >/dev/null; then
  test -z "$old_striplib" && old_striplib="$STRIP --strip-debug"
  test -z "$striplib" && striplib="$STRIP --strip-unneeded"
  AC_MSG_RESULT([yes])
else
# FIXME - insert some real tests, host_os isn't really good enough
  case $host_os in
   darwin*)
       if test -n "$STRIP" ; then
         striplib="$STRIP -x"
         AC_MSG_RESULT([yes])
       else
  AC_MSG_RESULT([no])
fi
       ;;
   *)
  AC_MSG_RESULT([no])
    ;;
  esac
fi
])# AC_LIBTOOL_SYS_LIB_STRIP


# AC_LIBTOOL_SYS_DYNAMIC_LINKER
# -----------------------------
# PORTME Fill in your ld.so characteristics
AC_DEFUN([AC_LIBTOOL_SYS_DYNAMIC_LINKER],
[AC_MSG_CHECKING([dynamic linker characteristics])
library_names_spec=
libname_spec='lib$name'
soname_spec=
shrext_cmds=".so"
postinstall_cmds=
postuninstall_cmds=
finish_cmds=
finish_eval=
shlibpath_var=
shlibpath_overrides_runpath=unknown
version_type=none
dynamic_linker="$host_os ld.so"
sys_lib_dlsearch_path_spec="/lib /usr/lib"
if test "$GCC" = yes; then
  sys_lib_search_path_spec=`$CC -print-search-dirs | grep "^libraries:" | $SED -e "s/^libraries://" -e "s,=/,/,g"`
  if echo "$sys_lib_search_path_spec" | grep ';' >/dev/null ; then
    # if the path contains ";" then we assume it to be the separator
    # otherwise default to the standard path separator (i.e. ":") - it is
    # assumed that no part of a normal pathname contains ";" but that should
    # okay in the real world where ";" in dirpaths is itself problematic.
    sys_lib_search_path_spec=`echo "$sys_lib_search_path_spec" | $SED -e 's/;/ /g'`
  else
    sys_lib_search_path_spec=`echo "$sys_lib_search_path_spec" | $SED  -e "s/$PATH_SEPARATOR/ /g"`
  fi
else
  sys_lib_search_path_spec="/lib /usr/lib /usr/local/lib"
fi
need_lib_prefix=unknown
hardcode_into_libs=no

# when you set need_version to no, make sure it does not cause -set_version
# flags to be left without arguments
need_version=unknown

case $host_os in
aix3*)
  version_type=linux
  library_names_spec='${libname}${release}${shared_ext}$versuffix $libname.a'
  shlibpath_var=LIBPATH

  # AIX 3 has no versioning support, so we append a major version to the name.
  soname_spec='${libname}${release}${shared_ext}$major'
  ;;

aix4* | aix5*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  hardcode_into_libs=yes
  if test "$host_cpu" = ia64; then
    # AIX 5 supports IA64
    library_names_spec='${libname}${release}${shared_ext}$major ${libname}${release}${shared_ext}$versuffix $libname${shared_ext}'
    shlibpath_var=LD_LIBRARY_PATH
  else
    # With GCC up to 2.95.x, collect2 would create an import file
    # for dependence libraries.  The import file would start with
    # the line `#! .'.  This would cause the generated library to
    # depend on `.', always an invalid library.  This was fixed in
    # development snapshots of GCC prior to 3.0.
    case $host_os in
      aix4 | aix4.[[01]] | aix4.[[01]].*)
      if { echo '#if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 97)'
	   echo ' yes '
	   echo '#endif'; } | ${CC} -E - | grep yes > /dev/null; then
	:
      else
	can_build_shared=no
      fi
      ;;
    esac
    # AIX (on Power*) has no versioning support, so currently we can not hardcode correct
    # soname into executable. Probably we can add versioning support to
    # collect2, so additional links can be useful in future.
    if test "$aix_use_runtimelinking" = yes; then
      # If using run time linking (on AIX 4.2 or later) use lib<name>.so
      # instead of lib<name>.a to let people know that these are not
      # typical AIX shared libraries.
      library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
    else
      # We preserve .a as extension for shared libraries through AIX4.2
      # and later when we are not doing run time linking.
      library_names_spec='${libname}${release}.a $libname.a'
      soname_spec='${libname}${release}${shared_ext}$major'
    fi
    shlibpath_var=LIBPATH
  fi
  ;;

amigaos*)
  library_names_spec='$libname.ixlibrary $libname.a'
  # Create ${libname}_ixlibrary.a entries in /sys/libs.
  finish_eval='for lib in `ls $libdir/*.ixlibrary 2>/dev/null`; do libname=`$echo "X$lib" | $Xsed -e '\''s%^.*/\([[^/]]*\)\.ixlibrary$%\1%'\''`; test $rm /sys/libs/${libname}_ixlibrary.a; $show "cd /sys/libs && $LN_S $lib ${libname}_ixlibrary.a"; cd /sys/libs && $LN_S $lib ${libname}_ixlibrary.a || exit 1; done'
  ;;

beos*)
  library_names_spec='${libname}${shared_ext}'
  dynamic_linker="$host_os ld.so"
  shlibpath_var=LIBRARY_PATH
  ;;

bsdi[[45]]*)
  version_type=linux
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  finish_cmds='PATH="\$PATH:/sbin" ldconfig $libdir'
  shlibpath_var=LD_LIBRARY_PATH
  sys_lib_search_path_spec="/shlib /usr/lib /usr/X11/lib /usr/contrib/lib /lib /usr/local/lib"
  sys_lib_dlsearch_path_spec="/shlib /usr/lib /usr/local/lib"
  # the default ld.so.conf also contains /usr/contrib/lib and
  # /usr/X11R6/lib (/usr/X11 is a link to /usr/X11R6), but let us allow
  # libtool to hard-code these into programs
  ;;

cygwin* | mingw* | pw32*)
  version_type=windows
  shrext_cmds=".dll"
  need_version=no
  need_lib_prefix=no

  case $GCC,$host_os in
  yes,cygwin* | yes,mingw* | yes,pw32*)
    library_names_spec='$libname.dll.a'
    # DLL is installed to $(libdir)/../bin by postinstall_cmds
    postinstall_cmds='base_file=`basename \${file}`~
      dlpath=`$SHELL 2>&1 -c '\''. $dir/'\''\${base_file}'\''i;echo \$dlname'\''`~
      dldir=$destdir/`dirname \$dlpath`~
      test -d \$dldir || mkdir -p \$dldir~
      $install_prog $dir/$dlname \$dldir/$dlname~
      chmod a+x \$dldir/$dlname'
    postuninstall_cmds='dldll=`$SHELL 2>&1 -c '\''. $file; echo \$dlname'\''`~
      dlpath=$dir/\$dldll~
       $rm \$dlpath'
    shlibpath_overrides_runpath=yes

    case $host_os in
    cygwin*)
      # Cygwin DLLs use 'cyg' prefix rather than 'lib'
      soname_spec='`echo ${libname} | sed -e 's/^lib/cyg/'``echo ${release} | $SED -e 's/[[.]]/-/g'`${versuffix}${shared_ext}'
      sys_lib_search_path_spec="/usr/lib /lib/w32api /lib /usr/local/lib"
      ;;
    mingw*)
      # MinGW DLLs use traditional 'lib' prefix
      soname_spec='${libname}`echo ${release} | $SED -e 's/[[.]]/-/g'`${versuffix}${shared_ext}'
      sys_lib_search_path_spec=`$CC -print-search-dirs | grep "^libraries:" | $SED -e "s/^libraries://" -e "s,=/,/,g"`
      if echo "$sys_lib_search_path_spec" | [grep ';[c-zC-Z]:/' >/dev/null]; then
        # It is most probably a Windows format PATH printed by
        # mingw gcc, but we are running on Cygwin. Gcc prints its search
        # path with ; separators, and with drive letters. We can handle the
        # drive letters (cygwin fileutils understands them), so leave them,
        # especially as we might pass files found there to a mingw objdump,
        # which wouldn't understand a cygwinified path. Ahh.
        sys_lib_search_path_spec=`echo "$sys_lib_search_path_spec" | $SED -e 's/;/ /g'`
      else
        sys_lib_search_path_spec=`echo "$sys_lib_search_path_spec" | $SED  -e "s/$PATH_SEPARATOR/ /g"`
      fi
      ;;
    pw32*)
      # pw32 DLLs use 'pw' prefix rather than 'lib'
      library_names_spec='`echo ${libname} | sed -e 's/^lib/pw/'``echo ${release} | $SED -e 's/[[.]]/-/g'`${versuffix}${shared_ext}'
      ;;
    esac
    ;;

  *)
    library_names_spec='${libname}`echo ${release} | $SED -e 's/[[.]]/-/g'`${versuffix}${shared_ext} $libname.lib'
    ;;
  esac
  dynamic_linker='Win32 ld.exe'
  # FIXME: first we should search . and the directory the executable is in
  shlibpath_var=PATH
  ;;

darwin* | rhapsody*)
  dynamic_linker="$host_os dyld"
  version_type=darwin
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${versuffix}$shared_ext ${libname}${release}${major}$shared_ext ${libname}$shared_ext'
  soname_spec='${libname}${release}${major}$shared_ext'
  shlibpath_overrides_runpath=yes
  shlibpath_var=DYLD_LIBRARY_PATH
  shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'
  # Apple's gcc prints 'gcc -print-search-dirs' doesn't operate the same.
  if test "$GCC" = yes; then
    sys_lib_search_path_spec=`$CC -print-search-dirs | tr "\n" "$PATH_SEPARATOR" | sed -e 's/libraries:/@libraries:/' | tr "@" "\n" | grep "^libraries:" | sed -e "s/^libraries://" -e "s,=/,/,g" -e "s,$PATH_SEPARATOR, ,g" -e "s,.*,& /lib /usr/lib /usr/local/lib,g"`
  else
    sys_lib_search_path_spec='/lib /usr/lib /usr/local/lib'
  fi
  sys_lib_dlsearch_path_spec='/usr/local/lib /lib /usr/lib'
  ;;

dgux*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname$shared_ext'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  ;;

freebsd1*)
  dynamic_linker=no
  ;;

kfreebsd*-gnu)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major ${libname}${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=no
  hardcode_into_libs=yes
  dynamic_linker='GNU ld.so'
  ;;

freebsd* | dragonfly*)
  # DragonFly does not have aout.  When/if they implement a new
  # versioning mechanism, adjust this.
  if test -x /usr/bin/objformat; then
    objformat=`/usr/bin/objformat`
  else
    case $host_os in
    freebsd[[123]]*) objformat=aout ;;
    *) objformat=elf ;;
    esac
  fi
  version_type=freebsd-$objformat
  case $version_type in
    freebsd-elf*)
      library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext} $libname${shared_ext}'
      need_version=no
      need_lib_prefix=no
      ;;
    freebsd-*)
      library_names_spec='${libname}${release}${shared_ext}$versuffix $libname${shared_ext}$versuffix'
      need_version=yes
      ;;
  esac
  shlibpath_var=LD_LIBRARY_PATH
  case $host_os in
  freebsd2*)
    shlibpath_overrides_runpath=yes
    ;;
  freebsd3.[[01]]* | freebsdelf3.[[01]]*)
    shlibpath_overrides_runpath=yes
    hardcode_into_libs=yes
    ;;
  freebsd3.[[2-9]]* | freebsdelf3.[[2-9]]* | \
  freebsd4.[[0-5]] | freebsdelf4.[[0-5]] | freebsd4.1.1 | freebsdelf4.1.1)
    shlibpath_overrides_runpath=no
    hardcode_into_libs=yes
    ;;
  freebsd*) # from 4.6 on
    shlibpath_overrides_runpath=yes
    hardcode_into_libs=yes
    ;;
  esac
  ;;

gnu*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}${major} ${libname}${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  hardcode_into_libs=yes
  ;;

hpux9* | hpux10* | hpux11*)
  # Give a soname corresponding to the major version so that dld.sl refuses to
  # link against other versions.
  version_type=sunos
  need_lib_prefix=no
  need_version=no
  case $host_cpu in
  ia64*)
    shrext_cmds='.so'
    hardcode_into_libs=yes
    dynamic_linker="$host_os dld.so"
    shlibpath_var=LD_LIBRARY_PATH
    shlibpath_overrides_runpath=yes # Unless +noenvvar is specified.
    library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
    soname_spec='${libname}${release}${shared_ext}$major'
    if test "X$HPUX_IA64_MODE" = X32; then
      sys_lib_search_path_spec="/usr/lib/hpux32 /usr/local/lib/hpux32 /usr/local/lib"
    else
      sys_lib_search_path_spec="/usr/lib/hpux64 /usr/local/lib/hpux64"
    fi
    sys_lib_dlsearch_path_spec=$sys_lib_search_path_spec
    ;;
   hppa*64*)
     shrext_cmds='.sl'
     hardcode_into_libs=yes
     dynamic_linker="$host_os dld.sl"
     shlibpath_var=LD_LIBRARY_PATH # How should we handle SHLIB_PATH
     shlibpath_overrides_runpath=yes # Unless +noenvvar is specified.
     library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
     soname_spec='${libname}${release}${shared_ext}$major'
     sys_lib_search_path_spec="/usr/lib/pa20_64 /usr/ccs/lib/pa20_64"
     sys_lib_dlsearch_path_spec=$sys_lib_search_path_spec
     ;;
   *)
    shrext_cmds='.sl'
    dynamic_linker="$host_os dld.sl"
    shlibpath_var=SHLIB_PATH
    shlibpath_overrides_runpath=no # +s is required to enable SHLIB_PATH
    library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
    soname_spec='${libname}${release}${shared_ext}$major'
    ;;
  esac
  # HP-UX runs *really* slowly unless shared libraries are mode 555.
  postinstall_cmds='chmod 555 $lib'
  ;;

interix3*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major ${libname}${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  dynamic_linker='Interix 3.x ld.so.1 (PE, like ELF)'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=no
  hardcode_into_libs=yes
  ;;

irix5* | irix6* | nonstopux*)
  case $host_os in
    nonstopux*) version_type=nonstopux ;;
    *)
	if test "$lt_cv_prog_gnu_ld" = yes; then
		version_type=linux
	else
		version_type=irix
	fi ;;
  esac
  need_lib_prefix=no
  need_version=no
  soname_spec='${libname}${release}${shared_ext}$major'
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major ${libname}${release}${shared_ext} $libname${shared_ext}'
  case $host_os in
  irix5* | nonstopux*)
    libsuff= shlibsuff=
    ;;
  *)
    case $LD in # libtool.m4 will add one of these switches to LD
    *-32|*"-32 "|*-melf32bsmip|*"-melf32bsmip ")
      libsuff= shlibsuff= libmagic=32-bit;;
    *-n32|*"-n32 "|*-melf32bmipn32|*"-melf32bmipn32 ")
      libsuff=32 shlibsuff=N32 libmagic=N32;;
    *-64|*"-64 "|*-melf64bmip|*"-melf64bmip ")
      libsuff=64 shlibsuff=64 libmagic=64-bit;;
    *) libsuff= shlibsuff= libmagic=never-match;;
    esac
    ;;
  esac
  shlibpath_var=LD_LIBRARY${shlibsuff}_PATH
  shlibpath_overrides_runpath=no
  sys_lib_search_path_spec="/usr/lib${libsuff} /lib${libsuff} /usr/local/lib${libsuff}"
  sys_lib_dlsearch_path_spec="/usr/lib${libsuff} /lib${libsuff}"
  hardcode_into_libs=yes
  ;;

# No shared lib support for Linux oldld, aout, or coff.
linux*oldld* | linux*aout* | linux*coff*)
  dynamic_linker=no
  ;;

# This must be Linux ELF.
linux*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  finish_cmds='PATH="\$PATH:/sbin" ldconfig -n $libdir'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=no
  # This implies no fast_install, which is unacceptable.
  # Some rework will be needed to allow for fast_install
  # before this can be enabled.
  hardcode_into_libs=yes

  # Append ld.so.conf contents to the search path
  if test -f /etc/ld.so.conf; then
    lt_ld_extra=`awk '/^include / { system(sprintf("cd /etc; cat %s", \[$]2)); skip = 1; } { if (!skip) print \[$]0; skip = 0; }' < /etc/ld.so.conf | $SED -e 's/#.*//;s/[:,	]/ /g;s/=[^=]*$//;s/=[^= ]* / /g;/^$/d' | tr '\n' ' '`
    sys_lib_dlsearch_path_spec="/lib /usr/lib $lt_ld_extra"
  fi

  # We used to test for /lib/ld.so.1 and disable shared libraries on
  # powerpc, because MkLinux only supported shared libraries with the
  # GNU dynamic linker.  Since this was broken with cross compilers,
  # most powerpc-linux boxes support dynamic linking these days and
  # people can always --disable-shared, the test was removed, and we
  # assume the GNU/Linux dynamic linker is in use.
  dynamic_linker='GNU/Linux ld.so'
  ;;

knetbsd*-gnu)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major ${libname}${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=no
  hardcode_into_libs=yes
  dynamic_linker='GNU ld.so'
  ;;

netbsd*)
  version_type=sunos
  need_lib_prefix=no
  need_version=no
  if echo __ELF__ | $CC -E - | grep __ELF__ >/dev/null; then
    library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${shared_ext}$versuffix'
    finish_cmds='PATH="\$PATH:/sbin" ldconfig -m $libdir'
    dynamic_linker='NetBSD (a.out) ld.so'
  else
    library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major ${libname}${shared_ext}'
    soname_spec='${libname}${release}${shared_ext}$major'
    dynamic_linker='NetBSD ld.elf_so'
  fi
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=yes
  hardcode_into_libs=yes
  ;;

newsos6)
  version_type=linux
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=yes
  ;;

nto-qnx*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=yes
  ;;

openbsd*)
  version_type=sunos
  sys_lib_dlsearch_path_spec="/usr/lib"
  need_lib_prefix=no
  # Some older versions of OpenBSD (3.3 at least) *do* need versioned libs.
  case $host_os in
    openbsd3.3 | openbsd3.3.*) need_version=yes ;;
    *)                         need_version=no  ;;
  esac
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${shared_ext}$versuffix'
  finish_cmds='PATH="\$PATH:/sbin" ldconfig -m $libdir'
  shlibpath_var=LD_LIBRARY_PATH
  if test -z "`echo __ELF__ | $CC -E - | grep __ELF__`" || test "$host_os-$host_cpu" = "openbsd2.8-powerpc"; then
    case $host_os in
      openbsd2.[[89]] | openbsd2.[[89]].*)
	shlibpath_overrides_runpath=no
	;;
      *)
	shlibpath_overrides_runpath=yes
	;;
      esac
  else
    shlibpath_overrides_runpath=yes
  fi
  ;;

os2*)
  libname_spec='$name'
  shrext_cmds=".dll"
  need_lib_prefix=no
  library_names_spec='$libname${shared_ext} $libname.a'
  dynamic_linker='OS/2 ld.exe'
  shlibpath_var=LIBPATH
  ;;

osf3* | osf4* | osf5*)
  version_type=osf
  need_lib_prefix=no
  need_version=no
  soname_spec='${libname}${release}${shared_ext}$major'
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  shlibpath_var=LD_LIBRARY_PATH
  sys_lib_search_path_spec="/usr/shlib /usr/ccs/lib /usr/lib/cmplrs/cc /usr/lib /usr/local/lib /var/shlib"
  sys_lib_dlsearch_path_spec="$sys_lib_search_path_spec"
  ;;

solaris*)
  version_type=linux
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=yes
  hardcode_into_libs=yes
  # ldd complains unless libraries are executable
  postinstall_cmds='chmod +x $lib'
  ;;

sunos4*)
  version_type=sunos
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${shared_ext}$versuffix'
  finish_cmds='PATH="\$PATH:/usr/etc" ldconfig $libdir'
  shlibpath_var=LD_LIBRARY_PATH
  shlibpath_overrides_runpath=yes
  if test "$with_gnu_ld" = yes; then
    need_lib_prefix=no
  fi
  need_version=yes
  ;;

sysv4 | sysv4.3*)
  version_type=linux
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  case $host_vendor in
    sni)
      shlibpath_overrides_runpath=no
      need_lib_prefix=no
      export_dynamic_flag_spec='${wl}-Blargedynsym'
      runpath_var=LD_RUN_PATH
      ;;
    siemens)
      need_lib_prefix=no
      ;;
    motorola)
      need_lib_prefix=no
      need_version=no
      shlibpath_overrides_runpath=no
      sys_lib_search_path_spec='/lib /usr/lib /usr/ccs/lib'
      ;;
  esac
  ;;

sysv4*MP*)
  if test -d /usr/nec ;then
    version_type=linux
    library_names_spec='$libname${shared_ext}.$versuffix $libname${shared_ext}.$major $libname${shared_ext}'
    soname_spec='$libname${shared_ext}.$major'
    shlibpath_var=LD_LIBRARY_PATH
  fi
  ;;

sysv5* | sco3.2v5* | sco5v6* | unixware* | OpenUNIX* | sysv4*uw2*)
  version_type=freebsd-elf
  need_lib_prefix=no
  need_version=no
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext} $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  hardcode_into_libs=yes
  if test "$with_gnu_ld" = yes; then
    sys_lib_search_path_spec='/usr/local/lib /usr/gnu/lib /usr/ccs/lib /usr/lib /lib'
    shlibpath_overrides_runpath=no
  else
    sys_lib_search_path_spec='/usr/ccs/lib /usr/lib'
    shlibpath_overrides_runpath=yes
    case $host_os in
      sco3.2v5*)
        sys_lib_search_path_spec="$sys_lib_search_path_spec /lib"
	;;
    esac
  fi
  sys_lib_dlsearch_path_spec='/usr/lib'
  ;;

uts4*)
  version_type=linux
  library_names_spec='${libname}${release}${shared_ext}$versuffix ${libname}${release}${shared_ext}$major $libname${shared_ext}'
  soname_spec='${libname}${release}${shared_ext}$major'
  shlibpath_var=LD_LIBRARY_PATH
  ;;

*)
  dynamic_linker=no
  ;;
esac
AC_MSG_RESULT([$dynamic_linker])
test "$dynamic_linker" = no && can_build_shared=no

variables_saved_for_relink="PATH $shlibpath_var $runpath_var"
if test "$GCC" = yes; then
  variables_saved_for_relink="$variables_saved_for_relink GCC_EXEC_PREFIX COMPILER_PATH LIBRARY_PATH"
fi
])# AC_LIBTOOL_SYS_DYNAMIC_LINKER


# _LT_AC_TAGCONFIG
# ----------------
AC_DEFUN([_LT_AC_TAGCONFIG],
[AC_ARG_WITH([tags],
    [AC_HELP_STRING([--with-tags@<:@=TAGS@:>@],
        [include additional configurations @<:@automatic@:>@])],
    [tagnames="$withval"])

if test -f "$ltmain" && test -n "$tagnames"; then
  if test ! -f "${ofile}"; then
    AC_MSG_WARN([output file `$ofile' does not exist])
  fi

  if test -z "$LTCC"; then
    eval "`$SHELL ${ofile} --config | grep '^LTCC='`"
    if test -z "$LTCC"; then
      AC_MSG_WARN([output file `$ofile' does not look like a libtool script])
    else
      AC_MSG_WARN([using `LTCC=$LTCC', extracted from `$ofile'])
    fi
  fi
  if test -z "$LTCFLAGS"; then
    eval "`$SHELL ${ofile} --config | grep '^LTCFLAGS='`"
  fi

  # Extract list of available tagged configurations in $ofile.
  # Note that this assumes the entire list is on one line.
  available_tags=`grep "^available_tags=" "${ofile}" | $SED -e 's/available_tags=\(.*$\)/\1/' -e 's/\"//g'`

  lt_save_ifs="$IFS"; IFS="${IFS}$PATH_SEPARATOR,"
  for tagname in $tagnames; do
    IFS="$lt_save_ifs"
    # Check whether tagname contains only valid characters
    case `$echo "X$tagname" | $Xsed -e 's:[[-_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890,/]]::g'` in
    "") ;;
    *)  AC_MSG_ERROR([invalid tag name: $tagname])
	;;
    esac

    if grep "^# ### BEGIN LIBTOOL TAG CONFIG: $tagname$" < "${ofile}" > /dev/null
    then
      AC_MSG_ERROR([tag name \"$tagname\" already exists])
    fi

    # Update the list of available tags.
    if test -n "$tagname"; then
      echo appending configuration tag \"$tagname\" to $ofile

      case $tagname in
      CXX)
	if test -n "$CXX" && ( test "X$CXX" != "Xno" &&
	    ( (test "X$CXX" = "Xg++" && `g++ -v >/dev/null 2>&1` ) ||
	    (test "X$CXX" != "Xg++"))) ; then
	  AC_LIBTOOL_LANG_CXX_CONFIG
	else
	  tagname=""
	fi
	;;

      F77)
	if test -n "$F77" && test "X$F77" != "Xno"; then
	  AC_LIBTOOL_LANG_F77_CONFIG
	else
	  tagname=""
	fi
	;;

      GCJ)
	if test -n "$GCJ" && test "X$GCJ" != "Xno"; then
	  AC_LIBTOOL_LANG_GCJ_CONFIG
	else
	  tagname=""
	fi
	;;

      RC)
	AC_LIBTOOL_LANG_RC_CONFIG
	;;

      *)
	AC_MSG_ERROR([Unsupported tag name: $tagname])
	;;
      esac

      # Append the new tag name to the list of available tags.
      if test -n "$tagname" ; then
      available_tags="$available_tags $tagname"
    fi
    fi
  done
  IFS="$lt_save_ifs"

  # Now substitute the updated list of available tags.
  if eval "sed -e 's/^available_tags=.*\$/available_tags=\"$available_tags\"/' \"$ofile\" > \"${ofile}T\""; then
    mv "${ofile}T" "$ofile"
    chmod +x "$ofile"
  else
    rm -f "${ofile}T"
    AC_MSG_ERROR([unable to update list of available tagged configurations.])
  fi
fi
])# _LT_AC_TAGCONFIG


# AC_LIBTOOL_DLOPEN
# -----------------
# enable checks for dlopen support
AC_DEFUN([AC_LIBTOOL_DLOPEN],
 [AC_BEFORE([$0],[AC_LIBTOOL_SETUP])
])# AC_LIBTOOL_DLOPEN


# AC_LIBTOOL_WIN32_DLL
# --------------------
# declare package support for building win32 DLLs
AC_DEFUN([AC_LIBTOOL_WIN32_DLL],
[AC_BEFORE([$0], [AC_LIBTOOL_SETUP])
])# AC_LIBTOOL_WIN32_DLL


# AC_ENABLE_SHARED([DEFAULT])
# ---------------------------
# implement the --enable-shared flag
# DEFAULT is either `yes' or `no'.  If omitted, it defaults to `yes'.
AC_DEFUN([AC_ENABLE_SHARED],
[define([AC_ENABLE_SHARED_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE([shared],
    [AC_HELP_STRING([--enable-shared@<:@=PKGS@:>@],
	[build shared libraries @<:@default=]AC_ENABLE_SHARED_DEFAULT[@:>@])],
    [p=${PACKAGE-default}
    case $enableval in
    yes) enable_shared=yes ;;
    no) enable_shared=no ;;
    *)
      enable_shared=no
      # Look at the argument we got.  We use all the common list separators.
      lt_save_ifs="$IFS"; IFS="${IFS}$PATH_SEPARATOR,"
      for pkg in $enableval; do
	IFS="$lt_save_ifs"
	if test "X$pkg" = "X$p"; then
	  enable_shared=yes
	fi
      done
      IFS="$lt_save_ifs"
      ;;
    esac],
    [enable_shared=]AC_ENABLE_SHARED_DEFAULT)
])# AC_ENABLE_SHARED


# AC_DISABLE_SHARED
# -----------------
# set the default shared flag to --disable-shared
AC_DEFUN([AC_DISABLE_SHARED],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_SHARED(no)
])# AC_DISABLE_SHARED


# AC_ENABLE_STATIC([DEFAULT])
# ---------------------------
# implement the --enable-static flag
# DEFAULT is either `yes' or `no'.  If omitted, it defaults to `yes'.
AC_DEFUN([AC_ENABLE_STATIC],
[define([AC_ENABLE_STATIC_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE([static],
    [AC_HELP_STRING([--enable-static@<:@=PKGS@:>@],
	[build static libraries @<:@default=]AC_ENABLE_STATIC_DEFAULT[@:>@])],
    [p=${PACKAGE-default}
    case $enableval in
    yes) enable_static=yes ;;
    no) enable_static=no ;;
    *)
     enable_static=no
      # Look at the argument we got.  We use all the common list separators.
      lt_save_ifs="$IFS"; IFS="${IFS}$PATH_SEPARATOR,"
      for pkg in $enableval; do
	IFS="$lt_save_ifs"
	if test "X$pkg" = "X$p"; then
	  enable_static=yes
	fi
      done
      IFS="$lt_save_ifs"
      ;;
    esac],
    [enable_static=]AC_ENABLE_STATIC_DEFAULT)
])# AC_ENABLE_STATIC


# AC_DISABLE_STATIC
# -----------------
# set the default static flag to --disable-static
AC_DEFUN([AC_DISABLE_STATIC],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_STATIC(no)
])# AC_DISABLE_STATIC


# AC_ENABLE_FAST_INSTALL([DEFAULT])
# ---------------------------------
# implement the --enable-fast-install flag
# DEFAULT is either `yes' or `no'.  If omitted, it defaults to `yes'.
AC_DEFUN([AC_ENABLE_FAST_INSTALL],
[define([AC_ENABLE_FAST_INSTALL_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE([fast-install],
    [AC_HELP_STRING([--enable-fast-install@<:@=PKGS@:>@],
    [optimize for fast installation @<:@default=]AC_ENABLE_FAST_INSTALL_DEFAULT[@:>@])],
    [p=${PACKAGE-default}
    case $enableval in
    yes) enable_fast_install=yes ;;
    no) enable_fast_install=no ;;
    *)
      enable_fast_install=no
      # Look at the argument we got.  We use all the common list separators.
      lt_save_ifs="$IFS"; IFS="${IFS}$PATH_SEPARATOR,"
      for pkg in $enableval; do
	IFS="$lt_save_ifs"
	if test "X$pkg" = "X$p"; then
	  enable_fast_install=yes
	fi
      done
      IFS="$lt_save_ifs"
      ;;
    esac],
    [enable_fast_install=]AC_ENABLE_FAST_INSTALL_DEFAULT)
])# AC_ENABLE_FAST_INSTALL


# AC_DISABLE_FAST_INSTALL
# -----------------------
# set the default to --disable-fast-install
AC_DEFUN([AC_DISABLE_FAST_INSTALL],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
AC_ENABLE_FAST_INSTALL(no)
])# AC_DISABLE_FAST_INSTALL


# AC_LIBTOOL_PICMODE([MODE])
# --------------------------
# implement the --with-pic flag
# MODE is either `yes' or `no'.  If omitted, it defaults to `both'.
AC_DEFUN([AC_LIBTOOL_PICMODE],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
pic_mode=ifelse($#,1,$1,default)
])# AC_LIBTOOL_PICMODE


# AC_PROG_EGREP
# -------------
# This is predefined starting with Autoconf 2.54, so this conditional
# definition can be removed once we require Autoconf 2.54 or later.
m4_ifndef([AC_PROG_EGREP], [AC_DEFUN([AC_PROG_EGREP],
[AC_CACHE_CHECK([for egrep], [ac_cv_prog_egrep],
   [if echo a | (grep -E '(a|b)') >/dev/null 2>&1
    then ac_cv_prog_egrep='grep -E'
    else ac_cv_prog_egrep='egrep'
    fi])
 EGREP=$ac_cv_prog_egrep
 AC_SUBST([EGREP])
])])


# AC_PATH_TOOL_PREFIX
# -------------------
# find a file program which can recognise shared library
AC_DEFUN([AC_PATH_TOOL_PREFIX],
[AC_REQUIRE([AC_PROG_EGREP])dnl
AC_MSG_CHECKING([for $1])
AC_CACHE_VAL(lt_cv_path_MAGIC_CMD,
[case $MAGIC_CMD in
[[\\/*] |  ?:[\\/]*])
  lt_cv_path_MAGIC_CMD="$MAGIC_CMD" # Let the user override the test with a path.
  ;;
*)
  lt_save_MAGIC_CMD="$MAGIC_CMD"
  lt_save_ifs="$IFS"; IFS=$PATH_SEPARATOR
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
  ac_dummy="ifelse([$2], , $PATH, [$2])"
  for ac_dir in $ac_dummy; do
    IFS="$lt_save_ifs"
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/$1; then
      lt_cv_path_MAGIC_CMD="$ac_dir/$1"
      if test -n "$file_magic_test_file"; then
	case $deplibs_check_method in
	"file_magic "*)
	  file_magic_regex=`expr "$deplibs_check_method" : "file_magic \(.*\)"`
	  MAGIC_CMD="$lt_cv_path_MAGIC_CMD"
	  if eval $file_magic_cmd \$file_magic_test_file 2> /dev/null |
	    $EGREP "$file_magic_regex" > /dev/null; then
	    :
	  else
	    cat <<EOF 1>&2

*** Warning: the command libtool uses to detect shared libraries,
*** $file_magic_cmd, produces output that libtool cannot recognize.
*** The result is that libtool may fail to recognize shared libraries
*** as such.  This will affect the creation of libtool libraries that
*** depend on shared libraries, but programs linked with such libtool
*** libraries will work regardless of this problem.  Nevertheless, you
*** may want to report the problem to your system manager and/or to
*** bug-libtool@gnu.org

EOF
	  fi ;;
	esac
      fi
      break
    fi
  done
  IFS="$lt_save_ifs"
  MAGIC_CMD="$lt_save_MAGIC_CMD"
  ;;
esac])
MAGIC_CMD="$lt_cv_path_MAGIC_CMD"
if test -n "$MAGIC_CMD"; then
  AC_MSG_RESULT($MAGIC_CMD)
else
  AC_MSG_RESULT(no)
fi
])# AC_PATH_TOOL_PREFIX


# AC_PATH_MAGIC
# -------------
# find a file program which can recognise a shared library
AC_DEFUN([AC_PATH_MAGIC],
[AC_PATH_TOOL_PREFIX(${ac_tool_prefix}file, /usr/bin$PATH_SEPARATOR$PATH)
if test -z "$lt_cv_path_MAGIC_CMD"; then
  if test -n "$ac_tool_prefix"; then
    AC_PATH_TOOL_PREFIX(file, /usr/bin$PATH_SEPARATOR$PATH)
  else
    MAGIC_CMD=:
  fi
fi
])# AC_PATH_MAGIC


# AC_PROG_LD
# ----------
# find the pathname to the GNU or non-GNU linker
AC_DEFUN([AC_PROG_LD],
[AC_ARG_WITH([gnu-ld],
    [AC_HELP_STRING([--with-gnu-ld],
	[assume the C compiler uses GNU ld @<:@default=no@:>@])],
    [test "$withval" = no || with_gnu_ld=yes],
    [with_gnu_ld=no])
AC_REQUIRE([LT_AC_PROG_SED])dnl
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
ac_prog=ld
if test "$GCC" = yes; then
  # Check if gcc -print-prog-name=ld gives a path.
  AC_MSG_CHECKING([for ld used by $CC])
  case $host in
  *-*-mingw*)
    # gcc leaves a trailing carriage return which upsets mingw
    ac_prog=`($CC -print-prog-name=ld) 2>&5 | tr -d '\015'` ;;
  *)
    ac_prog=`($CC -print-prog-name=ld) 2>&5` ;;
  esac
  case $ac_prog in
    # Accept absolute paths.
    [[\\/]]* | ?:[[\\/]]*)
      re_direlt='/[[^/]][[^/]]*/\.\./'
      # Canonicalize the pathname of ld
      ac_prog=`echo $ac_prog| $SED 's%\\\\%/%g'`
      while echo $ac_prog | grep "$re_direlt" > /dev/null 2>&1; do
	ac_prog=`echo $ac_prog| $SED "s%$re_direlt%/%"`
      done
      test -z "$LD" && LD="$ac_prog"
      ;;
  "")
    # If it fails, then pretend we aren't using GCC.
    ac_prog=ld
    ;;
  *)
    # If it is relative, then search for the first ld in PATH.
    with_gnu_ld=unknown
    ;;
  esac
elif test "$with_gnu_ld" = yes; then
  AC_MSG_CHECKING([for GNU ld])
else
  AC_MSG_CHECKING([for non-GNU ld])
fi
AC_CACHE_VAL(lt_cv_path_LD,
[if test -z "$LD"; then
  lt_save_ifs="$IFS"; IFS=$PATH_SEPARATOR
  for ac_dir in $PATH; do
    IFS="$lt_save_ifs"
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_prog" || test -f "$ac_dir/$ac_prog$ac_exeext"; then
      lt_cv_path_LD="$ac_dir/$ac_prog"
      # Check to see if the program is GNU ld.  I'd rather use --version,
      # but apparently some variants of GNU ld only accept -v.
      # Break only if it was the GNU/non-GNU ld that we prefer.
      case `"$lt_cv_path_LD" -v 2>&1 </dev/null` in
      *GNU* | *'with BFD'*)
	test "$with_gnu_ld" != no && break
	;;
      *)
	test "$with_gnu_ld" != yes && break
	;;
      esac
    fi
  done
  IFS="$lt_save_ifs"
else
  lt_cv_path_LD="$LD" # Let the user override the test with a path.
fi])
LD="$lt_cv_path_LD"
if test -n "$LD"; then
  AC_MSG_RESULT($LD)
else
  AC_MSG_RESULT(no)
fi
test -z "$LD" && AC_MSG_ERROR([no acceptable ld found in \$PATH])
AC_PROG_LD_GNU
])# AC_PROG_LD


# AC_PROG_LD_GNU
# --------------
AC_DEFUN([AC_PROG_LD_GNU],
[AC_REQUIRE([AC_PROG_EGREP])dnl
AC_CACHE_CHECK([if the linker ($LD) is GNU ld], lt_cv_prog_gnu_ld,
[# I'd rather use --version here, but apparently some GNU lds only accept -v.
case `$LD -v 2>&1 </dev/null` in
*GNU* | *'with BFD'*)
  lt_cv_prog_gnu_ld=yes
  ;;
*)
  lt_cv_prog_gnu_ld=no
  ;;
esac])
with_gnu_ld=$lt_cv_prog_gnu_ld
])# AC_PROG_LD_GNU


# AC_PROG_LD_RELOAD_FLAG
# ----------------------
# find reload flag for linker
#   -- PORTME Some linkers may need a different reload flag.
AC_DEFUN([AC_PROG_LD_RELOAD_FLAG],
[AC_CACHE_CHECK([for $LD option to reload object files],
  lt_cv_ld_reload_flag,
  [lt_cv_ld_reload_flag='-r'])
reload_flag=$lt_cv_ld_reload_flag
case $reload_flag in
"" | " "*) ;;
*) reload_flag=" $reload_flag" ;;
esac
reload_cmds='$LD$reload_flag -o $output$reload_objs'
case $host_os in
  darwin*)
    if test "$GCC" = yes; then
      reload_cmds='$LTCC $LTCFLAGS -nostdlib ${wl}-r -o $output$reload_objs'
    else
      reload_cmds='$LD$reload_flag -o $output$reload_objs'
    fi
    ;;
esac
])# AC_PROG_LD_RELOAD_FLAG


# AC_DEPLIBS_CHECK_METHOD
# -----------------------
# how to check for library dependencies
#  -- PORTME fill in with the dynamic library characteristics
AC_DEFUN([AC_DEPLIBS_CHECK_METHOD],
[AC_CACHE_CHECK([how to recognise dependent libraries],
lt_cv_deplibs_check_method,
[lt_cv_file_magic_cmd='$MAGIC_CMD'
lt_cv_file_magic_test_file=
lt_cv_deplibs_check_method='unknown'
# Need to set the preceding variable on all platforms that support
# interlibrary dependencies.
# 'none' -- dependencies not supported.
# `unknown' -- same as none, but documents that we really don't know.
# 'pass_all' -- all dependencies passed with no checks.
# 'test_compile' -- check by making test program.
# 'file_magic [[regex]]' -- check by looking for files in library path
# which responds to the $file_magic_cmd with a given extended regex.
# If you have `file' or equivalent on your system and you're not sure
# whether `pass_all' will *always* work, you probably want this one.

case $host_os in
aix4* | aix5*)
  lt_cv_deplibs_check_method=pass_all
  ;;

beos*)
  lt_cv_deplibs_check_method=pass_all
  ;;

bsdi[[45]]*)
  lt_cv_deplibs_check_method='file_magic ELF [[0-9]][[0-9]]*-bit [[ML]]SB (shared object|dynamic lib)'
  lt_cv_file_magic_cmd='/usr/bin/file -L'
  lt_cv_file_magic_test_file=/shlib/libc.so
  ;;

cygwin*)
  # func_win32_libid is a shell function defined in ltmain.sh
  lt_cv_deplibs_check_method='file_magic ^x86 archive import|^x86 DLL'
  lt_cv_file_magic_cmd='func_win32_libid'
  ;;

mingw* | pw32*)
  # Base MSYS/MinGW do not provide the 'file' command needed by
  # func_win32_libid shell function, so use a weaker test based on 'objdump'.
  lt_cv_deplibs_check_method='file_magic file format pei*-i386(.*architecture: i386)?'
  lt_cv_file_magic_cmd='$OBJDUMP -f'
  ;;

darwin* | rhapsody*)
  lt_cv_deplibs_check_method=pass_all
  ;;

freebsd* | kfreebsd*-gnu | dragonfly*)
  if echo __ELF__ | $CC -E - | grep __ELF__ > /dev/null; then
    case $host_cpu in
    i*86 )
      # Not sure whether the presence of OpenBSD here was a mistake.
      # Let's accept both of them until this is cleared up.
      lt_cv_deplibs_check_method='file_magic (FreeBSD|OpenBSD|DragonFly)/i[[3-9]]86 (compact )?demand paged shared library'
      lt_cv_file_magic_cmd=/usr/bin/file
      lt_cv_file_magic_test_file=`echo /usr/lib/libc.so.*`
      ;;
    esac
  else
    lt_cv_deplibs_check_method=pass_all
  fi
  ;;

gnu*)
  lt_cv_deplibs_check_method=pass_all
  ;;

hpux10.20* | hpux11*)
  lt_cv_file_magic_cmd=/usr/bin/file
  case $host_cpu in
  ia64*)
    lt_cv_deplibs_check_method='file_magic (s[[0-9]][[0-9]][[0-9]]|ELF-[[0-9]][[0-9]]) shared object file - IA64'
    lt_cv_file_magic_test_file=/usr/lib/hpux32/libc.so
    ;;
  hppa*64*)
    [lt_cv_deplibs_check_method='file_magic (s[0-9][0-9][0-9]|ELF-[0-9][0-9]) shared object file - PA-RISC [0-9].[0-9]']
    lt_cv_file_magic_test_file=/usr/lib/pa20_64/libc.sl
    ;;
  *)
    lt_cv_deplibs_check_method='file_magic (s[[0-9]][[0-9]][[0-9]]|PA-RISC[[0-9]].[[0-9]]) shared library'
    lt_cv_file_magic_test_file=/usr/lib/libc.sl
    ;;
  esac
  ;;

interix3*)
  # PIC code is broken on Interix 3.x, that's why |\.a not |_pic\.a here
  lt_cv_deplibs_check_method='match_pattern /lib[[^/]]+(\.so|\.a)$'
  ;;

irix5* | irix6* | nonstopux*)
  case $LD in
  *-32|*"-32 ") libmagic=32-bit;;
  *-n32|*"-n32 ") libmagic=N32;;
  *-64|*"-64 ") libmagic=64-bit;;
  *) libmagic=never-match;;
  esac
  lt_cv_deplibs_check_method=pass_all
  ;;

# This must be Linux ELF.
linux*)
  lt_cv_deplibs_check_method=pass_all
  ;;

netbsd*)
  if echo __ELF__ | $CC -E - | grep __ELF__ > /dev/null; then
    lt_cv_deplibs_check_method='match_pattern /lib[[^/]]+(\.so\.[[0-9]]+\.[[0-9]]+|_pic\.a)$'
  else
    lt_cv_deplibs_check_method='match_pattern /lib[[^/]]+(\.so|_pic\.a)$'
  fi
  ;;

newos6*)
  lt_cv_deplibs_check_method='file_magic ELF [[0-9]][[0-9]]*-bit [[ML]]SB (executable|dynamic lib)'
  lt_cv_file_magic_cmd=/usr/bin/file
  lt_cv_file_magic_test_file=/usr/lib/libnls.so
  ;;

nto-qnx*)
  lt_cv_deplibs_check_method=unknown
  ;;

openbsd*)
  if test -z "`echo __ELF__ | $CC -E - | grep __ELF__`" || test "$host_os-$host_cpu" = "openbsd2.8-powerpc"; then
    lt_cv_deplibs_check_method='match_pattern /lib[[^/]]+(\.so\.[[0-9]]+\.[[0-9]]+|\.so|_pic\.a)$'
  else
    lt_cv_deplibs_check_method='match_pattern /lib[[^/]]+(\.so\.[[0-9]]+\.[[0-9]]+|_pic\.a)$'
  fi
  ;;

osf3* | osf4* | osf5*)
  lt_cv_deplibs_check_method=pass_all
  ;;

solaris*)
  lt_cv_deplibs_check_method=pass_all
  ;;

sysv4 | sysv4.3*)
  case $host_vendor in
  motorola)
    lt_cv_deplibs_check_method='file_magic ELF [[0-9]][[0-9]]*-bit [[ML]]SB (shared object|dynamic lib) M[[0-9]][[0-9]]* Version [[0-9]]'
    lt_cv_file_magic_test_file=`echo /usr/lib/libc.so*`
    ;;
  ncr)
    lt_cv_deplibs_check_method=pass_all
    ;;
  sequent)
    lt_cv_file_magic_cmd='/bin/file'
    lt_cv_deplibs_check_method='file_magic ELF [[0-9]][[0-9]]*-bit [[LM]]SB (shared object|dynamic lib )'
    ;;
  sni)
    lt_cv_file_magic_cmd='/bin/file'
    lt_cv_deplibs_check_method="file_magic ELF [[0-9]][[0-9]]*-bit [[LM]]SB dynamic lib"
    lt_cv_file_magic_test_file=/lib/libc.so
    ;;
  siemens)
    lt_cv_deplibs_check_method=pass_all
    ;;
  pc)
    lt_cv_deplibs_check_method=pass_all
    ;;
  esac
  ;;

sysv5* | sco3.2v5* | sco5v6* | unixware* | OpenUNIX* | sysv4*uw2*)
  lt_cv_deplibs_check_method=pass_all
  ;;
esac
])
file_magic_cmd=$lt_cv_file_magic_cmd
deplibs_check_method=$lt_cv_deplibs_check_method
test -z "$deplibs_check_method" && deplibs_check_method=unknown
])# AC_DEPLIBS_CHECK_METHOD


# AC_PROG_NM
# ----------
# find the pathname to a BSD-compatible name lister
AC_DEFUN([AC_PROG_NM],
[AC_CACHE_CHECK([for BSD-compatible nm], lt_cv_path_NM,
[if test -n "$NM"; then
  # Let the user override the test.
  lt_cv_path_NM="$NM"
else
  lt_nm_to_check="${ac_tool_prefix}nm"
  if test -n "$ac_tool_prefix" && test "$build" = "$host"; then 
    lt_nm_to_check="$lt_nm_to_check nm"
  fi
  for lt_tmp_nm in $lt_nm_to_check; do
    lt_save_ifs="$IFS"; IFS=$PATH_SEPARATOR
    for ac_dir in $PATH /usr/ccs/bin/elf /usr/ccs/bin /usr/ucb /bin; do
      IFS="$lt_save_ifs"
      test -z "$ac_dir" && ac_dir=.
      tmp_nm="$ac_dir/$lt_tmp_nm"
      if test -f "$tmp_nm" || test -f "$tmp_nm$ac_exeext" ; then
	# Check to see if the nm accepts a BSD-compat flag.
	# Adding the `sed 1q' prevents false positives on HP-UX, which says:
	#   nm: unknown option "B" ignored
	# Tru64's nm complains that /dev/null is an invalid object file
	case `"$tmp_nm" -B /dev/null 2>&1 | sed '1q'` in
	*/dev/null* | *'Invalid file or object type'*)
	  lt_cv_path_NM="$tmp_nm -B"
	  break
	  ;;
	*)
	  case `"$tmp_nm" -p /dev/null 2>&1 | sed '1q'` in
	  */dev/null*)
	    lt_cv_path_NM="$tmp_nm -p"
	    break
	    ;;
	  *)
	    lt_cv_path_NM=${lt_cv_path_NM="$tmp_nm"} # keep the first match, but
	    continue # so that we can try to find one that supports BSD flags
	    ;;
	  esac
	  ;;
	esac
      fi
    done
    IFS="$lt_save_ifs"
  done
  test -z "$lt_cv_path_NM" && lt_cv_path_NM=nm
fi])
NM="$lt_cv_path_NM"
])# AC_PROG_NM


# AC_CHECK_LIBM
# -------------
# check for math library
AC_DEFUN([AC_CHECK_LIBM],
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
LIBM=
case $host in
*-*-beos* | *-*-cygwin* | *-*-pw32* | *-*-darwin*)
  # These system don't have libm, or don't need it
  ;;
*-ncr-sysv4.3*)
  AC_CHECK_LIB(mw, _mwvalidcheckl, LIBM="-lmw")
  AC_CHECK_LIB(m, cos, LIBM="$LIBM -lm")
  ;;
*)
  AC_CHECK_LIB(m, cos, LIBM="-lm")
  ;;
esac
])# AC_CHECK_LIBM


# AC_LIBLTDL_CONVENIENCE([DIRECTORY])
# -----------------------------------
# sets LIBLTDL to the link flags for the libltdl convenience library and
# LTDLINCL to the include flags for the libltdl header and adds
# --enable-ltdl-convenience to the configure arguments.  Note that
# AC_CONFIG_SUBDIRS is not called here.  If DIRECTORY is not provided,
# it is assumed to be `libltdl'.  LIBLTDL will be prefixed with
# '${top_builddir}/' and LTDLINCL will be prefixed with '${top_srcdir}/'
# (note the single quotes!).  If your package is not flat and you're not
# using automake, define top_builddir and top_srcdir appropriately in
# the Makefiles.
AC_DEFUN([AC_LIBLTDL_CONVENIENCE],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  case $enable_ltdl_convenience in
  no) AC_MSG_ERROR([this package needs a convenience libltdl]) ;;
  "") enable_ltdl_convenience=yes
      ac_configure_args="$ac_configure_args --enable-ltdl-convenience" ;;
  esac
  LIBLTDL='${top_builddir}/'ifelse($#,1,[$1],['libltdl'])/libltdlc.la
  LTDLINCL='-I${top_srcdir}/'ifelse($#,1,[$1],['libltdl'])
  # For backwards non-gettext consistent compatibility...
  INCLTDL="$LTDLINCL"
])# AC_LIBLTDL_CONVENIENCE


# AC_LIBLTDL_INSTALLABLE([DIRECTORY])
# -----------------------------------
# sets LIBLTDL to the link flags for the libltdl installable library and
# LTDLINCL to the include flags for the libltdl header and adds
# --enable-ltdl-install to the configure arguments.  Note that
# AC_CONFIG_SUBDIRS is not called here.  If DIRECTORY is not provided,
# and an installed libltdl is not found, it is assumed to be `libltdl'.
# LIBLTDL will be prefixed with '${top_builddir}/'# and LTDLINCL with
# '${top_srcdir}/' (note the single quotes!).  If your package is not
# flat and you're not using automake, define top_builddir and top_srcdir
# appropriately in the Makefiles.
# In the future, this macro may have to be called after AC_PROG_LIBTOOL.
AC_DEFUN([AC_LIBLTDL_INSTALLABLE],
[AC_BEFORE([$0],[AC_LIBTOOL_SETUP])dnl
  AC_CHECK_LIB(ltdl, lt_dlinit,
  [test x"$enable_ltdl_install" != xyes && enable_ltdl_install=no],
  [if test x"$enable_ltdl_install" = xno; then
     AC_MSG_WARN([libltdl not installed, but installation disabled])
   else
     enable_ltdl_install=yes
   fi
  ])
  if test x"$enable_ltdl_install" = x"yes"; then
    ac_configure_args="$ac_configure_args --enable-ltdl-install"
    LIBLTDL='${top_builddir}/'ifelse($#,1,[$1],['libltdl'])/libltdl.la
    LTDLINCL='-I${top_srcdir}/'ifelse($#,1,[$1],['libltdl'])
  else
    ac_configure_args="$ac_configure_args --enable-ltdl-install=no"
    LIBLTDL="-lltdl"
    LTDLINCL=
  fi
  # For backwards non-gettext consistent compatibility...
  INCLTDL="$LTDLINCL"
])# AC_LIBLTDL_INSTALLABLE


# AC_LIBTOOL_CXX
# --------------
# enable support for C++ libraries
AC_DEFUN([AC_LIBTOOL_CXX],
[AC_REQUIRE([_LT_AC_LANG_CXX])
])# AC_LIBTOOL_CXX


# _LT_AC_LANG_CXX
# ---------------
AC_DEFUN([_LT_AC_LANG_CXX],
[AC_REQUIRE([AC_PROG_CXX])
AC_REQUIRE([_LT_AC_PROG_CXXCPP])
_LT_AC_SHELL_INIT([tagnames=${tagnames+${tagnames},}CXX])
])# _LT_AC_LANG_CXX

# _LT_AC_PROG_CXXCPP
# ------------------
AC_DEFUN([_LT_AC_PROG_CXXCPP],
[
AC_REQUIRE([AC_PROG_CXX])
if test -n "$CXX" && ( test "X$CXX" != "Xno" &&
    ( (test "X$CXX" = "Xg++" && `g++ -v >/dev/null 2>&1` ) ||
    (test "X$CXX" != "Xg++"))) ; then
  AC_PROG_CXXCPP
fi
])# _LT_AC_PROG_CXXCPP

# AC_LIBTOOL_F77
# --------------
# enable support for Fortran 77 libraries
AC_DEFUN([AC_LIBTOOL_F77],
[AC_REQUIRE([_LT_AC_LANG_F77])
])# AC_LIBTOOL_F77


# _LT_AC_LANG_F77
# ---------------
AC_DEFUN([_LT_AC_LANG_F77],
[AC_REQUIRE([AC_PROG_F77])
_LT_AC_SHELL_INIT([tagnames=${tagnames+${tagnames},}F77])
])# _LT_AC_LANG_F77


# AC_LIBTOOL_GCJ
# --------------
# enable support for GCJ libraries
AC_DEFUN([AC_LIBTOOL_GCJ],
[AC_REQUIRE([_LT_AC_LANG_GCJ])
])# AC_LIBTOOL_GCJ


# _LT_AC_LANG_GCJ
# ---------------
AC_DEFUN([_LT_AC_LANG_GCJ],
[AC_PROVIDE_IFELSE([AC_PROG_GCJ],[],
  [AC_PROVIDE_IFELSE([A][M_PROG_GCJ],[],
    [AC_PROVIDE_IFELSE([LT_AC_PROG_GCJ],[],
      [ifdef([AC_PROG_GCJ],[AC_REQUIRE([AC_PROG_GCJ])],
	 [ifdef([A][M_PROG_GCJ],[AC_REQUIRE([A][M_PROG_GCJ])],
	   [AC_REQUIRE([A][C_PROG_GCJ_OR_A][M_PROG_GCJ])])])])])])
_LT_AC_SHELL_INIT([tagnames=${tagnames+${tagnames},}GCJ])
])# _LT_AC_LANG_GCJ


# AC_LIBTOOL_RC
# -------------
# enable support for Windows resource files
AC_DEFUN([AC_LIBTOOL_RC],
[AC_REQUIRE([LT_AC_PROG_RC])
_LT_AC_SHELL_INIT([tagnames=${tagnames+${tagnames},}RC])
])# AC_LIBTOOL_RC


# AC_LIBTOOL_LANG_C_CONFIG
# ------------------------
# Ensure that the configuration vars for the C compiler are
# suitably defined.  Those variables are subsequently used by
# AC_LIBTOOL_CONFIG to write the compiler configuration to `libtool'.
AC_DEFUN([AC_LIBTOOL_LANG_C_CONFIG], [_LT_AC_LANG_C_CONFIG])
AC_DEFUN([_LT_AC_LANG_C_CONFIG],
[lt_save_CC="$CC"
AC_LANG_PUSH(C)

# Source file extension for C test sources.
ac_ext=c

# Object file extension for compiled C test sources.
objext=o
_LT_AC_TAGVAR(objext, $1)=$objext

# Code to be used in simple compile tests
lt_simple_compile_test_code="int some_variable = 0;\n"

# Code to be used in simple link tests
lt_simple_link_test_code='int main(){return(0);}\n'

_LT_AC_SYS_COMPILER

# save warnings/boilerplate of simple test code
_LT_COMPILER_BOILERPLATE
_LT_LINKER_BOILERPLATE

AC_LIBTOOL_PROG_COMPILER_NO_RTTI($1)
AC_LIBTOOL_PROG_COMPILER_PIC($1)
AC_LIBTOOL_PROG_CC_C_O($1)
AC_LIBTOOL_SYS_HARD_LINK_LOCKS($1)
AC_LIBTOOL_PROG_LD_SHLIBS($1)
AC_LIBTOOL_SYS_DYNAMIC_LINKER($1)
AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH($1)
AC_LIBTOOL_SYS_LIB_STRIP
AC_LIBTOOL_DLOPEN_SELF

# Report which library types will actually be built
AC_MSG_CHECKING([if libtool supports shared libraries])
AC_MSG_RESULT([$can_build_shared])

AC_MSG_CHECKING([whether to build shared libraries])
test "$can_build_shared" = "no" && enable_shared=no

# On AIX, shared libraries and static libraries use the same namespace, and
# are all built from PIC.
case $host_os in
aix3*)
  test "$enable_shared" = yes && enable_static=no
  if test -n "$RANLIB"; then
    archive_cmds="$archive_cmds~\$RANLIB \$lib"
    postinstall_cmds='$RANLIB $lib'
  fi
  ;;

aix4* | aix5*)
  if test "$host_cpu" != ia64 && test "$aix_use_runtimelinking" = no ; then
    test "$enable_shared" = yes && enable_static=no
  fi
    ;;
esac
AC_MSG_RESULT([$enable_shared])

AC_MSG_CHECKING([whether to build static libraries])
# Make sure either enable_shared or enable_static is yes.
test "$enable_shared" = yes || enable_static=yes
AC_MSG_RESULT([$enable_static])

AC_LIBTOOL_CONFIG($1)

AC_LANG_POP
CC="$lt_save_CC"
])# AC_LIBTOOL_LANG_C_CONFIG


# AC_LIBTOOL_LANG_CXX_CONFIG
# --------------------------
# Ensure that the configuration vars for the C compiler are
# suitably defined.  Those variables are subsequently used by
# AC_LIBTOOL_CONFIG to write the compiler configuration to `libtool'.
AC_DEFUN([AC_LIBTOOL_LANG_CXX_CONFIG], [_LT_AC_LANG_CXX_CONFIG(CXX)])
AC_DEFUN([_LT_AC_LANG_CXX_CONFIG],
[AC_LANG_PUSH(C++)
AC_REQUIRE([AC_PROG_CXX])
AC_REQUIRE([_LT_AC_PROG_CXXCPP])

_LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
_LT_AC_TAGVAR(allow_undefined_flag, $1)=
_LT_AC_TAGVAR(always_export_symbols, $1)=no
_LT_AC_TAGVAR(archive_expsym_cmds, $1)=
_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)=
_LT_AC_TAGVAR(hardcode_direct, $1)=no
_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)=
_LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)=
_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=
_LT_AC_TAGVAR(hardcode_minus_L, $1)=no
_LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=unsupported
_LT_AC_TAGVAR(hardcode_automatic, $1)=no
_LT_AC_TAGVAR(module_cmds, $1)=
_LT_AC_TAGVAR(module_expsym_cmds, $1)=
_LT_AC_TAGVAR(link_all_deplibs, $1)=unknown
_LT_AC_TAGVAR(old_archive_cmds, $1)=$old_archive_cmds
_LT_AC_TAGVAR(no_undefined_flag, $1)=
_LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
_LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=no

# Dependencies to place before and after the object being linked:
_LT_AC_TAGVAR(predep_objects, $1)=
_LT_AC_TAGVAR(postdep_objects, $1)=
_LT_AC_TAGVAR(predeps, $1)=
_LT_AC_TAGVAR(postdeps, $1)=
_LT_AC_TAGVAR(compiler_lib_search_path, $1)=

# Source file extension for C++ test sources.
ac_ext=cpp

# Object file extension for compiled C++ test sources.
objext=o
_LT_AC_TAGVAR(objext, $1)=$objext

# Code to be used in simple compile tests
lt_simple_compile_test_code="int some_variable = 0;\n"

# Code to be used in simple link tests
lt_simple_link_test_code='int main(int, char *[[]]) { return(0); }\n'

# ltmain only uses $CC for tagged configurations so make sure $CC is set.
_LT_AC_SYS_COMPILER

# save warnings/boilerplate of simple test code
_LT_COMPILER_BOILERPLATE
_LT_LINKER_BOILERPLATE

# Allow CC to be a program name with arguments.
lt_save_CC=$CC
lt_save_LD=$LD
lt_save_GCC=$GCC
GCC=$GXX
lt_save_with_gnu_ld=$with_gnu_ld
lt_save_path_LD=$lt_cv_path_LD
if test -n "${lt_cv_prog_gnu_ldcxx+set}"; then
  lt_cv_prog_gnu_ld=$lt_cv_prog_gnu_ldcxx
else
  $as_unset lt_cv_prog_gnu_ld
fi
if test -n "${lt_cv_path_LDCXX+set}"; then
  lt_cv_path_LD=$lt_cv_path_LDCXX
else
  $as_unset lt_cv_path_LD
fi
test -z "${LDCXX+set}" || LD=$LDCXX
CC=${CXX-"c++"}
compiler=$CC
_LT_AC_TAGVAR(compiler, $1)=$CC
_LT_CC_BASENAME([$compiler])

# We don't want -fno-exception wen compiling C++ code, so set the
# no_builtin_flag separately
if test "$GXX" = yes; then
  _LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)=' -fno-builtin'
else
  _LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)=
fi

if test "$GXX" = yes; then
  # Set up default GNU C++ configuration

  AC_PROG_LD

  # Check if GNU C++ uses GNU ld as the underlying linker, since the
  # archiving commands below assume that GNU ld is being used.
  if test "$with_gnu_ld" = yes; then
    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname -o $lib'
    _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'

    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}--rpath ${wl}$libdir'
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}--export-dynamic'

    # If archive_cmds runs LD, not CC, wlarc should be empty
    # XXX I think wlarc can be eliminated in ltcf-cxx, but I need to
    #     investigate it a little bit more. (MM)
    wlarc='${wl}'

    # ancient GNU ld didn't support --whole-archive et. al.
    if eval "`$CC -print-prog-name=ld` --help 2>&1" | \
	grep 'no-whole-archive' > /dev/null; then
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)="$wlarc"'--whole-archive$convenience '"$wlarc"'--no-whole-archive'
    else
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
    fi
  else
    with_gnu_ld=no
    wlarc=

    # A generic and very simple default shared library creation
    # command for GNU C++ for the case where it uses the native
    # linker, instead of GNU ld.  If possible, this setting should
    # overridden to take advantage of the native linker features on
    # the platform it is being used on.
    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -o $lib'
  fi

  # Commands to make compiler produce verbose output that lists
  # what "hidden" libraries, object files and flags are used when
  # linking a shared library.
  output_verbose_link_cmd='$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "\-L"'

else
  GXX=no
  with_gnu_ld=no
  wlarc=
fi

# PORTME: fill in a description of your system's C++ link characteristics
AC_MSG_CHECKING([whether the $compiler linker ($LD) supports shared libraries])
_LT_AC_TAGVAR(ld_shlibs, $1)=yes
case $host_os in
  aix3*)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  aix4* | aix5*)
    if test "$host_cpu" = ia64; then
      # On IA64, the linker does run time linking by default, so we don't
      # have to do anything special.
      aix_use_runtimelinking=no
      exp_sym_flag='-Bexport'
      no_entry_flag=""
    else
      aix_use_runtimelinking=no

      # Test if we are trying to use run time linking or normal
      # AIX style linking. If -brtl is somewhere in LDFLAGS, we
      # need to do runtime linking.
      case $host_os in aix4.[[23]]|aix4.[[23]].*|aix5*)
	for ld_flag in $LDFLAGS; do
	  case $ld_flag in
	  *-brtl*)
	    aix_use_runtimelinking=yes
	    break
	    ;;
	  esac
	done
	;;
      esac

      exp_sym_flag='-bexport'
      no_entry_flag='-bnoentry'
    fi

    # When large executables or shared objects are built, AIX ld can
    # have problems creating the table of contents.  If linking a library
    # or program results in "error TOC overflow" add -mminimal-toc to
    # CXXFLAGS/CFLAGS for g++/gcc.  In the cases where that is not
    # enough to fix the problem, add -Wl,-bbigtoc to LDFLAGS.

    _LT_AC_TAGVAR(archive_cmds, $1)=''
    _LT_AC_TAGVAR(hardcode_direct, $1)=yes
    _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=':'
    _LT_AC_TAGVAR(link_all_deplibs, $1)=yes

    if test "$GXX" = yes; then
      case $host_os in aix4.[[012]]|aix4.[[012]].*)
      # We only want to do this on AIX 4.2 and lower, the check
      # below for broken collect2 doesn't work under 4.3+
	collect2name=`${CC} -print-prog-name=collect2`
	if test -f "$collect2name" && \
	   strings "$collect2name" | grep resolve_lib_name >/dev/null
	then
	  # We have reworked collect2
	  _LT_AC_TAGVAR(hardcode_direct, $1)=yes
	else
	  # We have old collect2
	  _LT_AC_TAGVAR(hardcode_direct, $1)=unsupported
	  # It fails to find uninstalled libraries when the uninstalled
	  # path is not listed in the libpath.  Setting hardcode_minus_L
	  # to unsupported forces relinking
	  _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
	  _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=
	fi
	;;
      esac
      shared_flag='-shared'
      if test "$aix_use_runtimelinking" = yes; then
	shared_flag="$shared_flag "'${wl}-G'
      fi
    else
      # not using gcc
      if test "$host_cpu" = ia64; then
	# VisualAge C++, Version 5.5 for AIX 5L for IA-64, Beta 3 Release
	# chokes on -Wl,-G. The following line is correct:
	shared_flag='-G'
      else
	if test "$aix_use_runtimelinking" = yes; then
	  shared_flag='${wl}-G'
	else
	  shared_flag='${wl}-bM:SRE'
	fi
      fi
    fi

    # It seems that -bexpall does not export symbols beginning with
    # underscore (_), so it is better to generate a list of symbols to export.
    _LT_AC_TAGVAR(always_export_symbols, $1)=yes
    if test "$aix_use_runtimelinking" = yes; then
      # Warning - without using the other runtime loading flags (-brtl),
      # -berok will link without error, but may produce a broken library.
      _LT_AC_TAGVAR(allow_undefined_flag, $1)='-berok'
      # Determine the default libpath from the value encoded in an empty executable.
      _LT_AC_SYS_LIBPATH_AIX
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-blibpath:$libdir:'"$aix_libpath"

      _LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC"' -o $output_objdir/$soname $libobjs $deplibs '"\${wl}$no_entry_flag"' $compiler_flags `if test "x${allow_undefined_flag}" != "x"; then echo "${wl}${allow_undefined_flag}"; else :; fi` '"\${wl}$exp_sym_flag:\$export_symbols $shared_flag"
     else
      if test "$host_cpu" = ia64; then
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-R $libdir:/usr/lib:/lib'
	_LT_AC_TAGVAR(allow_undefined_flag, $1)="-z nodefs"
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC $shared_flag"' -o $output_objdir/$soname $libobjs $deplibs '"\${wl}$no_entry_flag"' $compiler_flags ${wl}${allow_undefined_flag} '"\${wl}$exp_sym_flag:\$export_symbols"
      else
	# Determine the default libpath from the value encoded in an empty executable.
	_LT_AC_SYS_LIBPATH_AIX
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-blibpath:$libdir:'"$aix_libpath"
	# Warning - without using the other run time loading flags,
	# -berok will link without error, but may produce a broken library.
	_LT_AC_TAGVAR(no_undefined_flag, $1)=' ${wl}-bernotok'
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-berok'
	# Exported symbols can be pulled into shared objects from archives
	_LT_AC_TAGVAR(whole_archive_flag_spec, $1)='$convenience'
	_LT_AC_TAGVAR(archive_cmds_need_lc, $1)=yes
	# This is similar to how AIX traditionally builds its shared libraries.
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC $shared_flag"' -o $output_objdir/$soname $libobjs $deplibs ${wl}-bnoentry $compiler_flags ${wl}-bE:$export_symbols${allow_undefined_flag}~$AR $AR_FLAGS $output_objdir/$libname$release.a $output_objdir/$soname'
      fi
    fi
    ;;

  beos*)
    if $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
      _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
      # Joseph Beckenbach <jrb3@best.com> says some releases of gcc
      # support --undefined.  This deserves some investigation.  FIXME
      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -nostart $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
    else
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
    fi
    ;;

  chorus*)
    case $cc_basename in
      *)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
    esac
    ;;

  cygwin* | mingw* | pw32*)
    # _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1) is actually meaningless,
    # as there is no search path for DLLs.
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
    _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
    _LT_AC_TAGVAR(always_export_symbols, $1)=no
    _LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=yes

    if $LD --help 2>&1 | grep 'auto-import' > /dev/null; then
      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -o $output_objdir/$soname ${wl}--enable-auto-image-base -Xlinker --out-implib -Xlinker $lib'
      # If the export-symbols file already is a .def file (1st line
      # is EXPORTS), use it as is; otherwise, prepend...
      _LT_AC_TAGVAR(archive_expsym_cmds, $1)='if test "x`$SED 1q $export_symbols`" = xEXPORTS; then
	cp $export_symbols $output_objdir/$soname.def;
      else
	echo EXPORTS > $output_objdir/$soname.def;
	cat $export_symbols >> $output_objdir/$soname.def;
      fi~
      $CC -shared -nostdlib $output_objdir/$soname.def $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -o $output_objdir/$soname ${wl}--enable-auto-image-base -Xlinker --out-implib -Xlinker $lib'
    else
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
    fi
  ;;
      darwin* | rhapsody*)
        case $host_os in
        rhapsody* | darwin1.[[012]])
         _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-undefined ${wl}suppress'
         ;;
       *) # Darwin 1.3 on
         if test -z ${MACOSX_DEPLOYMENT_TARGET} ; then
           _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-flat_namespace ${wl}-undefined ${wl}suppress'
         else
           case ${MACOSX_DEPLOYMENT_TARGET} in
             10.[[012]])
               _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-flat_namespace ${wl}-undefined ${wl}suppress'
               ;;
             10.*)
               _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-undefined ${wl}dynamic_lookup'
               ;;
           esac
         fi
         ;;
        esac
      _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
      _LT_AC_TAGVAR(hardcode_direct, $1)=no
      _LT_AC_TAGVAR(hardcode_automatic, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=unsupported
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)=''
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes

    if test "$GXX" = yes ; then
      lt_int_apple_cc_single_mod=no
      output_verbose_link_cmd='echo'
      if $CC -dumpspecs 2>&1 | $EGREP 'single_module' >/dev/null ; then
       lt_int_apple_cc_single_mod=yes
      fi
      if test "X$lt_int_apple_cc_single_mod" = Xyes ; then
       _LT_AC_TAGVAR(archive_cmds, $1)='$CC -dynamiclib -single_module $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags -install_name $rpath/$soname $verstring'
      else
          _LT_AC_TAGVAR(archive_cmds, $1)='$CC -r -keep_private_externs -nostdlib -o ${lib}-master.o $libobjs~$CC -dynamiclib $allow_undefined_flag -o $lib ${lib}-master.o $deplibs $compiler_flags -install_name $rpath/$soname $verstring'
        fi
        _LT_AC_TAGVAR(module_cmds, $1)='$CC $allow_undefined_flag -o $lib -bundle $libobjs $deplibs$compiler_flags'
        # Don't fix this by using the ld -exported_symbols_list flag, it doesn't exist in older darwin lds
          if test "X$lt_int_apple_cc_single_mod" = Xyes ; then
            _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC -dynamiclib -single_module $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags -install_name $rpath/$soname $verstring~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          else
            _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC -r -keep_private_externs -nostdlib -o ${lib}-master.o $libobjs~$CC -dynamiclib $allow_undefined_flag -o $lib ${lib}-master.o $deplibs $compiler_flags -install_name $rpath/$soname $verstring~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          fi
            _LT_AC_TAGVAR(module_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC $allow_undefined_flag  -o $lib -bundle $libobjs $deplibs$compiler_flags~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
      else
      case $cc_basename in
        xlc*)
         output_verbose_link_cmd='echo'
          _LT_AC_TAGVAR(archive_cmds, $1)='$CC -qmkshrobj ${wl}-single_module $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags ${wl}-install_name ${wl}`echo $rpath/$soname` $verstring'
          _LT_AC_TAGVAR(module_cmds, $1)='$CC $allow_undefined_flag -o $lib -bundle $libobjs $deplibs$compiler_flags'
          # Don't fix this by using the ld -exported_symbols_list flag, it doesn't exist in older darwin lds
          _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC -qmkshrobj ${wl}-single_module $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags ${wl}-install_name ${wl}$rpath/$soname $verstring~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          _LT_AC_TAGVAR(module_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC $allow_undefined_flag  -o $lib -bundle $libobjs $deplibs$compiler_flags~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          ;;
       *)
         _LT_AC_TAGVAR(ld_shlibs, $1)=no
          ;;
      esac
      fi
        ;;

  dgux*)
    case $cc_basename in
      ec++*)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      ghcx*)
	# Green Hills C++ Compiler
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      *)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
    esac
    ;;
  freebsd[[12]]*)
    # C++ shared libraries reported to be fairly broken before switch to ELF
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  freebsd-elf*)
    _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
    ;;
  freebsd* | kfreebsd*-gnu | dragonfly*)
    # FreeBSD 3 and later use GNU C++ and GNU ld with standard ELF
    # conventions
    _LT_AC_TAGVAR(ld_shlibs, $1)=yes
    ;;
  gnu*)
    ;;
  hpux9*)
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}+b ${wl}$libdir'
    _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
    _LT_AC_TAGVAR(hardcode_direct, $1)=yes
    _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes # Not in the search PATH,
				# but as the default
				# location of the library.

    case $cc_basename in
    CC*)
      # FIXME: insert proper C++ library support
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
      ;;
    aCC*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/$soname~$CC -b ${wl}+b ${wl}$install_libdir -o $output_objdir/$soname $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags~test $output_objdir/$soname = $lib || mv $output_objdir/$soname $lib'
      # Commands to make compiler produce verbose output that lists
      # what "hidden" libraries, object files and flags are used when
      # linking a shared library.
      #
      # There doesn't appear to be a way to prevent this compiler from
      # explicitly linking system object files so we need to strip them
      # from the output so that they don't get included in the library
      # dependencies.
      output_verbose_link_cmd='templist=`($CC -b $CFLAGS -v conftest.$objext 2>&1) | grep "[[-]]L"`; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'
      ;;
    *)
      if test "$GXX" = yes; then
        _LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/$soname~$CC -shared -nostdlib -fPIC ${wl}+b ${wl}$install_libdir -o $output_objdir/$soname $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags~test $output_objdir/$soname = $lib || mv $output_objdir/$soname $lib'
      else
        # FIXME: insert proper C++ library support
        _LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;
    esac
    ;;
  hpux10*|hpux11*)
    if test $with_gnu_ld = no; then
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}+b ${wl}$libdir'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

      case $host_cpu in
      hppa*64*|ia64*)
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)='+b $libdir'
        ;;
      *)
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
        ;;
      esac
    fi
    case $host_cpu in
    hppa*64*|ia64*)
      _LT_AC_TAGVAR(hardcode_direct, $1)=no
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;
    *)
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes # Not in the search PATH,
					      # but as the default
					      # location of the library.
      ;;
    esac

    case $cc_basename in
      CC*)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      aCC*)
	case $host_cpu in
	hppa*64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	  ;;
	ia64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname ${wl}+nodefaultrpath -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	  ;;
	*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname ${wl}+b ${wl}$install_libdir -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	  ;;
	esac
	# Commands to make compiler produce verbose output that lists
	# what "hidden" libraries, object files and flags are used when
	# linking a shared library.
	#
	# There doesn't appear to be a way to prevent this compiler from
	# explicitly linking system object files so we need to strip them
	# from the output so that they don't get included in the library
	# dependencies.
	output_verbose_link_cmd='templist=`($CC -b $CFLAGS -v conftest.$objext 2>&1) | grep "\-L"`; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'
	;;
      *)
	if test "$GXX" = yes; then
	  if test $with_gnu_ld = no; then
	    case $host_cpu in
	    hppa*64*)
	      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib -fPIC ${wl}+h ${wl}$soname -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	      ;;
	    ia64*)
	      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib -fPIC ${wl}+h ${wl}$soname ${wl}+nodefaultrpath -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	      ;;
	    *)
	      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib -fPIC ${wl}+h ${wl}$soname ${wl}+b ${wl}$install_libdir -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	      ;;
	    esac
	  fi
	else
	  # FIXME: insert proper C++ library support
	  _LT_AC_TAGVAR(ld_shlibs, $1)=no
	fi
	;;
    esac
    ;;
  interix3*)
    _LT_AC_TAGVAR(hardcode_direct, $1)=no
    _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
    # Hack: On Interix 3.x, we cannot compile PIC because of a broken gcc.
    # Instead, shared libraries are loaded at an image base (0x10000000 by
    # default) and relocated if they conflict, which is a slow very memory
    # consuming and fragmenting process.  To avoid this, we pick a random,
    # 256 KiB-aligned image base between 0x50000000 and 0x6FFC0000 at link
    # time.  Moving up from 0x10000000 also allows more sbrk(2) space.
    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag $libobjs $deplibs $compiler_flags ${wl}-h,$soname ${wl}--image-base,`expr ${RANDOM-$$} % 4096 / 2 \* 262144 + 1342177280` -o $lib'
    _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed "s,^,_," $export_symbols >$output_objdir/$soname.expsym~$CC -shared $pic_flag $libobjs $deplibs $compiler_flags ${wl}-h,$soname ${wl}--retain-symbols-file,$output_objdir/$soname.expsym ${wl}--image-base,`expr ${RANDOM-$$} % 4096 / 2 \* 262144 + 1342177280` -o $lib'
    ;;
  irix5* | irix6*)
    case $cc_basename in
      CC*)
	# SGI C++
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -all -multigot $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'

	# Archives containing C++ object files must be created using
	# "CC -ar", where "CC" is the IRIX C++ compiler.  This is
	# necessary to make sure instantiated templates are included
	# in the archive.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC -ar -WR,-u -o $oldlib $oldobjs'
	;;
      *)
	if test "$GXX" = yes; then
	  if test "$with_gnu_ld" = no; then
	    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'
	  else
	    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` -o $lib'
	  fi
	fi
	_LT_AC_TAGVAR(link_all_deplibs, $1)=yes
	;;
    esac
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
    _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
    ;;
  linux*)
    case $cc_basename in
      KCC*)
	# Kuck and Associates, Inc. (KAI) C++ Compiler

	# KCC will only create a shared library if the output file
	# ends with ".so" (or ".sl" for HP-UX), so rename the library
	# to its proper name (with version) after linking.
	_LT_AC_TAGVAR(archive_cmds, $1)='tempext=`echo $shared_ext | $SED -e '\''s/\([[^()0-9A-Za-z{}]]\)/\\\\\1/g'\''`; templib=`echo $lib | $SED -e "s/\${tempext}\..*/.so/"`; $CC $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags --soname $soname -o \$templib; mv \$templib $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='tempext=`echo $shared_ext | $SED -e '\''s/\([[^()0-9A-Za-z{}]]\)/\\\\\1/g'\''`; templib=`echo $lib | $SED -e "s/\${tempext}\..*/.so/"`; $CC $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags --soname $soname -o \$templib ${wl}-retain-symbols-file,$export_symbols; mv \$templib $lib'
	# Commands to make compiler produce verbose output that lists
	# what "hidden" libraries, object files and flags are used when
	# linking a shared library.
	#
	# There doesn't appear to be a way to prevent this compiler from
	# explicitly linking system object files so we need to strip them
	# from the output so that they don't get included in the library
	# dependencies.
	output_verbose_link_cmd='templist=`$CC $CFLAGS -v conftest.$objext -o libconftest$shared_ext 2>&1 | grep "ld"`; rm -f libconftest$shared_ext; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}--rpath,$libdir'
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}--export-dynamic'

	# Archives containing C++ object files must be created using
	# "CC -Bstatic", where "CC" is the KAI C++ compiler.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC -Bstatic -o $oldlib $oldobjs'
	;;
      icpc*)
	# Intel C++
	with_gnu_ld=yes
	# version 8.0 and above of icpc choke on multiply defined symbols
	# if we add $predep_objects and $postdep_objects, however 7.1 and
	# earlier do not add the objects themselves.
	case `$CC -V 2>&1` in
	*"Version 7."*)
  	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname -o $lib'
  	  _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'
	  ;;
	*)  # Version 8.0 or newer
	  tmp_idyn=
	  case $host_cpu in
	    ia64*) tmp_idyn=' -i_dynamic';;
	  esac
  	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared'"$tmp_idyn"' $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
	  _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared'"$tmp_idyn"' $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'
	  ;;
	esac
	_LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}--export-dynamic'
	_LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}--whole-archive$convenience ${wl}--no-whole-archive'
	;;
      pgCC*)
        # Portland Group C++ compiler
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname ${wl}$soname -o $lib'
  	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $pic_flag $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname ${wl}$soname ${wl}-retain-symbols-file ${wl}$export_symbols -o $lib'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}--rpath ${wl}$libdir'
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}--export-dynamic'
	_LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}--whole-archive`for conv in $convenience\"\"; do test  -n \"$conv\" && new_convenience=\"$new_convenience,$conv\"; done; $echo \"$new_convenience\"` ${wl}--no-whole-archive'
        ;;
      cxx*)
	# Compaq C++
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $wl$soname  -o $lib ${wl}-retain-symbols-file $wl$export_symbols'

	runpath_var=LD_RUN_PATH
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-rpath $libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	# Commands to make compiler produce verbose output that lists
	# what "hidden" libraries, object files and flags are used when
	# linking a shared library.
	#
	# There doesn't appear to be a way to prevent this compiler from
	# explicitly linking system object files so we need to strip them
	# from the output so that they don't get included in the library
	# dependencies.
	output_verbose_link_cmd='templist=`$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "ld"`; templist=`echo $templist | $SED "s/\(^.*ld.*\)\( .*ld .*$\)/\1/"`; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'
	;;
    esac
    ;;
  lynxos*)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  m88k*)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  mvs*)
    case $cc_basename in
      cxx*)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      *)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
    esac
    ;;
  netbsd*)
    if echo __ELF__ | $CC -E - | grep __ELF__ >/dev/null; then
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable  -o $lib $predep_objects $libobjs $deplibs $postdep_objects $linker_flags'
      wlarc=
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
    fi
    # Workaround some broken pre-1.5 toolchains
    output_verbose_link_cmd='$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep conftest.$objext | $SED -e "s:-lgcc -lc -lgcc::"'
    ;;
  openbsd2*)
    # C++ shared libraries are fairly broken
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  openbsd*)
    _LT_AC_TAGVAR(hardcode_direct, $1)=yes
    _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -o $lib'
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
    if test -z "`echo __ELF__ | $CC -E - | grep __ELF__`" || test "$host_os-$host_cpu" = "openbsd2.8-powerpc"; then
      _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $pic_flag $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-retain-symbols-file,$export_symbols -o $lib'
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)="$wlarc"'--whole-archive$convenience '"$wlarc"'--no-whole-archive'
    fi
    output_verbose_link_cmd='echo'
    ;;
  osf3*)
    case $cc_basename in
      KCC*)
	# Kuck and Associates, Inc. (KAI) C++ Compiler

	# KCC will only create a shared library if the output file
	# ends with ".so" (or ".sl" for HP-UX), so rename the library
	# to its proper name (with version) after linking.
	_LT_AC_TAGVAR(archive_cmds, $1)='tempext=`echo $shared_ext | $SED -e '\''s/\([[^()0-9A-Za-z{}]]\)/\\\\\1/g'\''`; templib=`echo $lib | $SED -e "s/\${tempext}\..*/.so/"`; $CC $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags --soname $soname -o \$templib; mv \$templib $lib'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	# Archives containing C++ object files must be created using
	# "CC -Bstatic", where "CC" is the KAI C++ compiler.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC -Bstatic -o $oldlib $oldobjs'

	;;
      RCC*)
	# Rational C++ 2.4.1
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      cxx*)
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-expect_unresolved ${wl}\*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared${allow_undefined_flag} $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname $soname `test -n "$verstring" && echo ${wl}-set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	# Commands to make compiler produce verbose output that lists
	# what "hidden" libraries, object files and flags are used when
	# linking a shared library.
	#
	# There doesn't appear to be a way to prevent this compiler from
	# explicitly linking system object files so we need to strip them
	# from the output so that they don't get included in the library
	# dependencies.
	output_verbose_link_cmd='templist=`$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "ld" | grep -v "ld:"`; templist=`echo $templist | $SED "s/\(^.*ld.*\)\( .*ld.*$\)/\1/"`; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'
	;;
      *)
	if test "$GXX" = yes && test "$with_gnu_ld" = no; then
	  _LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-expect_unresolved ${wl}\*'
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib ${allow_undefined_flag} $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'

	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
	  _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	  # Commands to make compiler produce verbose output that lists
	  # what "hidden" libraries, object files and flags are used when
	  # linking a shared library.
	  output_verbose_link_cmd='$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "\-L"'

	else
	  # FIXME: insert proper C++ library support
	  _LT_AC_TAGVAR(ld_shlibs, $1)=no
	fi
	;;
    esac
    ;;
  osf4* | osf5*)
    case $cc_basename in
      KCC*)
	# Kuck and Associates, Inc. (KAI) C++ Compiler

	# KCC will only create a shared library if the output file
	# ends with ".so" (or ".sl" for HP-UX), so rename the library
	# to its proper name (with version) after linking.
	_LT_AC_TAGVAR(archive_cmds, $1)='tempext=`echo $shared_ext | $SED -e '\''s/\([[^()0-9A-Za-z{}]]\)/\\\\\1/g'\''`; templib=`echo $lib | $SED -e "s/\${tempext}\..*/.so/"`; $CC $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags --soname $soname -o \$templib; mv \$templib $lib'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	# Archives containing C++ object files must be created using
	# the KAI C++ compiler.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC -o $oldlib $oldobjs'
	;;
      RCC*)
	# Rational C++ 2.4.1
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      cxx*)
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' -expect_unresolved \*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared${allow_undefined_flag} $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -msym -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='for i in `cat $export_symbols`; do printf "%s %s\\n" -exported_symbol "\$i" >> $lib.exp; done~
	  echo "-hidden">> $lib.exp~
	  $CC -shared$allow_undefined_flag $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags -msym -soname $soname -Wl,-input -Wl,$lib.exp  `test -n "$verstring" && echo -set_version	$verstring` -update_registry ${output_objdir}/so_locations -o $lib~
	  $rm $lib.exp'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-rpath $libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	# Commands to make compiler produce verbose output that lists
	# what "hidden" libraries, object files and flags are used when
	# linking a shared library.
	#
	# There doesn't appear to be a way to prevent this compiler from
	# explicitly linking system object files so we need to strip them
	# from the output so that they don't get included in the library
	# dependencies.
	output_verbose_link_cmd='templist=`$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "ld" | grep -v "ld:"`; templist=`echo $templist | $SED "s/\(^.*ld.*\)\( .*ld.*$\)/\1/"`; list=""; for z in $templist; do case $z in conftest.$objext) list="$list $z";; *.$objext);; *) list="$list $z";;esac; done; echo $list'
	;;
      *)
	if test "$GXX" = yes && test "$with_gnu_ld" = no; then
	  _LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-expect_unresolved ${wl}\*'
	 _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib ${allow_undefined_flag} $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-msym ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'

	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
	  _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	  # Commands to make compiler produce verbose output that lists
	  # what "hidden" libraries, object files and flags are used when
	  # linking a shared library.
	  output_verbose_link_cmd='$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep "\-L"'

	else
	  # FIXME: insert proper C++ library support
	  _LT_AC_TAGVAR(ld_shlibs, $1)=no
	fi
	;;
    esac
    ;;
  psos*)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  sunos4*)
    case $cc_basename in
      CC*)
	# Sun C++ 4.x
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      lcc*)
	# Lucid
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      *)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
    esac
    ;;
  solaris*)
    case $cc_basename in
      CC*)
	# Sun C++ 4.2, 5.x and Centerline C++
        _LT_AC_TAGVAR(archive_cmds_need_lc,$1)=yes
	_LT_AC_TAGVAR(no_undefined_flag, $1)=' -zdefs'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G${allow_undefined_flag}  -h$soname -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $lib.exp~cat $export_symbols | $SED -e "s/\(.*\)/\1;/" >> $lib.exp~$echo "local: *; };" >> $lib.exp~
	$CC -G${allow_undefined_flag}  ${wl}-M ${wl}$lib.exp -h$soname -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags~$rm $lib.exp'

	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
	_LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
	case $host_os in
	  solaris2.[[0-5]] | solaris2.[[0-5]].*) ;;
	  *)
	    # The C++ compiler is used as linker so we must use $wl
	    # flag to pass the commands to the underlying system
	    # linker. We must also pass each convience library through
	    # to the system linker between allextract/defaultextract.
	    # The C++ compiler will combine linker options so we
	    # cannot just pass the convience library names through
	    # without $wl.
	    # Supported since Solaris 2.6 (maybe 2.5.1?)
	    _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}-z ${wl}allextract`for conv in $convenience\"\"; do test -n \"$conv\" && new_convenience=\"$new_convenience,$conv\"; done; $echo \"$new_convenience\"` ${wl}-z ${wl}defaultextract'
	    ;;
	esac
	_LT_AC_TAGVAR(link_all_deplibs, $1)=yes

	output_verbose_link_cmd='echo'

	# Archives containing C++ object files must be created using
	# "CC -xar", where "CC" is the Sun C++ compiler.  This is
	# necessary to make sure instantiated templates are included
	# in the archive.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC -xar -o $oldlib $oldobjs'
	;;
      gcx*)
	# Green Hills C++ Compiler
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-h $wl$soname -o $lib'

	# The C++ compiler must be used to create the archive.
	_LT_AC_TAGVAR(old_archive_cmds, $1)='$CC $LDFLAGS -archive -o $oldlib $oldobjs'
	;;
      *)
	# GNU C++ compiler with Solaris linker
	if test "$GXX" = yes && test "$with_gnu_ld" = no; then
	  _LT_AC_TAGVAR(no_undefined_flag, $1)=' ${wl}-z ${wl}defs'
	  if $CC --version | grep -v '^2\.7' > /dev/null; then
	    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -nostdlib $LDFLAGS $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-h $wl$soname -o $lib'
	    _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $lib.exp~cat $export_symbols | $SED -e "s/\(.*\)/\1;/" >> $lib.exp~$echo "local: *; };" >> $lib.exp~
		$CC -shared -nostdlib ${wl}-M $wl$lib.exp -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags~$rm $lib.exp'

	    # Commands to make compiler produce verbose output that lists
	    # what "hidden" libraries, object files and flags are used when
	    # linking a shared library.
	    output_verbose_link_cmd="$CC -shared $CFLAGS -v conftest.$objext 2>&1 | grep \"\-L\""
	  else
	    # g++ 2.7 appears to require `-G' NOT `-shared' on this
	    # platform.
	    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -G -nostdlib $LDFLAGS $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags ${wl}-h $wl$soname -o $lib'
	    _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $lib.exp~cat $export_symbols | $SED -e "s/\(.*\)/\1;/" >> $lib.exp~$echo "local: *; };" >> $lib.exp~
		$CC -G -nostdlib ${wl}-M $wl$lib.exp -o $lib $predep_objects $libobjs $deplibs $postdep_objects $compiler_flags~$rm $lib.exp'

	    # Commands to make compiler produce verbose output that lists
	    # what "hidden" libraries, object files and flags are used when
	    # linking a shared library.
	    output_verbose_link_cmd="$CC -G $CFLAGS -v conftest.$objext 2>&1 | grep \"\-L\""
	  fi

	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-R $wl$libdir'
	fi
	;;
    esac
    ;;
  sysv4*uw2* | sysv5OpenUNIX* | sysv5UnixWare7.[[01]].[[10]]* | unixware7* | sco3.2v5.0.[[024]]*)
    _LT_AC_TAGVAR(no_undefined_flag, $1)='${wl}-z,text'
    _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
    _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
    runpath_var='LD_RUN_PATH'

    case $cc_basename in
      CC*)
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -G ${wl}-Bexport:$export_symbols ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	;;
      *)
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared ${wl}-Bexport:$export_symbols ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	;;
    esac
    ;;
  sysv5* | sco3.2v5* | sco5v6*)
    # Note: We can NOT use -z defs as we might desire, because we do not
    # link with -lc, and that would cause any symbols used from libc to
    # always be unresolved, which means just about no library would
    # ever link correctly.  If we're not using GNU ld we use -z text
    # though, which does catch some bad symbols but isn't as heavy-handed
    # as -z defs.
    # For security reasons, it is highly recommended that you always
    # use absolute paths for naming shared libraries, and exclude the
    # DT_RUNPATH tag from executables and libraries.  But doing so
    # requires that you compile everything twice, which is a pain.
    # So that behaviour is only enabled if SCOABSPATH is set to a
    # non-empty value in the environment.  Most likely only useful for
    # creating official distributions of packages.
    # This is a hack until libtool officially supports absolute path
    # names for shared libraries.
    _LT_AC_TAGVAR(no_undefined_flag, $1)='${wl}-z,text'
    _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-z,nodefs'
    _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
    _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='`test -z "$SCOABSPATH" && echo ${wl}-R,$libdir`'
    _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=':'
    _LT_AC_TAGVAR(link_all_deplibs, $1)=yes
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-Bexport'
    runpath_var='LD_RUN_PATH'

    case $cc_basename in
      CC*)
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -G ${wl}-Bexport:$export_symbols ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	;;
      *)
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared ${wl}-Bexport:$export_symbols ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	;;
    esac
    ;;
  tandem*)
    case $cc_basename in
      NCC*)
	# NonStop-UX NCC 3.20
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
      *)
	# FIXME: insert proper C++ library support
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	;;
    esac
    ;;
  vxworks*)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
  *)
    # FIXME: insert proper C++ library support
    _LT_AC_TAGVAR(ld_shlibs, $1)=no
    ;;
esac
AC_MSG_RESULT([$_LT_AC_TAGVAR(ld_shlibs, $1)])
test "$_LT_AC_TAGVAR(ld_shlibs, $1)" = no && can_build_shared=no

_LT_AC_TAGVAR(GCC, $1)="$GXX"
_LT_AC_TAGVAR(LD, $1)="$LD"

AC_LIBTOOL_POSTDEP_PREDEP($1)
AC_LIBTOOL_PROG_COMPILER_PIC($1)
AC_LIBTOOL_PROG_CC_C_O($1)
AC_LIBTOOL_SYS_HARD_LINK_LOCKS($1)
AC_LIBTOOL_PROG_LD_SHLIBS($1)
AC_LIBTOOL_SYS_DYNAMIC_LINKER($1)
AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH($1)

AC_LIBTOOL_CONFIG($1)

AC_LANG_POP
CC=$lt_save_CC
LDCXX=$LD
LD=$lt_save_LD
GCC=$lt_save_GCC
with_gnu_ldcxx=$with_gnu_ld
with_gnu_ld=$lt_save_with_gnu_ld
lt_cv_path_LDCXX=$lt_cv_path_LD
lt_cv_path_LD=$lt_save_path_LD
lt_cv_prog_gnu_ldcxx=$lt_cv_prog_gnu_ld
lt_cv_prog_gnu_ld=$lt_save_with_gnu_ld
])# AC_LIBTOOL_LANG_CXX_CONFIG

# AC_LIBTOOL_POSTDEP_PREDEP([TAGNAME])
# ------------------------------------
# Figure out "hidden" library dependencies from verbose
# compiler output when linking a shared library.
# Parse the compiler output and extract the necessary
# objects, libraries and library flags.
AC_DEFUN([AC_LIBTOOL_POSTDEP_PREDEP],[
dnl we can't use the lt_simple_compile_test_code here,
dnl because it contains code intended for an executable,
dnl not a library.  It's possible we should let each
dnl tag define a new lt_????_link_test_code variable,
dnl but it's only used here...
ifelse([$1],[],[cat > conftest.$ac_ext <<EOF
int a;
void foo (void) { a = 0; }
EOF
],[$1],[CXX],[cat > conftest.$ac_ext <<EOF
class Foo
{
public:
  Foo (void) { a = 0; }
private:
  int a;
};
EOF
],[$1],[F77],[cat > conftest.$ac_ext <<EOF
      subroutine foo
      implicit none
      integer*4 a
      a=0
      return
      end
EOF
],[$1],[GCJ],[cat > conftest.$ac_ext <<EOF
public class foo {
  private int a;
  public void bar (void) {
    a = 0;
  }
};
EOF
])
dnl Parse the compiler output and extract the necessary
dnl objects, libraries and library flags.
if AC_TRY_EVAL(ac_compile); then
  # Parse the compiler output and extract the necessary
  # objects, libraries and library flags.

  # Sentinel used to keep track of whether or not we are before
  # the conftest object file.
  pre_test_object_deps_done=no

  # The `*' in the case matches for architectures that use `case' in
  # $output_verbose_cmd can trigger glob expansion during the loop
  # eval without this substitution.
  output_verbose_link_cmd=`$echo "X$output_verbose_link_cmd" | $Xsed -e "$no_glob_subst"`

  for p in `eval $output_verbose_link_cmd`; do
    case $p in

    -L* | -R* | -l*)
       # Some compilers place space between "-{L,R}" and the path.
       # Remove the space.
       if test $p = "-L" \
	  || test $p = "-R"; then
	 prev=$p
	 continue
       else
	 prev=
       fi

       if test "$pre_test_object_deps_done" = no; then
	 case $p in
	 -L* | -R*)
	   # Internal compiler library paths should come after those
	   # provided the user.  The postdeps already come after the
	   # user supplied libs so there is no need to process them.
	   if test -z "$_LT_AC_TAGVAR(compiler_lib_search_path, $1)"; then
	     _LT_AC_TAGVAR(compiler_lib_search_path, $1)="${prev}${p}"
	   else
	     _LT_AC_TAGVAR(compiler_lib_search_path, $1)="${_LT_AC_TAGVAR(compiler_lib_search_path, $1)} ${prev}${p}"
	   fi
	   ;;
	 # The "-l" case would never come before the object being
	 # linked, so don't bother handling this case.
	 esac
       else
	 if test -z "$_LT_AC_TAGVAR(postdeps, $1)"; then
	   _LT_AC_TAGVAR(postdeps, $1)="${prev}${p}"
	 else
	   _LT_AC_TAGVAR(postdeps, $1)="${_LT_AC_TAGVAR(postdeps, $1)} ${prev}${p}"
	 fi
       fi
       ;;

    *.$objext)
       # This assumes that the test object file only shows up
       # once in the compiler output.
       if test "$p" = "conftest.$objext"; then
	 pre_test_object_deps_done=yes
	 continue
       fi

       if test "$pre_test_object_deps_done" = no; then
	 if test -z "$_LT_AC_TAGVAR(predep_objects, $1)"; then
	   _LT_AC_TAGVAR(predep_objects, $1)="$p"
	 else
	   _LT_AC_TAGVAR(predep_objects, $1)="$_LT_AC_TAGVAR(predep_objects, $1) $p"
	 fi
       else
	 if test -z "$_LT_AC_TAGVAR(postdep_objects, $1)"; then
	   _LT_AC_TAGVAR(postdep_objects, $1)="$p"
	 else
	   _LT_AC_TAGVAR(postdep_objects, $1)="$_LT_AC_TAGVAR(postdep_objects, $1) $p"
	 fi
       fi
       ;;

    *) ;; # Ignore the rest.

    esac
  done

  # Clean up.
  rm -f a.out a.exe
else
  echo "libtool.m4: error: problem compiling $1 test program"
fi

$rm -f confest.$objext

# PORTME: override above test on systems where it is broken
ifelse([$1],[CXX],
[case $host_os in
interix3*)
  # Interix 3.5 installs completely hosed .la files for C++, so rather than
  # hack all around it, let's just trust "g++" to DTRT.
  _LT_AC_TAGVAR(predep_objects,$1)=
  _LT_AC_TAGVAR(postdep_objects,$1)=
  _LT_AC_TAGVAR(postdeps,$1)=
  ;;

solaris*)
  case $cc_basename in
  CC*)
    # Adding this requires a known-good setup of shared libraries for
    # Sun compiler versions before 5.6, else PIC objects from an old
    # archive will be linked into the output, leading to subtle bugs.
    _LT_AC_TAGVAR(postdeps,$1)='-lCstd -lCrun'
    ;;
  esac
  ;;
esac
])

case " $_LT_AC_TAGVAR(postdeps, $1) " in
*" -lc "*) _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no ;;
esac
])# AC_LIBTOOL_POSTDEP_PREDEP

# AC_LIBTOOL_LANG_F77_CONFIG
# --------------------------
# Ensure that the configuration vars for the C compiler are
# suitably defined.  Those variables are subsequently used by
# AC_LIBTOOL_CONFIG to write the compiler configuration to `libtool'.
AC_DEFUN([AC_LIBTOOL_LANG_F77_CONFIG], [_LT_AC_LANG_F77_CONFIG(F77)])
AC_DEFUN([_LT_AC_LANG_F77_CONFIG],
[AC_REQUIRE([AC_PROG_F77])
AC_LANG_PUSH(Fortran 77)

_LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
_LT_AC_TAGVAR(allow_undefined_flag, $1)=
_LT_AC_TAGVAR(always_export_symbols, $1)=no
_LT_AC_TAGVAR(archive_expsym_cmds, $1)=
_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)=
_LT_AC_TAGVAR(hardcode_direct, $1)=no
_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)=
_LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)=
_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=
_LT_AC_TAGVAR(hardcode_minus_L, $1)=no
_LT_AC_TAGVAR(hardcode_automatic, $1)=no
_LT_AC_TAGVAR(module_cmds, $1)=
_LT_AC_TAGVAR(module_expsym_cmds, $1)=
_LT_AC_TAGVAR(link_all_deplibs, $1)=unknown
_LT_AC_TAGVAR(old_archive_cmds, $1)=$old_archive_cmds
_LT_AC_TAGVAR(no_undefined_flag, $1)=
_LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
_LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=no

# Source file extension for f77 test sources.
ac_ext=f

# Object file extension for compiled f77 test sources.
objext=o
_LT_AC_TAGVAR(objext, $1)=$objext

# Code to be used in simple compile tests
lt_simple_compile_test_code="      subroutine t\n      return\n      end\n"

# Code to be used in simple link tests
lt_simple_link_test_code="      program t\n      end\n"

# ltmain only uses $CC for tagged configurations so make sure $CC is set.
_LT_AC_SYS_COMPILER

# save warnings/boilerplate of simple test code
_LT_COMPILER_BOILERPLATE
_LT_LINKER_BOILERPLATE

# Allow CC to be a program name with arguments.
lt_save_CC="$CC"
CC=${F77-"f77"}
compiler=$CC
_LT_AC_TAGVAR(compiler, $1)=$CC
_LT_CC_BASENAME([$compiler])

AC_MSG_CHECKING([if libtool supports shared libraries])
AC_MSG_RESULT([$can_build_shared])

AC_MSG_CHECKING([whether to build shared libraries])
test "$can_build_shared" = "no" && enable_shared=no

# On AIX, shared libraries and static libraries use the same namespace, and
# are all built from PIC.
case $host_os in
aix3*)
  test "$enable_shared" = yes && enable_static=no
  if test -n "$RANLIB"; then
    archive_cmds="$archive_cmds~\$RANLIB \$lib"
    postinstall_cmds='$RANLIB $lib'
  fi
  ;;
aix4* | aix5*)
  if test "$host_cpu" != ia64 && test "$aix_use_runtimelinking" = no ; then
    test "$enable_shared" = yes && enable_static=no
  fi
  ;;
esac
AC_MSG_RESULT([$enable_shared])

AC_MSG_CHECKING([whether to build static libraries])
# Make sure either enable_shared or enable_static is yes.
test "$enable_shared" = yes || enable_static=yes
AC_MSG_RESULT([$enable_static])

_LT_AC_TAGVAR(GCC, $1)="$G77"
_LT_AC_TAGVAR(LD, $1)="$LD"

AC_LIBTOOL_PROG_COMPILER_PIC($1)
AC_LIBTOOL_PROG_CC_C_O($1)
AC_LIBTOOL_SYS_HARD_LINK_LOCKS($1)
AC_LIBTOOL_PROG_LD_SHLIBS($1)
AC_LIBTOOL_SYS_DYNAMIC_LINKER($1)
AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH($1)

AC_LIBTOOL_CONFIG($1)

AC_LANG_POP
CC="$lt_save_CC"
])# AC_LIBTOOL_LANG_F77_CONFIG


# AC_LIBTOOL_LANG_GCJ_CONFIG
# --------------------------
# Ensure that the configuration vars for the C compiler are
# suitably defined.  Those variables are subsequently used by
# AC_LIBTOOL_CONFIG to write the compiler configuration to `libtool'.
AC_DEFUN([AC_LIBTOOL_LANG_GCJ_CONFIG], [_LT_AC_LANG_GCJ_CONFIG(GCJ)])
AC_DEFUN([_LT_AC_LANG_GCJ_CONFIG],
[AC_LANG_SAVE

# Source file extension for Java test sources.
ac_ext=java

# Object file extension for compiled Java test sources.
objext=o
_LT_AC_TAGVAR(objext, $1)=$objext

# Code to be used in simple compile tests
lt_simple_compile_test_code="class foo {}\n"

# Code to be used in simple link tests
lt_simple_link_test_code='public class conftest { public static void main(String[[]] argv) {}; }\n'

# ltmain only uses $CC for tagged configurations so make sure $CC is set.
_LT_AC_SYS_COMPILER

# save warnings/boilerplate of simple test code
_LT_COMPILER_BOILERPLATE
_LT_LINKER_BOILERPLATE

# Allow CC to be a program name with arguments.
lt_save_CC="$CC"
CC=${GCJ-"gcj"}
compiler=$CC
_LT_AC_TAGVAR(compiler, $1)=$CC
_LT_CC_BASENAME([$compiler])

# GCJ did not exist at the time GCC didn't implicitly link libc in.
_LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no

_LT_AC_TAGVAR(old_archive_cmds, $1)=$old_archive_cmds

AC_LIBTOOL_PROG_COMPILER_NO_RTTI($1)
AC_LIBTOOL_PROG_COMPILER_PIC($1)
AC_LIBTOOL_PROG_CC_C_O($1)
AC_LIBTOOL_SYS_HARD_LINK_LOCKS($1)
AC_LIBTOOL_PROG_LD_SHLIBS($1)
AC_LIBTOOL_SYS_DYNAMIC_LINKER($1)
AC_LIBTOOL_PROG_LD_HARDCODE_LIBPATH($1)

AC_LIBTOOL_CONFIG($1)

AC_LANG_RESTORE
CC="$lt_save_CC"
])# AC_LIBTOOL_LANG_GCJ_CONFIG


# AC_LIBTOOL_LANG_RC_CONFIG
# -------------------------
# Ensure that the configuration vars for the Windows resource compiler are
# suitably defined.  Those variables are subsequently used by
# AC_LIBTOOL_CONFIG to write the compiler configuration to `libtool'.
AC_DEFUN([AC_LIBTOOL_LANG_RC_CONFIG], [_LT_AC_LANG_RC_CONFIG(RC)])
AC_DEFUN([_LT_AC_LANG_RC_CONFIG],
[AC_LANG_SAVE

# Source file extension for RC test sources.
ac_ext=rc

# Object file extension for compiled RC test sources.
objext=o
_LT_AC_TAGVAR(objext, $1)=$objext

# Code to be used in simple compile tests
lt_simple_compile_test_code='sample MENU { MENUITEM "&Soup", 100, CHECKED }\n'

# Code to be used in simple link tests
lt_simple_link_test_code="$lt_simple_compile_test_code"

# ltmain only uses $CC for tagged configurations so make sure $CC is set.
_LT_AC_SYS_COMPILER

# save warnings/boilerplate of simple test code
_LT_COMPILER_BOILERPLATE
_LT_LINKER_BOILERPLATE

# Allow CC to be a program name with arguments.
lt_save_CC="$CC"
CC=${RC-"windres"}
compiler=$CC
_LT_AC_TAGVAR(compiler, $1)=$CC
_LT_CC_BASENAME([$compiler])
_LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)=yes

AC_LIBTOOL_CONFIG($1)

AC_LANG_RESTORE
CC="$lt_save_CC"
])# AC_LIBTOOL_LANG_RC_CONFIG


# AC_LIBTOOL_CONFIG([TAGNAME])
# ----------------------------
# If TAGNAME is not passed, then create an initial libtool script
# with a default configuration from the untagged config vars.  Otherwise
# add code to config.status for appending the configuration named by
# TAGNAME from the matching tagged config vars.
AC_DEFUN([AC_LIBTOOL_CONFIG],
[# The else clause should only fire when bootstrapping the
# libtool distribution, otherwise you forgot to ship ltmain.sh
# with your package, and you will get complaints that there are
# no rules to generate ltmain.sh.
if test -f "$ltmain"; then
  # See if we are running on zsh, and set the options which allow our commands through
  # without removal of \ escapes.
  if test -n "${ZSH_VERSION+set}" ; then
    setopt NO_GLOB_SUBST
  fi
  # Now quote all the things that may contain metacharacters while being
  # careful not to overquote the AC_SUBSTed values.  We take copies of the
  # variables and quote the copies for generation of the libtool script.
  for var in echo old_CC old_CFLAGS AR AR_FLAGS EGREP RANLIB LN_S LTCC LTCFLAGS NM \
    SED SHELL STRIP \
    libname_spec library_names_spec soname_spec extract_expsyms_cmds \
    old_striplib striplib file_magic_cmd finish_cmds finish_eval \
    deplibs_check_method reload_flag reload_cmds need_locks \
    lt_cv_sys_global_symbol_pipe lt_cv_sys_global_symbol_to_cdecl \
    lt_cv_sys_global_symbol_to_c_name_address \
    sys_lib_search_path_spec sys_lib_dlsearch_path_spec \
    old_postinstall_cmds old_postuninstall_cmds \
    _LT_AC_TAGVAR(compiler, $1) \
    _LT_AC_TAGVAR(CC, $1) \
    _LT_AC_TAGVAR(LD, $1) \
    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1) \
    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1) \
    _LT_AC_TAGVAR(lt_prog_compiler_static, $1) \
    _LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1) \
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1) \
    _LT_AC_TAGVAR(thread_safe_flag_spec, $1) \
    _LT_AC_TAGVAR(whole_archive_flag_spec, $1) \
    _LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1) \
    _LT_AC_TAGVAR(old_archive_cmds, $1) \
    _LT_AC_TAGVAR(old_archive_from_new_cmds, $1) \
    _LT_AC_TAGVAR(predep_objects, $1) \
    _LT_AC_TAGVAR(postdep_objects, $1) \
    _LT_AC_TAGVAR(predeps, $1) \
    _LT_AC_TAGVAR(postdeps, $1) \
    _LT_AC_TAGVAR(compiler_lib_search_path, $1) \
    _LT_AC_TAGVAR(archive_cmds, $1) \
    _LT_AC_TAGVAR(archive_expsym_cmds, $1) \
    _LT_AC_TAGVAR(postinstall_cmds, $1) \
    _LT_AC_TAGVAR(postuninstall_cmds, $1) \
    _LT_AC_TAGVAR(old_archive_from_expsyms_cmds, $1) \
    _LT_AC_TAGVAR(allow_undefined_flag, $1) \
    _LT_AC_TAGVAR(no_undefined_flag, $1) \
    _LT_AC_TAGVAR(export_symbols_cmds, $1) \
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1) \
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1) \
    _LT_AC_TAGVAR(hardcode_libdir_separator, $1) \
    _LT_AC_TAGVAR(hardcode_automatic, $1) \
    _LT_AC_TAGVAR(module_cmds, $1) \
    _LT_AC_TAGVAR(module_expsym_cmds, $1) \
    _LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1) \
    _LT_AC_TAGVAR(exclude_expsyms, $1) \
    _LT_AC_TAGVAR(include_expsyms, $1); do

    case $var in
    _LT_AC_TAGVAR(old_archive_cmds, $1) | \
    _LT_AC_TAGVAR(old_archive_from_new_cmds, $1) | \
    _LT_AC_TAGVAR(archive_cmds, $1) | \
    _LT_AC_TAGVAR(archive_expsym_cmds, $1) | \
    _LT_AC_TAGVAR(module_cmds, $1) | \
    _LT_AC_TAGVAR(module_expsym_cmds, $1) | \
    _LT_AC_TAGVAR(old_archive_from_expsyms_cmds, $1) | \
    _LT_AC_TAGVAR(export_symbols_cmds, $1) | \
    extract_expsyms_cmds | reload_cmds | finish_cmds | \
    postinstall_cmds | postuninstall_cmds | \
    old_postinstall_cmds | old_postuninstall_cmds | \
    sys_lib_search_path_spec | sys_lib_dlsearch_path_spec)
      # Double-quote double-evaled strings.
      eval "lt_$var=\\\"\`\$echo \"X\$$var\" | \$Xsed -e \"\$double_quote_subst\" -e \"\$sed_quote_subst\" -e \"\$delay_variable_subst\"\`\\\""
      ;;
    *)
      eval "lt_$var=\\\"\`\$echo \"X\$$var\" | \$Xsed -e \"\$sed_quote_subst\"\`\\\""
      ;;
    esac
  done

  case $lt_echo in
  *'\[$]0 --fallback-echo"')
    lt_echo=`$echo "X$lt_echo" | $Xsed -e 's/\\\\\\\[$]0 --fallback-echo"[$]/[$]0 --fallback-echo"/'`
    ;;
  esac

ifelse([$1], [],
  [cfgfile="${ofile}T"
  trap "$rm \"$cfgfile\"; exit 1" 1 2 15
  $rm -f "$cfgfile"
  AC_MSG_NOTICE([creating $ofile])],
  [cfgfile="$ofile"])

  cat <<__EOF__ >> "$cfgfile"
ifelse([$1], [],
[#! $SHELL

# `$echo "$cfgfile" | sed 's%^.*/%%'` - Provide generalized library-building support services.
# Generated automatically by $PROGRAM (GNU $PACKAGE $VERSION$TIMESTAMP)
# NOTE: Changes made to this file will be lost: look at ltmain.sh.
#
# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001
# Free Software Foundation, Inc.
#
# This file is part of GNU Libtool:
# Originally by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# A sed program that does not truncate output.
SED=$lt_SED

# Sed that helps us avoid accidentally triggering echo(1) options like -n.
Xsed="$SED -e 1s/^X//"

# The HP-UX ksh and POSIX shell print the target directory to stdout
# if CDPATH is set.
(unset CDPATH) >/dev/null 2>&1 && unset CDPATH

# The names of the tagged configurations supported by this script.
available_tags=

# ### BEGIN LIBTOOL CONFIG],
[# ### BEGIN LIBTOOL TAG CONFIG: $tagname])

# Libtool was configured on host `(hostname || uname -n) 2>/dev/null | sed 1q`:

# Shell to use when invoking shell scripts.
SHELL=$lt_SHELL

# Whether or not to build shared libraries.
build_libtool_libs=$enable_shared

# Whether or not to build static libraries.
build_old_libs=$enable_static

# Whether or not to add -lc for building shared libraries.
build_libtool_need_lc=$_LT_AC_TAGVAR(archive_cmds_need_lc, $1)

# Whether or not to disallow shared libs when runtime libs are static
allow_libtool_libs_with_static_runtimes=$_LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)

# Whether or not to optimize for fast installation.
fast_install=$enable_fast_install

# The host system.
host_alias=$host_alias
host=$host
host_os=$host_os

# The build system.
build_alias=$build_alias
build=$build
build_os=$build_os

# An echo program that does not interpret backslashes.
echo=$lt_echo

# The archiver.
AR=$lt_AR
AR_FLAGS=$lt_AR_FLAGS

# A C compiler.
LTCC=$lt_LTCC

# LTCC compiler flags.
LTCFLAGS=$lt_LTCFLAGS

# A language-specific compiler.
CC=$lt_[]_LT_AC_TAGVAR(compiler, $1)

# Is the compiler the GNU C compiler?
with_gcc=$_LT_AC_TAGVAR(GCC, $1)

# An ERE matcher.
EGREP=$lt_EGREP

# The linker used to build libraries.
LD=$lt_[]_LT_AC_TAGVAR(LD, $1)

# Whether we need hard or soft links.
LN_S=$lt_LN_S

# A BSD-compatible nm program.
NM=$lt_NM

# A symbol stripping program
STRIP=$lt_STRIP

# Used to examine libraries when file_magic_cmd begins "file"
MAGIC_CMD=$MAGIC_CMD

# Used on cygwin: DLL creation program.
DLLTOOL="$DLLTOOL"

# Used on cygwin: object dumper.
OBJDUMP="$OBJDUMP"

# Used on cygwin: assembler.
AS="$AS"

# The name of the directory that contains temporary libtool files.
objdir=$objdir

# How to create reloadable object files.
reload_flag=$lt_reload_flag
reload_cmds=$lt_reload_cmds

# How to pass a linker flag through the compiler.
wl=$lt_[]_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)

# Object file suffix (normally "o").
objext="$ac_objext"

# Old archive suffix (normally "a").
libext="$libext"

# Shared library suffix (normally ".so").
shrext_cmds='$shrext_cmds'

# Executable file suffix (normally "").
exeext="$exeext"

# Additional compiler flags for building library objects.
pic_flag=$lt_[]_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)
pic_mode=$pic_mode

# What is the maximum length of a command?
max_cmd_len=$lt_cv_sys_max_cmd_len

# Does compiler simultaneously support -c and -o options?
compiler_c_o=$lt_[]_LT_AC_TAGVAR(lt_cv_prog_compiler_c_o, $1)

# Must we lock files when doing compilation?
need_locks=$lt_need_locks

# Do we need the lib prefix for modules?
need_lib_prefix=$need_lib_prefix

# Do we need a version for libraries?
need_version=$need_version

# Whether dlopen is supported.
dlopen_support=$enable_dlopen

# Whether dlopen of programs is supported.
dlopen_self=$enable_dlopen_self

# Whether dlopen of statically linked programs is supported.
dlopen_self_static=$enable_dlopen_self_static

# Compiler flag to prevent dynamic linking.
link_static_flag=$lt_[]_LT_AC_TAGVAR(lt_prog_compiler_static, $1)

# Compiler flag to turn off builtin functions.
no_builtin_flag=$lt_[]_LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)

# Compiler flag to allow reflexive dlopens.
export_dynamic_flag_spec=$lt_[]_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)

# Compiler flag to generate shared objects directly from archives.
whole_archive_flag_spec=$lt_[]_LT_AC_TAGVAR(whole_archive_flag_spec, $1)

# Compiler flag to generate thread-safe objects.
thread_safe_flag_spec=$lt_[]_LT_AC_TAGVAR(thread_safe_flag_spec, $1)

# Library versioning type.
version_type=$version_type

# Format of library name prefix.
libname_spec=$lt_libname_spec

# List of archive names.  First name is the real one, the rest are links.
# The last name is the one that the linker finds with -lNAME.
library_names_spec=$lt_library_names_spec

# The coded name of the library, if different from the real name.
soname_spec=$lt_soname_spec

# Commands used to build and install an old-style archive.
RANLIB=$lt_RANLIB
old_archive_cmds=$lt_[]_LT_AC_TAGVAR(old_archive_cmds, $1)
old_postinstall_cmds=$lt_old_postinstall_cmds
old_postuninstall_cmds=$lt_old_postuninstall_cmds

# Create an old-style archive from a shared archive.
old_archive_from_new_cmds=$lt_[]_LT_AC_TAGVAR(old_archive_from_new_cmds, $1)

# Create a temporary old-style archive to link instead of a shared archive.
old_archive_from_expsyms_cmds=$lt_[]_LT_AC_TAGVAR(old_archive_from_expsyms_cmds, $1)

# Commands used to build and install a shared archive.
archive_cmds=$lt_[]_LT_AC_TAGVAR(archive_cmds, $1)
archive_expsym_cmds=$lt_[]_LT_AC_TAGVAR(archive_expsym_cmds, $1)
postinstall_cmds=$lt_postinstall_cmds
postuninstall_cmds=$lt_postuninstall_cmds

# Commands used to build a loadable module (assumed same as above if empty)
module_cmds=$lt_[]_LT_AC_TAGVAR(module_cmds, $1)
module_expsym_cmds=$lt_[]_LT_AC_TAGVAR(module_expsym_cmds, $1)

# Commands to strip libraries.
old_striplib=$lt_old_striplib
striplib=$lt_striplib

# Dependencies to place before the objects being linked to create a
# shared library.
predep_objects=$lt_[]_LT_AC_TAGVAR(predep_objects, $1)

# Dependencies to place after the objects being linked to create a
# shared library.
postdep_objects=$lt_[]_LT_AC_TAGVAR(postdep_objects, $1)

# Dependencies to place before the objects being linked to create a
# shared library.
predeps=$lt_[]_LT_AC_TAGVAR(predeps, $1)

# Dependencies to place after the objects being linked to create a
# shared library.
postdeps=$lt_[]_LT_AC_TAGVAR(postdeps, $1)

# The library search path used internally by the compiler when linking
# a shared library.
compiler_lib_search_path=$lt_[]_LT_AC_TAGVAR(compiler_lib_search_path, $1)

# Method to check whether dependent libraries are shared objects.
deplibs_check_method=$lt_deplibs_check_method

# Command to use when deplibs_check_method == file_magic.
file_magic_cmd=$lt_file_magic_cmd

# Flag that allows shared libraries with undefined symbols to be built.
allow_undefined_flag=$lt_[]_LT_AC_TAGVAR(allow_undefined_flag, $1)

# Flag that forces no undefined symbols.
no_undefined_flag=$lt_[]_LT_AC_TAGVAR(no_undefined_flag, $1)

# Commands used to finish a libtool library installation in a directory.
finish_cmds=$lt_finish_cmds

# Same as above, but a single script fragment to be evaled but not shown.
finish_eval=$lt_finish_eval

# Take the output of nm and produce a listing of raw symbols and C names.
global_symbol_pipe=$lt_lt_cv_sys_global_symbol_pipe

# Transform the output of nm in a proper C declaration
global_symbol_to_cdecl=$lt_lt_cv_sys_global_symbol_to_cdecl

# Transform the output of nm in a C name address pair
global_symbol_to_c_name_address=$lt_lt_cv_sys_global_symbol_to_c_name_address

# This is the shared library runtime path variable.
runpath_var=$runpath_var

# This is the shared library path variable.
shlibpath_var=$shlibpath_var

# Is shlibpath searched before the hard-coded library search path?
shlibpath_overrides_runpath=$shlibpath_overrides_runpath

# How to hardcode a shared library path into an executable.
hardcode_action=$_LT_AC_TAGVAR(hardcode_action, $1)

# Whether we should hardcode library paths into libraries.
hardcode_into_libs=$hardcode_into_libs

# Flag to hardcode \$libdir into a binary during linking.
# This must work even if \$libdir does not exist.
hardcode_libdir_flag_spec=$lt_[]_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)

# If ld is used when linking, flag to hardcode \$libdir into
# a binary during linking. This must work even if \$libdir does
# not exist.
hardcode_libdir_flag_spec_ld=$lt_[]_LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)

# Whether we need a single -rpath flag with a separated argument.
hardcode_libdir_separator=$lt_[]_LT_AC_TAGVAR(hardcode_libdir_separator, $1)

# Set to yes if using DIR/libNAME${shared_ext} during linking hardcodes DIR into the
# resulting binary.
hardcode_direct=$_LT_AC_TAGVAR(hardcode_direct, $1)

# Set to yes if using the -LDIR flag during linking hardcodes DIR into the
# resulting binary.
hardcode_minus_L=$_LT_AC_TAGVAR(hardcode_minus_L, $1)

# Set to yes if using SHLIBPATH_VAR=DIR during linking hardcodes DIR into
# the resulting binary.
hardcode_shlibpath_var=$_LT_AC_TAGVAR(hardcode_shlibpath_var, $1)

# Set to yes if building a shared library automatically hardcodes DIR into the library
# and all subsequent libraries and executables linked against it.
hardcode_automatic=$_LT_AC_TAGVAR(hardcode_automatic, $1)

# Variables whose values should be saved in libtool wrapper scripts and
# restored at relink time.
variables_saved_for_relink="$variables_saved_for_relink"

# Whether libtool must link a program against all its dependency libraries.
link_all_deplibs=$_LT_AC_TAGVAR(link_all_deplibs, $1)

# Compile-time system search path for libraries
sys_lib_search_path_spec=$lt_sys_lib_search_path_spec

# Run-time system search path for libraries
sys_lib_dlsearch_path_spec=$lt_sys_lib_dlsearch_path_spec

# Fix the shell variable \$srcfile for the compiler.
fix_srcfile_path="$_LT_AC_TAGVAR(fix_srcfile_path, $1)"

# Set to yes if exported symbols are required.
always_export_symbols=$_LT_AC_TAGVAR(always_export_symbols, $1)

# The commands to list exported symbols.
export_symbols_cmds=$lt_[]_LT_AC_TAGVAR(export_symbols_cmds, $1)

# The commands to extract the exported symbol list from a shared archive.
extract_expsyms_cmds=$lt_extract_expsyms_cmds

# Symbols that should not be listed in the preloaded symbols.
exclude_expsyms=$lt_[]_LT_AC_TAGVAR(exclude_expsyms, $1)

# Symbols that must always be exported.
include_expsyms=$lt_[]_LT_AC_TAGVAR(include_expsyms, $1)

ifelse([$1],[],
[# ### END LIBTOOL CONFIG],
[# ### END LIBTOOL TAG CONFIG: $tagname])

__EOF__

ifelse([$1],[], [
  case $host_os in
  aix3*)
    cat <<\EOF >> "$cfgfile"

# AIX sometimes has problems with the GCC collect2 program.  For some
# reason, if we set the COLLECT_NAMES environment variable, the problems
# vanish in a puff of smoke.
if test "X${COLLECT_NAMES+set}" != Xset; then
  COLLECT_NAMES=
  export COLLECT_NAMES
fi
EOF
    ;;
  esac

  # We use sed instead of cat because bash on DJGPP gets confused if
  # if finds mixed CR/LF and LF-only lines.  Since sed operates in
  # text mode, it properly converts lines to CR/LF.  This bash problem
  # is reportedly fixed, but why not run on old versions too?
  sed '$q' "$ltmain" >> "$cfgfile" || (rm -f "$cfgfile"; exit 1)

  mv -f "$cfgfile" "$ofile" || \
    (rm -f "$ofile" && cp "$cfgfile" "$ofile" && rm -f "$cfgfile")
  chmod +x "$ofile"
])
else
  # If there is no Makefile yet, we rely on a make rule to execute
  # `config.status --recheck' to rerun these tests and create the
  # libtool script then.
  ltmain_in=`echo $ltmain | sed -e 's/\.sh$/.in/'`
  if test -f "$ltmain_in"; then
    test -f Makefile && make "$ltmain"
  fi
fi
])# AC_LIBTOOL_CONFIG


# AC_LIBTOOL_PROG_COMPILER_NO_RTTI([TAGNAME])
# -------------------------------------------
AC_DEFUN([AC_LIBTOOL_PROG_COMPILER_NO_RTTI],
[AC_REQUIRE([_LT_AC_SYS_COMPILER])dnl

_LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)=

if test "$GCC" = yes; then
  _LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)=' -fno-builtin'

  AC_LIBTOOL_COMPILER_OPTION([if $compiler supports -fno-rtti -fno-exceptions],
    lt_cv_prog_compiler_rtti_exceptions,
    [-fno-rtti -fno-exceptions], [],
    [_LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)="$_LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1) -fno-rtti -fno-exceptions"])
fi
])# AC_LIBTOOL_PROG_COMPILER_NO_RTTI


# AC_LIBTOOL_SYS_GLOBAL_SYMBOL_PIPE
# ---------------------------------
AC_DEFUN([AC_LIBTOOL_SYS_GLOBAL_SYMBOL_PIPE],
[AC_REQUIRE([AC_CANONICAL_HOST])
AC_REQUIRE([AC_PROG_NM])
AC_REQUIRE([AC_OBJEXT])
# Check for command to grab the raw symbol name followed by C symbol from nm.
AC_MSG_CHECKING([command to parse $NM output from $compiler object])
AC_CACHE_VAL([lt_cv_sys_global_symbol_pipe],
[
# These are sane defaults that work on at least a few old systems.
# [They come from Ultrix.  What could be older than Ultrix?!! ;)]

# Character class describing NM global symbol codes.
symcode='[[BCDEGRST]]'

# Regexp to match symbols that can be accessed directly from C.
sympat='\([[_A-Za-z]][[_A-Za-z0-9]]*\)'

# Transform an extracted symbol line into a proper C declaration
lt_cv_sys_global_symbol_to_cdecl="sed -n -e 's/^. .* \(.*\)$/extern int \1;/p'"

# Transform an extracted symbol line into symbol name and symbol address
lt_cv_sys_global_symbol_to_c_name_address="sed -n -e 's/^: \([[^ ]]*\) $/  {\\\"\1\\\", (lt_ptr) 0},/p' -e 's/^$symcode \([[^ ]]*\) \([[^ ]]*\)$/  {\"\2\", (lt_ptr) \&\2},/p'"

# Define system-specific variables.
case $host_os in
aix*)
  symcode='[[BCDT]]'
  ;;
cygwin* | mingw* | pw32*)
  symcode='[[ABCDGISTW]]'
  ;;
hpux*) # Its linker distinguishes data from code symbols
  if test "$host_cpu" = ia64; then
    symcode='[[ABCDEGRST]]'
  fi
  lt_cv_sys_global_symbol_to_cdecl="sed -n -e 's/^T .* \(.*\)$/extern int \1();/p' -e 's/^$symcode* .* \(.*\)$/extern char \1;/p'"
  lt_cv_sys_global_symbol_to_c_name_address="sed -n -e 's/^: \([[^ ]]*\) $/  {\\\"\1\\\", (lt_ptr) 0},/p' -e 's/^$symcode* \([[^ ]]*\) \([[^ ]]*\)$/  {\"\2\", (lt_ptr) \&\2},/p'"
  ;;
linux*)
  if test "$host_cpu" = ia64; then
    symcode='[[ABCDGIRSTW]]'
    lt_cv_sys_global_symbol_to_cdecl="sed -n -e 's/^T .* \(.*\)$/extern int \1();/p' -e 's/^$symcode* .* \(.*\)$/extern char \1;/p'"
    lt_cv_sys_global_symbol_to_c_name_address="sed -n -e 's/^: \([[^ ]]*\) $/  {\\\"\1\\\", (lt_ptr) 0},/p' -e 's/^$symcode* \([[^ ]]*\) \([[^ ]]*\)$/  {\"\2\", (lt_ptr) \&\2},/p'"
  fi
  ;;
irix* | nonstopux*)
  symcode='[[BCDEGRST]]'
  ;;
osf*)
  symcode='[[BCDEGQRST]]'
  ;;
solaris*)
  symcode='[[BDRT]]'
  ;;
sco3.2v5*)
  symcode='[[DT]]'
  ;;
sysv4.2uw2*)
  symcode='[[DT]]'
  ;;
sysv5* | sco5v6* | unixware* | OpenUNIX*)
  symcode='[[ABDT]]'
  ;;
sysv4)
  symcode='[[DFNSTU]]'
  ;;
esac

# Handle CRLF in mingw tool chain
opt_cr=
case $build_os in
mingw*)
  opt_cr=`echo 'x\{0,1\}' | tr x '\015'` # option cr in regexp
  ;;
esac

# If we're using GNU nm, then use its standard symbol codes.
case `$NM -V 2>&1` in
*GNU* | *'with BFD'*)
  symcode='[[ABCDGIRSTW]]' ;;
esac

# Try without a prefix undercore, then with it.
for ac_symprfx in "" "_"; do

  # Transform symcode, sympat, and symprfx into a raw symbol and a C symbol.
  symxfrm="\\1 $ac_symprfx\\2 \\2"

  # Write the raw and C identifiers.
  lt_cv_sys_global_symbol_pipe="sed -n -e 's/^.*[[ 	]]\($symcode$symcode*\)[[ 	]][[ 	]]*$ac_symprfx$sympat$opt_cr$/$symxfrm/p'"

  # Check to see that the pipe works correctly.
  pipe_works=no

  rm -f conftest*
  cat > conftest.$ac_ext <<EOF
#ifdef __cplusplus
extern "C" {
#endif
char nm_test_var;
void nm_test_func(){}
#ifdef __cplusplus
}
#endif
int main(){nm_test_var='a';nm_test_func();return(0);}
EOF

  if AC_TRY_EVAL(ac_compile); then
    # Now try to grab the symbols.
    nlist=conftest.nm
    if AC_TRY_EVAL(NM conftest.$ac_objext \| $lt_cv_sys_global_symbol_pipe \> $nlist) && test -s "$nlist"; then
      # Try sorting and uniquifying the output.
      if sort "$nlist" | uniq > "$nlist"T; then
	mv -f "$nlist"T "$nlist"
      else
	rm -f "$nlist"T
      fi

      # Make sure that we snagged all the symbols we need.
      if grep ' nm_test_var$' "$nlist" >/dev/null; then
	if grep ' nm_test_func$' "$nlist" >/dev/null; then
	  cat <<EOF > conftest.$ac_ext
#ifdef __cplusplus
extern "C" {
#endif

EOF
	  # Now generate the symbol file.
	  eval "$lt_cv_sys_global_symbol_to_cdecl"' < "$nlist" | grep -v main >> conftest.$ac_ext'

	  cat <<EOF >> conftest.$ac_ext
#if defined (__STDC__) && __STDC__
# define lt_ptr_t void *
#else
# define lt_ptr_t char *
# define const
#endif

/* The mapping between symbol names and symbols. */
const struct {
  const char *name;
  lt_ptr_t address;
}
lt_preloaded_symbols[[]] =
{
EOF
	  $SED "s/^$symcode$symcode* \(.*\) \(.*\)$/  {\"\2\", (lt_ptr_t) \&\2},/" < "$nlist" | grep -v main >> conftest.$ac_ext
	  cat <<\EOF >> conftest.$ac_ext
  {0, (lt_ptr_t) 0}
};

#ifdef __cplusplus
}
#endif
EOF
	  # Now try linking the two files.
	  mv conftest.$ac_objext conftstm.$ac_objext
	  lt_save_LIBS="$LIBS"
	  lt_save_CFLAGS="$CFLAGS"
	  LIBS="conftstm.$ac_objext"
	  CFLAGS="$CFLAGS$_LT_AC_TAGVAR(lt_prog_compiler_no_builtin_flag, $1)"
	  if AC_TRY_EVAL(ac_link) && test -s conftest${ac_exeext}; then
	    pipe_works=yes
	  fi
	  LIBS="$lt_save_LIBS"
	  CFLAGS="$lt_save_CFLAGS"
	else
	  echo "cannot find nm_test_func in $nlist" >&AS_MESSAGE_LOG_FD
	fi
      else
	echo "cannot find nm_test_var in $nlist" >&AS_MESSAGE_LOG_FD
      fi
    else
      echo "cannot run $lt_cv_sys_global_symbol_pipe" >&AS_MESSAGE_LOG_FD
    fi
  else
    echo "$progname: failed program was:" >&AS_MESSAGE_LOG_FD
    cat conftest.$ac_ext >&5
  fi
  rm -f conftest* conftst*

  # Do not use the global_symbol_pipe unless it works.
  if test "$pipe_works" = yes; then
    break
  else
    lt_cv_sys_global_symbol_pipe=
  fi
done
])
if test -z "$lt_cv_sys_global_symbol_pipe"; then
  lt_cv_sys_global_symbol_to_cdecl=
fi
if test -z "$lt_cv_sys_global_symbol_pipe$lt_cv_sys_global_symbol_to_cdecl"; then
  AC_MSG_RESULT(failed)
else
  AC_MSG_RESULT(ok)
fi
]) # AC_LIBTOOL_SYS_GLOBAL_SYMBOL_PIPE


# AC_LIBTOOL_PROG_COMPILER_PIC([TAGNAME])
# ---------------------------------------
AC_DEFUN([AC_LIBTOOL_PROG_COMPILER_PIC],
[_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)=
_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
_LT_AC_TAGVAR(lt_prog_compiler_static, $1)=

AC_MSG_CHECKING([for $compiler option to produce PIC])
 ifelse([$1],[CXX],[
  # C++ specific cases for pic, static, wl, etc.
  if test "$GXX" = yes; then
    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-static'

    case $host_os in
    aix*)
      # All AIX code is PIC.
      if test "$host_cpu" = ia64; then
	# AIX 5 now supports IA64 processor
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      fi
      ;;
    amigaos*)
      # FIXME: we need at least 68020 code to build shared libraries, but
      # adding the `-m68020' flag to GCC prevents building anything better,
      # like `-m68040'.
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-m68020 -resident32 -malways-restore-a4'
      ;;
    beos* | cygwin* | irix5* | irix6* | nonstopux* | osf3* | osf4* | osf5*)
      # PIC is the default for these OSes.
      ;;
    mingw* | os2* | pw32*)
      # This hack is so that the source file can tell whether it is being
      # built for inclusion in a dll (and should export symbols for example).
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-DDLL_EXPORT'
      ;;
    darwin* | rhapsody*)
      # PIC is the default on this platform
      # Common symbols not allowed in MH_DYLIB files
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fno-common'
      ;;
    *djgpp*)
      # DJGPP does not support shared libraries at all
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
      ;;
    interix3*)
      # Interix 3.x gcc -fpic/-fPIC options generate broken code.
      # Instead, we relocate shared libraries at runtime.
      ;;
    sysv4*MP*)
      if test -d /usr/nec; then
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=-Kconform_pic
      fi
      ;;
    hpux*)
      # PIC is the default for IA64 HP-UX and 64-bit HP-UX, but
      # not for PA HP-UX.
      case $host_cpu in
      hppa*64*|ia64*)
	;;
      *)
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fPIC'
	;;
      esac
      ;;
    *)
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fPIC'
      ;;
    esac
  else
    case $host_os in
      aix4* | aix5*)
	# All AIX code is PIC.
	if test "$host_cpu" = ia64; then
	  # AIX 5 now supports IA64 processor
	  _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
	else
	  _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-bnso -bI:/lib/syscalls.exp'
	fi
	;;
      chorus*)
	case $cc_basename in
	cxch68*)
	  # Green Hills C++ Compiler
	  # _LT_AC_TAGVAR(lt_prog_compiler_static, $1)="--no_auto_instantiation -u __main -u __premain -u _abort -r $COOL_DIR/lib/libOrb.a $MVME_DIR/lib/CC/libC.a $MVME_DIR/lib/classix/libcx.s.a"
	  ;;
	esac
	;;
       darwin*)
         # PIC is the default on this platform
         # Common symbols not allowed in MH_DYLIB files
         case $cc_basename in
           xlc*)
           _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-qnocommon'
           _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
           ;;
         esac
       ;;
      dgux*)
	case $cc_basename in
	  ec++*)
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	    ;;
	  ghcx*)
	    # Green Hills C++ Compiler
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-pic'
	    ;;
	  *)
	    ;;
	esac
	;;
      freebsd* | kfreebsd*-gnu | dragonfly*)
	# FreeBSD uses GNU C++
	;;
      hpux9* | hpux10* | hpux11*)
	case $cc_basename in
	  CC*)
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='${wl}-a ${wl}archive'
	    if test "$host_cpu" != ia64; then
	      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='+Z'
	    fi
	    ;;
	  aCC*)
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='${wl}-a ${wl}archive'
	    case $host_cpu in
	    hppa*64*|ia64*)
	      # +Z the default
	      ;;
	    *)
	      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='+Z'
	      ;;
	    esac
	    ;;
	  *)
	    ;;
	esac
	;;
      interix*)
	# This is c89, which is MS Visual C++ (no shared libs)
	# Anyone wants to do a port?
	;;
      irix5* | irix6* | nonstopux*)
	case $cc_basename in
	  CC*)
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
	    # CC pic flag -KPIC is the default.
	    ;;
	  *)
	    ;;
	esac
	;;
      linux*)
	case $cc_basename in
	  KCC*)
	    # KAI C++ Compiler
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='--backend -Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fPIC'
	    ;;
	  icpc* | ecpc*)
	    # Intel C++
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-static'
	    ;;
	  pgCC*)
	    # Portland Group C++ compiler.
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fpic'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
	    ;;
	  cxx*)
	    # Compaq C++
	    # Make sure the PIC flag is empty.  It appears that all Alpha
	    # Linux and Compaq Tru64 Unix objects are PIC.
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
	    ;;
	  *)
	    ;;
	esac
	;;
      lynxos*)
	;;
      m88k*)
	;;
      mvs*)
	case $cc_basename in
	  cxx*)
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-W c,exportall'
	    ;;
	  *)
	    ;;
	esac
	;;
      netbsd*)
	;;
      osf3* | osf4* | osf5*)
	case $cc_basename in
	  KCC*)
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='--backend -Wl,'
	    ;;
	  RCC*)
	    # Rational C++ 2.4.1
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-pic'
	    ;;
	  cxx*)
	    # Digital/Compaq C++
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    # Make sure the PIC flag is empty.  It appears that all Alpha
	    # Linux and Compaq Tru64 Unix objects are PIC.
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
	    ;;
	  *)
	    ;;
	esac
	;;
      psos*)
	;;
      solaris*)
	case $cc_basename in
	  CC*)
	    # Sun C++ 4.2, 5.x and Centerline C++
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Qoption ld '
	    ;;
	  gcx*)
	    # Green Hills C++ Compiler
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-PIC'
	    ;;
	  *)
	    ;;
	esac
	;;
      sunos4*)
	case $cc_basename in
	  CC*)
	    # Sun C++ 4.x
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-pic'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
	    ;;
	  lcc*)
	    # Lucid
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-pic'
	    ;;
	  *)
	    ;;
	esac
	;;
      tandem*)
	case $cc_basename in
	  NCC*)
	    # NonStop-UX NCC 3.20
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	    ;;
	  *)
	    ;;
	esac
	;;
      sysv5* | unixware* | sco3.2v5* | sco5v6* | OpenUNIX*)
	case $cc_basename in
	  CC*)
	    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
	    ;;
	esac
	;;
      vxworks*)
	;;
      *)
	_LT_AC_TAGVAR(lt_prog_compiler_can_build_shared, $1)=no
	;;
    esac
  fi
],
[
  if test "$GCC" = yes; then
    _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
    _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-static'

    case $host_os in
      aix*)
      # All AIX code is PIC.
      if test "$host_cpu" = ia64; then
	# AIX 5 now supports IA64 processor
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      fi
      ;;

    amigaos*)
      # FIXME: we need at least 68020 code to build shared libraries, but
      # adding the `-m68020' flag to GCC prevents building anything better,
      # like `-m68040'.
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-m68020 -resident32 -malways-restore-a4'
      ;;

    beos* | cygwin* | irix5* | irix6* | nonstopux* | osf3* | osf4* | osf5*)
      # PIC is the default for these OSes.
      ;;

    mingw* | pw32* | os2*)
      # This hack is so that the source file can tell whether it is being
      # built for inclusion in a dll (and should export symbols for example).
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-DDLL_EXPORT'
      ;;

    darwin* | rhapsody*)
      # PIC is the default on this platform
      # Common symbols not allowed in MH_DYLIB files
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fno-common'
      ;;

    interix3*)
      # Interix 3.x gcc -fpic/-fPIC options generate broken code.
      # Instead, we relocate shared libraries at runtime.
      ;;

    msdosdjgpp*)
      # Just because we use GCC doesn't mean we suddenly get shared libraries
      # on systems that don't support them.
      _LT_AC_TAGVAR(lt_prog_compiler_can_build_shared, $1)=no
      enable_shared=no
      ;;

    sysv4*MP*)
      if test -d /usr/nec; then
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=-Kconform_pic
      fi
      ;;

    hpux*)
      # PIC is the default for IA64 HP-UX and 64-bit HP-UX, but
      # not for PA HP-UX.
      case $host_cpu in
      hppa*64*|ia64*)
	# +Z the default
	;;
      *)
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fPIC'
	;;
      esac
      ;;

    *)
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fPIC'
      ;;
    esac
  else
    # PORTME Check for flag to pass linker flags through the system compiler.
    case $host_os in
    aix*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      if test "$host_cpu" = ia64; then
	# AIX 5 now supports IA64 processor
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      else
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-bnso -bI:/lib/syscalls.exp'
      fi
      ;;
      darwin*)
        # PIC is the default on this platform
        # Common symbols not allowed in MH_DYLIB files
       case $cc_basename in
         xlc*)
         _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-qnocommon'
         _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
         ;;
       esac
       ;;

    mingw* | pw32* | os2*)
      # This hack is so that the source file can tell whether it is being
      # built for inclusion in a dll (and should export symbols for example).
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-DDLL_EXPORT'
      ;;

    hpux9* | hpux10* | hpux11*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      # PIC is the default for IA64 HP-UX and 64-bit HP-UX, but
      # not for PA HP-UX.
      case $host_cpu in
      hppa*64*|ia64*)
	# +Z the default
	;;
      *)
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='+Z'
	;;
      esac
      # Is there a better lt_prog_compiler_static that works with the bundled CC?
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='${wl}-a ${wl}archive'
      ;;

    irix5* | irix6* | nonstopux*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      # PIC (with -KPIC) is the default.
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
      ;;

    newsos6)
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      ;;

    linux*)
      case $cc_basename in
      icc* | ecc*)
	_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-static'
        ;;
      pgcc* | pgf77* | pgf90* | pgf95*)
        # Portland Group compilers (*not* the Pentium gcc compiler,
	# which looks to be a dead project)
	_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-fpic'
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
        ;;
      ccc*)
        _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
        # All Alpha code is PIC.
        _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
        ;;
      esac
      ;;

    osf3* | osf4* | osf5*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      # All OSF/1 code is PIC.
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-non_shared'
      ;;

    solaris*)
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      case $cc_basename in
      f77* | f90* | f95*)
	_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Qoption ld ';;
      *)
	_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,';;
      esac
      ;;

    sunos4*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Qoption ld '
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-PIC'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      ;;

    sysv4 | sysv4.2uw2* | sysv4.3*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      ;;

    sysv4*MP*)
      if test -d /usr/nec ;then
	_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-Kconform_pic'
	_LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      fi
      ;;

    sysv5* | unixware* | sco3.2v5* | sco5v6* | OpenUNIX*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-KPIC'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      ;;

    unicos*)
      _LT_AC_TAGVAR(lt_prog_compiler_wl, $1)='-Wl,'
      _LT_AC_TAGVAR(lt_prog_compiler_can_build_shared, $1)=no
      ;;

    uts4*)
      _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)='-pic'
      _LT_AC_TAGVAR(lt_prog_compiler_static, $1)='-Bstatic'
      ;;

    *)
      _LT_AC_TAGVAR(lt_prog_compiler_can_build_shared, $1)=no
      ;;
    esac
  fi
])
AC_MSG_RESULT([$_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)])

#
# Check to make sure the PIC flag actually works.
#
if test -n "$_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)"; then
  AC_LIBTOOL_COMPILER_OPTION([if $compiler PIC flag $_LT_AC_TAGVAR(lt_prog_compiler_pic, $1) works],
    _LT_AC_TAGVAR(lt_prog_compiler_pic_works, $1),
    [$_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)ifelse([$1],[],[ -DPIC],[ifelse([$1],[CXX],[ -DPIC],[])])], [],
    [case $_LT_AC_TAGVAR(lt_prog_compiler_pic, $1) in
     "" | " "*) ;;
     *) _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=" $_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)" ;;
     esac],
    [_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
     _LT_AC_TAGVAR(lt_prog_compiler_can_build_shared, $1)=no])
fi
case $host_os in
  # For platforms which do not support PIC, -DPIC is meaningless:
  *djgpp*)
    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)=
    ;;
  *)
    _LT_AC_TAGVAR(lt_prog_compiler_pic, $1)="$_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)ifelse([$1],[],[ -DPIC],[ifelse([$1],[CXX],[ -DPIC],[])])"
    ;;
esac

#
# Check to make sure the static flag actually works.
#
wl=$_LT_AC_TAGVAR(lt_prog_compiler_wl, $1) eval lt_tmp_static_flag=\"$_LT_AC_TAGVAR(lt_prog_compiler_static, $1)\"
AC_LIBTOOL_LINKER_OPTION([if $compiler static flag $lt_tmp_static_flag works],
  _LT_AC_TAGVAR(lt_prog_compiler_static_works, $1),
  $lt_tmp_static_flag,
  [],
  [_LT_AC_TAGVAR(lt_prog_compiler_static, $1)=])
])


# AC_LIBTOOL_PROG_LD_SHLIBS([TAGNAME])
# ------------------------------------
# See if the linker supports building shared libraries.
AC_DEFUN([AC_LIBTOOL_PROG_LD_SHLIBS],
[AC_MSG_CHECKING([whether the $compiler linker ($LD) supports shared libraries])
ifelse([$1],[CXX],[
  _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM $libobjs $convenience | $global_symbol_pipe | $SED '\''s/.* //'\'' | sort | uniq > $export_symbols'
  case $host_os in
  aix4* | aix5*)
    # If we're using GNU nm, then we don't want the "-C" option.
    # -C means demangle to AIX nm, but means don't demangle with GNU nm
    if $NM -V 2>&1 | grep 'GNU' > /dev/null; then
      _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM -Bpg $libobjs $convenience | awk '\''{ if (((\[$]2 == "T") || (\[$]2 == "D") || (\[$]2 == "B")) && ([substr](\[$]3,1,1) != ".")) { print \[$]3 } }'\'' | sort -u > $export_symbols'
    else
      _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM -BCpg $libobjs $convenience | awk '\''{ if (((\[$]2 == "T") || (\[$]2 == "D") || (\[$]2 == "B")) && ([substr](\[$]3,1,1) != ".")) { print \[$]3 } }'\'' | sort -u > $export_symbols'
    fi
    ;;
  pw32*)
    _LT_AC_TAGVAR(export_symbols_cmds, $1)="$ltdll_cmds"
  ;;
  cygwin* | mingw*)
    _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM $libobjs $convenience | $global_symbol_pipe | $SED -e '\''/^[[BCDGRS]] /s/.* \([[^ ]]*\)/\1 DATA/;/^.* __nm__/s/^.* __nm__\([[^ ]]*\) [[^ ]]*/\1 DATA/;/^I /d;/^[[AITW]] /s/.* //'\'' | sort | uniq > $export_symbols'
  ;;
  *)
    _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM $libobjs $convenience | $global_symbol_pipe | $SED '\''s/.* //'\'' | sort | uniq > $export_symbols'
  ;;
  esac
],[
  runpath_var=
  _LT_AC_TAGVAR(allow_undefined_flag, $1)=
  _LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=no
  _LT_AC_TAGVAR(archive_cmds, $1)=
  _LT_AC_TAGVAR(archive_expsym_cmds, $1)=
  _LT_AC_TAGVAR(old_archive_From_new_cmds, $1)=
  _LT_AC_TAGVAR(old_archive_from_expsyms_cmds, $1)=
  _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)=
  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
  _LT_AC_TAGVAR(thread_safe_flag_spec, $1)=
  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)=
  _LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)=
  _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=
  _LT_AC_TAGVAR(hardcode_direct, $1)=no
  _LT_AC_TAGVAR(hardcode_minus_L, $1)=no
  _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=unsupported
  _LT_AC_TAGVAR(link_all_deplibs, $1)=unknown
  _LT_AC_TAGVAR(hardcode_automatic, $1)=no
  _LT_AC_TAGVAR(module_cmds, $1)=
  _LT_AC_TAGVAR(module_expsym_cmds, $1)=
  _LT_AC_TAGVAR(always_export_symbols, $1)=no
  _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM $libobjs $convenience | $global_symbol_pipe | $SED '\''s/.* //'\'' | sort | uniq > $export_symbols'
  # include_expsyms should be a list of space-separated symbols to be *always*
  # included in the symbol list
  _LT_AC_TAGVAR(include_expsyms, $1)=
  # exclude_expsyms can be an extended regexp of symbols to exclude
  # it will be wrapped by ` (' and `)$', so one must not match beginning or
  # end of line.  Example: `a|bc|.*d.*' will exclude the symbols `a' and `bc',
  # as well as any symbol that contains `d'.
  _LT_AC_TAGVAR(exclude_expsyms, $1)="_GLOBAL_OFFSET_TABLE_"
  # Although _GLOBAL_OFFSET_TABLE_ is a valid symbol C name, most a.out
  # platforms (ab)use it in PIC code, but their linkers get confused if
  # the symbol is explicitly referenced.  Since portable code cannot
  # rely on this symbol name, it's probably fine to never include it in
  # preloaded symbol tables.
  extract_expsyms_cmds=
  # Just being paranoid about ensuring that cc_basename is set.
  _LT_CC_BASENAME([$compiler])
  case $host_os in
  cygwin* | mingw* | pw32*)
    # FIXME: the MSVC++ port hasn't been tested in a loooong time
    # When not using gcc, we currently assume that we are using
    # Microsoft Visual C++.
    if test "$GCC" != yes; then
      with_gnu_ld=no
    fi
    ;;
  interix*)
    # we just hope/assume this is gcc and not c89 (= MSVC++)
    with_gnu_ld=yes
    ;;
  openbsd*)
    with_gnu_ld=no
    ;;
  esac

  _LT_AC_TAGVAR(ld_shlibs, $1)=yes
  if test "$with_gnu_ld" = yes; then
    # If archive_cmds runs LD, not CC, wlarc should be empty
    wlarc='${wl}'

    # Set some defaults for GNU ld with shared library support. These
    # are reset later if shared libraries are not supported. Putting them
    # here allows them to be overridden if necessary.
    runpath_var=LD_RUN_PATH
    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}--rpath ${wl}$libdir'
    _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}--export-dynamic'
    # ancient GNU ld didn't support --whole-archive et. al.
    if $LD --help 2>&1 | grep 'no-whole-archive' > /dev/null; then
	_LT_AC_TAGVAR(whole_archive_flag_spec, $1)="$wlarc"'--whole-archive$convenience '"$wlarc"'--no-whole-archive'
      else
  	_LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
    fi
    supports_anon_versioning=no
    case `$LD -v 2>/dev/null` in
      *\ [[01]].* | *\ 2.[[0-9]].* | *\ 2.10.*) ;; # catch versions < 2.11
      *\ 2.11.93.0.2\ *) supports_anon_versioning=yes ;; # RH7.3 ...
      *\ 2.11.92.0.12\ *) supports_anon_versioning=yes ;; # Mandrake 8.2 ...
      *\ 2.11.*) ;; # other 2.11 versions
      *) supports_anon_versioning=yes ;;
    esac

    # See if GNU ld supports shared libraries.
    case $host_os in
    aix3* | aix4* | aix5*)
      # On AIX/PPC, the GNU linker is very broken
      if test "$host_cpu" != ia64; then
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	cat <<EOF 1>&2

*** Warning: the GNU linker, at least up to release 2.9.1, is reported
*** to be unable to reliably create shared libraries on AIX.
*** Therefore, libtool is disabling shared libraries support.  If you
*** really care for shared libraries, you may want to modify your PATH
*** so that a non-GNU linker is found, and then restart.

EOF
      fi
      ;;

    amigaos*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/a2ixlibrary.data~$echo "#define NAME $libname" > $output_objdir/a2ixlibrary.data~$echo "#define LIBRARY_ID 1" >> $output_objdir/a2ixlibrary.data~$echo "#define VERSION $major" >> $output_objdir/a2ixlibrary.data~$echo "#define REVISION $revision" >> $output_objdir/a2ixlibrary.data~$AR $AR_FLAGS $lib $libobjs~$RANLIB $lib~(cd $output_objdir && a2ixlibrary -32)'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes

      # Samuel A. Falvo II <kc5tja@dolphin.openprojects.net> reports
      # that the semantics of dynamic libraries on AmigaOS, at least up
      # to version 4, is to share data among multiple programs linked
      # with the same dynamic library.  Since this doesn't match the
      # behavior of shared libraries on other platforms, we can't use
      # them.
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
      ;;

    beos*)
      if $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
	# Joseph Beckenbach <jrb3@best.com> says some releases of gcc
	# support --undefined.  This deserves some investigation.  FIXME
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -nostart $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
      else
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;

    cygwin* | mingw* | pw32*)
      # _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1) is actually meaningless,
      # as there is no search path for DLLs.
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
      _LT_AC_TAGVAR(always_export_symbols, $1)=no
      _LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=yes
      _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM $libobjs $convenience | $global_symbol_pipe | $SED -e '\''/^[[BCDGRS]] /s/.* \([[^ ]]*\)/\1 DATA/'\'' | $SED -e '\''/^[[AITW]] /s/.* //'\'' | sort | uniq > $export_symbols'

      if $LD --help 2>&1 | grep 'auto-import' > /dev/null; then
        _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags -o $output_objdir/$soname ${wl}--enable-auto-image-base -Xlinker --out-implib -Xlinker $lib'
	# If the export-symbols file already is a .def file (1st line
	# is EXPORTS), use it as is; otherwise, prepend...
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='if test "x`$SED 1q $export_symbols`" = xEXPORTS; then
	  cp $export_symbols $output_objdir/$soname.def;
	else
	  echo EXPORTS > $output_objdir/$soname.def;
	  cat $export_symbols >> $output_objdir/$soname.def;
	fi~
	$CC -shared $output_objdir/$soname.def $libobjs $deplibs $compiler_flags -o $output_objdir/$soname ${wl}--enable-auto-image-base -Xlinker --out-implib -Xlinker $lib'
      else
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;

    interix3*)
      _LT_AC_TAGVAR(hardcode_direct, $1)=no
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
      # Hack: On Interix 3.x, we cannot compile PIC because of a broken gcc.
      # Instead, shared libraries are loaded at an image base (0x10000000 by
      # default) and relocated if they conflict, which is a slow very memory
      # consuming and fragmenting process.  To avoid this, we pick a random,
      # 256 KiB-aligned image base between 0x50000000 and 0x6FFC0000 at link
      # time.  Moving up from 0x10000000 also allows more sbrk(2) space.
      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag $libobjs $deplibs $compiler_flags ${wl}-h,$soname ${wl}--image-base,`expr ${RANDOM-$$} % 4096 / 2 \* 262144 + 1342177280` -o $lib'
      _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed "s,^,_," $export_symbols >$output_objdir/$soname.expsym~$CC -shared $pic_flag $libobjs $deplibs $compiler_flags ${wl}-h,$soname ${wl}--retain-symbols-file,$output_objdir/$soname.expsym ${wl}--image-base,`expr ${RANDOM-$$} % 4096 / 2 \* 262144 + 1342177280` -o $lib'
      ;;

    linux*)
      if $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
	tmp_addflag=
	case $cc_basename,$host_cpu in
	pgcc*)				# Portland Group C compiler
	  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}--whole-archive`for conv in $convenience\"\"; do test  -n \"$conv\" && new_convenience=\"$new_convenience,$conv\"; done; $echo \"$new_convenience\"` ${wl}--no-whole-archive'
	  tmp_addflag=' $pic_flag'
	  ;;
	pgf77* | pgf90* | pgf95*)	# Portland Group f77 and f90 compilers
	  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}--whole-archive`for conv in $convenience\"\"; do test  -n \"$conv\" && new_convenience=\"$new_convenience,$conv\"; done; $echo \"$new_convenience\"` ${wl}--no-whole-archive'
	  tmp_addflag=' $pic_flag -Mnomain' ;;
	ecc*,ia64* | icc*,ia64*)		# Intel C compiler on ia64
	  tmp_addflag=' -i_dynamic' ;;
	efc*,ia64* | ifort*,ia64*)	# Intel Fortran compiler on ia64
	  tmp_addflag=' -i_dynamic -nofor_main' ;;
	ifc* | ifort*)			# Intel Fortran compiler
	  tmp_addflag=' -nofor_main' ;;
	esac
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared'"$tmp_addflag"' $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'

	if test $supports_anon_versioning = yes; then
	  _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $output_objdir/$libname.ver~
  cat $export_symbols | sed -e "s/\(.*\)/\1;/" >> $output_objdir/$libname.ver~
  $echo "local: *; };" >> $output_objdir/$libname.ver~
	  $CC -shared'"$tmp_addflag"' $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname ${wl}-version-script ${wl}$output_objdir/$libname.ver -o $lib'
	fi
      else
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;

    netbsd*)
      if echo __ELF__ | $CC -E - | grep __ELF__ >/dev/null; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable $libobjs $deplibs $linker_flags -o $lib'
	wlarc=
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'
      fi
      ;;

    solaris*)
      if $LD -v 2>&1 | grep 'BFD 2\.8' > /dev/null; then
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	cat <<EOF 1>&2

*** Warning: The releases 2.8.* of the GNU linker cannot reliably
*** create shared libraries on Solaris systems.  Therefore, libtool
*** is disabling shared libraries support.  We urge you to upgrade GNU
*** binutils to release 2.9.1 or newer.  Another option is to modify
*** your PATH or compiler configuration so that the native linker is
*** used, and then restart.

EOF
      elif $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'
      else
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;

    sysv5* | sco3.2v5* | sco5v6* | unixware* | OpenUNIX*)
      case `$LD -v 2>&1` in
        *\ [[01]].* | *\ 2.[[0-9]].* | *\ 2.1[[0-5]].*) 
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
	cat <<_LT_EOF 1>&2

*** Warning: Releases of the GNU linker prior to 2.16.91.0.3 can not
*** reliably create shared libraries on SCO systems.  Therefore, libtool
*** is disabling shared libraries support.  We urge you to upgrade GNU
*** binutils to release 2.16.91.0.3 or newer.  Another option is to modify
*** your PATH or compiler configuration so that the native linker is
*** used, and then restart.

_LT_EOF
	;;
	*)
	  if $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
	    _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='`test -z "$SCOABSPATH" && echo ${wl}-rpath,$libdir`'
	    _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib'
	    _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname,\${SCOABSPATH:+${install_libdir}/}$soname,-retain-symbols-file,$export_symbols -o $lib'
	  else
	    _LT_AC_TAGVAR(ld_shlibs, $1)=no
	  fi
	;;
      esac
      ;;

    sunos4*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -assert pure-text -Bshareable -o $lib $libobjs $deplibs $linker_flags'
      wlarc=
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    *)
      if $LD --help 2>&1 | grep ': supported targets:.* elf' > /dev/null; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname $wl$soname ${wl}-retain-symbols-file $wl$export_symbols -o $lib'
      else
	_LT_AC_TAGVAR(ld_shlibs, $1)=no
      fi
      ;;
    esac

    if test "$_LT_AC_TAGVAR(ld_shlibs, $1)" = no; then
      runpath_var=
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)=
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)=
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)=
    fi
  else
    # PORTME fill in a description of your system's linker (not GNU ld)
    case $host_os in
    aix3*)
      _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
      _LT_AC_TAGVAR(always_export_symbols, $1)=yes
      _LT_AC_TAGVAR(archive_expsym_cmds, $1)='$LD -o $output_objdir/$soname $libobjs $deplibs $linker_flags -bE:$export_symbols -T512 -H512 -bM:SRE~$AR $AR_FLAGS $lib $output_objdir/$soname'
      # Note: this linker hardcodes the directories in LIBPATH if there
      # are no directories specified by -L.
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      if test "$GCC" = yes && test -z "$lt_prog_compiler_static"; then
	# Neither direct hardcoding nor static linking is supported with a
	# broken collect2.
	_LT_AC_TAGVAR(hardcode_direct, $1)=unsupported
      fi
      ;;

    aix4* | aix5*)
      if test "$host_cpu" = ia64; then
	# On IA64, the linker does run time linking by default, so we don't
	# have to do anything special.
	aix_use_runtimelinking=no
	exp_sym_flag='-Bexport'
	no_entry_flag=""
      else
	# If we're using GNU nm, then we don't want the "-C" option.
	# -C means demangle to AIX nm, but means don't demangle with GNU nm
	if $NM -V 2>&1 | grep 'GNU' > /dev/null; then
	  _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM -Bpg $libobjs $convenience | awk '\''{ if (((\[$]2 == "T") || (\[$]2 == "D") || (\[$]2 == "B")) && ([substr](\[$]3,1,1) != ".")) { print \[$]3 } }'\'' | sort -u > $export_symbols'
	else
	  _LT_AC_TAGVAR(export_symbols_cmds, $1)='$NM -BCpg $libobjs $convenience | awk '\''{ if (((\[$]2 == "T") || (\[$]2 == "D") || (\[$]2 == "B")) && ([substr](\[$]3,1,1) != ".")) { print \[$]3 } }'\'' | sort -u > $export_symbols'
	fi
	aix_use_runtimelinking=no

	# Test if we are trying to use run time linking or normal
	# AIX style linking. If -brtl is somewhere in LDFLAGS, we
	# need to do runtime linking.
	case $host_os in aix4.[[23]]|aix4.[[23]].*|aix5*)
	  for ld_flag in $LDFLAGS; do
  	  if (test $ld_flag = "-brtl" || test $ld_flag = "-Wl,-brtl"); then
  	    aix_use_runtimelinking=yes
  	    break
  	  fi
	  done
	  ;;
	esac

	exp_sym_flag='-bexport'
	no_entry_flag='-bnoentry'
      fi

      # When large executables or shared objects are built, AIX ld can
      # have problems creating the table of contents.  If linking a library
      # or program results in "error TOC overflow" add -mminimal-toc to
      # CXXFLAGS/CFLAGS for g++/gcc.  In the cases where that is not
      # enough to fix the problem, add -Wl,-bbigtoc to LDFLAGS.

      _LT_AC_TAGVAR(archive_cmds, $1)=''
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=':'
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes

      if test "$GCC" = yes; then
	case $host_os in aix4.[[012]]|aix4.[[012]].*)
	# We only want to do this on AIX 4.2 and lower, the check
	# below for broken collect2 doesn't work under 4.3+
	  collect2name=`${CC} -print-prog-name=collect2`
	  if test -f "$collect2name" && \
  	   strings "$collect2name" | grep resolve_lib_name >/dev/null
	  then
  	  # We have reworked collect2
  	  _LT_AC_TAGVAR(hardcode_direct, $1)=yes
	  else
  	  # We have old collect2
  	  _LT_AC_TAGVAR(hardcode_direct, $1)=unsupported
  	  # It fails to find uninstalled libraries when the uninstalled
  	  # path is not listed in the libpath.  Setting hardcode_minus_L
  	  # to unsupported forces relinking
  	  _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
  	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
  	  _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=
	  fi
	  ;;
	esac
	shared_flag='-shared'
	if test "$aix_use_runtimelinking" = yes; then
	  shared_flag="$shared_flag "'${wl}-G'
	fi
      else
	# not using gcc
	if test "$host_cpu" = ia64; then
  	# VisualAge C++, Version 5.5 for AIX 5L for IA-64, Beta 3 Release
  	# chokes on -Wl,-G. The following line is correct:
	  shared_flag='-G'
	else
	  if test "$aix_use_runtimelinking" = yes; then
	    shared_flag='${wl}-G'
	  else
	    shared_flag='${wl}-bM:SRE'
	  fi
	fi
      fi

      # It seems that -bexpall does not export symbols beginning with
      # underscore (_), so it is better to generate a list of symbols to export.
      _LT_AC_TAGVAR(always_export_symbols, $1)=yes
      if test "$aix_use_runtimelinking" = yes; then
	# Warning - without using the other runtime loading flags (-brtl),
	# -berok will link without error, but may produce a broken library.
	_LT_AC_TAGVAR(allow_undefined_flag, $1)='-berok'
       # Determine the default libpath from the value encoded in an empty executable.
       _LT_AC_SYS_LIBPATH_AIX
       _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-blibpath:$libdir:'"$aix_libpath"
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC"' -o $output_objdir/$soname $libobjs $deplibs '"\${wl}$no_entry_flag"' $compiler_flags `if test "x${allow_undefined_flag}" != "x"; then echo "${wl}${allow_undefined_flag}"; else :; fi` '"\${wl}$exp_sym_flag:\$export_symbols $shared_flag"
       else
	if test "$host_cpu" = ia64; then
	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-R $libdir:/usr/lib:/lib'
	  _LT_AC_TAGVAR(allow_undefined_flag, $1)="-z nodefs"
	  _LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC $shared_flag"' -o $output_objdir/$soname $libobjs $deplibs '"\${wl}$no_entry_flag"' $compiler_flags ${wl}${allow_undefined_flag} '"\${wl}$exp_sym_flag:\$export_symbols"
	else
	 # Determine the default libpath from the value encoded in an empty executable.
	 _LT_AC_SYS_LIBPATH_AIX
	 _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-blibpath:$libdir:'"$aix_libpath"
	  # Warning - without using the other run time loading flags,
	  # -berok will link without error, but may produce a broken library.
	  _LT_AC_TAGVAR(no_undefined_flag, $1)=' ${wl}-bernotok'
	  _LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-berok'
	  # Exported symbols can be pulled into shared objects from archives
	  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='$convenience'
	  _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=yes
	  # This is similar to how AIX traditionally builds its shared libraries.
	  _LT_AC_TAGVAR(archive_expsym_cmds, $1)="\$CC $shared_flag"' -o $output_objdir/$soname $libobjs $deplibs ${wl}-bnoentry $compiler_flags ${wl}-bE:$export_symbols${allow_undefined_flag}~$AR $AR_FLAGS $output_objdir/$libname$release.a $output_objdir/$soname'
	fi
      fi
      ;;

    amigaos*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/a2ixlibrary.data~$echo "#define NAME $libname" > $output_objdir/a2ixlibrary.data~$echo "#define LIBRARY_ID 1" >> $output_objdir/a2ixlibrary.data~$echo "#define VERSION $major" >> $output_objdir/a2ixlibrary.data~$echo "#define REVISION $revision" >> $output_objdir/a2ixlibrary.data~$AR $AR_FLAGS $lib $libobjs~$RANLIB $lib~(cd $output_objdir && a2ixlibrary -32)'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      # see comment about different semantics on the GNU ld section
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
      ;;

    bsdi[[45]]*)
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)=-rdynamic
      ;;

    cygwin* | mingw* | pw32*)
      # When not using gcc, we currently assume that we are using
      # Microsoft Visual C++.
      # hardcode_libdir_flag_spec is actually meaningless, as there is
      # no search path for DLLs.
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)=' '
      _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
      # Tell ltmain to make .lib files, not .a files.
      libext=lib
      # Tell ltmain to make .dll files, not .so files.
      shrext_cmds=".dll"
      # FIXME: Setting linknames here is a bad hack.
      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -o $lib $libobjs $compiler_flags `echo "$deplibs" | $SED -e '\''s/ -lc$//'\''` -link -dll~linknames='
      # The linker will automatically build a .lib file if we build a DLL.
      _LT_AC_TAGVAR(old_archive_From_new_cmds, $1)='true'
      # FIXME: Should let the user specify the lib program.
      _LT_AC_TAGVAR(old_archive_cmds, $1)='lib /OUT:$oldlib$oldobjs$old_deplibs'
      _LT_AC_TAGVAR(fix_srcfile_path, $1)='`cygpath -w "$srcfile"`'
      _LT_AC_TAGVAR(enable_shared_with_static_runtimes, $1)=yes
      ;;

    darwin* | rhapsody*)
      case $host_os in
        rhapsody* | darwin1.[[012]])
         _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-undefined ${wl}suppress'
         ;;
       *) # Darwin 1.3 on
         if test -z ${MACOSX_DEPLOYMENT_TARGET} ; then
           _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-flat_namespace ${wl}-undefined ${wl}suppress'
         else
           case ${MACOSX_DEPLOYMENT_TARGET} in
             10.[[012]])
               _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-flat_namespace ${wl}-undefined ${wl}suppress'
               ;;
             10.*)
               _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-undefined ${wl}dynamic_lookup'
               ;;
           esac
         fi
         ;;
      esac
      _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
      _LT_AC_TAGVAR(hardcode_direct, $1)=no
      _LT_AC_TAGVAR(hardcode_automatic, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=unsupported
      _LT_AC_TAGVAR(whole_archive_flag_spec, $1)=''
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes
    if test "$GCC" = yes ; then
    	output_verbose_link_cmd='echo'
        _LT_AC_TAGVAR(archive_cmds, $1)='$CC -dynamiclib $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags -install_name $rpath/$soname $verstring'
      _LT_AC_TAGVAR(module_cmds, $1)='$CC $allow_undefined_flag -o $lib -bundle $libobjs $deplibs$compiler_flags'
      # Don't fix this by using the ld -exported_symbols_list flag, it doesn't exist in older darwin lds
      _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC -dynamiclib $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags -install_name $rpath/$soname $verstring~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
      _LT_AC_TAGVAR(module_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC $allow_undefined_flag  -o $lib -bundle $libobjs $deplibs$compiler_flags~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
    else
      case $cc_basename in
        xlc*)
         output_verbose_link_cmd='echo'
         _LT_AC_TAGVAR(archive_cmds, $1)='$CC -qmkshrobj $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags ${wl}-install_name ${wl}`echo $rpath/$soname` $verstring'
         _LT_AC_TAGVAR(module_cmds, $1)='$CC $allow_undefined_flag -o $lib -bundle $libobjs $deplibs$compiler_flags'
          # Don't fix this by using the ld -exported_symbols_list flag, it doesn't exist in older darwin lds
         _LT_AC_TAGVAR(archive_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC -qmkshrobj $allow_undefined_flag -o $lib $libobjs $deplibs $compiler_flags ${wl}-install_name ${wl}$rpath/$soname $verstring~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          _LT_AC_TAGVAR(module_expsym_cmds, $1)='sed -e "s,#.*,," -e "s,^[    ]*,," -e "s,^\(..*\),_&," < $export_symbols > $output_objdir/${libname}-symbols.expsym~$CC $allow_undefined_flag  -o $lib -bundle $libobjs $deplibs$compiler_flags~nmedit -s $output_objdir/${libname}-symbols.expsym ${lib}'
          ;;
       *)
         _LT_AC_TAGVAR(ld_shlibs, $1)=no
          ;;
      esac
    fi
      ;;

    dgux*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    freebsd1*)
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
      ;;

    # FreeBSD 2.2.[012] allows us to include c++rt0.o to get C++ constructor
    # support.  Future versions do this automatically, but an explicit c++rt0.o
    # does not break anything, and helps significantly (at the cost of a little
    # extra space).
    freebsd2.2*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable -o $lib $libobjs $deplibs $linker_flags /usr/lib/c++rt0.o'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    # Unfortunately, older versions of FreeBSD 2 do not have this feature.
    freebsd2*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable -o $lib $libobjs $deplibs $linker_flags'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    # FreeBSD 3 and greater uses gcc -shared to do shared libraries.
    freebsd* | kfreebsd*-gnu | dragonfly*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -o $lib $libobjs $deplibs $compiler_flags'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    hpux9*)
      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/$soname~$CC -shared -fPIC ${wl}+b ${wl}$install_libdir -o $output_objdir/$soname $libobjs $deplibs $compiler_flags~test $output_objdir/$soname = $lib || mv $output_objdir/$soname $lib'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$rm $output_objdir/$soname~$LD -b +b $install_libdir -o $output_objdir/$soname $libobjs $deplibs $linker_flags~test $output_objdir/$soname = $lib || mv $output_objdir/$soname $lib'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}+b ${wl}$libdir'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes

      # hardcode_minus_L: Not really in the search PATH,
      # but as the default location of the library.
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
      ;;

    hpux10*)
      if test "$GCC" = yes -a "$with_gnu_ld" = no; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -fPIC ${wl}+h ${wl}$soname ${wl}+b ${wl}$install_libdir -o $lib $libobjs $deplibs $compiler_flags'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -b +h $soname +b $install_libdir -o $lib $libobjs $deplibs $linker_flags'
      fi
      if test "$with_gnu_ld" = no; then
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}+b ${wl}$libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	_LT_AC_TAGVAR(hardcode_direct, $1)=yes
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'

	# hardcode_minus_L: Not really in the search PATH,
	# but as the default location of the library.
	_LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      fi
      ;;

    hpux11*)
      if test "$GCC" = yes -a "$with_gnu_ld" = no; then
	case $host_cpu in
	hppa*64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}+h ${wl}$soname -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	ia64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}+h ${wl}$soname ${wl}+nodefaultrpath -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared -fPIC ${wl}+h ${wl}$soname ${wl}+b ${wl}$install_libdir -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	esac
      else
	case $host_cpu in
	hppa*64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	ia64*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname ${wl}+nodefaultrpath -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	*)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$CC -b ${wl}+h ${wl}$soname ${wl}+b ${wl}$install_libdir -o $lib $libobjs $deplibs $compiler_flags'
	  ;;
	esac
      fi
      if test "$with_gnu_ld" = no; then
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}+b ${wl}$libdir'
	_LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:

	case $host_cpu in
	hppa*64*|ia64*)
	  _LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)='+b $libdir'
	  _LT_AC_TAGVAR(hardcode_direct, $1)=no
	  _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
	  ;;
	*)
	  _LT_AC_TAGVAR(hardcode_direct, $1)=yes
	  _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'

	  # hardcode_minus_L: Not really in the search PATH,
	  # but as the default location of the library.
	  _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
	  ;;
	esac
      fi
      ;;

    irix5* | irix6* | nonstopux*)
      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $libobjs $deplibs $compiler_flags ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -shared $libobjs $deplibs $linker_flags -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec_ld, $1)='-rpath $libdir'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes
      ;;

    netbsd*)
      if echo __ELF__ | $CC -E - | grep __ELF__ >/dev/null; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable -o $lib $libobjs $deplibs $linker_flags'  # a.out
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -shared -o $lib $libobjs $deplibs $linker_flags'      # ELF
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    newsos6)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    openbsd*)
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      if test -z "`echo __ELF__ | $CC -E - | grep __ELF__`" || test "$host_os-$host_cpu" = "openbsd2.8-powerpc"; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared $pic_flag -o $lib $libobjs $deplibs $compiler_flags ${wl}-retain-symbols-file,$export_symbols'
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
	_LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-E'
      else
       case $host_os in
	 openbsd[[01]].* | openbsd2.[[0-7]] | openbsd2.[[0-7]].*)
	   _LT_AC_TAGVAR(archive_cmds, $1)='$LD -Bshareable -o $lib $libobjs $deplibs $linker_flags'
	   _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
	   ;;
	 *)
	   _LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared $pic_flag -o $lib $libobjs $deplibs $compiler_flags'
	   _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath,$libdir'
	   ;;
       esac
      fi
      ;;

    os2*)
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      _LT_AC_TAGVAR(allow_undefined_flag, $1)=unsupported
      _LT_AC_TAGVAR(archive_cmds, $1)='$echo "LIBRARY $libname INITINSTANCE" > $output_objdir/$libname.def~$echo "DESCRIPTION \"$libname\"" >> $output_objdir/$libname.def~$echo DATA >> $output_objdir/$libname.def~$echo " SINGLE NONSHARED" >> $output_objdir/$libname.def~$echo EXPORTS >> $output_objdir/$libname.def~emxexp $libobjs >> $output_objdir/$libname.def~$CC -Zdll -Zcrtdll -o $lib $libobjs $deplibs $compiler_flags $output_objdir/$libname.def'
      _LT_AC_TAGVAR(old_archive_From_new_cmds, $1)='emximp -o $output_objdir/$libname.a $output_objdir/$libname.def'
      ;;

    osf3*)
      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-expect_unresolved ${wl}\*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared${allow_undefined_flag} $libobjs $deplibs $compiler_flags ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'
      else
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' -expect_unresolved \*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -shared${allow_undefined_flag} $libobjs $deplibs $linker_flags -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
      ;;

    osf4* | osf5*)	# as osf3* with the addition of -msym flag
      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' ${wl}-expect_unresolved ${wl}\*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared${allow_undefined_flag} $libobjs $deplibs $compiler_flags ${wl}-msym ${wl}-soname ${wl}$soname `test -n "$verstring" && echo ${wl}-set_version ${wl}$verstring` ${wl}-update_registry ${wl}${output_objdir}/so_locations -o $lib'
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='${wl}-rpath ${wl}$libdir'
      else
	_LT_AC_TAGVAR(allow_undefined_flag, $1)=' -expect_unresolved \*'
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -shared${allow_undefined_flag} $libobjs $deplibs $linker_flags -msym -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='for i in `cat $export_symbols`; do printf "%s %s\\n" -exported_symbol "\$i" >> $lib.exp; done; echo "-hidden">> $lib.exp~
	$LD -shared${allow_undefined_flag} -input $lib.exp $linker_flags $libobjs $deplibs -soname $soname `test -n "$verstring" && echo -set_version $verstring` -update_registry ${output_objdir}/so_locations -o $lib~$rm $lib.exp'

	# Both c and cxx compiler support -rpath directly
	_LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-rpath $libdir'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=:
      ;;

    solaris*)
      _LT_AC_TAGVAR(no_undefined_flag, $1)=' -z text'
      if test "$GCC" = yes; then
	wlarc='${wl}'
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}-h ${wl}$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $lib.exp~cat $export_symbols | $SED -e "s/\(.*\)/\1;/" >> $lib.exp~$echo "local: *; };" >> $lib.exp~
	  $CC -shared ${wl}-M ${wl}$lib.exp ${wl}-h ${wl}$soname -o $lib $libobjs $deplibs $compiler_flags~$rm $lib.exp'
      else
	wlarc=''
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -G${allow_undefined_flag} -h $soname -o $lib $libobjs $deplibs $linker_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$echo "{ global:" > $lib.exp~cat $export_symbols | $SED -e "s/\(.*\)/\1;/" >> $lib.exp~$echo "local: *; };" >> $lib.exp~
  	$LD -G${allow_undefined_flag} -M $lib.exp -h $soname -o $lib $libobjs $deplibs $linker_flags~$rm $lib.exp'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-R$libdir'
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      case $host_os in
      solaris2.[[0-5]] | solaris2.[[0-5]].*) ;;
      *)
 	# The compiler driver will combine linker options so we
 	# cannot just pass the convience library names through
 	# without $wl, iff we do not link with $LD.
 	# Luckily, gcc supports the same syntax we need for Sun Studio.
 	# Supported since Solaris 2.6 (maybe 2.5.1?)
 	case $wlarc in
 	'')
 	  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='-z allextract$convenience -z defaultextract' ;;
 	*)
 	  _LT_AC_TAGVAR(whole_archive_flag_spec, $1)='${wl}-z ${wl}allextract`for conv in $convenience\"\"; do test -n \"$conv\" && new_convenience=\"$new_convenience,$conv\"; done; $echo \"$new_convenience\"` ${wl}-z ${wl}defaultextract' ;;
 	esac ;;
      esac
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes
      ;;

    sunos4*)
      if test "x$host_vendor" = xsequent; then
	# Use $CC to link under sequent, because it throws in some extra .o
	# files that make .init and .fini sections work.
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G ${wl}-h $soname -o $lib $libobjs $deplibs $compiler_flags'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -assert pure-text -Bstatic -o $lib $libobjs $deplibs $linker_flags'
      fi
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_direct, $1)=yes
      _LT_AC_TAGVAR(hardcode_minus_L, $1)=yes
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    sysv4)
      case $host_vendor in
	sni)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
	  _LT_AC_TAGVAR(hardcode_direct, $1)=yes # is this really true???
	;;
	siemens)
	  ## LD is ld it makes a PLAMLIB
	  ## CC just makes a GrossModule.
	  _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -o $lib $libobjs $deplibs $linker_flags'
	  _LT_AC_TAGVAR(reload_cmds, $1)='$CC -r -o $output$reload_objs'
	  _LT_AC_TAGVAR(hardcode_direct, $1)=no
        ;;
	motorola)
	  _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
	  _LT_AC_TAGVAR(hardcode_direct, $1)=no #Motorola manual says yes, but my tests say they lie
	;;
      esac
      runpath_var='LD_RUN_PATH'
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    sysv4.3*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='-Bexport'
      ;;

    sysv4*MP*)
      if test -d /usr/nec; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
	_LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
	runpath_var=LD_RUN_PATH
	hardcode_runpath_var=yes
	_LT_AC_TAGVAR(ld_shlibs, $1)=yes
      fi
      ;;

    sysv4*uw2* | sysv5OpenUNIX* | sysv5UnixWare7.[[01]].[[10]]* | unixware7*)
      _LT_AC_TAGVAR(no_undefined_flag, $1)='${wl}-z,text'
      _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      runpath_var='LD_RUN_PATH'

      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared ${wl}-Bexport:$export_symbols ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -G ${wl}-Bexport:$export_symbols ${wl}-h,$soname -o $lib $libobjs $deplibs $compiler_flags'
      fi
      ;;

    sysv5* | sco3.2v5* | sco5v6*)
      # Note: We can NOT use -z defs as we might desire, because we do not
      # link with -lc, and that would cause any symbols used from libc to
      # always be unresolved, which means just about no library would
      # ever link correctly.  If we're not using GNU ld we use -z text
      # though, which does catch some bad symbols but isn't as heavy-handed
      # as -z defs.
      _LT_AC_TAGVAR(no_undefined_flag, $1)='${wl}-z,text'
      _LT_AC_TAGVAR(allow_undefined_flag, $1)='${wl}-z,nodefs'
      _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='`test -z "$SCOABSPATH" && echo ${wl}-R,$libdir`'
      _LT_AC_TAGVAR(hardcode_libdir_separator, $1)=':'
      _LT_AC_TAGVAR(link_all_deplibs, $1)=yes
      _LT_AC_TAGVAR(export_dynamic_flag_spec, $1)='${wl}-Bexport'
      runpath_var='LD_RUN_PATH'

      if test "$GCC" = yes; then
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -shared ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -shared ${wl}-Bexport:$export_symbols ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
      else
	_LT_AC_TAGVAR(archive_cmds, $1)='$CC -G ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
	_LT_AC_TAGVAR(archive_expsym_cmds, $1)='$CC -G ${wl}-Bexport:$export_symbols ${wl}-h,\${SCOABSPATH:+${install_libdir}/}$soname -o $lib $libobjs $deplibs $compiler_flags'
      fi
      ;;

    uts4*)
      _LT_AC_TAGVAR(archive_cmds, $1)='$LD -G -h $soname -o $lib $libobjs $deplibs $linker_flags'
      _LT_AC_TAGVAR(hardcode_libdir_flag_spec, $1)='-L$libdir'
      _LT_AC_TAGVAR(hardcode_shlibpath_var, $1)=no
      ;;

    *)
      _LT_AC_TAGVAR(ld_shlibs, $1)=no
      ;;
    esac
  fi
])
AC_MSG_RESULT([$_LT_AC_TAGVAR(ld_shlibs, $1)])
test "$_LT_AC_TAGVAR(ld_shlibs, $1)" = no && can_build_shared=no

#
# Do we need to explicitly link libc?
#
case "x$_LT_AC_TAGVAR(archive_cmds_need_lc, $1)" in
x|xyes)
  # Assume -lc should be added
  _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=yes

  if test "$enable_shared" = yes && test "$GCC" = yes; then
    case $_LT_AC_TAGVAR(archive_cmds, $1) in
    *'~'*)
      # FIXME: we may have to deal with multi-command sequences.
      ;;
    '$CC '*)
      # Test whether the compiler implicitly links with -lc since on some
      # systems, -lgcc has to come before -lc. If gcc already passes -lc
      # to ld, don't add -lc before -lgcc.
      AC_MSG_CHECKING([whether -lc should be explicitly linked in])
      $rm conftest*
      printf "$lt_simple_compile_test_code" > conftest.$ac_ext

      if AC_TRY_EVAL(ac_compile) 2>conftest.err; then
        soname=conftest
        lib=conftest
        libobjs=conftest.$ac_objext
        deplibs=
        wl=$_LT_AC_TAGVAR(lt_prog_compiler_wl, $1)
	pic_flag=$_LT_AC_TAGVAR(lt_prog_compiler_pic, $1)
        compiler_flags=-v
        linker_flags=-v
        verstring=
        output_objdir=.
        libname=conftest
        lt_save_allow_undefined_flag=$_LT_AC_TAGVAR(allow_undefined_flag, $1)
        _LT_AC_TAGVAR(allow_undefined_flag, $1)=
        if AC_TRY_EVAL(_LT_AC_TAGVAR(archive_cmds, $1) 2\>\&1 \| grep \" -lc \" \>/dev/null 2\>\&1)
        then
	  _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=no
        else
	  _LT_AC_TAGVAR(archive_cmds_need_lc, $1)=yes
        fi
        _LT_AC_TAGVAR(allow_undefined_flag, $1)=$lt_save_allow_undefined_flag
      else
        cat conftest.err 1>&5
      fi
      $rm conftest*
      AC_MSG_RESULT([$_LT_AC_TAGVAR(archive_cmds_need_lc, $1)])
      ;;
    esac
  fi
  ;;
esac
])# AC_LIBTOOL_PROG_LD_SHLIBS


# _LT_AC_FILE_LTDLL_C
# -------------------
# Be careful that the start marker always follows a newline.
AC_DEFUN([_LT_AC_FILE_LTDLL_C], [
# /* ltdll.c starts here */
# #define WIN32_LEAN_AND_MEAN
# #include <windows.h>
# #undef WIN32_LEAN_AND_MEAN
# #include <stdio.h>
#
# #ifndef __CYGWIN__
# #  ifdef __CYGWIN32__
# #    define __CYGWIN__ __CYGWIN32__
# #  endif
# #endif
#
# #ifdef __cplusplus
# extern "C" {
# #endif
# BOOL APIENTRY DllMain (HINSTANCE hInst, DWORD reason, LPVOID reserved);
# #ifdef __cplusplus
# }
# #endif
#
# #ifdef __CYGWIN__
# #include <cygwin/cygwin_dll.h>
# DECLARE_CYGWIN_DLL( DllMain );
# #endif
# HINSTANCE __hDllInstance_base;
#
# BOOL APIENTRY
# DllMain (HINSTANCE hInst, DWORD reason, LPVOID reserved)
# {
#   __hDllInstance_base = hInst;
#   return TRUE;
# }
# /* ltdll.c ends here */
])# _LT_AC_FILE_LTDLL_C


# _LT_AC_TAGVAR(VARNAME, [TAGNAME])
# ---------------------------------
AC_DEFUN([_LT_AC_TAGVAR], [ifelse([$2], [], [$1], [$1_$2])])


# old names
AC_DEFUN([AM_PROG_LIBTOOL],   [AC_PROG_LIBTOOL])
AC_DEFUN([AM_ENABLE_SHARED],  [AC_ENABLE_SHARED($@)])
AC_DEFUN([AM_ENABLE_STATIC],  [AC_ENABLE_STATIC($@)])
AC_DEFUN([AM_DISABLE_SHARED], [AC_DISABLE_SHARED($@)])
AC_DEFUN([AM_DISABLE_STATIC], [AC_DISABLE_STATIC($@)])
AC_DEFUN([AM_PROG_LD],        [AC_PROG_LD])
AC_DEFUN([AM_PROG_NM],        [AC_PROG_NM])

# This is just to silence aclocal about the macro not being used
ifelse([AC_DISABLE_FAST_INSTALL])

AC_DEFUN([LT_AC_PROG_GCJ],
[AC_CHECK_TOOL(GCJ, gcj, no)
  test "x${GCJFLAGS+set}" = xset || GCJFLAGS="-g -O2"
  AC_SUBST(GCJFLAGS)
])

AC_DEFUN([LT_AC_PROG_RC],
[AC_CHECK_TOOL(RC, windres, no)
])

# NOTE: This macro has been submitted for inclusion into   #
#  GNU Autoconf as AC_PROG_SED.  When it is available in   #
#  a released version of Autoconf we should remove this    #
#  macro and use it instead.                               #
# LT_AC_PROG_SED
# --------------
# Check for a fully-functional sed program, that truncates
# as few characters as possible.  Prefer GNU sed if found.
AC_DEFUN([LT_AC_PROG_SED],
[AC_MSG_CHECKING([for a sed that does not truncate output])
AC_CACHE_VAL(lt_cv_path_SED,
[# Loop through the user's path and test for sed and gsed.
# Then use that list of sed's as ones to test for truncation.
as_save_IFS=$IFS; IFS=$PATH_SEPARATOR
for as_dir in $PATH
do
  IFS=$as_save_IFS
  test -z "$as_dir" && as_dir=.
  for lt_ac_prog in sed gsed; do
    for ac_exec_ext in '' $ac_executable_extensions; do
      if $as_executable_p "$as_dir/$lt_ac_prog$ac_exec_ext"; then
        lt_ac_sed_list="$lt_ac_sed_list $as_dir/$lt_ac_prog$ac_exec_ext"
      fi
    done
  done
done
lt_ac_max=0
lt_ac_count=0
# Add /usr/xpg4/bin/sed as it is typically found on Solaris
# along with /bin/sed that truncates output.
for lt_ac_sed in $lt_ac_sed_list /usr/xpg4/bin/sed; do
  test ! -f $lt_ac_sed && continue
  cat /dev/null > conftest.in
  lt_ac_count=0
  echo $ECHO_N "0123456789$ECHO_C" >conftest.in
  # Check for GNU sed and select it if it is found.
  if "$lt_ac_sed" --version 2>&1 < /dev/null | grep 'GNU' > /dev/null; then
    lt_cv_path_SED=$lt_ac_sed
    break
  fi
  while true; do
    cat conftest.in conftest.in >conftest.tmp
    mv conftest.tmp conftest.in
    cp conftest.in conftest.nl
    echo >>conftest.nl
    $lt_ac_sed -e 's/a$//' < conftest.nl >conftest.out || break
    cmp -s conftest.out conftest.nl || break
    # 10000 chars as input seems more than enough
    test $lt_ac_count -gt 10 && break
    lt_ac_count=`expr $lt_ac_count + 1`
    if test $lt_ac_count -gt $lt_ac_max; then
      lt_ac_max=$lt_ac_count
      lt_cv_path_SED=$lt_ac_sed
    fi
  done
done
])
SED=$lt_cv_path_SED
AC_MSG_RESULT([$SED])
])

# Add --enable-maintainer-mode option to configure.
# From Jim Meyering

# Copyright 1996, 1998, 2000, 2001, 2002  Free Software Foundation, Inc.

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

# serial 2

AC_DEFUN([AM_MAINTAINER_MODE],
[AC_MSG_CHECKING([whether to enable maintainer-specific portions of Makefiles])
  dnl maintainer-mode is disabled by default
  AC_ARG_ENABLE(maintainer-mode,
[  --enable-maintainer-mode enable make rules and dependencies not useful
                          (and sometimes confusing) to the casual installer],
      USE_MAINTAINER_MODE=$enableval,
      USE_MAINTAINER_MODE=no)
  AC_MSG_RESULT([$USE_MAINTAINER_MODE])
  AM_CONDITIONAL(MAINTAINER_MODE, [test $USE_MAINTAINER_MODE = yes])
  MAINT=$MAINTAINER_MODE_TRUE
  AC_SUBST(MAINT)dnl
]
)

AU_DEFUN([jm_MAINTAINER_MODE], [AM_MAINTAINER_MODE])

# SIM_AC_STRIP_EXIT_DECLARATION
#
# Autoconf adds a declaration of exit() to confdefs.h, which causes
# configure tests to fail later on when configuring for Visual C++
# compilers.  This macro edits out the exit-declaration (which we
# really don't need anyway) from the confdefs.h file.
#
# Typically, it should be inserted as early as possible, but after
# AC_PROG_CXX / AC_PROG_CXXCPP.
#
# 2007-05-30 larsa

AC_DEFUN([SIM_AC_STRIP_EXIT_DECLARATION], [
mv confdefs.h confdefs.old
egrep -v "void.*exit" confdefs.old >confdefs.h
rm -f confdefs.old
])


#
# This file contains misc "macro-containers" for stuff that is
# common between the various configure.ac files of the So* libraries.
#
# Note: none of the macros in this file is likely to be well designed
# and made for generic use in any project.
#

# Usage:
#   SIM_AC_SOGUI_SETUP_DOXYGEN( LIBRARY-NAME )
#
# Description:
#   Do the necessary configurations for setting up HTML and man-page
#   building by the Doxygen documentation system.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>
#   Lars J�rgen Aas, <larsa@sim.no>


AC_DEFUN([SIM_AC_SOGUI_SETUP_DOXYGEN],
[
AC_ARG_VAR([htmldir],
           [destination for HTML docs (default ${datadir}/$1/html)])

AC_ARG_ENABLE(html,
  AC_HELP_STRING([--enable-html], [build and install $1 HTML documentation]),
  [case $enableval in
    yes | true) want_html=yes ;;
    *)          want_html=no ;;
  esac],
  [want_html=no])

case $htmldir in
"")
  htmldir="$datadir/$1/html"
  ;;
/*)
  # do nothing - absolute path
  ;;
*)
  htmldir="\${prefix}/$htmldir"
  ;;
esac

AC_SUBST(htmldir)

AC_ARG_ENABLE(man,
  AC_HELP_STRING([--enable-man], [build and install $1 man pages]),
  [case $enableval in
    yes | true) want_man=yes ;;
    *)          want_man=no ;;
  esac],
  [want_man=no])

AC_ARG_VAR([htmlhelpdir],
           [destination for HTML-help docs (default ${datadir}/$1/htmlhelp)])

AC_ARG_ENABLE([html-help],
  AC_HELP_STRING([--enable-html-help], [build and install $1 HTML-help documentation]),
  [case $enableval in
    yes | true) want_html_help=yes ;;
    *)          want_html_help=no ;;
  esac],
  [want_html_help=no])

case $htmlhelpdir in
"")
  htmlhelpdir="$datadir/$1/htmlhelp"
  ;;
/*)
  # do nothing - absolute path
  ;;
*)
  htmlhelpdir="\${prefix}/$htmlhelpdir"
  ;;
esac

AC_SUBST(htmlhelpdir)

# We must turn on html-generation if html-help is turned on,
# but without affecting the setup of the BUILD_HTMLPAGES
# conditional, so HTML files aren't installed if you don't
# use --enable-html.  20031202 larsa
sogui_doc_html=`echo $want_html | tr '[a-z]' '[A-Z]'`
if test x"$want_html_help" = x"yes"; then
  sogui_doc_html=YES
fi

# Used in the Doxygen parameter file.
AC_SUBST([SOGUI_DOC_HTML], [$sogui_doc_html])
AC_SUBST([SOGUI_DOC_MAN], [`echo $want_man | tr '[a-z]' '[A-Z]'`])
AC_SUBST([SOGUI_DOC_HTML_HELP], [`echo $want_html_help | tr '[a-z]' '[A-Z]'`])

AC_SUBST([sogui_build_dir], [`pwd`])
AC_SUBST([sogui_src_dir], [`cd $srcdir; pwd`])
AC_SUBST([sogui_html_dir], [`pwd`/html])
AC_SUBST([sogui_html_help_dir], [`pwd`/htmlhelp])
AC_SUBST([sogui_man_dir], [`pwd`/man])

AM_CONDITIONAL(BUILD_MANPAGES, test x"$want_man" = x"yes")
AM_CONDITIONAL(BUILD_HTMLPAGES, test x"$want_html" = x"yes")
AM_CONDITIONAL(BUILD_HTMLHELP, test x"$want_html_help" = x"yes")

if test x"$want_man" = x"yes"; then
  SIM_AC_CONFIGURATION_SETTING([manpage installation], [$mandir])
fi

if test x"$want_html" = x"yes"; then
  SIM_AC_CONFIGURATION_SETTING([HTML installation], [$htmldir])
fi

sim_ac_hhc_exe=
case $host in
  *-cygwin) AC_PATH_PROG([sim_ac_hhc_exe], [hhc]) ;;
  *)        AC_SUBST([sim_ac_hhc_exe]) ;;
esac

if test x"$want_html_help" = x"yes"; then
  SIM_AC_CONFIGURATION_SETTING([HTML-help installation], [$htmlhelpdir])
  if test x"$sim_ac_hhc_exe" = x; then
    AC_MSG_WARN([Could not find the HTML Help Compiler (hhc) executable])
  fi
fi

if test x"$want_html" != xno -o x"$want_man" != xno -o x"$want_html_help" != xno; then
  SIM_AC_DOXYGEN_TOOL([], [SIM_AC_ERROR([no-doxygen])])

  AC_PATH_PROG(sim_ac_perl_exe, perl, false, $PATH)
  if test x"$sim_ac_perl_exe" = xfalse; then
    AC_MSG_WARN(Could not find the Perl executable)
  fi
fi

# path_tag is used to identify paths in docs/coin.doxygen that needs to be
# transformed using cygpath under cygwin.

case $host in
*-cygwin) path_tag="<PATH>" ;;
*)        path_tag= ;;
esac

AC_SUBST(path_tag)

]) # SIM_AC_SOGUI_SETUP_DOXYGEN()

# Usage:
#  SIM_AC_DOXYGEN_TOOL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
# Description:
#   This macro locates the doxygen executable. If it is found, the
#   variable $sim_ac_doxygen_exe is set to the full path- and
#   executable name (if not found, it is set to "false") and
#   $sim_ac_doxygen_avail is set to the version number (if not
#   found, it is set to "no").
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_DOXYGEN_TOOL], [
AC_ARG_WITH(
  [doxygen],
  AC_HELP_STRING([--with-doxygen=DIR],
                 [DIR is the directory where the doxygen executable resides]),
  [],
  [with_doxygen=yes])

sim_ac_doxygen_avail=no

if test x"$with_doxygen" != xno; then
  sim_ac_path=$PATH
  if test x"$with_doxygen" != xyes; then
    sim_ac_path=${with_doxygen}:$PATH
  fi

  AC_PATH_PROG([sim_ac_doxygen_exe], [doxygen], [false], [$sim_ac_path])
  if test x"$sim_ac_doxygen_exe" = xfalse; then
    ifelse([$2], , :, [$2])
  else
    sim_ac_doxygen_avail=`$sim_ac_doxygen_exe -help 2> /dev/null | head -1 | sed 's%[[^ ]]\+ [[^ ]]\+ %%'`
    $1
  fi
fi
])


# Usage:
#  SIM_AC_CHECK_X11([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 development system. If it is found, these
#  shell variables are set:
#
#    $sim_ac_x11_cppflags (extra flags the compiler needs for X11)
#    $sim_ac_x11_ldflags  (extra flags the linker needs for X11)
#    $sim_ac_x11_libs     (link libraries the linker needs for X11)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_x11_avail is set to "yes" if
#  the X11 development system is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_X11], [
AC_REQUIRE([AC_PATH_XTRA])

sim_ac_enable_darwin_x11=false

case $host_os in
  darwin* )
    AC_ARG_ENABLE([darwin-x11],
      AC_HELP_STRING([--enable-darwin-x11],
                     [enable X11 on Darwin [[default=--disable-darwin-x11]]]),
      [case "${enableval}" in
        yes | true) sim_ac_enable_darwin_x11=true ;;
        no | false) sim_ac_enable_darwin_x11=false; no_x=yes ;;
        *) SIM_AC_ENABLE_ERROR([--enable-darwin-x11]) ;;
      esac],
      [sim_ac_enable_darwin_x11=false; no_x=yes])
  ;;
esac

sim_ac_x11_avail=no

if test x"$no_x" != xyes; then

  #  *** DEBUG ***
  #  Keep this around, as it can be handy when testing on new systems.
  # echo "X_CFLAGS: $X_CFLAGS"
  # echo "X_PRE_LIBS: $X_PRE_LIBS"
  # echo "X_LIBS: $X_LIBS"
  # echo "X_EXTRA_LIBS: $X_EXTRA_LIBS"
  # echo
  # exit 0

  sim_ac_x11_cppflags="$X_CFLAGS"
  sim_ac_x11_ldflags="$X_LIBS"
  sim_ac_x11_libs="$X_PRE_LIBS -lX11 $X_EXTRA_LIBS"

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_x11_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_x11_ldflags"
  LIBS="$sim_ac_x11_libs $LIBS"

  AC_CACHE_CHECK(
    [whether we can link against X11],
    sim_cv_lib_x11_avail,
    [AC_TRY_LINK([#include <X11/Xlib.h>],
                 [(void)XOpenDisplay(0L);],
                 [sim_cv_lib_x11_avail=yes],
                 [sim_cv_lib_x11_avail=no])])

  if test x"$sim_cv_lib_x11_avail" = x"yes"; then
    sim_ac_x11_avail=yes
    $1
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    $2
  fi
fi
])

# Usage:
#  SIM_AC_CHECK_X11SHMEM([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 shared memory extension. If it is found, this
#  shell variable is set:
#
#    $sim_ac_x11shmem_libs   (link libraries the linker needs for X11 Shm)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11shmem_avail is set to "yes" if the X11 shared
#  memory extension is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)
#

AC_DEFUN([SIM_AC_CHECK_X11SHMEM], [

sim_ac_x11shmem_avail=no
sim_ac_x11shmem_libs="-lXext"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_x11shmem_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 shared memory extension is available],
  sim_cv_lib_x11shmem_avail,
  [AC_TRY_LINK([#include <X11/Xlib.h>
               #include <X11/extensions/XShm.h>],
               [(void)XShmQueryVersion(0L, 0L, 0L, 0L);],
               [sim_cv_lib_x11shmem_avail=yes],
               [sim_cv_lib_x11shmem_avail=no])])

if test x"$sim_cv_lib_x11shmem_avail" = xyes; then
  sim_ac_x11shmem_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X11MU([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 miscellaneous utilities extension. If it is
#  found, this shell variable is set:
#
#    $sim_ac_x11mu_libs   (link libraries the linker needs for X11 MU)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11mu_avail is set to "yes" if the X11 miscellaneous
#  utilities extension is found.
#  CPPFLAGS and LDFLAGS might also be modified, if library is found in a
#  non-standard location.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)

AC_DEFUN([SIM_AC_CHECK_X11MU], [

sim_ac_x11mu_avail=no
sim_ac_x11mu_cppflags=""
sim_ac_x11mu_ldflags=""
sim_ac_x11mu_libs="-lXmu"

sim_ac_save_libs=$LIBS
sim_ac_save_cppflags=$CPPFLAGS
sim_ac_save_ldflags=$LDFLAGS

LIBS="$sim_ac_x11mu_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 miscellaneous utilities library is available],
  sim_cv_lib_x11mu_avail,
  [AC_TRY_LINK([#include <X11/Xlib.h>
                #include <X11/Xmu/Xmu.h>
                #include <X11/Xmu/StdCmap.h>],
               [(void)XmuAllStandardColormaps(0L);],
               [sim_cv_lib_x11mu_avail=yes],
               [sim_cv_lib_x11mu_avail=maybe])])

if test x"$sim_cv_lib_x11mu_avail" = xyes; then
  sim_ac_x11mu_avail=yes
else
  # On HP-UX, Xmu might be located under /usr/contrib/X11R6/
  mudir=/usr/contrib/X11R6
  if test -d $mudir; then
    sim_ac_x11mu_cppflags="-I$mudir/include"
    sim_ac_x11mu_ldflags="-L$mudir/lib"
    CPPFLAGS="$sim_ac_x11mu_cppflags $CPPFLAGS"
    LDFLAGS="$sim_ac_x11mu_ldflags $LDFLAGS"

    AC_CACHE_CHECK(
      [once more whether the X11 miscellaneous utilities library is available],
      sim_cv_lib_x11mu_contrib_avail,
      [AC_TRY_LINK([#include <X11/Xlib.h>
                    #include <X11/Xmu/Xmu.h>
                    #include <X11/Xmu/StdCmap.h>],
                   [(void)XmuAllStandardColormaps(0L);],
                   [sim_cv_lib_x11mu_contrib_avail=yes],
                   [sim_cv_lib_x11mu_contrib_avail=no])])
    if test x"$sim_cv_lib_x11mu_contrib_avail" = xyes; then
      sim_ac_x11mu_avail=yes
    else
      sim_ac_x11mu_cppflags=""
      sim_ac_x11mu_ldflags=""
    fi
  fi
fi

if test x"$sim_ac_x11mu_avail" = xyes; then
  :
  $1
else
  LIBS=$sim_ac_save_libs
  CPPFLAGS=$sim_ac_save_cppflags
  LDFLAGS=$sim_ac_save_ldflags
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X11XID([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the X11 extension device library. Sets this
#  shell variable:
#
#    $sim_ac_x11xid_libs   (link libraries the linker needs for X11 XID)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_x11xid_avail is set to "yes" if the X11 extension
#  device library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#    * [mortene:20000122] make sure this work on MSWin (with
#      Cygwin installation)
#

AC_DEFUN([SIM_AC_CHECK_X11XID], [

sim_ac_x11xid_avail=no
sim_ac_x11xid_libs="-lXi"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_x11xid_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 extension device library is available],
  sim_cv_lib_x11xid_avail,
  [AC_TRY_LINK([#include <X11/extensions/XInput.h>],
               [(void)XOpenDevice(0L, 0);],
               [sim_cv_lib_x11xid_avail=yes],
               [sim_cv_lib_x11xid_avail=no])])

if test x"$sim_cv_lib_x11xid_avail" = x"yes"; then
  sim_ac_x11xid_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_AC_CHECK_X_INTRINSIC([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the Xt intrinsic library. Sets this shell variable:
#
#    $sim_ac_xt_libs   (link library the linker needs for X Intrinsic)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_xt_avail is set to "yes" if the X11 Intrinsic
#  library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_CHECK_X_INTRINSIC], [

sim_ac_xt_avail=no
sim_ac_xt_libs="-lXt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_xt_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 Intrinsic library is available],
  sim_cv_lib_xt_avail,
  [AC_TRY_LINK([#include <X11/Intrinsic.h>],
               [(void)XtVaCreateWidget("", 0L, 0L);],
               [sim_cv_lib_xt_avail=yes],
               [sim_cv_lib_xt_avail=no])])

if test x"$sim_cv_lib_xt_avail" = xyes; then
  sim_ac_xt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#   SIM_AC_CHECK_LIBXPM( [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND] )
#
# Description:
#   This macro checks for libXpm.
#
# Variables:
#   $sim_ac_xpm_avail      yes | no
#   $sim_ac_xpm_libs       [link-line libraries]
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_CHECK_LIBXPM], [

sim_ac_xpm_avail=no
sim_ac_xpm_libs="-lXpm"

AC_CACHE_CHECK(
  [whether libXpm is available],
  sim_cv_lib_xpm_avail,
  [sim_ac_save_libs=$LIBS
  LIBS="$sim_ac_xpm_libs $LIBS"
  AC_TRY_LINK([#include <X11/xpm.h>],
              [(void)XpmLibraryVersion();],
              [sim_cv_lib_xpm_avail=yes],
              [sim_cv_lib_xpm_avail=no])
  LIBS="$sim_ac_save_libs"])

if test x"$sim_cv_lib_xpm_avail" = x"yes"; then
  sim_ac_xpm_avail=yes
  LIBS="$sim_ac_xpm_libs $LIBS"
  $1
else
  ifelse([$2], , :, [$2])
fi
])


# Usage:
#  SIM_AC_CHECK_X11_XP([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the Xp library for printing functionality. Sets this
#  shell variable:
#
#    $sim_ac_xp_libs   (link library the linker needs for the Xp library)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_xp_avail is set to "yes" if the Xp library is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_CHECK_X11_XP], [
sim_ac_xp_avail=no
sim_ac_xp_libs="-lXp"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_xp_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 printing library is available],
  sim_cv_lib_xp_avail,
  [AC_TRY_LINK([#include <X11/extensions/Print.h>],
               [XpEndJob(0L);],
               [sim_cv_lib_xp_avail=yes],
               [sim_cv_lib_xp_avail=no])])

if test x"$sim_cv_lib_xp_avail" = xyes; then
  sim_ac_xp_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# SIM_AC_CHECK_X11_ATHENA( [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND] )

AC_DEFUN([SIM_AC_CHECK_X11_ATHENA], [
sim_ac_athena_avail=no
sim_ac_athena_libs="-lXaw"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_athena_libs $LIBS"

AC_CACHE_CHECK(
  [whether the X11 Athena widgets library is available],
  sim_cv_lib_athena_avail,
  [AC_TRY_LINK([#include <X11/Xfuncproto.h>
                #include <X11/Xaw/XawInit.h>],
               [XawInitializeWidgetSet();],
               [sim_cv_lib_athena_avail=yes],
               [sim_cv_lib_athena_avail=no])])

if test x"$sim_cv_lib_athena_avail" = xyes; then
  sim_ac_athena_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# SIM_AC_X11_READY( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_CHECK_X11_READY],
[AC_CACHE_CHECK(
  [if X11 linkage is ready],
  [sim_cv_x11_ready],
  [AC_TRY_LINK(
    [#include <X11/Xlib.h>],
    [(void)XOpenDisplay(0L);],
    [sim_cv_x11_ready=true],
    [sim_cv_x11_ready=false])])
if ${sim_cv_x11_ready}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_X11_READY()

# **************************************************************************
# SIM_AC_CHECK_HEADER_TLHELP32_H:
#
#   Check for tlhelp32.h.

AC_DEFUN([SIM_AC_CHECK_HEADER_TLHELP32_H], [
# At least with MSVC++, these headers needs windows.h to have been included first.
AC_CHECK_HEADERS([tlhelp32.h], [], [], [
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif
])
]) # SIM_AC_CHECK_HEADER_TLHELP32_H


# **************************************************************************
# SIM_AC_CHECK_FUNC__SPLITPATH:
#
#   Check for the _splitpath() macro/function.

AC_DEFUN([SIM_AC_CHECK_FUNC__SPLITPATH], [
AC_MSG_CHECKING([for _splitpath()])
AC_LINK_IFELSE(
[AC_LANG_PROGRAM([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif
#include <stdlib.h>
], [
  char filename[[100]];
  char drive[[100]];
  char dir[[100]];
  _splitpath(filename, drive, dir, NULL, NULL);
])], [
  AC_DEFINE([HAVE__SPLITPATH], 1, [define if the system has _splitpath()])
  AC_MSG_RESULT([found])
], [
  AC_MSG_RESULT([not found])
])
]) # SIM_AC_CHECK_FUNC__SPLITPATH


# **************************************************************************
# SIM_AC_CHECK_WIN32_API:
#
#   Check if the basic Win32 API is available.
#
#   Defines HAVE_WIN32_API, and sets sim_ac_have_win32_api to
#   either true or false.

AC_DEFUN([SIM_AC_CHECK_WIN32_API], [
sim_ac_have_win32_api=false
AC_MSG_CHECKING([if the Win32 API is available])
AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM([
#include <windows.h>
],
[
  /* These need to be as basic as possible. I.e. they should be
     available on all Windows versions. That means NT 3.1 and later,
     Win95 and later, WinCE 1.0 and later), their definitions should
     be available from windows.h, and should be linked in from kernel32.

     The ones below are otherwise rather random picks.
  */
  (void)CreateDirectory(NULL, NULL);
  (void)RemoveDirectory(NULL);
  SetLastError(0);
  (void)GetLastError();
  (void)LocalAlloc(0, 1);
  (void)LocalFree(NULL);
  return 0;
])],
[sim_ac_have_win32_api=true])

if $sim_ac_have_win32_api; then
  AC_DEFINE([HAVE_WIN32_API], [1], [Define if the Win32 API is available])
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
fi
]) # SIM_AC_CHECK_WIN32_API


# SIM_AC_CHECK_DL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------------------------------------
#
#  Try to find the dynamic link loader library. If it is found, these
#  shell variables are set:
#
#    $sim_ac_dl_cppflags (extra flags the compiler needs for dl lib)
#    $sim_ac_dl_ldflags  (extra flags the linker needs for dl lib)
#    $sim_ac_dl_libs     (link libraries the linker needs for dl lib)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_DL], [
AC_ARG_WITH(
  [dl],
  [AC_HELP_STRING(
    [--with-dl=DIR],
    [include support for the dynamic link loader library [default=yes]])],
  [],
  [with_dl=yes])

if test x"$with_dl" != xno; then
  if test x"$with_dl" != xyes; then
    sim_ac_dl_cppflags="-I${with_dl}/include"
    sim_ac_dl_ldflags="-L${with_dl}/lib"
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_dl_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_dl_ldflags"

  # Use SIM_AC_CHECK_HEADERS instead of .._HEADER to get the
  # HAVE_DLFCN_H symbol set up in config.h automatically.
  AC_CHECK_HEADERS([dlfcn.h])

  sim_ac_dl_avail=false

  AC_MSG_CHECKING([for the dl library])
  # At least under FreeBSD, dlopen() et al is part of the C library.
  # On HP-UX, dlopen() might reside in a library "svld" instead of "dl".
  for sim_ac_dl_libcheck in "" "-ldl" "-lsvld"; do
    if $sim_ac_dl_avail; then :; else
      LIBS="$sim_ac_dl_libcheck $sim_ac_save_libs"
      AC_TRY_LINK([
#ifdef HAVE_DLFCN_H
#include <dlfcn.h>
#endif /* HAVE_DLFCN_H */
],
                  [(void)dlopen(0L, 0); (void)dlsym(0L, "Gunners!"); (void)dlclose(0L);],
                  [sim_ac_dl_avail=true
                   sim_ac_dl_libs="$sim_ac_dl_libcheck"
                  ])
    fi
  done

  if $sim_ac_dl_avail; then
    if test x"$sim_ac_dl_libs" = x""; then
      AC_MSG_RESULT(yes)
    else
      AC_MSG_RESULT($sim_ac_dl_cppflags $sim_ac_dl_ldflags $sim_ac_dl_libs)
    fi
  else
    AC_MSG_RESULT(not available)
  fi

  if $sim_ac_dl_avail; then
    ifelse([$1], , :, [$1])
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
fi
])

# SIM_AC_CHECK_LOADLIBRARY([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -------------------------------------------------------------------
#
#  Try to use the Win32 dynamic link loader methods LoadLibrary(),
#  GetProcAddress() and FreeLibrary().
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_LOADLIBRARY], [
AC_ARG_ENABLE(
  [loadlibrary],
  [AC_HELP_STRING([--disable-loadlibrary], [don't use run-time link bindings under Win32])],
  [case $enableval in
  yes | true ) sim_ac_win32_loadlibrary=true ;;
  *) sim_ac_win32_loadlibrary=false ;;
  esac],
  [sim_ac_win32_loadlibrary=true])

if $sim_ac_win32_loadlibrary; then
  # Use SIM_AC_CHECK_HEADERS instead of .._HEADER to get the
  # HAVE_DLFCN_H symbol set up in config.h automatically.
  AC_CHECK_HEADERS([windows.h])

  AC_CACHE_CHECK([whether the Win32 LoadLibrary() method is available],
    sim_cv_lib_loadlibrary_avail,
    [AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
],
                 [(void)LoadLibrary(0L); (void)GetProcAddress(0L, 0L); (void)FreeLibrary(0L); ],
                 [sim_cv_lib_loadlibrary_avail=yes],
                 [sim_cv_lib_loadlibrary_avail=no])])

  if test x"$sim_cv_lib_loadlibrary_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
fi
])

# SIM_AC_CHECK_DLD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------------------------------------
#
#  Try to find the dynamic link loader library available on HP-UX 10.
#  If it is found, this shell variable is set:
#
#    $sim_ac_dld_libs     (link libraries the linker needs for dld lib)
#
#  The $LIBS var will also be modified accordingly.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_DLD], [
  sim_ac_dld_libs="-ldld"

  sim_ac_save_libs=$LIBS
  LIBS="$sim_ac_dld_libs $LIBS"

  AC_CACHE_CHECK([whether the DLD shared library loader is available],
    sim_cv_lib_dld_avail,
    [AC_TRY_LINK([#include <dl.h>],
                 [(void)shl_load("allyourbase", 0, 0L); (void)shl_findsym(0L, "arebelongtous", 0, 0L); (void)shl_unload((shl_t)0);],
                 [sim_cv_lib_dld_avail=yes],
                 [sim_cv_lib_dld_avail=no])])

  if test x"$sim_cv_lib_dld_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
])


# SIM_AC_CHECK_DYLD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -------------------------------------------------------------------
#
#  Try to use the Mac OS X dynamik link editor method
#  NSLookupAndBindSymbol()
#
# Author: Karin Kosina, <kyrah@sim.no>

AC_DEFUN([SIM_AC_CHECK_DYLD], [
AC_ARG_ENABLE(
  [dyld],
  [AC_HELP_STRING([--disable-dyld],
                  [don't use run-time link bindings under Mac OS X])],
  [case $enableval in
  yes | true ) sim_ac_dyld=true ;;
  *) sim_ac_dyld=false ;;
  esac],
  [sim_ac_dyld=true])

if $sim_ac_dyld; then

  AC_CHECK_HEADERS([mach-o/dyld.h])

  AC_CACHE_CHECK([whether we can use Mach-O dyld],
    sim_cv_dyld_avail,
    [AC_TRY_LINK([
#ifdef HAVE_MACH_O_DYLD_H
#include <mach-o/dyld.h>
#endif /* HAVE_MACH_O_DYLD_H */
],
                 [(void)NSLookupAndBindSymbol("foo");],
                 [sim_cv_dyld_avail=yes],
                 [sim_cv_dyld_avail=no])])

  if test x"$sim_cv_dyld_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
fi
])

# **************************************************************************
# Usage:
#   SIM_AC_CHECK_FINK ([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
# Description:
#   This macro checks for the availability of the Fink system. Fink is
#   dpkg-based distribution of UNIX tools for Mac OS X that installs
#   libraries and headers into /sw.
#
# Autoconf Variables:
#     $sim_ac_fink_avail       true | false
#     $sim_ac_fink_cppflags    (extra flags the preprocessor needs)
#     $sim_ac_fink_ldflags     (extra flags the linker needs)
#
# CPPFLAGS and LDFLAGS will also be set accordingly.
#
# Authors:
#   Karin Kosina <kyrah@sim.no>
#

AC_DEFUN([SIM_AC_CHECK_FINK], [
sim_ac_have_fink=false
AC_MSG_CHECKING([if fink is available])
if test -d /sw/include && test -d /sw/lib; then
  AC_MSG_RESULT([yes])
  sim_ac_have_fink=true
  sim_ac_fink_cppflags="-I/sw/include"
  sim_ac_fink_ldflags="-L/sw/lib"
  CPPFLAGS="$CPPFLAGS $sim_ac_fink_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_fink_ldflags"
else
  AC_MSG_RESULT([no])
  sim_ac_fink_cppflags=
  sim_ac_fink_ldflags=
fi

if $sim_ac_have_fink; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi

]) # SIM_AC_CHECK_FINK


# **************************************************************************
# SIM_AC_CHECK_HEADER_SILENT([header], [if-found], [if-not-found], [includes])
#
# This macro will not output any header checking information, nor will it
# cache the result, so it can be used multiple times on the same header,
# trying out different compiler options.

AC_DEFUN([SIM_AC_CHECK_HEADER_SILENT],
[AS_VAR_PUSHDEF([ac_Header], [ac_cv_header_$1])
m4_ifval([$4],
         [AC_COMPILE_IFELSE([AC_LANG_SOURCE([$4
@%:@include <$1>])],
                            [AS_VAR_SET(ac_Header, yes)],
                            [AS_VAR_SET(ac_Header, no)])],
         [AC_PREPROC_IFELSE([AC_LANG_SOURCE([@%:@include <$1>])],
                            [AS_VAR_SET(ac_Header, yes)],
                            [AS_VAR_SET(ac_Header, no)])])
AS_IF([test AS_VAR_GET(ac_Header) = yes], [$2], [$3])
AS_VAR_POPDEF([ac_Header])
])# SIM_AC_CHECK_HEADER_SILENT

# **************************************************************************
# SIM_AC_CHECK_HEADER_GL([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GL header file, and gives you the
# necessary CPPFLAGS in $sim_ac_gl_cppflags, and also sets the config.h
# defines HAVE_GL_GL_H or HAVE_OPENGL_GL_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GL],
[sim_ac_gl_header_avail=false
AC_MSG_CHECKING([how to include gl.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_gl_save_CPPFLAGS=$CPPFLAGS
  sim_ac_gl_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_gl_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_gl_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/gl.h], [
      sim_ac_gl_header_avail=true
      sim_ac_gl_header=OpenGL/gl.h
      AC_DEFINE([HAVE_OPENGL_GL_H], 1, [define if the GL header should be included as OpenGL/gl.h])
    ])
  fi

  if $sim_ac_gl_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/gl.h], [
      sim_ac_gl_header_avail=true
      sim_ac_gl_header=GL/gl.h
      AC_DEFINE([HAVE_GL_GL_H], 1, [define if the GL header should be included as GL/gl.h])
    ])
  fi

  CPPFLAGS="$sim_ac_gl_save_CPPFLAGS"
  if $sim_ac_gl_header_avail; then
    if test x"$sim_ac_gl_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_gl_header>])
    else
      AC_MSG_RESULT([$sim_ac_gl_cppflags, @%:@include <$sim_ac_gl_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GL

# **************************************************************************
# SIM_AC_CHECK_HEADER_GLU([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GLU header file, and gives you the
# necessary CPPFLAGS in $sim_ac_glu_cppflags, and also sets the config.h
# defines HAVE_GL_GLU_H or HAVE_OPENGL_GLU_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GLU],
[sim_ac_glu_header_avail=false
AC_MSG_CHECKING([how to include glu.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
  sim_ac_glu_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_glu_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_glu_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_glu_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/glu.h], [
      sim_ac_glu_header_avail=true
      sim_ac_glu_header=OpenGL/glu.h
      AC_DEFINE([HAVE_OPENGL_GLU_H], 1, [define if the GLU header should be included as OpenGL/glu.h])
    ])
  fi

  if $sim_ac_glu_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/glu.h], [
      sim_ac_glu_header_avail=true
      sim_ac_glu_header=GL/glu.h
      AC_DEFINE([HAVE_GL_GLU_H], 1, [define if the GLU header should be included as GL/glu.h])
    ])
  fi

  CPPFLAGS="$sim_ac_glu_save_CPPFLAGS"
  if $sim_ac_glu_header_avail; then
    if test x"$sim_ac_glu_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_glu_header>])
    else
      AC_MSG_RESULT([$sim_ac_glu_cppflags, @%:@include <$sim_ac_glu_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GLU

# **************************************************************************
# SIM_AC_CHECK_HEADER_GLEXT([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects how to include the GLEXT header file, and gives you the
# necessary CPPFLAGS in $sim_ac_glext_cppflags, and also sets the config.h
# defines HAVE_GL_GLEXT_H or HAVE_OPENGL_GLEXT_H if one of them is found.

AC_DEFUN([SIM_AC_CHECK_HEADER_GLEXT],
[sim_ac_glext_header_avail=false
AC_MSG_CHECKING([how to include glext.h])
if test x"$with_opengl" != x"no"; then
  sim_ac_glext_save_CPPFLAGS=$CPPFLAGS
  sim_ac_glext_cppflags=

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_glext_cppflags="-I${with_opengl}/include"
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_glext_cppflags=-I$sim_ac_gl_hpux/include
    fi
  fi

  # On Mac OS X, GL is part of the optional X11 fraemwork
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_gl_cppflags=-I$sim_ac_gl_darwin_x11/include
      fi
    fi
    ;;
  esac

  CPPFLAGS="$CPPFLAGS $sim_ac_glext_cppflags"

  # Mac OS X framework (no X11, -framework OpenGL)
  if $sim_ac_enable_darwin_x11; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([OpenGL/glext.h], [
      sim_ac_glext_header_avail=true
      sim_ac_glext_header=OpenGL/glext.h
      AC_DEFINE([HAVE_OPENGL_GLEXT_H], 1, [define if the GLEXT header should be included as OpenGL/glext.h])
    ])
  fi

  if $sim_ac_glext_header_avail; then :
  else
    SIM_AC_CHECK_HEADER_SILENT([GL/glext.h], [
      sim_ac_glext_header_avail=true
      sim_ac_glext_header=GL/glext.h
      AC_DEFINE([HAVE_GL_GLEXT_H], 1, [define if the GLEXT header should be included as GL/glext.h])
    ])
  fi

  CPPFLAGS="$sim_ac_glext_save_CPPFLAGS"
  if $sim_ac_glext_header_avail; then
    if test x"$sim_ac_glext_cppflags" = x""; then
      AC_MSG_RESULT([@%:@include <$sim_ac_glext_header>])
    else
      AC_MSG_RESULT([$sim_ac_glext_cppflags, @%:@include <$sim_ac_glext_header>])
    fi
    $1
  else
    AC_MSG_RESULT([not found])
    $2
  fi
else
  AC_MSG_RESULT([disabled])
  $2
fi
])# SIM_AC_CHECK_HEADER_GLEXT


# **************************************************************************
# SIM_AC_CHECK_OPENGL([IF-FOUND], [IF-NOT-FOUND])
#
# This macro detects whether or not it's possible to link against OpenGL
# (or Mesa), and gives you the necessary modifications to the
# pre-processor, compiler and linker environment in the envvars
#
#                $sim_ac_ogl_cppflags
#                $sim_ac_ogl_ldflags
#                $sim_ac_ogl_libs (OpenGL library and all dependencies)
#                $sim_ac_ogl_lib (basename of OpenGL library)
#
# The necessary extra options are also automatically added to CPPFLAGS,
# LDFLAGS and LIBS.
#
# Authors: <larsa@sim.no>, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_OPENGL], [

sim_ac_ogl_cppflags=
sim_ac_ogl_ldflags=
sim_ac_ogl_lib=
sim_ac_ogl_libs=

AC_ARG_WITH(
  [mesa],
  AC_HELP_STRING([--with-mesa],
                 [prefer MesaGL (if found) over OpenGL [[default=no]]]),
  [],
  [with_mesa=no])


sim_ac_ogl_glnames="GL opengl32"
sim_ac_ogl_mesaglnames=MesaGL

if test "x$with_mesa" = "xyes"; then
  sim_ac_ogl_first=$sim_ac_ogl_mesaglnames
  sim_ac_ogl_second=$sim_ac_ogl_glnames
else
  sim_ac_ogl_first=$sim_ac_ogl_glnames
  sim_ac_ogl_second=$sim_ac_ogl_mesaglnames
fi

AC_ARG_WITH(
  [opengl],
  AC_HELP_STRING([--with-opengl=DIR],
                 [OpenGL/Mesa installation directory]),
  [],
  [with_opengl=yes])

if test x"$with_opengl" != xno; then

  if test x"$with_opengl" != xyes && test x"$with_opengl" != x""; then
    sim_ac_ogl_ldflags=-L$with_opengl/lib
    # $sim_ac_ogl_cppflags is set up in the SIM_AC_CHECK_HEADER_GL
    # invocation further below.
  else
    # On HP-UX platforms, OpenGL headers and libraries are usually installed
    # at this location.
    sim_ac_gl_hpux=/opt/graphics/OpenGL
    if test -d $sim_ac_gl_hpux; then
      sim_ac_ogl_ldflags=-L$sim_ac_gl_hpux/lib
    fi
  fi

  sim_ac_use_framework_option=false;
  case $host_os in
  darwin*)
    AC_REQUIRE([SIM_AC_CHECK_X11])
    if $sim_ac_enable_darwin_x11; then
      # Use X11-based GL instead of OpenGL.framework when building against X11
      sim_ac_gl_darwin_x11=/usr/X11R6
      if test -d $sim_ac_gl_darwin_x11; then
        sim_ac_ogl_cppflags=-I$sim_ac_gl_darwin_x11/include
        sim_ac_ogl_ldflags=-L$sim_ac_gl_darwin_x11/lib
      fi
    else
      SIM_AC_CC_COMPILER_OPTION([-framework OpenGL], [sim_ac_use_framework_option=true])
    fi
    ;;
  esac

  if $sim_ac_use_framework_option; then
    sim_ac_ogl_ldflags="-Wl,-framework,OpenGL"
    sim_ac_ogl_lib=OpenGL
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_ogl_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_ogl_ldflags"

  SIM_AC_CHECK_HEADER_GL([CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags"],
                         [AC_MSG_WARN([could not find gl.h])])

  sim_ac_glchk_hit=false
  for sim_ac_tmp_outerloop in barebones withpthreads; do
    if $sim_ac_glchk_hit; then :; else

      sim_ac_oglchk_pthreadslib=""
      if test "$sim_ac_tmp_outerloop" = "withpthreads"; then
        AC_MSG_WARN([couldn't compile or link with OpenGL library -- trying with pthread library in place...])
        LIBS="$sim_ac_save_libs"
        SIM_AC_CHECK_PTHREAD([
          sim_ac_ogl_cppflags="$sim_ac_ogl_cppflags $sim_ac_pthread_cppflags"
          sim_ac_ogl_ldflags="$sim_ac_ogl_ldflags $sim_ac_pthread_ldflags"
          sim_ac_oglchk_pthreadslib="$sim_ac_pthread_libs"
          ],
          [AC_MSG_WARN([couldn't compile or link with pthread library])
          ])
      fi

      AC_MSG_CHECKING([for OpenGL library dev-kit])
      # Mac OS X uses nada (only LDFLAGS), which is why "" was set first
      for sim_ac_ogl_libcheck in "" $sim_ac_ogl_first $sim_ac_ogl_second; do
        if $sim_ac_glchk_hit; then :; else
          if test -n "${sim_ac_ogl_libcheck}"; then
            LIBS="-l${sim_ac_ogl_libcheck} $sim_ac_oglchk_pthreadslib $sim_ac_save_libs"
          else
            LIBS="$sim_ac_oglchk_pthreadslib $sim_ac_save_libs"
          fi
          AC_TRY_LINK(
            [#ifdef HAVE_WINDOWS_H
             #include <windows.h>
             #endif /* HAVE_WINDOWS_H */
             #ifdef HAVE_GL_GL_H
             #include <GL/gl.h>
             #else /* ! HAVE_GL_GL_H */
             #ifdef HAVE_OPENGL_GL_H
             /* Mac OS X */
             #include <OpenGL/gl.h>
             #endif /* HAVE_OPENGL_GL_H */
             #endif /* ! HAVE_GL_GL_H */
            ],
            [glPointSize(1.0f);],
            [
             sim_ac_glchk_hit=true
             sim_ac_ogl_libs=$sim_ac_oglchk_pthreadslib
             if test -n "${sim_ac_ogl_libcheck}"; then
               sim_ac_ogl_lib=$sim_ac_ogl_libcheck
               sim_ac_ogl_libs="-l${sim_ac_ogl_libcheck} $sim_ac_oglchk_pthreadslib"
             fi
            ]
          )
        fi
      done
      if $sim_ac_glchk_hit; then
        AC_MSG_RESULT($sim_ac_ogl_cppflags $sim_ac_ogl_ldflags $sim_ac_ogl_libs)
      else
        AC_MSG_RESULT([unresolved])
      fi
    fi
  done

  if $sim_ac_glchk_hit; then
    LIBS="$sim_ac_ogl_libs $sim_ac_save_libs"
    $1
  else
    CPPFLAGS="$sim_ac_save_cppflags"
    LDFLAGS="$sim_ac_save_ldflags"
    LIBS="$sim_ac_save_libs"
    $2
  fi
fi
])


# **************************************************************************
# SIM_AC_GLU_READY_IFELSE( [ACTION-IF-TRUE], [ACTION-IF-FALSE] )

AC_DEFUN([SIM_AC_GLU_READY_IFELSE], [
sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
SIM_AC_CHECK_HEADER_GLU(, [AC_MSG_WARN([could not find glu.h])])
if test x"$sim_ac_gl_cppflags" != x"$sim_ac_glu_cppflags"; then
  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags $sim_ac_glu_cppflags"
fi
AC_CACHE_CHECK(
  [if GLU is available as part of GL library],
  [sim_cv_glu_ready],
  [AC_TRY_LINK(
    [
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
    [
gluSphere(0L, 1.0, 1, 1);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
    [sim_cv_glu_ready=true],
    [sim_cv_glu_ready=false])])

if $sim_cv_glu_ready; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_GLU_READY_IFELSE()

# Usage:
#  SIM_AC_CHECK_GLU([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to use the OpenGL utility library; GLU. If it is found,
#  these shell variables are set:
#
#    $sim_ac_glu_cppflags (extra flags the compiler needs for GLU)
#    $sim_ac_glu_ldflags  (extra flags the linker needs for GLU)
#    $sim_ac_glu_libs     (link libraries the linker needs for GLU)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_glu_avail is set to "yes" if GLU
#  is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_GLU], [
sim_ac_glu_save_CPPFLAGS=$CPPFLAGS
SIM_AC_CHECK_HEADER_GLU(, [AC_MSG_WARN([could not find glu.h])])
if test x"$sim_ac_gl_cppflags" != x"$sim_ac_glu_cppflags"; then
  CPPFLAGS="$CPPFLAGS $sim_ac_gl_cppflags $sim_ac_glu_cppflags"
fi
sim_ac_glu_avail=no

# It's usually libGLU.so on UNIX systems and glu32.lib on MSWindows.
sim_ac_glu_names="-lGLU -lglu32"
sim_ac_glu_mesanames=-lMesaGLU

# with_mesa is set from the SIM_AC_CHECK_OPENGL macro.
if test "x$with_mesa" = "xyes"; then
  sim_ac_glu_first=$sim_ac_glu_mesanames
  sim_ac_glu_second=$sim_ac_glu_names
else
  sim_ac_glu_first=$sim_ac_glu_names
  sim_ac_glu_second=$sim_ac_glu_mesanames
fi

AC_ARG_WITH(
  [glu],
  AC_HELP_STRING([--with-glu=DIR],
                 [use the OpenGL utility library [[default=yes]]]),
  [],
  [with_glu=yes])

if test x"$with_glu" != xno; then
  if test x"$with_glu" != xyes; then
    # sim_ac_glu_cppflags="-I${with_glu}/include"
    sim_ac_glu_ldflags="-L${with_glu}/lib"
  fi

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_glu_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_glu_ldflags"

  AC_CACHE_CHECK(
    [whether GLU is available],
    sim_cv_lib_glu,
    [sim_cv_lib_glu=UNRESOLVED

    # Some platforms (like BeOS) have the GLU functionality in the GL
    # library (and no GLU library present).
    for sim_ac_glu_libcheck in "" $sim_ac_glu_first $sim_ac_glu_second; do
      if test "x$sim_cv_lib_glu" = "xUNRESOLVED"; then
        LIBS="$sim_ac_glu_libcheck $sim_ac_save_libs"
        AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
                    [
gluSphere(0L, 1.0, 1, 1);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
                    [sim_cv_lib_glu="$sim_ac_glu_libcheck"])
      fi
    done
    if test x"$sim_cv_lib_glu" = x"" &&
       test x`echo $LDFLAGS | grep -c -- "-Wl,-framework,OpenGL"` = x1; then
      # just for the visual representation on Mac OS X
      sim_cv_lib_glu="-Wl,-framework,OpenGL"
    fi
  ])

  LIBS="$sim_ac_save_libs"

  CPPFLAGS=$sim_ac_glu_save_CPPFLAGS
  if test "x$sim_cv_lib_glu" != "xUNRESOLVED"; then
    if test x"$sim_cv_lib_glu" = x"-Wl,-framework,OpenGL"; then
      sim_ac_glu_libs=""
    else
      sim_ac_glu_libs="$sim_cv_lib_glu"
    fi
    LIBS="$sim_ac_glu_libs $sim_ac_save_libs"
    sim_ac_glu_avail=yes
    $1
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    $2
  fi
fi
])


# Usage:
#  SIM_AC_GLU_NURBSOBJECT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find out whether the interface struct against the GLU
#  library NURBS functions is called "GLUnurbs" or "GLUnurbsObj".
#  (This seems to have changed somewhere between release 1.1 and
#  release 1.3 of GLU).
#
#  The variable $sim_ac_glu_nurbsobject is set to the correct name
#  if the nurbs structure is found.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_GLU_NURBSOBJECT], [
AC_CACHE_CHECK(
  [what structure to use in the GLU NURBS interface],
  sim_cv_func_glu_nurbsobject,
  [sim_cv_func_glu_nurbsobject=NONE
   for sim_ac_glu_structname in GLUnurbs GLUnurbsObj; do
    if test "$sim_cv_func_glu_nurbsobject" = NONE; then
      AC_TRY_LINK([
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif /* HAVE_WINDOWS_H */
#ifdef HAVE_GL_GL_H
#include <GL/gl.h>
#else
#ifdef HAVE_OPENGL_GL_H
#include <OpenGL/gl.h>
#endif
#endif
#ifdef HAVE_GL_GLU_H
#include <GL/glu.h>
#else
#ifdef HAVE_OPENGL_GLU_H
#include <OpenGL/glu.h>
#endif
#endif
],
                  [
$sim_ac_glu_structname * hepp = gluNewNurbsRenderer();
gluDeleteNurbsRenderer(hepp);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
                  [sim_cv_func_glu_nurbsobject=$sim_ac_glu_structname])
    fi
  done
])

if test $sim_cv_func_glu_nurbsobject = NONE; then
  sim_ac_glu_nurbsobject=
  $2
else
  sim_ac_glu_nurbsobject=$sim_cv_func_glu_nurbsobject
  $1
fi
])

# **************************************************************************
# SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether the OpenGL implementation includes the method
# glXGetCurrentDisplay().

AC_DEFUN([SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE], [
AC_CACHE_CHECK(
  [whether glXGetCurrentDisplay() is available],
  sim_cv_have_glxgetcurrentdisplay,
  AC_TRY_LINK([
#include <GL/gl.h>
#include <GL/glx.h>
],
[(void)glXGetCurrentDisplay();],
[sim_cv_have_glxgetcurrentdisplay=true],
[sim_cv_have_glxgetcurrentdisplay=false]))

if ${sim_cv_have_glxgetcurrentdisplay}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLXGETCURRENTDISPLAY_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_GLX_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether GLX is on the system.

AC_DEFUN([SIM_AC_HAVE_GLX_IFELSE], [
AC_CACHE_CHECK(
  [whether GLX is on the system],
  sim_cv_have_glx,
  AC_TRY_LINK(
    [
#include <GL/glx.h>
#include <GL/gl.h>
],
    [
(void)glXChooseVisual(0L, 0, 0L);
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
glEnd();
],
    [sim_cv_have_glx=true],
    [sim_cv_have_glx=false]))

if ${sim_cv_have_glx=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLX_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check for glXGetProcAddressARB() function.

AC_DEFUN([SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE], [
AC_CACHE_CHECK(
  [for glXGetProcAddressARB() function],
  sim_cv_have_glxgetprocaddressarb,
  AC_TRY_LINK(
    [
#include <GL/glx.h>
#include <GL/gl.h>
],
    [
      glXGetProcAddressARB((const GLubyte *)"glClearColor");
/* Defect JAGad01283 of HP's aCC compiler causes a link failure unless
   there is at least one "pure" OpenGL call along with GLU calls. */
      glEnd();
],
    [sim_cv_have_glxgetprocaddressarb=true],
    [sim_cv_have_glxgetprocaddressarb=false]))

if ${sim_cv_have_glxgetprocaddressarb=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_GLXGETPROCADDRESSARB_IFELSE()


# **************************************************************************
# SIM_AC_HAVE_WGL_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether WGL is on the system.
#
# This macro has one important side-effect: the variable
# sim_ac_wgl_libs will be set to the list of libraries
# needed to link with wgl*() functions.

AC_DEFUN([SIM_AC_HAVE_WGL_IFELSE], [
sim_ac_save_libs=$LIBS
sim_ac_wgl_libs="-lgdi32"
LIBS="$LIBS $sim_ac_wgl_libs"

AC_CACHE_CHECK(
  [whether WGL is on the system],
  sim_cv_have_wgl,
  AC_TRY_LINK(
    [
#include <windows.h>
#include <GL/gl.h>
],
    [(void)wglCreateContext(0L);],
    [sim_cv_have_wgl=true],
    [sim_cv_have_wgl=false]))

LIBS=$sim_ac_save_libs
if ${sim_cv_have_wgl=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_WGL_IFELSE()

# **************************************************************************
# SIM_AC_HAVE_AGL_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Check whether AGL is on the system.

AC_DEFUN([SIM_AC_HAVE_AGL_IFELSE], [
sim_ac_save_ldflags=$LDFLAGS
sim_ac_agl_ldflags="-Wl,-framework,ApplicationServices -Wl,-framework,AGL"

LDFLAGS="$LDFLAGS $sim_ac_agl_ldflags"

# see comment in Coin/src/glue/gl_agl.c: regarding __CARBONSOUND__ define

AC_CACHE_CHECK(
  [whether AGL is on the system],
  sim_cv_have_agl,
  AC_TRY_LINK(
    [#include <AGL/agl.h>
     #define __CARBONSOUND__
     #include <Carbon/Carbon.h>],
    [aglGetCurrentContext();],
    [sim_cv_have_agl=true],
    [sim_cv_have_agl=false]))

LDFLAGS=$sim_ac_save_ldflags
if ${sim_cv_have_agl=false}; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_AGL_IFELSE()


AC_DEFUN([SIM_AC_HAVE_AGL_PBUFFER], [
  AC_CACHE_CHECK([whether we can use AGL pBuffers],
    sim_cv_agl_pbuffer_avail,
    [AC_TRY_LINK([ #include <AGL/agl.h> ],
                 [AGLPbuffer pbuffer;],
                 [sim_cv_agl_pbuffer_avail=yes],
                 [sim_cv_agl_pbuffer_avail=no])])

  if test x"$sim_cv_agl_pbuffer_avail" = xyes; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
])


# Usage:
#  SIM_AC_CHECK_PTHREAD([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the PTHREAD development system. If it is found, these
#  shell variables are set:
#
#    $sim_ac_pthread_cppflags (extra flags the compiler needs for pthread)
#    $sim_ac_pthread_ldflags  (extra flags the linker needs for pthread)
#    $sim_ac_pthread_libs     (link libraries the linker needs for pthread)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_pthread_avail is set to "true" if the
#  pthread development system is found.
#
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_PTHREAD], [

AC_ARG_WITH(
  [pthread],
  AC_HELP_STRING([--with-pthread=DIR],
                 [pthread installation directory]),
  [],
  [with_pthread=yes])

sim_ac_pthread_avail=no

if test x"$with_pthread" != xno; then
  if test x"$with_pthread" != xyes; then
    sim_ac_pthread_cppflags="-I${with_pthread}/include"
    sim_ac_pthread_ldflags="-L${with_pthread}/lib"
  fi

  # FIXME: should investigate and document the exact meaning of
  # the _REENTRANT flag. larsa's commit message mentions
  # "glibc-doc/FAQ.threads.html". Also, kintel points to the
  # comp.programming.thrads FAQ, which has an entry on the
  # _REENTRANT define.
  #
  # Preferably, it should only be set up when really needed
  # (as detected by some other configure check).
  #
  # 20030306 mortene.
  sim_ac_pthread_cppflags="-D_REENTRANT ${sim_ac_pthread_cppflags}"

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  CPPFLAGS="$CPPFLAGS $sim_ac_pthread_cppflags"
  LDFLAGS="$LDFLAGS $sim_ac_pthread_ldflags"

  sim_ac_pthread_avail=false

  AC_MSG_CHECKING([for POSIX threads])
  # At least under FreeBSD, we link to pthreads library with -pthread.
  for sim_ac_pthreads_libcheck in "-lpthread" "-pthread"; do
    if $sim_ac_pthread_avail; then :; else
      LIBS="$sim_ac_pthreads_libcheck $sim_ac_save_libs"
      AC_TRY_LINK([#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#include <pthread.h>],
                  [(void)pthread_create(0L, 0L, 0L, 0L);],
                  [sim_ac_pthread_avail=true
                   sim_ac_pthread_libs="$sim_ac_pthreads_libcheck"
                  ])
    fi
  done

  if $sim_ac_pthread_avail; then
    AC_MSG_RESULT($sim_ac_pthread_cppflags $sim_ac_pthread_ldflags $sim_ac_pthread_libs)
  else
    AC_MSG_RESULT(not available)
  fi

  if $sim_ac_pthread_avail; then
    AC_CACHE_CHECK(
      [the struct timespec resolution],
      sim_cv_lib_pthread_timespec_resolution,
      [AC_TRY_COMPILE([#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#include <pthread.h>],
                      [struct timespec timeout;
                       timeout.tv_nsec = 0;],
                      [sim_cv_lib_pthread_timespec_resolution=nsecs],
                      [sim_cv_lib_pthread_timespec_resolution=usecs])])
    if test x"$sim_cv_lib_pthread_timespec_resolution" = x"nsecs"; then
      AC_DEFINE([HAVE_PTHREAD_TIMESPEC_NSEC], 1, [define if pthread's struct timespec uses nsecs and not usecs])
    fi
  fi

  if $sim_ac_pthread_avail; then
    ifelse([$1], , :, [$1])
  else
    CPPFLAGS=$sim_ac_save_cppflags
    LDFLAGS=$sim_ac_save_ldflags
    LIBS=$sim_ac_save_libs
    ifelse([$2], , :, [$2])
  fi
fi
]) # SIM_AC_CHECK_PTHREAD

# Usage:
#  SIM_CHECK_OIV_XT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link against the Xt GUI glue library for
#  the Open Inventor development system. Sets this shell
#  variable:
#
#    $sim_ac_oivxt_libs     (link libraries the linker needs for InventorXt)
#
#  The LIBS variable will also be modified accordingly. In addition,
#  the variable $sim_ac_oivxt_avail is set to "yes" if the Xt glue
#  library for the Open Inventor development system is found.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>.
#   Lars J. Aas, <larsa@sim.no>.
#

AC_DEFUN([SIM_CHECK_OIV_XT], [
sim_ac_oivxt_avail=no

sim_ac_oivxt_libs="-lInventorXt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_oivxt_libs $LIBS"

AC_CACHE_CHECK([for Xt glue library in the Open Inventor developer kit],
  sim_cv_lib_oivxt_avail,
  [AC_TRY_LINK([#include <Inventor/Xt/SoXt.h>],
               [(void)SoXt::init(0L, 0L);],
               [sim_cv_lib_oivxt_avail=yes],
               [sim_cv_lib_oivxt_avail=no])])

if test x"$sim_cv_lib_oivxt_avail" = xyes; then
  sim_ac_oivxt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# Usage:
#  SIM_CHECK_OIV_QT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to compile and link against the Qt GUI glue library for
#  the Open Inventor development system. Sets this shell
#  variable:
#
#    $sim_ac_oivqt_libs     (link libraries the linker needs for InventorQt)
#
#  The LIBS variable will also be modified accordingly. In addition,
#  the variable $sim_ac_oivqt_avail is set to "yes" if the Qt glue
#  library for the Open Inventor development system is found.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>.
#   Lars J. Aas, <larsa@sim.no>.
#

AC_DEFUN([SIM_CHECK_OIV_QT], [
sim_ac_oivqt_avail=no

sim_ac_oivqt_libs="-lInventorQt"
sim_ac_save_libs=$LIBS
LIBS="$sim_ac_oivqt_libs $LIBS"

AC_CACHE_CHECK([for InventorQt glue library],
  sim_cv_lib_oivqt_avail,
  [AC_TRY_LINK([#include <Inventor/Qt/SoQt.h>],
               [(void)SoQt::init(0L, 0L);],
               [sim_cv_lib_oivqt_avail=yes],
               [sim_cv_lib_oivqt_avail=no])])

if test x"$sim_cv_lib_oivqt_avail" = xyes; then
  sim_ac_oivqt_avail=yes
  $1
else
  LIBS=$sim_ac_save_libs
  $2
fi
])

# **************************************************************************
# SIM_AC_WITH_INVENTOR
# This macro just ensures the --with-inventor option is used.

AC_DEFUN([SIM_AC_WITH_INVENTOR], [
: ${sim_ac_want_inventor=false}
AC_ARG_WITH([inventor],
  AC_HELP_STRING([--with-inventor], [use SGI or TGS Open Inventor rather than Coin [[default=no]]])
AC_HELP_STRING([--with-inventor=PATH], [specify where SGI or TGS Open Inventor resides]),
  [case "$withval" in
  no)  sim_ac_want_inventor=false ;;
  yes) sim_ac_want_inventor=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventor_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventor=true; sim_ac_inventor_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTOR

# **************************************************************************
# SIM_AC_WITH_INVENTORXT
# This macro just ensures the --with-inventor-xt option is used.

AC_DEFUN([SIM_AC_WITH_INVENTORXT], [
: ${sim_ac_want_inventorxt=true}
AC_ARG_WITH([inventor-xt],
  AC_HELP_STRING([--with-inventor-xt], [use InventorXt when using SGI or TGS Open Inventor [[default=yes]]])
AC_HELP_STRING([--with-inventor-xt=PATH], [specify where InventorXt resides]),
  [case "$withval" in
  no)  sim_ac_want_inventorxt=false ;;
  yes) sim_ac_want_inventorxt=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventorxt_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventorxt=true; sim_ac_inventorxt_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTORXT

# **************************************************************************
# SIM_AC_WITH_INVENTORQT
# This macro just ensures the --with-inventor-qt option is used.

AC_DEFUN([SIM_AC_WITH_INVENTORQT], [
: ${sim_ac_want_inventorqt=false}
AC_ARG_WITH([inventor-qt],
  AC_HELP_STRING([--with-inventor-qt], [use InventorQt when using SGI or TGS Open Inventor [[default=yes]]])
AC_HELP_STRING([--with-inventor-qt=PATH], [specify where InventorQt resides]),
  [case "$withval" in
  no)  sim_ac_want_inventorqt=false ;;
  yes) sim_ac_want_inventorqt=true
       test -n "$OIVHOME" &&
         SIM_AC_DEBACKSLASH(sim_ac_inventorqt_path, "$OIVHOME") ;;
  *)   sim_ac_want_inventorqt=true; sim_ac_inventorqt_path="$withval" ;;
  esac])
]) # SIM_AC_WITH_INVENTORQT

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE

AC_DEFUN([SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE], [
AC_REQUIRE([SIM_AC_WITH_INVENTOR])
AC_REQUIRE([SIM_AC_WITH_INVENTORXT])
AC_REQUIRE([SIM_AC_WITH_INVENTORQT])

if $sim_ac_want_inventor; then
  sim_ac_inventor_image_save_CPPFLAGS="$CPPFLAGS"
  sim_ac_inventor_image_save_LDFLAGS="$LDFLAGS"
  sim_ac_inventor_image_save_LIBS="$LIBS"

  if test s${sim_ac_inventor_path+et} = set; then
    sim_ac_inventor_image_cppflags="-I${sim_ac_inventor_path}/include"
    sim_ac_inventor_image_ldflags="-L${sim_ac_inventor_path}/lib"
  fi
  sim_ac_inventor_image_libs="-limage"

  AC_CACHE_CHECK(
    [if linking with libimage is possible],
    sim_cv_have_inventor_image,
    [
    CPPFLAGS="$sim_ac_inventor_image_cppflags $CPPFLAGS"
    LDFLAGS="$sim_ac_inventor_image_ldflags $LDFLAGS"
    LIBS="$sim_ac_inventor_image_libs $LIBS"
    AC_TRY_LINK(
      [],
      [],
      [sim_cv_have_inventor_image=true],
      [sim_cv_have_inventor_image=false])
    CPPFLAGS="$sim_ac_inventor_image_save_CPPFLAGS"
    LDFLAGS="$sim_ac_inventor_image_save_LDFLAGS"
    LIBS="$sim_ac_inventor_image_save_LIBS"
    ])

  if $sim_cv_have_inventor_image; then
    ifelse([$1], , :, [$1])
  else
    ifelse([$2], , :, [$2])
  fi
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_IFELSE( [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND] ] )
#
# Defines $sim_ac_inventor_cppflags, $sim_ac_inventor_ldflags and
# $sim_ac_inventor_libs.

AC_DEFUN([SIM_AC_HAVE_INVENTOR_IFELSE], [
AC_REQUIRE([SIM_AC_WITH_INVENTOR])
AC_REQUIRE([SIM_AC_WITH_INVENTORXT])
AC_REQUIRE([SIM_AC_WITH_INVENTORQT])

if $sim_ac_want_inventor; then
  sim_ac_save_CPPFLAGS="$CPPFLAGS"
  sim_ac_save_LDFLAGS="$LDFLAGS"
  sim_ac_save_LIBS="$LIBS"

  SIM_AC_HAVE_INVENTOR_IMAGE_IFELSE([
    sim_ac_inventor_cppflags="$sim_ac_inventor_image_cppflags"
    sim_ac_inventor_ldflags="$sim_ac_inventor_image_ldflags"
  ], [
    if test s${sim_ac_inventor_path+et} = set; then
      sim_ac_inventor_cppflags="-I${sim_ac_inventor_path}/include"
      sim_ac_inventor_ldflags="-L${sim_ac_inventor_path}/lib"
    fi
    sim_ac_inventor_image_libs=
  ])

  # Let's at least test for "libInventor".
  sim_ac_inventor_chk_libs="-lInventor"
  sim_ac_inventor_libs=UNRESOLVED

  CPPFLAGS="$sim_ac_inventor_cppflags $CPPFLAGS"

  AC_CHECK_HEADER([Inventor/SbBasic.h],
                  [sim_ac_sbbasic=true],
                  [AC_MSG_WARN([header file Inventor/SbBasic.h not found])
                   sim_ac_sbbasic=false])

  if $sim_ac_sbbasic; then
  AC_MSG_CHECKING([the Open Inventor version])
  # See if we can get the TGS_VERSION number for including a
  # check for inv{ver}.lib.
  # TGS did not include TGS_VERSION before 2.6, so this may have to be
  # back-ported to SO_VERSION+SO_REVISION usage.  larsa 2001-07-25
    cat <<EOF > conftest.c
#include <Inventor/SbBasic.h>
#ifdef __COIN__
#error Testing for original Open Inventor, but found Coin...
#endif
PeekInventorVersion: TGS_VERSION
EOF
  if test x"$CPP" = x; then
    AC_MSG_ERROR([cpp not detected - aborting.  notify maintainer at coin-support@coin3d.org.])
  fi
  echo "$CPP $CPPFLAGS conftest.c" >&AS_MESSAGE_LOG_FD
  tgs_version_line=`$CPP $CPPFLAGS conftest.c 2>&AS_MESSAGE_LOG_FD | grep "^PeekInventorVersion"`
  if test x"$tgs_version_line" = x; then
    echo "second try..." >&AS_MESSAGE_LOG_FD
    echo "$CPP -DWIN32 $CPPFLAGS conftest.c" >&AS_MESSAGE_LOG_FD
    tgs_version_line=`$CPP -DWIN32 $CPPFLAGS conftest.c 2>&AS_MESSAGE_LOG_FD | grep "^PeekInventorVersion"`
  fi
  rm -f conftest.c
  tgs_version=`echo $tgs_version_line | cut -c22-24`
  tgs_suffix=
  if test x"${enable_inventor_debug+set}" = xset &&
     test x"${enable_inventor_debug}" = xyes; then
    tgs_suffix=d
  fi
  if test x"$tgs_version" != xTGS; then
    sim_ac_inventor_chk_libs="$sim_ac_inventor_chk_libs -linv$tgs_version$tgs_suffix"
    tgs_version_string=`echo $tgs_version | sed 's/\(.\)\(.\)\(.\)/\1.\2.\3/g'`
    AC_MSG_RESULT([TGS Open Inventor v$tgs_version_string])
  else
    AC_MSG_RESULT([probably SGI or older TGS Open Inventor])
  fi

  AC_MSG_CHECKING([for Open Inventor library])

  for sim_ac_iv_cppflags_loop in "" "-DWIN32"; do
    # Trying with no libraries first, as TGS Inventor uses pragmas in
    # a header file to notify MSVC of what to link with.
    for sim_ac_iv_libcheck in "" $sim_ac_inventor_chk_libs; do
      if test "x$sim_ac_inventor_libs" = "xUNRESOLVED"; then
        CPPFLAGS="$sim_ac_iv_cppflags_loop $sim_ac_inventor_cppflags $sim_ac_save_CPPFLAGS"
        LDFLAGS="$sim_ac_inventor_ldflags $sim_ac_save_LDFLAGS"
        LIBS="$sim_ac_iv_libcheck $sim_ac_inventor_image_libs $sim_ac_save_LIBS"
        AC_TRY_LINK([#include <Inventor/SoDB.h>],
                    [SoDB::init();],
                    [sim_ac_inventor_libs="$sim_ac_iv_libcheck $sim_ac_inventor_image_libs"
                     sim_ac_inventor_cppflags="$sim_ac_iv_cppflags_loop $sim_ac_inventor_cppflags"])
      fi
    done
  done

  if test "x$sim_ac_inventor_libs" != "xUNRESOLVED"; then
    AC_MSG_RESULT($sim_ac_inventor_cppflags $sim_ac_inventor_ldflags $sim_ac_inventor_libs)
  else
    AC_MSG_RESULT([unavailable])
  fi

  fi # sim_ac_sbbasic = TRUE

  CPPFLAGS="$sim_ac_save_CPPFLAGS"
  LDFLAGS="$sim_ac_save_LDFLAGS"
  LIBS="$sim_ac_save_LIBS"

  if test "x$sim_ac_inventor_libs" != "xUNRESOLVED"; then
    :
    $1
  else
    :
    $2
  fi
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_INVENTOR_IFELSE

# **************************************************************************

# utility macros:
AC_DEFUN([AC_TOUPPER], [translit([$1], [[a-z]], [[A-Z]])])
AC_DEFUN([AC_TOLOWER], [translit([$1], [[A-Z]], [[a-z]])])

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_NODE( NODE, [ACTION-IF-FOUND] [, ACTION-IF-NOT-FOUND])
#
# Check whether or not the given NODE is available in the Open Inventor
# development system.  If so, the HAVE_<NODE> define is set.
#
# Authors:
#   Lars J. Aas  <larsa@sim.no>
#   Morten Eriksen  <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_NODE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$1])_node)],
       [pushdef([DEFINE_VARIABLE], HAVE_[]AC_TOUPPER([$1]))])
AC_CACHE_CHECK(
  [if the Open Inventor $1 node is available],
  cache_variable,
  [AC_TRY_LINK(
    [#include <Inventor/nodes/$1.h>],
    [$1 * p = new $1;],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of the Open Inventor $1 node])
  $2
else
  ifelse([$3], , :, [$3])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_NODE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_VRMLNODE( VRLMNODE, [ACTION-IF-FOUND] [, ACTION-IF-NOT-FOUND])
#
# Check whether or not the given VRMLNODE is available in the Open Inventor
# development system.  If so, the HAVE_<VRMLNODE> define is set.
#
# Authors:
#   Lars J. Aas  <larsa@sim.no>
#   Morten Eriksen  <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_VRMLNODE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$1])_vrmlnode)],
       [pushdef([DEFINE_VARIABLE], HAVE_[]AC_TOUPPER([$1]))])
AC_CACHE_CHECK(
  [if the Open Inventor $1 VRML node is available],
  cache_variable,
  [AC_TRY_LINK(
    [#include <Inventor/VRMLnodes/$1.h>],
    [$1 * p = new $1;],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of the Open Inventor $1 VRML node])
  $2
else
  ifelse([$3], , :, [$3])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_VRMLNODE

# **************************************************************************
# SIM_AC_HAVE_INVENTOR_FEATURE(MESSAGE, HEADERS, BODY, DEFINE
#                              [, ACTION-IF-FOUND[, ACTION-IF-NOT-FOUND]])
#
# Authors:
#   Morten Eriksen <mortene@sim.no>

AC_DEFUN([SIM_AC_HAVE_INVENTOR_FEATURE],
[m4_do([pushdef([cache_variable], sim_cv_have_oiv_[]AC_TOLOWER([$4]))],
       [pushdef([DEFINE_VARIABLE], AC_TOUPPER([$4]))])
AC_CACHE_CHECK(
  [$1],
  cache_variable,
  [AC_TRY_LINK(
    [$2],
    [$3],
    cache_variable=true,
    cache_variable=false)])

if $cache_variable; then
  AC_DEFINE(DEFINE_VARIABLE, 1, [Define to enable use of Inventor feature])
  $5
else
  ifelse([$6], , :, [$6])
fi
m4_do([popdef([cache_variable])],
      [popdef([DEFINE_VARIABLE])])
]) # SIM_AC_HAVE_INVENTOR_FEATURE

# **************************************************************************
# SIM_AC_INVENTOR_EXTENSIONS( ACTION )
#
# This macro adds an "--with-iv-extensions=..." option to configure, that
# enabes the configurer to enable extensions in third-party libraries to
# be initialized by the library by default.  The configure-option argument
# must be a comma-separated list of link library path options, link library
# options and class-names.
#
# Sample usage is
#   ./configure --with-iv-extension=-L/tmp/mynodes,-lmynodes,MyNode1,MyNode2
#
# TODO:
#   * check if __declspec(dllimport) is needed on Cygwin

AC_DEFUN([SIM_AC_INVENTOR_EXTENSIONS],
[
AC_ARG_WITH(
  [iv-extensions],
  [AC_HELP_STRING([--with-iv-extensions=extensions], [enable extra open inventor extensions])],
  [sim_ac_iv_try_extensions=$withval])

sim_ac_iv_extension_save_LIBS=$LIBS

sim_ac_iv_extension_LIBS=
sim_ac_iv_extension_LDFLAGS=
sim_ac_iv_extension_decarations=
sim_ac_iv_extension_initializations=

sim_ac_iv_extensions=
while test x"${sim_ac_iv_try_extensions}" != x""; do
  sim_ac_iv_extension=`echo ,$sim_ac_iv_try_extensions | cut -d, -f2`
  sim_ac_iv_try_extensions=`echo ,$sim_ac_iv_try_extensions | cut -d, -f3-`
  case $sim_ac_iv_extension in
  sim_ac_dummy ) # ignore
    ;;
  -L* ) # extension library path hint
    sim_ac_iv_extension_LDFLAGS="$sim_ac_iv_extension_LDFLAGS $sim_ac_iv_extension"
    ;;
  -l* ) # extension library hint
    LIBS="$sim_ac_iv_extension_save_LIBS $sim_ac_iv_extension_LIBS $sim_ac_iv_extension"
    AC_MSG_CHECKING([for Open Inventor extension library $sim_ac_iv_extension])
    AC_TRY_LINK([#include <Inventor/SoDB.h>], [SoDB::init();],
      [sim_ac_iv_extension_LIBS="$sim_ac_iv_extension_LIBS $sim_ac_iv_extension"
       AC_MSG_RESULT([linkable])],
      [AC_MSG_RESULT([unlinkable - discarded])])
    ;;
  * )
    AC_MSG_CHECKING([for Open Inventor extension $sim_ac_iv_extension])
    AC_TRY_LINK(
[#include <Inventor/SoDB.h>
// hack up a declaration and see if the mangled name is found by the linker
class $sim_ac_iv_extension {
public:
static void initClass(void);
};], [
  SoDB::init();
  $sim_ac_iv_extension::initClass();
], [
  AC_MSG_RESULT([found])
  sim_ac_iv_extensions="$sim_ac_iv_extensions COIN_IV_EXTENSION($sim_ac_iv_extension)"
], [
  AC_MSG_RESULT([not found])
])
    ;;
  esac
done

AC_DEFINE_UNQUOTED([COIN_IV_EXTENSIONS], [$sim_ac_iv_extensions], [Open Inventor extensions])

LIBS=$sim_ac_iv_extension_save_LIBS

ifelse([$1], , :, [$1])

]) # SIM_AC_INVENTOR_EXTENSIONS


# Convenience macros SIM_AC_DEBACKSLASH and SIM_AC_DOBACKSLASH for
# converting to and from MSWin/MS-DOS style paths.
#
# Example use:
#
#     SIM_AC_DEBACKSLASH(my_ac_reversed, "C:\\mydir\\bin")
#
# will give a shell variable $my_ac_reversed with the value "C:/mydir/bin").
# Vice versa for SIM_AC_DOBACKSLASH.
#
# Author: Marius Bugge Monsen <mariusbu@sim.no>
#         Lars J�rgen Aas <larsa@sim.no>
#         Morten Eriksen <mortene@sim.no>

AC_DEFUN([SIM_AC_DEBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\\\%\\/%g'`\""
])

AC_DEFUN([SIM_AC_DOBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\/%\\\\%g'`\""
])

AC_DEFUN([SIM_AC_DODOUBLEBACKSLASH], [
eval "$1=\"`echo $2 | sed -e 's%\\/%\\\\\\\\\\\\\\\\%g'`\""
])


# Usage:
#   SIM_AC_HAVE_COIN_IFELSE( IF-FOUND, IF-NOT-FOUND )
#
# Description:
#   This macro locates the Coin development system.  If it is found,
#   the set of variables listed below are set up as described and made
#   available to the configure script.
#
#   The $sim_ac_coin_desired variable can be set to false externally to
#   make Coin default to be excluded.
#
# Autoconf Variables:
# > $sim_ac_coin_desired     true | false (defaults to true)
# < $sim_ac_coin_avail       true | false
# < $sim_ac_coin_cppflags    (extra flags the preprocessor needs)
# < $sim_ac_coin_cflags      (extra flags the C compiler needs)
# < $sim_ac_coin_cxxflags    (extra flags the C++ compiler needs)
# < $sim_ac_coin_ldflags     (extra flags the linker needs)
# < $sim_ac_coin_libs        (link library flags the linker needs)
# < $sim_ac_coin_datadir     (location of Coin data files)
# < $sim_ac_coin_includedir  (location of Coin headers)
# < $sim_ac_coin_version     (the libCoin version)
# < $sim_ac_coin_msvcrt      (the MSVC++ C library Coin was built with)
# < $sim_ac_coin_configcmd   (the path to coin-config or "false")
#
# Authors:
#   Lars J. Aas, <larsa@sim.no>
#   Morten Eriksen, <mortene@sim.no>
#
# TODO:
#

AC_DEFUN([SIM_AC_HAVE_COIN_IFELSE], [
AC_PREREQ([2.14a])

# official variables
sim_ac_coin_avail=false
sim_ac_coin_cppflags=
sim_ac_coin_cflags=
sim_ac_coin_cxxflags=
sim_ac_coin_ldflags=
sim_ac_coin_libs=
sim_ac_coin_datadir=
sim_ac_coin_includedir=
sim_ac_coin_version=

# internal variables
: ${sim_ac_coin_desired=true}
sim_ac_coin_extrapath=

AC_ARG_WITH([coin],
AC_HELP_STRING([--with-coin], [enable use of Coin [[default=yes]]])
AC_HELP_STRING([--with-coin=DIR], [give prefix location of Coin]),
  [ case $withval in
    no)  sim_ac_coin_desired=false ;;
    yes) sim_ac_coin_desired=true ;;
    *)   sim_ac_coin_desired=true
         sim_ac_coin_extrapath=$withval ;;
    esac],
  [])

case $build in
*-mks ) sim_ac_pathsep=";" ;;
* )     sim_ac_pathsep="${PATH_SEPARATOR}" ;;
esac

if $sim_ac_coin_desired; then
  sim_ac_path=$PATH
  test -z "$sim_ac_coin_extrapath" || ## search in --with-coin path
    sim_ac_path="$sim_ac_coin_extrapath/bin${sim_ac_pathsep}$sim_ac_path"
  test x"$prefix" = xNONE ||          ## search in --prefix path
    sim_ac_path="$sim_ac_path${sim_ac_pathsep}$prefix/bin"

  AC_PATH_PROG(sim_ac_coin_configcmd, coin-config, false, $sim_ac_path)

  if test "X$sim_ac_coin_configcmd" != "Xfalse"; then
    test -n "$CONFIG" &&
      $sim_ac_coin_configcmd --alternate=$CONFIG >/dev/null 2>/dev/null &&
      sim_ac_coin_configcmd="$sim_ac_coin_configcmd --alternate=$CONFIG"
  fi

  if $sim_ac_coin_configcmd; then
    sim_ac_coin_version=`$sim_ac_coin_configcmd --version`
    sim_ac_coin_cppflags=`$sim_ac_coin_configcmd --cppflags`
    sim_ac_coin_cflags=`$sim_ac_coin_configcmd --cflags 2>/dev/null`
    sim_ac_coin_cxxflags=`$sim_ac_coin_configcmd --cxxflags`
    sim_ac_coin_ldflags=`$sim_ac_coin_configcmd --ldflags`
    sim_ac_coin_libs=`$sim_ac_coin_configcmd --libs`
    sim_ac_coin_datadir=`$sim_ac_coin_configcmd --datadir`
    # Hide stderr on the following, as ``--includedir'', ``--msvcrt''
    # and ``--cflags'' options were added late to coin-config.
    sim_ac_coin_includedir=`$sim_ac_coin_configcmd --includedir 2>/dev/null`
    sim_ac_coin_msvcrt=`$sim_ac_coin_configcmd --msvcrt 2>/dev/null`
    sim_ac_coin_cflags=`$sim_ac_coin_configcmd --cflags 2>/dev/null`
    AC_CACHE_CHECK(
      [if we can compile and link with the Coin library],
      sim_cv_coin_avail,
      [sim_ac_save_cppflags=$CPPFLAGS
      sim_ac_save_cxxflags=$CXXFLAGS
      sim_ac_save_ldflags=$LDFLAGS
      sim_ac_save_libs=$LIBS
      CPPFLAGS="$CPPFLAGS $sim_ac_coin_cppflags"
      CXXFLAGS="$CXXFLAGS $sim_ac_coin_cxxflags"
      LDFLAGS="$LDFLAGS $sim_ac_coin_ldflags"
      LIBS="$sim_ac_coin_libs $LIBS"
      AC_LANG_PUSH(C++)

      AC_TRY_LINK(
        [#include <Inventor/SoDB.h>],
        [SoDB::init();],
        [sim_cv_coin_avail=true],
        [sim_cv_coin_avail=false])

      AC_LANG_POP
      CPPFLAGS=$sim_ac_save_cppflags
      CXXFLAGS=$sim_ac_save_cxxflags
      LDFLAGS=$sim_ac_save_ldflags
      LIBS=$sim_ac_save_libs
    ])
    sim_ac_coin_avail=$sim_cv_coin_avail

    if $sim_ac_coin_avail; then :; else
      AC_MSG_WARN([
Compilation and/or linking with the Coin main library SDK failed, for
unknown reason. If you are familiar with configure-based configuration
and building, investigate the 'config.log' file for clues.

If you can not figure out what went wrong, please forward the 'config.log'
file to the email address <coin-support@coin3d.org> and ask for help by
describing the situation where this failed.
])
    fi
  else # no 'coin-config' found

# FIXME: test for Coin without coin-config script here
    if test x"$COINDIR" != x""; then
      sim_ac_coindir=`cygpath -u "$COINDIR" 2>/dev/null || echo "$COINDIR"`
      if test -d $sim_ac_coindir/bin && test -d $sim_ac_coindir/lib && test -d $sim_ac_coindir/include/Inventor; then
        # using newest version (last alphabetically) in case of multiple libs
        sim_ac_coin_lib_file=`echo $sim_ac_coindir/lib/coin*.lib | sed -e 's,.* ,,g'`
        if test -f $sim_ac_coin_lib_file; then
          sim_ac_coin_lib_name=`echo $sim_ac_coin_lib_file | sed -e 's,.*/,,g' -e 's,.lib,,'`
          sim_ac_save_cppflags=$CPPFLAGS
          sim_ac_save_libs=$LIBS
          sim_ac_save_ldflags=$LDFLAGS
          CPPFLAGS="$CPPFLAGS -I$sim_ac_coindir/include"
          if test -f $sim_ac_coindir/bin/$sim_ac_coin_lib_name.dll; then
            CPPFLAGS="$CPPFLAGS -DCOIN_DLL"
          fi
          LDFLAGS="$LDFLAGS -L$sim_ac_coindir/lib"
          LIBS="-l$sim_ac_coin_lib_name -lopengl32 $LIBS"

          AC_LANG_PUSH(C++)

          AC_TRY_LINK(
            [#include <Inventor/SoDB.h>],
            [SoDB::init();],
            [sim_cv_coin_avail=true],
            [sim_cv_coin_avail=false])

          AC_LANG_POP
          CPPFLAGS=$sim_ac_save_cppflags
          LDFLAGS=$sim_ac_save_ldflags
          LIBS=$sim_ac_save_libs
          sim_ac_coin_avail=$sim_cv_coin_avail
        fi
      fi
    fi

    if $sim_ac_coin_avail; then
      sim_ac_coin_cppflags=-I$sim_ac_coindir/include
      if test -f $sim_ac_coindir/bin/$sim_ac_coin_lib_name.dll; then
        sim_ac_coin_cppflags="$sim_ac_coin_cppflags -DCOIN_DLL"
      fi
      sim_ac_coin_ldflags=-L$sim_ac_coindir/lib
      sim_ac_coin_libs="-l$sim_ac_coin_lib_name -lopengl32"
      sim_ac_coin_datadir=$sim_ac_coindir/data
    else
      locations=`IFS="${sim_ac_pathsep}"; for p in $sim_ac_path; do echo " -> $p/coin-config"; done`
      AC_MSG_WARN([cannot find 'coin-config' at any of these locations:
$locations])
      AC_MSG_WARN([
Need to be able to run 'coin-config' to figure out how to build and link
against the Coin library. To rectify this problem, you most likely need
to a) install Coin if it has not been installed, b) add the Coin install
bin/ directory to your PATH environment variable.
])
    fi
  fi
fi

if $sim_ac_coin_avail; then
  ifelse([$1], , :, [$1])
else
  ifelse([$2], , :, [$2])
fi
]) # SIM_AC_HAVE_COIN_IFELSE()


# pkg.m4 - Macros to locate and utilise pkg-config.            -*- Autoconf -*-
#
# Copyright © 2004 Scott James Remnant <scott@netsplit.com>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# PKG_PROG_PKG_CONFIG([MIN-VERSION])
# ----------------------------------
AC_DEFUN([PKG_PROG_PKG_CONFIG],
[m4_pattern_forbid([^_?PKG_[A-Z_]+$])
m4_pattern_allow([^PKG_CONFIG(_PATH)?$])
AC_ARG_VAR([PKG_CONFIG], [path to pkg-config utility])dnl
if test "x$ac_cv_env_PKG_CONFIG_set" != "xset"; then
	AC_PATH_TOOL([PKG_CONFIG], [pkg-config])
fi
if test -n "$PKG_CONFIG"; then
	_pkg_min_version=m4_default([$1], [0.9.0])
	AC_MSG_CHECKING([pkg-config is at least version $_pkg_min_version])
	if $PKG_CONFIG --atleast-pkgconfig-version $_pkg_min_version; then
		AC_MSG_RESULT([yes])
	else
		AC_MSG_RESULT([no])
		PKG_CONFIG=""
	fi

fi[]dnl
])# PKG_PROG_PKG_CONFIG

# PKG_CHECK_EXISTS(MODULES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# Check to see whether a particular set of modules exists.  Similar
# to PKG_CHECK_MODULES(), but does not set variables or print errors.
#
#
# Similar to PKG_CHECK_MODULES, make sure that the first instance of
# this or PKG_CHECK_MODULES is called, or make sure to call
# PKG_CHECK_EXISTS manually
# --------------------------------------------------------------
AC_DEFUN([PKG_CHECK_EXISTS],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
if test -n "$PKG_CONFIG" && \
    AC_RUN_LOG([$PKG_CONFIG --exists --print-errors "$1"]); then
  m4_ifval([$2], [$2], [:])
m4_ifvaln([$3], [else
  $3])dnl
fi])


# _PKG_CONFIG([VARIABLE], [COMMAND], [MODULES])
# ---------------------------------------------
m4_define([_PKG_CONFIG],
[if test -n "$PKG_CONFIG"; then
    if test -n "$$1"; then
        pkg_cv_[]$1="$$1"
    else
        PKG_CHECK_EXISTS([$3],
                         [pkg_cv_[]$1=`$PKG_CONFIG --[]$2 "$3" 2>/dev/null`],
			 [pkg_failed=yes])
    fi
else
	pkg_failed=untried
fi[]dnl
])# _PKG_CONFIG

# _PKG_SHORT_ERRORS_SUPPORTED
# -----------------------------
AC_DEFUN([_PKG_SHORT_ERRORS_SUPPORTED],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])
if $PKG_CONFIG --atleast-pkgconfig-version 0.20; then
        _pkg_short_errors_supported=yes
else
        _pkg_short_errors_supported=no
fi[]dnl
])# _PKG_SHORT_ERRORS_SUPPORTED


# PKG_CHECK_MODULES(VARIABLE-PREFIX, MODULES, [ACTION-IF-FOUND],
# [ACTION-IF-NOT-FOUND])
#
#
# Note that if there is a possibility the first call to
# PKG_CHECK_MODULES might not happen, you should be sure to include an
# explicit call to PKG_PROG_PKG_CONFIG in your configure.ac
#
#
# --------------------------------------------------------------
AC_DEFUN([PKG_CHECK_MODULES],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
AC_ARG_VAR([$1][_CFLAGS], [C compiler flags for $1, overriding pkg-config])dnl
AC_ARG_VAR([$1][_LIBS], [linker flags for $1, overriding pkg-config])dnl

pkg_failed=no
AC_MSG_CHECKING([for $1])

_PKG_CONFIG([$1][_CFLAGS], [cflags], [$2])
_PKG_CONFIG([$1][_LIBS], [libs], [$2])

m4_define([_PKG_TEXT], [Alternatively, you may set the environment variables $1[]_CFLAGS
and $1[]_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.])

if test $pkg_failed = yes; then
        _PKG_SHORT_ERRORS_SUPPORTED
        if test $_pkg_short_errors_supported = yes; then
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --short-errors --errors-to-stdout --print-errors "$2"`
        else
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --errors-to-stdout --print-errors "$2"`
        fi
	# Put the nasty error message in config.log where it belongs
	echo "$$1[]_PKG_ERRORS" >&AS_MESSAGE_LOG_FD

	ifelse([$4], , [AC_MSG_ERROR(dnl
[Package requirements ($2) were not met:

$$1_PKG_ERRORS

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

_PKG_TEXT
])],
		[$4])
elif test $pkg_failed = untried; then
	ifelse([$4], , [AC_MSG_FAILURE(dnl
[The pkg-config script could not be found or is too old.  Make sure it
is in your PATH or set the PKG_CONFIG environment variable to the full
path to pkg-config.

_PKG_TEXT

To get pkg-config, see <http://www.freedesktop.org/software/pkgconfig>.])],
		[$4])
else
	$1[]_CFLAGS=$pkg_cv_[]$1[]_CFLAGS
	$1[]_LIBS=$pkg_cv_[]$1[]_LIBS
        AC_MSG_RESULT([yes])
	ifelse([$3], , :, [$3])
fi[]dnl
])# PKG_CHECK_MODULES

# Helper macros for the SIM_AC_CHECK_QT macro below.

# SIM_AC_WITH_QT
#
# Sets sim_ac_with_qt (from --with-qt=[true|false]) and
# sim_ac_qtdir (from either --with-qt=DIR or $QTDIR).

AC_DEFUN([SIM_AC_WITH_QT], [
sim_ac_qtdir=
AC_ARG_WITH(
  [qt],
  AC_HELP_STRING([--with-qt=[true|false|DIR]],
                 [specify if Qt should be used, and optionally the location of the Qt library [default=true]]),
  [case $withval in
  no | false ) sim_ac_with_qt=false ;;
  yes | true ) sim_ac_with_qt=true ;;
  *)
    sim_ac_with_qt=true
    sim_ac_qtdir=$withval
    ;;
  esac],
  [sim_ac_with_qt=true])

if $sim_ac_with_qt; then
  # The Cygwin environment needs to invoke moc with a POSIX-style path.
  AC_PATH_PROG(sim_ac_qt_cygpath, cygpath, false)

  if test -n "$sim_ac_qtdir"; then
    if test $sim_ac_qt_cygpath != "false"; then
      # Quote $sim_ac_qtdir in case it contains whitespace characters.
      sim_ac_qtdir=`$sim_ac_qt_cygpath -u "$sim_ac_qtdir"`
    fi
  else
    if test $sim_ac_qt_cygpath = "false"; then
      sim_ac_qtdir=$QTDIR
    else
      # Quote $QTDIR in case it's empty.
      sim_ac_qtdir=`$sim_ac_qt_cygpath -u "$QTDIR"`
    fi

    AC_MSG_CHECKING([value of the QTDIR environment variable])
    if test x"$sim_ac_qtdir" = x""; then
      AC_MSG_RESULT([empty])
    else
      AC_MSG_RESULT([$sim_ac_qtdir])

      # list contents of what's in the qt dev environment into config.log
      for i in "" bin lib; do
        echo "Listing contents of $sim_ac_qtdir/$i:" >&5
        ls -l $sim_ac_qtdir/$i >&5 2>&1
      done
    fi
  fi
fi
])

# SIM_AC_QT_PROG(VARIABLE, PROG-TO-CHECK-FOR)
#
# Substs VARIABLE to the path of the PROG-TO-CHECK-FOR, if found
# in either $PATH, $QTDIR/bin or the --with-qt=DIR directories.
#
# If not found, VARIABLE will be set to false.

AC_DEFUN([SIM_AC_QT_PROG], [
AC_REQUIRE([SIM_AC_WITH_QT])

if $sim_ac_with_qt; then

  sim_ac_path=$PATH
  if test -n "$sim_ac_qtdir"; then
    sim_ac_path=$sim_ac_qtdir/bin:$PATH
  fi

  AC_PATH_PROG([$1], $2, false, $sim_ac_path)
  if test x"$$1" = x"false"; then
    if test -z "$QTDIR"; then
      AC_MSG_WARN([QTDIR environment variable not set -- this might be an indication of a problem])
    fi
    AC_MSG_WARN([the ``$2'' Qt pre-processor tool not found])
  fi
else
  AC_SUBST([$1], [false])
fi
])

# Usage:
#  SIM_AC_QT_VERSION
#
# Find version number of the Qt library. sim_ac_qt_version will contain
# the full version number string, and sim_ac_qt_major_version will contain
# only the major version number.

AC_DEFUN([SIM_AC_QT_VERSION], [

AC_MSG_CHECKING([version of Qt library])

cat > conftest.c << EOF
#include <qglobal.h>
int VerQt = QT_VERSION;
EOF

# The " *"-parts of the last sed-expression on the next line are necessary
# because at least the Solaris/CC preprocessor adds extra spaces before and
# after the trailing semicolon.
sim_ac_qt_version=`$CXXCPP $CPPFLAGS conftest.c 2>/dev/null | grep '^int VerQt' | sed 's%^int VerQt = %%' | sed 's% *;.*$%%'`

case $sim_ac_qt_version in
0x* )
  sim_ac_qt_version=`echo $sim_ac_qt_version | sed -e 's/^0x.\(.\).\(.\).\(.\)/\1\2\3/;'`
  ;;
* )
  # nada
  ;;
esac
sim_ac_qt_major_version=`echo $sim_ac_qt_version | cut -c1`

rm -f conftest.c
AC_MSG_RESULT($sim_ac_qt_version)
])

# Usage:
#  SIM_AC_CHECK_QT([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the Qt development system. If it is found, these
#  shell variables are set:
#
#    $sim_ac_qt_cppflags (extra flags the compiler needs for Qt lib)
#    $sim_ac_qt_ldflags  (extra flags the linker needs for Qt lib)
#    $sim_ac_qt_libs     (link libraries the linker needs for Qt lib)
#
#  The CPPFLAGS, LDFLAGS and LIBS flags will also be modified accordingly.
#  In addition, the variable $sim_ac_qt_avail is set to "yes" if
#  the Qt development system is found.
#
# Authors:
#   Morten Eriksen <mortene@sim.no>.
#   Lars J. Aas <larsa@sim.no>.

AC_DEFUN([SIM_AC_CHECK_QT], [

AC_REQUIRE([SIM_AC_WITH_QT])

AC_ARG_ENABLE(
  [qt-debug],
  AC_HELP_STRING([--enable-qt-debug], [win32: link with debug versions of Qt libraries]),
  [case $enableval in
  yes | true ) sim_ac_qt_debug=true ;;
  *) sim_ac_qt_debug=false ;;
  esac],
  [sim_ac_qt_debug=false])

sim_ac_qt_avail=no

if $sim_ac_with_qt; then

  sim_ac_save_cppflags=$CPPFLAGS
  sim_ac_save_ldflags=$LDFLAGS
  sim_ac_save_libs=$LIBS

  sim_ac_qt_libs=UNRESOLVED

  # Check for Mac OS framework installation
  if test -z "$QTDIR"; then
    sim_ac_qt_framework_dir=/Library/Frameworks
    # FIXME: Should we also look for the Qt framework in other
    # default framework locations (such as ~/Library/Frameworks)?
    # Or require the user to specify this explicitly, e.g. by
    # passing --with-qt-framework=xxx? 20050802 kyrah.
  else
    sim_ac_qt_framework_dir=$sim_ac_qtdir/lib
  fi

  SIM_AC_HAVE_QT_FRAMEWORK

  if $sim_ac_have_qt_framework; then
    sim_ac_qt_cppflags="-I$sim_ac_qt_framework_dir/QtCore.framework/Headers -I$sim_ac_qt_framework_dir/QtOpenGL.framework/Headers -I$sim_ac_qt_framework_dir/QtGui.framework/Headers -F$sim_ac_qt_framework_dir"
    sim_ac_qt_libs="-Wl,-F$sim_ac_qt_framework_dir -Wl,-framework,QtGui -Wl,-framework,QtOpenGL -Wl,-framework,QtCore -Wl,-framework,QtXml -Wl,-framework,QtNetwork -Wl,-framework,QtSql"
  else

    sim_ac_qglobal_unresolved=true

    sim_ac_QTDIR_cppflags=
    sim_ac_QTDIR_ldflags=
    if test -n "$sim_ac_qtdir"; then
      sim_ac_QTDIR_cppflags="-I$sim_ac_qtdir/include"
      sim_ac_QTDIR_ldflags="-L$sim_ac_qtdir/lib"
      CPPFLAGS="$sim_ac_QTDIR_cppflags $CPPFLAGS"
      LDFLAGS="$LDFLAGS $sim_ac_QTDIR_ldflags"
    fi

    # This should take care of detecting qglobal.h for Qt 3 if QTDIR was set,
    # or if Qt is in default locations, or if it is in any additional "-I..."
    # set up by the user with CPPFLAGS:
    sim_ac_temp="$CPPFLAGS"
    SIM_AC_CHECK_HEADER_SILENT([qglobal.h], [sim_ac_qglobal_unresolved=false])

    # If we're to use Qt 4 and QTDIR is set, this should be able to find it:
    if $sim_ac_qglobal_unresolved; then
      SIM_AC_CHECK_HEADER_SILENT([Qt/qglobal.h],
                                 [sim_ac_qglobal_unresolved=false])
      if $sim_ac_qglobal_unresolved; then
        :
      else
        if test -z "$sim_ac_QTDIR_cppflags"; then
          AC_MSG_ERROR([Qt/qglobal.h detected, but no QTDIR environment variable set. Do not know where the Qt include files are.])
        else
          sim_ac_QTDIR_cppflags="$sim_ac_QTDIR_cppflags $sim_ac_QTDIR_cppflags/Qt"
        fi
      fi
    fi
    CPPFLAGS="$sim_ac_temp"

    # Check for known default locations of Qt installation on various
    # systems:
    if $sim_ac_qglobal_unresolved; then
      sim_ac_temp="$CPPFLAGS"
      # /usr/include/qt: Debian-installations with Qt 3
      # /usr/include/qt4: Debian-installations with Qt 4
      # /sw/include/qt: Mac OS X Fink
      for i in "/usr/include/qt" "/usr/include/qt4" "/sw/include/qt"; do
        if $sim_ac_qglobal_unresolved; then
          CPPFLAGS="-I$i $sim_ac_temp"
          SIM_AC_CHECK_HEADER_SILENT([qglobal.h],
                                     [sim_ac_qglobal_unresolved=false
                                      sim_ac_QTDIR_cppflags="-I$i"
                                     ])
          if $sim_ac_qglobal_unresolved; then
            SIM_AC_CHECK_HEADER_SILENT([Qt/qglobal.h],
                                       [sim_ac_qglobal_unresolved=false
                                        sim_ac_QTDIR_cppflags="-I$i -I$i/Qt"
                                       ])
          fi
        fi
      done
      CPPFLAGS="$sim_ac_temp"
    fi

    # Mac OS X Darwin ports
    if $sim_ac_qglobal_unresolved; then
      sim_ac_temp="$CPPFLAGS"
      sim_ac_i="-I/opt/local/include/qt3"
      CPPFLAGS="$sim_ac_i $CPPFLAGS"
      SIM_AC_CHECK_HEADER_SILENT([qglobal.h],
                                 [sim_ac_qglobal_unresolved=false
                                  sim_ac_QTDIR_cppflags="$sim_ac_i"
                                  sim_ac_QTDIR_ldflags="-L/opt/local/lib"
                                 ])
      CPPFLAGS="$sim_ac_temp"
    fi

    if $sim_ac_qglobal_unresolved; then
      AC_MSG_WARN([header file qglobal.h not found, can not compile Qt code])
    else
      CPPFLAGS="$sim_ac_QTDIR_cppflags $CPPFLAGS"
      LDFLAGS="$LDFLAGS $sim_ac_QTDIR_ldflags"

      SIM_AC_QT_VERSION

      if test $sim_ac_qt_version -lt 200; then
        SIM_AC_ERROR([too-old-qt])
      fi

      # Too hard to feature-check for the Qt-on-Mac problems, as they involve
      # obscure behavior of the QGLWidget -- so we just resort to do platform
      # and version checking instead.
      case $host_os in
      darwin*)
        if test $sim_ac_qt_version -lt 302; then
          SIM_AC_CONFIGURATION_WARNING([The version of Qt you are using is known to contain some serious bugs on MacOS X. We strongly recommend you to upgrade. (See $srcdir/README.MAC for details.)])
        fi

        if $sim_ac_enable_darwin_x11; then
          # --enable-darwin-x11 specified but attempting Qt/Mac linkage
          AC_TRY_COMPILE([#include <qapplication.h>],
                      [#if defined(__APPLE__) && defined(Q_WS_MAC)
                       #error blah!
                       #endif],[],
                      [SIM_AC_ERROR([mac-qt-but-x11-requested])])
        else
          # Using Qt/X11 but option --enable-darwin-x11 not given
          AC_TRY_COMPILE([#include <qapplication.h>],
                    [#if defined(__APPLE__) && defined(Q_WS_X11)
                     #error blah!
                     #endif],[],
                    [SIM_AC_ERROR([x11-qt-but-no-x11-requested])])
        fi
        ;;
      esac

      # Known problems:
      #
      #   * Qt v3.0.1 has a bug where SHIFT-PRESS + CTRL-PRESS + CTRL-RELEASE
      #     results in the last key-event coming out completely wrong under X11.
      #     Known to be fixed in 3.0.3, unknown status in 3.0.2.  <mortene@sim.no>.
      #
      if test $sim_ac_qt_version -lt 303; then
        SIM_AC_CONFIGURATION_WARNING([The version of Qt you are compiling against is known to contain bugs which influences functionality in SoQt. We strongly recommend you to upgrade.])
      fi

      sim_ac_qt_cppflags=

      # Do not cache the result, as we might need to play tricks with
      # CPPFLAGS under MSWin.

      # It should be helpful to be able to override the libs-checking with
      # environment variables. Then people won't get completely stuck
      # when the check fails -- we can just take a look at the
      # config.log and give them advice on how to proceed with no updates
      # necessary.
      #
      # (Note also that this makes it possible to select whether to use the
      # mt-safe or the "standard" Qt library if both are installed on the
      # user's system.)
      #
      # mortene.

      if test x"$CONFIG_QTLIBS" != x""; then
        AC_MSG_CHECKING([for Qt linking with $CONFIG_QTLIBS])

        for sim_ac_qt_cppflags_loop in "" "-DQT_DLL"; do
          CPPFLAGS="$sim_ac_QTDIR_cppflags $sim_ac_qt_cppflags_loop $sim_ac_save_cppflags"
          LIBS="$CONFIG_QTLIBS $sim_ac_save_libs"
          AC_TRY_LINK([#include <qapplication.h>],
                      [
                       // FIXME: assignment to qApp does no longer work with Qt 4,
                       // should try to find another way to do the same thing. 20050629 mortene.
                       #if QT_VERSION < 0x040000
                       qApp = NULL; /* QT_DLL must be defined for assignment to global variables to work */
                       #endif
                       qApp->exit(0);],
                      [sim_ac_qt_libs="$CONFIG_QTLIBS"
                       sim_ac_qt_cppflags="$sim_ac_QTDIR_cppflags $sim_ac_qt_cppflags_loop"
                       sim_ac_qt_ldflags="$sim_ac_QTDIR_ldflags"
                      ])
        done

        if test "x$sim_ac_qt_libs" = "xUNRESOLVED"; then
          AC_MSG_RESULT([failed!])
        else
          AC_MSG_RESULT([ok])
        fi

      else
        AC_MSG_CHECKING([for Qt library devkit])

        ## Test all known possible combinations of linking against the
        ## Troll Tech Qt library:
        ##
        ## * "-lQtGui": Qt 4 on UNIX-like systems
        ##
        ## * "-lQtGui -lQtCore -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32 -lwinspool -lwinmm -ladvapi32 -lws2_32 -lshell32"
        ##   Should cover static linking against Qt4 on win32
        ##
        ## * "-lqt-gl": links against the standard Debian version of the
        ##   Qt library with embedded QGL
        ##
        ## * "-lqt": should work for most UNIX(-derived) platforms on
        ##   dynamic and static linking with the non-mtsafe library
        ##
        ## * "-lqt-mt": should work for most UNIX(-derived) platforms on
        ##   dynamic and static linking with the mtsafe library
        ##
        ## * "-lqt{version} -lqtmain -lgdi32": w/QT_DLL defined should
        ##   cover dynamic Enterprise Edition linking on Win32 platforms
        ##
        ## * "-lqt -lqtmain -lgdi32": ...unless the {version} suffix is missing,
        ##   which we've had reports about
        ##
        ## * "-lqt-mt{version} -lqtmain -lgdi32": w/QT_DLL defined should
        ##   cover dynamic multi-thread Enterprise Edition linking on Win32
        ##   platforms
        ##
        ## * "-lqt-mt{version}nc -lqtmain -lgdi32": w/QT_DLL defined should
        ##   cover dynamic Non-Commercial Edition linking on Win32 platforms
        ##
        ## * "-lqt -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32": should cover
        ##   static linking on Win32 platforms
        ##
        ## * "-lqt-mt -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32 -lwinspool -lwinmm -ladvapi32 -lws2_32":
        ##   added for the benefit of the Qt 3.0.0 Evaluation Version
        ##   (update: "advapi32.lib" seems to be a new dependency for Qt 3.1.0)
        ##   (update: "ws2_32.lib" seems to be a new dependency for Qt 3.1.2)
        ##
        ## * "-lqt-mt-eval": the Qt/Mac evaluation version
        ##
        ## * "-lqt-mtnc{version}": the non-commercial Qt version that
        ##   comes on the CD with the book "C++ Gui Programming with Qt 3"
        ##   (version==321 there)

        ## FIXME: could probably improve check to not have to go through
        ## all of the above. See bug item #028 in SoQt/BUGS.txt.
        ## 20040805 mortene.

        sim_ac_qt_suffix=
        if $sim_ac_qt_debug; then
          sim_ac_qt_suffix=d
        fi

        # Note that we need to always check for -lqt-mt before -lqt, because
        # at least the most recent Debian platforms (as of 2003-02-20) comes
        # with a -lqt which is missing QGL support, while it also has a
        # -lqt-mt *with* QGL support. The reason for this is because the
        # default GL (Mesa) library on Debian is built in mt-safe mode,
        # so a non-mt-safe Qt can't use it.

        for sim_ac_qt_cppflags_loop in "" "-DQT_DLL"; do
          for sim_ac_qt_libcheck in \
              "-lQtGui${sim_ac_qt_suffix}${sim_ac_qt_major_version} -lQtCore${sim_ac_qt_suffix}${sim_ac_qt_major_version}" \
              "-lQtGui -lQtCore" \
              "-lQtGui${sim_ac_qt_suffix} -lQtCore${sim_ac_qt_suffix} -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32 -lwinspool -lwinmm -ladvapi32 -lws2_32 -lshell32" \
              "-lqt-gl" \
              "-lqt-mt" \
              "-lqt" \
              "-lqt-mt -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32 -lwinspool -lwinmm -ladvapi32 -lws2_32" \
              "-lqt-mt${sim_ac_qt_version}${sim_ac_qt_suffix} -lqtmain -lgdi32" \
              "-lqt-mt${sim_ac_qt_version}nc${sim_ac_qt_suffix} -lqtmain -lgdi32" \
              "-lqt-mtedu${sim_ac_qt_version}${sim_ac_qt_suffix} -lqtmain -lgdi32" \
              "-lqt -lqtmain -lgdi32" \
              "-lqt${sim_ac_qt_version}${sim_ac_qt_suffix} -lqtmain -lgdi32" \
              "-lqt -luser32 -lole32 -limm32 -lcomdlg32 -lgdi32" \
              "-lqt-mt-eval" \
              "-lqt-mteval${sim_ac_qt_version}" \
              "-lqt-mtnc${sim_ac_qt_version}"
          do
            if test "x$sim_ac_qt_libs" = "xUNRESOLVED"; then
              CPPFLAGS="$sim_ac_QTDIR_cppflags $sim_ac_qt_cppflags_loop $sim_ac_save_cppflags"
              LIBS="$sim_ac_qt_libcheck $sim_ac_save_libs"
              AC_TRY_LINK([#include <qapplication.h>],
                          [
                           // FIXME: assignment to qApp does no longer work with Qt 4,
                           // should try to find another way to do the same thing. 20050629 mortene.
                           #if QT_VERSION < 0x040000
                           qApp = NULL; /* QT_DLL must be defined for assignment to global variables to work */
                           #endif
                           qApp->exit(0);],
                          [sim_ac_qt_libs="$sim_ac_qt_libcheck"
                           sim_ac_qt_cppflags="$sim_ac_QTDIR_cppflags $sim_ac_qt_cppflags_loop"
                           sim_ac_qt_ldflags="$sim_ac_QTDIR_ldflags"
                          ])
            fi
          done
        done

        AC_MSG_RESULT($sim_ac_qt_cppflags $sim_ac_QTDIR_ldflags $sim_ac_qt_libs)
      fi

    fi # sim_ac_qglobal_unresolved = false

  fi # sim_ac_have_qt_framework

  # We should only *test* availability, not mutate the LIBS/CPPFLAGS
  # variables ourselves inside this macro. 20041021 larsa
  CPPFLAGS=$sim_ac_save_cppflags
  LDFLAGS=$sim_ac_save_ldflags
  LIBS=$sim_ac_save_libs
  if test ! x"$sim_ac_qt_libs" = xUNRESOLVED; then
    sim_ac_qt_avail=yes
    $1

    sim_ac_qt_install=`cd $sim_ac_qtdir; pwd`/bin/install
    AC_MSG_CHECKING([whether Qt's install tool shadows the system install])
    case $INSTALL in
    "${sim_ac_qt_install}"* )
      AC_MSG_RESULT(yes)
      echo "\$INSTALL is '$INSTALL', which matches '$QTDIR/bin/install*'." >&5
      echo "\$QTDIR part is '$QTDIR'." >&5
      SIM_AC_ERROR([qt-install])
      ;;
    * )
      AC_MSG_RESULT(no)
      ;;
    esac

  else
    if test -z "$QTDIR"; then
      AC_MSG_WARN([QTDIR environment variable not set -- this might be an indication of a problem])
    fi
    $2
  fi
fi
])

# Usage:
#  SIM_AC_CHECK_QGL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
#  Try to find the QGL widget for interfacing Qt with OpenGL. If it
#  is found, these shell variables are set:
#
#    $sim_ac_qgl_cppflags (extra flags the compiler needs for QGL lib)
#    $sim_ac_qgl_ldflags  (extra flags the linker needs for QGL lib)
#    $sim_ac_qgl_libs     (link libraries the linker needs for QGL lib)
#
#  The LIBS flag will also be modified accordingly. In addition, the
#  variable $sim_ac_qgl_avail is set to "yes" if the QGL extension
#  library is found.
#
# Note that all "modern" variants of Qt should come with QGL embedded.
# There's one important deviation: Debian comes with a -lqt which is
# missing QGL support, while it also has a -lqt-mt *with* QGL support.
# The reason for this is because the default GL (Mesa) library on Debian
# is built in mt-safe mode.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_CHECK_QGL], [

AC_REQUIRE([SIM_AC_WITH_QT])

sim_ac_qgl_avail=no
sim_ac_qgl_cppflags=
sim_ac_qgl_ldflags=
sim_ac_qgl_libs=

if $sim_ac_with_qt; then
  # first check if we can link with the QGL widget already
  AC_CACHE_CHECK(
    [whether the QGL widget is part of main Qt library],
    sim_cv_lib_qgl_integrated,
    [AC_TRY_LINK([#include <qgl.h>],
                 [QGLFormat * f = new QGLFormat; f->setDepth(true); ],
                 [sim_cv_lib_qgl_integrated=yes],
                 [sim_cv_lib_qgl_integrated=no])])

  if test x"$sim_cv_lib_qgl_integrated" = xyes; then
    sim_ac_qgl_avail=yes
    $1
  else
    sim_ac_save_LIBS=$LIBS
    LIBS="$sim_ac_qgl_libs $LIBS"

    AC_MSG_CHECKING([for the QGL extension library])

    sim_ac_qt_suffix=
    if $sim_ac_qt_debug; then
      sim_ac_qt_suffix=d
    fi

    sim_ac_qgl_libs=UNRESOLVED
    for sim_ac_qgl_libcheck in "-lQtOpenGL${sim_ac_qt_suffix}${sim_ac_qt_major_version}" "-lQtOpenGL${sim_ac_qt_suffix}" "-lqgl" "-lqgl -luser32"; do
      if test "x$sim_ac_qgl_libs" = "xUNRESOLVED"; then
        LIBS="$sim_ac_qgl_libcheck $sim_ac_save_LIBS"
        AC_TRY_LINK([#include <qgl.h>],
                    [QGLFormat * f = new QGLFormat; f->setDepth(true); ],
                    [sim_ac_qgl_libs="$sim_ac_qgl_libcheck"])
      fi
    done

    if test x"$sim_ac_qgl_libs" != xUNRESOLVED; then
      AC_MSG_RESULT($sim_ac_qgl_libs)
      sim_ac_qgl_avail=yes
      $1
    else
      AC_MSG_RESULT([unavailable])
      LIBS=$sim_ac_save_LIBS
      $2
    fi
  fi
fi
])

# SIM_AC_QGLWIDGET_SETAUTOBUFFERSWAP
# ----------------------------------
#
# Use the macro for its side-effect: it defines
#
#       HAVE_QGLWIDGET_SETAUTOBUFFERSWAP
#
# to 1 in config.h if QGLWidget::setAutoBufferSwap() is available.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_QGLWIDGET_SETAUTOBUFFERSWAP], [
AC_CACHE_CHECK(
  [whether the QGLWidget::setAutoBufferSwap() is available],
  sim_cv_func_qglwidget_setautobufferswap,
  [AC_TRY_LINK([#include <qgl.h>
class MyGLWidget : public QGLWidget {
public: MyGLWidget() {setAutoBufferSwap(FALSE);} };],
               [MyGLWidget * w = new MyGLWidget;],
               [sim_cv_func_qglwidget_setautobufferswap=yes],
               [sim_cv_func_qglwidget_setautobufferswap=no])])

if test x"$sim_cv_func_qglwidget_setautobufferswap" = xyes; then
  AC_DEFINE([HAVE_QGLWIDGET_SETAUTOBUFFERSWAP], 1,
    [Define this to 1 if QGLWidget::setAutoBufferSwap() is available])
fi
])


# SIM_AC_QGLFORMAT_SETOVERLAY
# ---------------------------
#
# Use the macro for its side-effect: it defines
#
#       HAVE_QGLFORMAT_SETOVERLAY
#
# to 1 in config.h if QGLFormat::setOverlay() is available.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_QGLFORMAT_SETOVERLAY], [
AC_CACHE_CHECK(
  [whether QGLFormat::setOverlay() is available],
  sim_cv_func_qglformat_setoverlay,
  [AC_TRY_LINK([#include <qgl.h>],
               [/* The basics: */
                QGLFormat f; f.setOverlay(TRUE);
                /* We've had a bug report about soqt.dll linking fail due
                   to missing the QGLWidget::overlayContext() symbol: */
                QGLWidget * w = NULL; (void)w->overlayContext();
               ],
               [sim_cv_func_qglformat_setoverlay=yes],
               [sim_cv_func_qglformat_setoverlay=no])])

if test x"$sim_cv_func_qglformat_setoverlay" = xyes; then
  AC_DEFINE([HAVE_QGLFORMAT_SETOVERLAY], 1,
    [Define this to 1 if QGLFormat::setOverlay() is available])
fi
])


# SIM_AC_QGLFORMAT_EQ_OP
# ----------------------
#
# Use the macro for its side-effect: it defines
#
#       HAVE_QGLFORMAT_EQ_OP
#
# to 1 in config.h if operator==(QGLFormat&, QGLFormat&) is available.
# (For Qt v2.2.2 at least, Troll Tech forgot to include this method
# in the publicly exported API for MSWindows DLLs.)
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_QGLFORMAT_EQ_OP], [
AC_CACHE_CHECK(
  [whether operator==(QGLFormat&,QGLFormat&) is available],
  sim_cv_func_qglformat_eq_op,
  [AC_TRY_LINK([#include <qgl.h>],
               [QGLFormat f; if (f == f) f.setDepth(true);],
               [sim_cv_func_qglformat_eq_op=true],
               [sim_cv_func_qglformat_eq_op=false])])

if $sim_cv_func_qglformat_eq_op; then
  AC_DEFINE([HAVE_QGLFORMAT_EQ_OP], 1,
    [Define this to 1 if operator==(QGLFormat&, QGLFormat&) is available])
fi
])


# SIM_AC_QWIDGET_SHOWFULLSCREEN
# -----------------------------
#
# Use the macro for its side-effect: it defines HAVE_QWIDGET_SHOWFULLSCREEN
# to 1 in config.h if QWidget::showFullScreen() is available (that
# function wasn't introduced in Qt until version 2.1.0).
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_QWIDGET_SHOWFULLSCREEN], [
AC_CACHE_CHECK(
  [whether QWidget::showFullScreen() is available],
  sim_cv_def_qwidget_showfullscreen,
  [AC_TRY_LINK([#include <qwidget.h>],
               [QWidget * w = new QWidget(); w->showFullScreen();],
               [sim_cv_def_qwidget_showfullscreen=true],
               [sim_cv_def_qwidget_showfullscreen=false])])

if $sim_cv_def_qwidget_showfullscreen; then
  AC_DEFINE([HAVE_QWIDGET_SHOWFULLSCREEN], 1,
            [Define this if QWidget::showFullScreen() is available])
fi
]) # SIM_AC_QWIDGET_SHOWFULLSCREEN

# SIM_AC_QAPPLICATION_HASPENDINGEVENTS
# -----------------------------
#
# Use the macro for its side-effect: it defines
# HAVE_QAPPLICATION_HASPENDINGEVENTS to 1 in config.h if
# QApplication::hasPendingEvents() is available (that
# function wasn't introduced in Qt until version 3.0).
#
# Author: Peder Blekken <pederb@sim.no>.

AC_DEFUN([SIM_AC_QAPPLICATION_HASPENDINGEVENTS], [
AC_CACHE_CHECK(
  [whether QApplication::hasPendingEvents() is available],
  sim_cv_def_qapplication_haspendingevents,
  [AC_TRY_LINK([#include <qapplication.h>],
               [int argc; char ** argv; QApplication app(argc, argv); (void) app.hasPendingEvents();],
               [sim_cv_def_qapplication_haspendingevents=true],
               [sim_cv_def_qapplication_haspendingevents=false])])

if $sim_cv_def_qapplication_haspendingevents; then
  AC_DEFINE([HAVE_QAPPLICATION_HASPENDINGEVENTS], 1,
            [Define this if QApplication::hasPendingEvents() is available])
fi
]) # SIM_AC_QAPPLICATION_HASPENDINGEVENTS


# SIM_AC_QT_KEYPAD_DEFINE
# -----------------------
#
# Use the macro for its side-effect: it defines HAVE_QT_KEYPAD_DEFINE
# to 1 in config.h if Qt::Keypad is available.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_QT_KEYPAD_DEFINE], [
AC_CACHE_CHECK(
  [whether Qt::Keypad is defined],
  sim_cv_def_qt_keypad,
  [AC_TRY_LINK([#include <qkeycode.h>],
               [Qt::ButtonState s = Qt::Keypad;],
               [sim_cv_def_qt_keypad=true],
               [sim_cv_def_qt_keypad=false])])

if $sim_cv_def_qt_keypad; then
  AC_DEFINE([HAVE_QT_KEYPAD_DEFINE], 1,
            [Define this if Qt::Keypad is available])
fi
]) # SIM_AC_QT_KEYPAD_DEFINE


# SIM_AC_QWIDGET_HASSETWINDOWSTATE
# --------------------------------
# QWidget->setWindowState() was added around Qt 3.3

AC_DEFUN([SIM_AC_QWIDGET_HASSETWINDOWSTATE], [
AC_CACHE_CHECK(
  [whether QWidget::setWindowState() exists],
  sim_cv_exists_qwidget_setwindowstate,

  [AC_TRY_LINK([#include <qwidget.h>],
               [QWidget * w = NULL; w->setWindowState(0);],
               [sim_cv_exists_qwidget_setwindowstate=true],
               [sim_cv_exists_qwidget_setwindowstate=false])])

if $sim_cv_exists_qwidget_setwindowstate; then
  AC_DEFINE([HAVE_QWIDGET_SETWINDOWSTATE], 1,
            [Define this if QWidget::setWindowState() is available])
fi
]) # SIM_AC_QWIDGET_HASSETWINDOWSTATE



# SIM_AC_QLINEEDIT_HASSETINPUTMASK
# --------------------------------
# QLineEdit->setInputMask() was added around Qt 3.3

AC_DEFUN([SIM_AC_QLINEEDIT_HASSETINPUTMASK], [
AC_CACHE_CHECK(
  [whether QLineEdit::setInputMask() exists],
  sim_cv_exists_qlineedit_setinputmask,

  [AC_TRY_LINK([#include <qlineedit.h>],
               [QLineEdit * le = NULL; le->setInputMask(0);],
               [sim_cv_exists_qlineedit_setinputmask=true],
               [sim_cv_exists_qlineedit_setinputmask=false])])

if $sim_cv_exists_qlineedit_setinputmask; then
  AC_DEFINE([HAVE_QLINEEDIT_SETINPUTMASK], 1,
            [Define this if QLineEdit::setInputMask() is available])
fi
]) # SIM_AC_QLINEEDIT_HASSETINPUTMASK



# SIM_AC_HAVE_QT_FRAMEWORK
# ----------------------
#
# Determine whether Qt is installed as a Mac OS X framework.
#
# Uses the variable $sim_ac_qt_framework_dir which should either
# point to /Library/Frameworks or $QTDIR/lib.
#
# Sets sim_ac_have_qt_framework to true if Qt is installed as
# a framework, and to false otherwise.
#
# Author: Karin Kosina, <kyrah@sim.no>.

AC_DEFUN([SIM_AC_HAVE_QT_FRAMEWORK], [
case $host_os in
  darwin*)
    # First check if framework exists in the specified location, then
    # try to actually link against the framework. This precaution is
    # needed to catch the case where Qt-4 is installed in the default
    # location /Library/Frameworks, but the user wants to override it
    # by setting QTDIR to point to a non-framework install.
    if test -d $sim_ac_qt_framework_dir/QtCore.framework; then
      sim_ac_save_ldflags_fw=$LDFLAGS
      LDFLAGS="$LDFLAGS -F$sim_ac_qt_framework_dir -framework QtCore"
      AC_CACHE_CHECK(
        [whether Qt is installed as a framework],
        sim_ac_have_qt_framework,
        [AC_TRY_LINK([#include <QtCore/qglobal.h>],
                 [],
                 [sim_ac_have_qt_framework=true],
                 [sim_ac_have_qt_framework=false])
        ])
        LDFLAGS=$sim_ac_save_ldflags_fw
    else
      sim_ac_have_qt_framework=false
    fi
    ;;
  *)
    sim_ac_have_qt_framework=false
    ;;
esac
])


# Usage:
#   SIM_AC_COMPILE_DEBUG([ACTION-IF-DEBUG[, ACTION-IF-NOT-DEBUG]])
#
# Description:
#   Let the user decide if compilation should be done in "debug mode".
#   If compilation is not done in debug mode, all assert()'s in the code
#   will be disabled.
#
#   Also sets enable_debug variable to either "yes" or "no", so the
#   configure.in writer can add package-specific actions. Default is "yes".
#   This was also extended to enable the developer to set up the two first
#   macro arguments following the well-known ACTION-IF / ACTION-IF-NOT
#   concept.
#
# Authors:
#   Morten Eriksen, <mortene@sim.no>
#   Lars J. Aas, <larsa@sim.no>
#

AC_DEFUN([SIM_AC_COMPILE_DEBUG], [
AC_REQUIRE([SIM_AC_CHECK_SIMIAN_IFELSE])

AC_ARG_ENABLE(
  [debug],
  AC_HELP_STRING([--enable-debug], [compile in debug mode [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_debug=true ;;
    no)  enable_debug=false ;;
    true | false) enable_debug=${enableval} ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-debug) ;;
  esac],
  [enable_debug=true])

if $enable_debug; then
  DSUFFIX=d
  if $sim_ac_simian; then
    case $CXX in
    *wrapmsvc* )
      # uninitialized checks
      if test ${sim_ac_msc_major_version-0} -gt 6; then
        SIM_AC_CC_COMPILER_OPTION([/RTCu], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /RTCu"])
        SIM_AC_CXX_COMPILER_OPTION([/RTCu], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /RTCu"])
        # stack frame checks
        SIM_AC_CC_COMPILER_OPTION([/RTCs], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /RTCs"])
        SIM_AC_CXX_COMPILER_OPTION([/RTCs], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /RTCs"])
      fi
      ;;
    esac
  fi

  ifelse([$1], , :, [$1])
else
  DSUFFIX=
  CPPFLAGS="$CPPFLAGS -DNDEBUG"
  ifelse([$2], , :, [$2])
fi
AC_SUBST(DSUFFIX)
])

# Usage:
#   SIM_AC_COMPILER_OPTIMIZATION
#
# Description:
#   Let the user decide if optimization should be attempted turned off
#   by stripping off an "-O[0-9]" option.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# FIXME: this is pretty much just a dirty hack. Unfortunately, this
# seems to be the best we can do without fixing Autoconf to behave
# properly wrt setting optimization options. 20011021 mortene.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_COMPILER_OPTIMIZATION], [
AC_ARG_ENABLE(
  [optimization],
  AC_HELP_STRING([--enable-optimization],
                 [allow compilers to make optimized code [[default=yes]]]),
  [case "${enableval}" in
    yes) sim_ac_enable_optimization=true ;;
    no)  sim_ac_enable_optimization=false ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-optimization) ;;
  esac],
  [sim_ac_enable_optimization=true])

if $sim_ac_enable_optimization; then
  case $CXX in
  *wrapmsvc* )
    CFLAGS="/Ox $CFLAGS"
    CXXFLAGS="/Ox $CXXFLAGS"
    ;;
  esac
  :
else
  CFLAGS="`echo $CFLAGS | sed 's/-O[[0-9]]*[[ ]]*//'`"
  CXXFLAGS="`echo $CXXFLAGS | sed 's/-O[[0-9]]*[[ ]]*//'`"
fi
])

#
# SIM_AC_CHECK_SIMIAN_IFELSE( IF-SIMIAN, IF-NOT-SIMIAN )
#
# Sets $sim_ac_simian to true or false
#

AC_DEFUN([SIM_AC_CHECK_SIMIAN_IFELSE], [
AC_MSG_CHECKING([if user is simian])
case `hostname -d 2>/dev/null || domainname 2>/dev/null || hostname` in
*.sim.no | sim.no )
  sim_ac_simian=true
  ;;
* )
  if grep -ls "domain.*sim\\.no" /etc/resolv.conf >/dev/null; then
    sim_ac_simian=true
    :
  else
    sim_ac_simian=false
    :
  fi
  ;;
esac

if $sim_ac_simian; then
  AC_MSG_RESULT([probably])
  ifelse($1, [], :, $1)
else
  AC_MSG_RESULT([probably not])
  ifelse($2, [], :, $2)
fi])


# Usage:
#   SIM_AC_COMPILER_FUNCTIONNAME_VAR(compiler-id)
#
# Side-effects, defines these in config.h:
#
#     HAVE_$compilerid_VAR___func__              (1 if exists)
#     HAVE_$compilerid_VAR___PRETTY_FUNCTION__   (1 if exists)
#     HAVE_$compilerid_VAR___FUNCTION__          (1 if exists)
#
# (Note that only one of these will be defined.)
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#   Morten Eriksen <mortene@sim.no>

AC_DEFUN([SIM_AC_COMPILER_FUNCTIONNAME_VAR], [
AC_MSG_CHECKING([for function name variable for $1 compiler])
sim_ac_var_functionname=

# * __func__ is the identifier used by compilers which are
#   compliant with the C99 ISO/IEC 9899:1999 standard.
#
# * GCC uses __PRETTY_FUNCTION__
#
# * Visual C++ uses __FUNCDNAME__, __FUNCSIG__, and __FUNCTION__.
#

for i in "__func__" "__PRETTY_FUNCTION__" "__FUNCTION__"; do
if test -z "$sim_ac_var_functionname"; then
  AC_TRY_COMPILE(
    [#include <stdio.h>],
    [(void)printf("%s\n", $i)],
    [sim_ac_var_functionname=$i]
  )
fi
done

if test -z "$sim_ac_var_functionname"; then
  AC_MSG_RESULT(none)
else
  AC_MSG_RESULT($sim_ac_var_functionname)
  AC_DEFINE_UNQUOTED(HAVE_$1_COMPILER_FUNCTION_NAME_VAR,
                     $sim_ac_var_functionname,
                     [The $1 compiler has a variable containing the current function name])
fi
])


# Usage:
#   SIM_AC_CHECK_VAR_FUNCTIONNAME
#
# Convenience wrapper for the above function.
AC_DEFUN([SIM_AC_CHECK_VAR_FUNCTIONNAME], [
  AC_LANG_PUSH(C++)
  SIM_AC_COMPILER_FUNCTIONNAME_VAR(CPP)
  AC_LANG_POP(C++)
  AC_LANG_PUSH(C)
  SIM_AC_COMPILER_FUNCTIONNAME_VAR(C)
  AC_LANG_POP(C)
])

# Usage:
#   SIM_AC_DEBUGSYMBOLS
#
# Description:
#   Let the user decide if debug symbol information should be compiled
#   in. The compiled libraries/executables will use a lot less space
#   if stripped for their symbol information.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#

AC_DEFUN([SIM_AC_DEBUGSYMBOLS], [
AC_ARG_ENABLE(
  [symbols],
  AC_HELP_STRING([--enable-symbols],
                 [include symbol debug information [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_symbols=yes ;;
    no)  enable_symbols=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-symbols) ;;
  esac],
  [enable_symbols=yes])

# weird seds to don't mangle options like -fno-gnu-linker and -fvolatile-global
if test x"$enable_symbols" = x"no"; then
  CFLAGS="`echo $CFLAGS | sed 's/ -g / /g' | sed 's/^-g / /g' | sed 's/ -g$/ /g' | sed 's/^-g$/ /'`"
  CXXFLAGS="`echo $CXXFLAGS | sed 's/ -g / /g' | sed 's/^-g / /g' | sed 's/ -g$/ /g' | sed 's/^-g$/ /'`"
fi
]) # SIM_AC_DEBUGSYMBOLS


# Usage:
#   SIM_AC_RTTI_SUPPORT
#
# Description:
#   Let the user decide if RTTI should be compiled in. The compiled
#   libraries/executables will use a lot less space if they don't
#   contain RTTI.
#
#   Note: this macro must be placed after AC_PROG_CXX in the
#   configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.

AC_DEFUN([SIM_AC_RTTI_SUPPORT], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [rtti],
  AC_HELP_STRING([--enable-rtti], [(g++ only) compile with RTTI [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_rtti=yes ;;
    no)  enable_rtti=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-rtti) ;;
  esac],
  [enable_rtti=yes])

if test x"$enable_rtti" = x"no"; then
  if test x"$GXX" = x"yes"; then
    CXXFLAGS="$CXXFLAGS -fno-rtti"
  else
    AC_MSG_WARN([--enable-rtti only has effect when using GNU g++])
  fi
fi
])

# Usage:
#   SIM_AC_EXCEPTION_HANDLING
#
# Description:
#   Let the user decide if C++ exception handling should be compiled
#   in. With older compilers the libraries/executables will use a lot
#   less space if they have exception handling support disabled, on
#   modern compilers the difference is negligible.
#
#   Note: this macro must be placed after AC_PROG_CXX in the
#   configure.in script.
#
#   Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] make this work with compilers other than gcc/g++
#

AC_DEFUN([SIM_AC_EXCEPTION_HANDLING], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [exceptions],
  AC_HELP_STRING([--enable-exceptions],
                 [(g++ only) compile with exceptions [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_exceptions=yes ;;
    no)  enable_exceptions=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-exceptions) ;;
  esac],
  [enable_exceptions=yes])

if test x"$enable_exceptions" = x"no"; then
  if test "x$GXX" = "xyes"; then
    unset _exception_flag
    dnl This is for GCC >= 2.8
    SIM_AC_CXX_COMPILER_OPTION([-fno-exceptions], [_exception_flag=-fno-exceptions])
    if test x"${_exception_flag+set}" != x"set"; then
      dnl For GCC versions < 2.8
      SIM_AC_CXX_COMPILER_OPTION([-fno-handle-exceptions],
                                 [_exception_flag=-fno-handle-exceptions])
    fi
    if test x"${_exception_flag+set}" != x"set"; then
      AC_MSG_WARN([couldn't find a valid option for avoiding exception handling])
    else
      CXXFLAGS="$CXXFLAGS $_exception_flag"
    fi
  fi
else
  if $BUILD_WITH_MSVC; then
    SIM_AC_CXX_COMPILER_OPTION([/EHsc], [CXXFLAGS="$CXXFLAGS /EHsc"])
  else
    if test x"$GXX" != x"yes"; then
      AC_MSG_WARN([--enable-exceptions only has effect when using GNU g++])
    fi
  fi
fi
])


# Usage:
#   SIM_AC_PROFILING_SUPPORT
#
# Description:
#   Let the user decide if profiling code should be compiled
#   in. The compiled libraries/executables will use a lot less space
#   if they don't contain profiling code information, and they will also
#   execute faster.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] make this work with compilers other than gcc/g++
#

AC_DEFUN([SIM_AC_PROFILING_SUPPORT], [
AC_PREREQ([2.13])
AC_ARG_ENABLE(
  [profile],
  AC_HELP_STRING([--enable-profile],
                 [(GCC only) turn on inclusion of profiling code [[default=no]]]),
  [case "${enableval}" in
    yes) enable_profile=yes ;;
    no)  enable_profile=no ;;
    *) AC_MSG_ERROR(bad value "${enableval}" for --enable-profile) ;;
  esac],
  [enable_profile=no])

if test x"$enable_profile" = x"yes"; then
  if test x"$GXX" = x"yes" || test x"$GCC" = x"yes"; then
    CFLAGS="$CFLAGS -pg"
    CXXFLAGS="$CXXFLAGS -pg"
    LDFLAGS="$LDFLAGS -pg"
  else
    AC_MSG_WARN([--enable-profile only has effect when using GNU gcc or g++])
  fi
fi
])


# Usage:
#   SIM_AC_COMPILER_WARNINGS
#
# Description:
#   Take care of making a sensible selection of warning messages
#   to turn on or off.
#
#   Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
#   in the configure.in script.
#
# Author: Morten Eriksen, <mortene@sim.no>.
#
# TODO:
#   * [mortene:19991114] find out how to get GCC's
#     -Werror-implicit-function-declaration option to work as expected
#
#   * [larsa:20010504] rename to SIM_AC_COMPILER_WARNINGS and clean up
#     the macro

AC_DEFUN([SIM_AC_COMPILER_WARNINGS], [
AC_ARG_ENABLE(
  [warnings],
  AC_HELP_STRING([--enable-warnings],
                 [turn on warnings when compiling [[default=yes]]]),
  [case "${enableval}" in
    yes) enable_warnings=yes ;;
    no)  enable_warnings=no ;;
    *) AC_MSG_ERROR([bad value "$enableval" for --enable-warnings]) ;;
  esac],
  [enable_warnings=yes])

if test x"$enable_warnings" = x"yes"; then

  for sim_ac_try_cc_warning_option in \
    "-W" "-Wall" "-Wno-unused" "-Wno-multichar"; do

    if test x"$GCC" = x"yes"; then
      SIM_AC_CC_COMPILER_OPTION([$sim_ac_try_cc_warning_option],
                                [CFLAGS="$CFLAGS $sim_ac_try_cc_warning_option"])
    fi
  done

  for sim_ac_try_cxx_warning_option in \
    "-W" "-Wall" "-Wno-unused" "-Wno-multichar" "-Woverloaded-virtual"; do
    if test x"$GXX" = x"yes"; then
      SIM_AC_CXX_COMPILER_OPTION([$sim_ac_try_cxx_warning_option],
                                 [CXXFLAGS="$CXXFLAGS $sim_ac_try_cxx_warning_option"])
    fi

  done

  case $host in
  *-*-irix*)
    ### Turn on all warnings ######################################
    # we try to catch settings like CC="CC -n32" too, even though the
    # -n32 option belongs to C[XX]FLAGS
    case $CC in
    cc | "cc "* | CC | "CC "* )
      SIM_AC_CC_COMPILER_OPTION([-fullwarn], [CFLAGS="$CFLAGS -fullwarn"])
      ;;
    esac
    case $CXX in
    CC | "CC "* )
      SIM_AC_CXX_COMPILER_OPTION([-fullwarn], [CXXFLAGS="$CXXFLAGS -fullwarn"])
      ;;
    esac

    ### Turn off specific (bogus) warnings ########################

    ### SGI MipsPro v?.?? (our compiler on IRIX 6.2) ##############
    ##
    ## 3115: ``type qualifiers are meaningless in this declaration''.
    ## 3262: unused variables.
    ##
    ### SGI MipsPro v7.30 #########################################
    ##
    ## 1174: "The function was declared but never referenced."
    ## 1209: "The controlling expression is constant." (kill warning on
    ##       if (0), assert(FALSE), etc).
    ## 1375: Non-virtual destructors in base classes.
    ## 3201: Unused argument to a function.
    ## 1110: "Statement is not reachable" (the Lex/Flex generated code in
    ##       Coin/src/engines has lots of shitty code which needs this).
    ## 1506: Implicit conversion from "unsigned long" to "long".
    ##       SbTime.h in SGI/TGS Inventor does this, so we need to kill
    ##       this warning to avoid all the output clutter when compiling
    ##       the SoQt, SoGtk or SoXt libraries on IRIX with SGI MIPSPro CC.
    ## 1169: External/internal linkage conflicts with a previous declaration.
    ##       We get this for the "friend operators" in SbString.h

    sim_ac_bogus_warnings="-woff 3115,3262,1174,1209,1375,3201,1110,1506,1169,1210"

    case $CC in
    cc | "cc "* | CC | "CC "* )
      SIM_AC_CC_COMPILER_OPTION([$sim_ac_bogus_warnings],
                                [CFLAGS="$CFLAGS $sim_ac_bogus_warnings"])
    esac
    case $CXX in
    CC | "CC "* )
      SIM_AC_CXX_COMPILER_OPTION([$sim_ac_bogus_warnings],
                                 [CXXFLAGS="$CXXFLAGS $sim_ac_bogus_warnings"])
      ;;
    esac
  ;;
  esac
fi
])

# **************************************************************************
#
# SIM_AC_DETECT_COMMON_COMPILER_FLAGS
#
# Sets sim_ac_compiler_CFLAGS and sim_ac_compiler_CXXFLAGS
#

AC_DEFUN([SIM_AC_DETECT_COMMON_COMPILER_FLAGS], [

AC_REQUIRE([SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE])
AC_REQUIRE([SIM_AC_CHECK_SIMIAN_IFELSE])

sim_ac_simian=false

SIM_AC_COMPILE_DEBUG([
  if test x"$GCC" = x"yes"; then
    # no auto string.h-functions
    SIM_AC_CC_COMPILER_OPTION([-fno-builtin], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -fno-builtin"])
    SIM_AC_CXX_COMPILER_OPTION([-fno-builtin], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -fno-builtin"])

    # disallow non-standard scoping of for()-variables
    SIM_AC_CXX_COMPILER_OPTION([-fno-for-scoping], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -fno-for-scope"])

    SIM_AC_CC_COMPILER_OPTION([-finline-functions], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -finline-functions"])
    SIM_AC_CXX_COMPILER_OPTION([-finline-functions], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -finline-functions"])

    if $sim_ac_simian; then
      if $sim_ac_source_release; then :; else
      # break build on warnings, except for in official source code releases
        if test x"$enable_werror" = x"no"; then :; else
          SIM_AC_CC_COMPILER_OPTION([-Werror], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Werror"])
          SIM_AC_CXX_COMPILER_OPTION([-Werror], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Werror"])
        fi
      fi
    fi

    # warn on missing return-value
    SIM_AC_CC_COMPILER_OPTION([-Wreturn-type], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wreturn-type"])
    SIM_AC_CXX_COMPILER_OPTION([-Wreturn-type], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wreturn-type"])

    SIM_AC_CC_COMPILER_OPTION([-Wchar-subscripts], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wchar-subscripts"])
    SIM_AC_CXX_COMPILER_OPTION([-Wchar-subscripts], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wchar-subscripts"])

    SIM_AC_CC_COMPILER_OPTION([-Wparentheses], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS -Wparentheses"])
    SIM_AC_CXX_COMPILER_OPTION([-Wparentheses], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS -Wparentheses"])

  else
    case $CXX in
    *wrapmsvc* )
      if $sim_ac_simian; then
        if $sim_ac_source_release; then :; else
          # break build on warnings, except for in official source code releases
          SIM_AC_CC_COMPILER_OPTION([/WX], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /WX"])
          SIM_AC_CXX_COMPILER_OPTION([/WX], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /WX"])
        fi
      fi

      # warning level 3
      SIM_AC_CC_COMPILER_OPTION([/W3], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /W3"])
      SIM_AC_CXX_COMPILER_OPTION([/W3], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /W3"])

      if test ${sim_ac_msvc_version-0} -gt 6; then
        # 64-bit porting warnings
        SIM_AC_CC_COMPILER_OPTION([/Wp64], [sim_ac_compiler_CFLAGS="$sim_ac_compiler_CFLAGS /Wp64"])
        SIM_AC_CXX_COMPILER_OPTION([/Wp64], [sim_ac_compiler_CXXFLAGS="$sim_ac_compiler_CXXFLAGS /Wp64"])
      fi
      ;;
    esac
  fi
])

ifelse($1, [], :, $1)

])

AC_DEFUN([SIM_AC_COMPILER_NOBOOL], [
sim_ac_nobool_CXXFLAGS=
sim_ac_have_nobool=false
AC_MSG_CHECKING([whether $CXX accepts /noBool])
if $BUILD_WITH_MSVC && test x$sim_ac_msvc_version = x6; then
  SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET(
    [/noBool],
    [int temp],
    [SIM_AC_CXX_COMPILER_BEHAVIOR_OPTION_QUIET(
      [/noBool],
      [bool res = true],
      [],
      [sim_ac_have_nobool=true])])
fi

if $sim_ac_have_nobool; then
  sim_ac_nobool_CXXFLAGS="/noBool"
  AC_MSG_RESULT([yes])
  ifelse([$1], , :, [$1])
else
  AC_MSG_RESULT([no])
  ifelse([$2], , :, [$2])
fi
])


#
# SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE( IF-BETA, IF-BONA-FIDE )
#
# Sets sim_ac_source_release to true or false
#

AC_DEFUN([SIM_AC_CHECK_PROJECT_BETA_STATUS_IFELSE], [
AC_MSG_CHECKING([for project release status])
case $VERSION in
*[[a-z]]* )
  AC_MSG_RESULT([beta / inbetween releases])
  sim_ac_source_release=false
  ifelse($1, [], :, $1)
  ;;
* )
  AC_MSG_RESULT([release version])
  sim_ac_source_release=true
  ifelse($2, [], :, $2)
  ;;
esac
])


# conf-macros/sogui.m4
#
# Common macros for the various GUI toolkit libraries for Coin.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>

# SIM_AC_SOGUI_STATIC_DEFAULTS
# ============================
# If --disable-static-defaults is used, do not define WITH_STATIC_DEFAULTS.

AC_DEFUN([SIM_AC_SOGUI_STATIC_DEFAULTS],
[
sim_ac_static_defaults=true;
AC_ARG_ENABLE(
  [static-defaults],
  AC_HELP_STRING([--disable-static-defaults], [Disable defaults from being statically linked in]),
  [case ${enable_static_defaults} in
   no)  sim_ac_static_defaults=false ;;
   yes) ;;
   *)   echo "Option '--enable-static-defaults=${enable_static_defaults}' ignored" ;;
  esac],
  [])

if $sim_ac_static_defaults; then
  AC_DEFINE(WITH_STATIC_DEFAULTS, ,
    [Define this if you want defaults to be linked into SoXt])
fi
])


# **************************************************************************
# SIM_AC_UNIQIFY_LIST( VARIABLE, LIST )
#
# This macro filters out redundant items from a list.  This macro was made
# to avoid having multiple equivalent -I and -L options for the compiler on
# the command-line, which made compilation quite messy to watch.
#
# BUGS:
#   Items with spaces are probably not supported.
#
# Note that this macro is obsolete! You should use the alternative
# macro SIM_AC_UNIQIFY_OPTION_LIST instead, which supports spaces.
#
# Authors:
#   Lars J. Aas <larsa@sim.no>
#

AC_DEFUN([SIM_AC_UNIQIFY_LIST], [
sim_ac_save_prefix=$prefix
sim_ac_save_exec_prefix=$exec_prefix
test x"$prefix" = xNONE && prefix=/usr/local
test x"$exec_prefix" = xNONE && exec_prefix='${prefix}'
sim_ac_uniqued_list=
for sim_ac_item in $2; do
  eval sim_ac_eval_item="$sim_ac_item"
  eval sim_ac_eval_item="$sim_ac_eval_item"
  if test x"$sim_ac_uniqued_list" = x; then
    sim_ac_uniqued_list="$sim_ac_item"
  else
    sim_ac_unique=true
    for sim_ac_uniq in $sim_ac_uniqued_list; do
      eval sim_ac_eval_uniq="$sim_ac_uniq"
      eval sim_ac_eval_uniq="$sim_ac_eval_uniq"
      test x"$sim_ac_eval_item" = x"$sim_ac_eval_uniq" && sim_ac_unique=false
    done
    $sim_ac_unique && sim_ac_uniqued_list="$sim_ac_uniqued_list $sim_ac_item"
  fi
done
$1=$sim_ac_uniqued_list
prefix=$sim_ac_save_prefix
exec_prefix=$sim_ac_save_exec_prefix
# unset sim_ac_save_prefix
# unset sim_ac_save_exec_prefix
# unset sim_ac_eval_item
# unset sim_ac_eval_uniq
]) # SIM_AC_UNIQIFY_LIST


# CPP_AC_SEARCH_ORDER_FILTER( VARIABLE, LIST )
#
# This macro filters out system directories from a list. This macro was made
# to avoid passing -I options to the gcc3 compiler that are possibly already
# one of gcc3's system directories. This would cause the preprocessor to
# issue a "warning: changing search order for system directory ..." message
# that could break some configure scripts and produce annoying warning
# messages for every source file compiled.
#
# Authors:
#   Tamer Fahmy <tamer@tammura.at>
#

AC_DEFUN([CPP_AC_SEARCH_ORDER_FILTER], [
if test x"$GCC" = x"yes"; then
 sim_ac_save_cpp=$CPP
 CPP="cpp"
 case $host_os in
  darwin*) CPP="cpp3"
    ;;
  esac
  cpp_sys_dirs=`$CPP -v <<EOF 2>&1 | sed -n -e \
  '/#include <...> search starts here:/,/End of search list./{
    /#include <...> search starts here:/b
    /End of search list./b
    s/ /-I/
    p
  }'
EOF`
  result=
  for inc_path in $2; do
    additem=true
    for sys_dir in $cpp_sys_dirs; do
      if test x$inc_path = x$sys_dir; then
        additem=false
        break
      fi
    done
    $additem && result="$result $inc_path"
  done
  $1=$result
  CPP=$sim_ac_save_cpp
fi
]) # CPP_AC_SEARCH_ORDER_FILTER


# Usage:
#  SIM_AC_PACKAGEMAKER_APP([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
#
# Description:
#   This macro locates the PackageMaker app bundle (Mac OS X).
#   If found, the variable $sim_ac_packagemaker_app is set to the full
#   path- and app bundle name.
#   If not found, it is set to "false".
#
# Author: Marius Kintel, <kintel@sim.no>

AC_DEFUN([SIM_AC_PACKAGEMAKER_APP], [
sim_ac_packagemaker_app=false
if test -d /Developer/Applications/PackageMaker.app; then
  sim_ac_packagemaker_app=/Developer/Applications/PackageMaker.app
elif test -d /Developer/Applications/Utilities/PackageMaker.app; then
  sim_ac_packagemaker_app=/Developer/Applications/Utilities/PackageMaker.app
fi
])

