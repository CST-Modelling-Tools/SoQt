dnl aclocal.m4 generated automatically by aclocal 1.4a

dnl Copyright (C) 1994, 1995-8, 1999 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY, to the extent permitted by law; without
dnl even the implied warranty of MERCHANTABILITY or FITNESS FOR A
dnl PARTICULAR PURPOSE.

# Do all the work for Automake.  This macro actually does too much --
# some checks are only needed if your package does certain things.
# But this isn't really a big deal.

# serial 1

dnl Usage:
dnl AM_INIT_AUTOMAKE(package,version, [no-define])

AC_DEFUN(AM_INIT_AUTOMAKE,
[AC_REQUIRE([AC_PROG_INSTALL])
dnl We require 2.13 because we rely on SHELL being computed by configure.
AC_PREREQ([2.13])
PACKAGE=[$1]
AC_SUBST(PACKAGE)
VERSION=[$2]
AC_SUBST(VERSION)
dnl test to see if srcdir already configured
if test "`cd $srcdir && pwd`" != "`pwd`" && test -f $srcdir/config.status; then
  AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
fi
ifelse([$3],,
AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package]))
AC_REQUIRE([AM_SANITY_CHECK])
AC_REQUIRE([AC_ARG_PROGRAM])
dnl FIXME This is truly gross.
missing_dir=`cd $ac_aux_dir && pwd`
AM_MISSING_PROG(ACLOCAL, aclocal, $missing_dir)
AM_MISSING_PROG(AUTOCONF, autoconf, $missing_dir)
AM_MISSING_PROG(AUTOMAKE, automake, $missing_dir)
AM_MISSING_PROG(AUTOHEADER, autoheader, $missing_dir)
AM_MISSING_PROG(MAKEINFO, makeinfo, $missing_dir)
AC_REQUIRE([AC_PROG_MAKE_SET])])

#
# Check to make sure that the build environment is sane.
#

AC_DEFUN(AM_SANITY_CHECK,
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftestfile
# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt $srcdir/configure conftestfile 2> /dev/null`
   if test "[$]*" = "X"; then
      # -L didn't work.
      set X `ls -t $srcdir/configure conftestfile`
   fi
   if test "[$]*" != "X $srcdir/configure conftestfile" \
      && test "[$]*" != "X conftestfile $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "[$]2" = conftestfile
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
rm -f conftest*
AC_MSG_RESULT(yes)])

dnl AM_MISSING_PROG(NAME, PROGRAM, DIRECTORY)
dnl The program must properly implement --version.
AC_DEFUN(AM_MISSING_PROG,
[AC_MSG_CHECKING(for working $2)
# Run test in a subshell; some versions of sh will print an error if
# an executable is not found, even if stderr is redirected.
# Redirect stdin to placate older versions of autoconf.  Sigh.
if ($2 --version) < /dev/null > /dev/null 2>&1; then
   $1=$2
   AC_MSG_RESULT(found)
else
   $1="$3/missing $2"
   AC_MSG_RESULT(missing)
fi
AC_SUBST($1)])

# Like AC_CONFIG_HEADER, but automatically create stamp file.

AC_DEFUN(AM_CONFIG_HEADER,
[AC_PREREQ([2.12])
AC_CONFIG_HEADER([$1])
dnl When config.status generates a header, we must update the stamp-h file.
dnl This file resides in the same directory as the config header
dnl that is generated.  We must strip everything past the first ":",
dnl and everything past the last "/".
AC_OUTPUT_COMMANDS(changequote(<<,>>)dnl
ifelse(patsubst(<<$1>>, <<[^ ]>>, <<>>), <<>>,
<<test -z "<<$>>CONFIG_HEADERS" || echo timestamp > patsubst(<<$1>>, <<^\([^:]*/\)?.*>>, <<\1>>)stamp-h<<>>dnl>>,
<<am_indx=1
for am_file in <<$1>>; do
  case " <<$>>CONFIG_HEADERS " in
  *" <<$>>am_file "*<<)>>
    echo timestamp > `echo <<$>>am_file | sed -e 's%:.*%%' -e 's%[^/]*$%%'`stamp-h$am_indx
    ;;
  esac
  am_indx=`expr "<<$>>am_indx" + 1`
done<<>>dnl>>)
changequote([,]))])


# serial 35 AC_PROG_LIBTOOL
AC_DEFUN(AC_PROG_LIBTOOL,
[AC_REQUIRE([AC_LIBTOOL_SETUP])dnl

# Save cache, so that ltconfig can load it
AC_CACHE_SAVE

# Actually configure libtool.  ac_aux_dir is where install-sh is found.
CC="$CC" CFLAGS="$CFLAGS" CPPFLAGS="$CPPFLAGS" \
LD="$LD" NM="$NM" RANLIB="$RANLIB" LN_S="$LN_S" \
DLLTOOL="$DLLTOOL" AS="$AS" \
${CONFIG_SHELL-/bin/sh} $ac_aux_dir/ltconfig --no-reexec \
$libtool_flags --no-verify $ac_aux_dir/ltmain.sh $host \
|| AC_MSG_ERROR([libtool configure failed])

# Reload cache, that may have been modified by ltconfig
AC_CACHE_LOAD

# This can be used to rebuild libtool when needed
LIBTOOL_DEPS="$ac_aux_dir/ltconfig $ac_aux_dir/ltmain.sh"

# Always use our own libtool.
LIBTOOL='$(SHELL) $(top_builddir)/libtool'
AC_SUBST(LIBTOOL)dnl

# Redirect the config.log output again, so that the ltconfig log is not
# clobbered by the next message.
exec 5>>./config.log
])

AC_DEFUN(AC_LIBTOOL_SETUP,
[AC_PREREQ(2.13)dnl
AC_REQUIRE([AC_ENABLE_SHARED])dnl
AC_REQUIRE([AC_ENABLE_STATIC])dnl
AC_REQUIRE([AC_ENABLE_FAST_INSTALL])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
AC_REQUIRE([AC_PROG_RANLIB])dnl
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_PROG_LD])dnl
AC_REQUIRE([AC_PROG_NM])dnl
AC_REQUIRE([AC_SYS_NM_PARSE])dnl
AC_REQUIRE([AC_SYS_SYMBOL_UNDERSCORE])dnl
AC_REQUIRE([AC_PROG_LN_S])dnl
dnl

# Check for any special flags to pass to ltconfig.
#
# the following will cause an existing older ltconfig to fail, so
# we ignore this at the expense of the cache file... Checking this 
# will just take longer ... bummer!
#libtool_flags="--cache-file=$cache_file"
#
test "$enable_shared" = no && libtool_flags="$libtool_flags --disable-shared"
test "$enable_static" = no && libtool_flags="$libtool_flags --disable-static"
test "$enable_fast_install" = no && libtool_flags="$libtool_flags --disable-fast-install"
test "$lt_dlopen" = yes && libtool_flags="$libtool_flags --enable-dlopen"
test "$silent" = yes && libtool_flags="$libtool_flags --silent"
test "$ac_cv_prog_gcc" = yes && libtool_flags="$libtool_flags --with-gcc"
test "$ac_cv_prog_gnu_ld" = yes && libtool_flags="$libtool_flags --with-gnu-ld"

# Some flags need to be propagated to the compiler or linker for good
# libtool support.
case "$host" in
*-*-irix6*)
  # Find out which ABI we are using.
  echo '[#]line __oline__ "configure"' > conftest.$ac_ext
  if AC_TRY_EVAL(ac_compile); then
    case "`/usr/bin/file conftest.o`" in
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
  rm -rf conftest*
  ;;

*-*-sco3.2v5*)
  # On SCO OpenServer 5, we need -belf to get full-featured binaries.
  SAVE_CFLAGS="$CFLAGS"
  CFLAGS="$CFLAGS -belf"
  AC_CACHE_CHECK([whether the C compiler needs -belf], lt_cv_cc_needs_belf,
    [AC_TRY_LINK([],[],[lt_cv_cc_needs_belf=yes],[lt_cv_cc_needs_belf=no])])
  if test x"$lt_cv_cc_needs_belf" != x"yes"; then
    # this is probably gcc 2.8.0, egcs 1.0 or newer; no need for -belf
    CFLAGS="$SAVE_CFLAGS"
  fi
  ;;

*-*-cygwin*)
  AC_SYS_LIBTOOL_CYGWIN
  ;;

esac

# enable the --disable-libtool-lock switch

AC_ARG_ENABLE(libtool-lock,
[  --disable-libtool-lock  force libtool not to do file locking],
need_locks=$enableval,
need_locks=yes)

if test x"$need_locks" = xno; then
  libtool_flags="$libtool_flags --disable-lock"
fi
])

# AC_LIBTOOL_DLOPEN - check for dlopen support
AC_DEFUN(AC_LIBTOOL_DLOPEN, [lt_dlopen=yes])

# AC_ENABLE_SHARED - implement the --enable-shared flag
# Usage: AC_ENABLE_SHARED[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_SHARED,
[define([AC_ENABLE_SHARED_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(shared,
changequote(<<, >>)dnl
<<  --enable-shared[=PKGS]  build shared libraries [default=>>AC_ENABLE_SHARED_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_shared=yes ;;
no) enable_shared=no ;;
*)
  enable_shared=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_shared=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_shared=AC_ENABLE_SHARED_DEFAULT)dnl
])

# AC_DISABLE_SHARED - set the default shared flag to --disable-shared
AC_DEFUN(AC_DISABLE_SHARED,
[AC_ENABLE_SHARED(no)])

# AC_ENABLE_STATIC - implement the --enable-static flag
# Usage: AC_ENABLE_STATIC[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_STATIC,
[define([AC_ENABLE_STATIC_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(static,
changequote(<<, >>)dnl
<<  --enable-static[=PKGS]  build static libraries [default=>>AC_ENABLE_STATIC_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_static=yes ;;
no) enable_static=no ;;
*)
  enable_static=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_static=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_static=AC_ENABLE_STATIC_DEFAULT)dnl
])

# AC_DISABLE_STATIC - set the default static flag to --disable-static
AC_DEFUN(AC_DISABLE_STATIC,
[AC_ENABLE_STATIC(no)])


# AC_ENABLE_FAST_INSTALL - implement the --enable-fast-install flag
# Usage: AC_ENABLE_FAST_INSTALL[(DEFAULT)]
#   Where DEFAULT is either `yes' or `no'.  If omitted, it defaults to
#   `yes'.
AC_DEFUN(AC_ENABLE_FAST_INSTALL,
[define([AC_ENABLE_FAST_INSTALL_DEFAULT], ifelse($1, no, no, yes))dnl
AC_ARG_ENABLE(fast-install,
changequote(<<, >>)dnl
<<  --enable-fast-install[=PKGS]  optimize for fast installation [default=>>AC_ENABLE_FAST_INSTALL_DEFAULT],
changequote([, ])dnl
[p=${PACKAGE-default}
case "$enableval" in
yes) enable_fast_install=yes ;;
no) enable_fast_install=no ;;
*)
  enable_fast_install=no
  # Look at the argument we got.  We use all the common list separators.
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:,"
  for pkg in $enableval; do
    if test "X$pkg" = "X$p"; then
      enable_fast_install=yes
    fi
  done
  IFS="$ac_save_ifs"
  ;;
esac],
enable_fast_install=AC_ENABLE_FAST_INSTALL_DEFAULT)dnl
])

# AC_ENABLE_FAST_INSTALL - set the default to --disable-fast-install
AC_DEFUN(AC_DISABLE_FAST_INSTALL,
[AC_ENABLE_FAST_INSTALL(no)])


# AC_PROG_LD - find the path to the GNU or non-GNU linker
AC_DEFUN(AC_PROG_LD,
[AC_ARG_WITH(gnu-ld,
[  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]],
test "$withval" = no || with_gnu_ld=yes, with_gnu_ld=no)
AC_REQUIRE([AC_PROG_CC])dnl
AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_CANONICAL_BUILD])dnl
ac_prog=ld
if test "$ac_cv_prog_gcc" = yes; then
  # Check if gcc -print-prog-name=ld gives a path.
  AC_MSG_CHECKING([for ld used by GCC])
  ac_prog=`($CC -print-prog-name=ld) 2>&5`
  case "$ac_prog" in
    # Accept absolute paths.
changequote(,)dnl
    /* | [A-Za-z]:[\\/]*)
      re_direlt='/[^/][^/]*/\.\./'
changequote([,])dnl
      # Canonicalize the path of ld
      ac_prog=`echo $ac_prog| sed 's%\\\\%/%g'`
      while echo $ac_prog | grep "$re_direlt" > /dev/null 2>&1; do
	ac_prog=`echo $ac_prog| sed "s%$re_direlt%/%"`
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
AC_CACHE_VAL(ac_cv_path_LD,
[if test -z "$LD"; then
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH; do
    test -z "$ac_dir" && ac_dir=.
    if test -f "$ac_dir/$ac_prog"; then
      ac_cv_path_LD="$ac_dir/$ac_prog"
      # Check to see if the program is GNU ld.  I'd rather use --version,
      # but apparently some GNU ld's only accept -v.
      # Break only if it was the GNU/non-GNU ld that we prefer.
      if "$ac_cv_path_LD" -v 2>&1 < /dev/null | egrep '(GNU|with BFD)' > /dev/null; then
	test "$with_gnu_ld" != no && break
      else
	test "$with_gnu_ld" != yes && break
      fi
    fi
  done
  IFS="$ac_save_ifs"
else
  ac_cv_path_LD="$LD" # Let the user override the test with a path.
fi])
LD="$ac_cv_path_LD"
if test -n "$LD"; then
  AC_MSG_RESULT($LD)
else
  AC_MSG_RESULT(no)
fi
test -z "$LD" && AC_MSG_ERROR([no acceptable ld found in \$PATH])
AC_SUBST(LD)
AC_PROG_LD_GNU
])

AC_DEFUN(AC_PROG_LD_GNU,
[AC_CACHE_CHECK([if the linker ($LD) is GNU ld], ac_cv_prog_gnu_ld,
[# I'd rather use --version here, but apparently some GNU ld's only accept -v.
if $LD -v 2>&1 </dev/null | egrep '(GNU|with BFD)' 1>&5; then
  ac_cv_prog_gnu_ld=yes
else
  ac_cv_prog_gnu_ld=no
fi])
])

# AC_PROG_NM - find the path to a BSD-compatible name lister
AC_DEFUN(AC_PROG_NM,
[AC_MSG_CHECKING([for BSD-compatible nm])
AC_CACHE_VAL(ac_cv_path_NM,
[if test -n "$NM"; then
  # Let the user override the test.
  ac_cv_path_NM="$NM"
else
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in $PATH /usr/ccs/bin /usr/ucb /bin; do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/nm; then
      # Check to see if the nm accepts a BSD-compat flag.
      # Adding the `sed 1q' prevents false positives on HP-UX, which says:
      #   nm: unknown option "B" ignored
      if ($ac_dir/nm -B /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -B"
	break
      elif ($ac_dir/nm -p /dev/null 2>&1 | sed '1q'; exit 0) | egrep /dev/null >/dev/null; then
	ac_cv_path_NM="$ac_dir/nm -p"
	break
      else
	ac_cv_path_NM=${ac_cv_path_NM="$ac_dir/nm"} # keep the first match, but
	continue # so that we can try to find one that supports BSD flags
      fi
    fi
  done
  IFS="$ac_save_ifs"
  test -z "$ac_cv_path_NM" && ac_cv_path_NM=nm
fi])
NM="$ac_cv_path_NM"
AC_MSG_RESULT([$NM])
AC_SUBST(NM)
])

# AC_SYS_NM_PARSE - Check for command to grab the raw symbol name followed
# by C symbol name from nm.
AC_DEFUN(AC_SYS_NM_PARSE,
[AC_REQUIRE([AC_CANONICAL_HOST])dnl
AC_REQUIRE([AC_PROG_NM])dnl
# Check for command to grab the raw symbol name followed by C symbol from nm.
AC_MSG_CHECKING([command to parse $NM output])
AC_CACHE_VAL(ac_cv_sys_global_symbol_pipe,
[# These are sane defaults that work on at least a few old systems.
# {They come from Ultrix.  What could be older than Ultrix?!! ;)}

changequote(,)dnl
# Character class describing NM global symbol codes.
ac_symcode='[BCDEGRST]'

# Regexp to match symbols that can be accessed directly from C.
ac_sympat='\([_A-Za-z][_A-Za-z0-9]*\)'

# Transform the above into a raw symbol and a C symbol.
ac_symxfrm='\1 \2\3 \3'

# Transform an extracted symbol line into a proper C declaration
ac_global_symbol_to_cdecl="sed -n -e 's/^. .* \(.*\)$/extern char \1;/p'"

# Define system-specific variables.
case "$host_os" in
aix*)
  ac_symcode='[BCDT]'
  ;;
cygwin* | mingw*)
  ac_symcode='[ABCDGISTW]'
  ;;
hpux*)
  ac_global_symbol_to_cdecl="sed -n -e 's/^T .* \(.*\)$/extern char \1();/p' -e 's/^. .* \(.*\)$/extern char \1;/p'"
  ;;
irix*)
  ac_symcode='[BCDEGRST]'
  ;;
solaris*)
  ac_symcode='[BDT]'
  ;;
esac

# If we're using GNU nm, then use its standard symbol codes.
if $NM -V 2>&1 | egrep '(GNU|with BFD)' > /dev/null; then
  ac_symcode='[ABCDGISTW]'
fi
changequote([,])dnl

# Try without a prefix undercore, then with it.
for ac_symprfx in "" "_"; do

  ac_cv_sys_global_symbol_pipe="sed -n -e 's/^.*[ 	]\($ac_symcode\)[ 	][ 	]*\($ac_symprfx\)$ac_sympat$/$ac_symxfrm/p'"

  # Check to see that the pipe works correctly.
  ac_pipe_works=no
  rm -f conftest.$ac_ext
  cat > conftest.$ac_ext <<EOF
#ifdef __cplusplus
extern "C" {
#endif
char nm_test_var;
void nm_test_func(){}
#ifdef __cplusplus
}
#endif
int main(){nm_test_var='a';nm_test_func;return 0;}
EOF

  if AC_TRY_EVAL(ac_compile); then
    # Now try to grab the symbols.
    ac_nlist=conftest.nm
  
    if AC_TRY_EVAL(NM conftest.$ac_objext \| $ac_cv_sys_global_symbol_pipe \> $ac_nlist) && test -s "$ac_nlist"; then

      # Try sorting and uniquifying the output.
      if sort "$ac_nlist" | uniq > "$ac_nlist"T; then
	mv -f "$ac_nlist"T "$ac_nlist"
      else
	rm -f "$ac_nlist"T
      fi

      # Make sure that we snagged all the symbols we need.
      if egrep ' nm_test_var$' "$ac_nlist" >/dev/null; then
	if egrep ' nm_test_func$' "$ac_nlist" >/dev/null; then
	  cat <<EOF > conftest.c
#ifdef __cplusplus
extern "C" {
#endif

EOF
	  # Now generate the symbol file.
	  eval "$ac_global_symbol_to_cdecl"' < "$ac_nlist" >> conftest.c'

	  cat <<EOF >> conftest.c
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
changequote(,)dnl
lt_preloaded_symbols[] =
changequote([,])dnl
{
EOF
	sed 's/^. \(.*\) \(.*\)$/  {"\2", (lt_ptr_t) \&\2},/' < "$ac_nlist" >> conftest.c
	cat <<\EOF >> conftest.c
  {0, (lt_ptr_t) 0}
};

#ifdef __cplusplus
}
#endif
EOF
	  # Now try linking the two files.
	  mv conftest.$ac_objext conftestm.$ac_objext
	  ac_save_LIBS="$LIBS"
	  ac_save_CFLAGS="$CFLAGS"
	  LIBS="conftestm.$ac_objext"
	  CFLAGS="$CFLAGS$no_builtin_flag"
	  if AC_TRY_EVAL(ac_link) && test -s conftest; then
	    ac_pipe_works=yes
	  else
	    echo "configure: failed program was:" >&AC_FD_CC
	    cat conftest.c >&AC_FD_CC
	  fi
	  LIBS="$ac_save_LIBS"
	  CFLAGS="$ac_save_CFLAGS"
	else
	  echo "cannot find nm_test_func in $ac_nlist" >&AC_FD_CC
	fi
      else
	echo "cannot find nm_test_var in $ac_nlist" >&AC_FD_CC
      fi
    else
      echo "cannot run $ac_cv_sys_global_symbol_pipe" >&AC_FD_CC
    fi
  else
    echo "$progname: failed program was:" >&AC_FD_CC
    cat conftest.c >&AC_FD_CC
  fi
  rm -rf conftest*

  # Do not use the global_symbol_pipe unless it works.
  if test "$ac_pipe_works" = yes; then
    if test x"$ac_symprfx" = x"_"; then
      ac_cv_sys_symbol_underscore=yes
    else
      ac_cv_sys_symbol_underscore=no
    fi
    break
  else
    ac_cv_sys_global_symbol_pipe=
  fi
done
])

ac_result=yes
if test -z "$ac_cv_sys_global_symbol_pipe"; then
   ac_result=no
fi
AC_MSG_RESULT($ac_result)
])

# AC_SYS_LIBTOOL_CYGWIN - find tools needed on cygwin
AC_DEFUN(AC_SYS_LIBTOOL_CYGWIN,
[AC_CHECK_TOOL(DLLTOOL, dlltool, false)
AC_CHECK_TOOL(AS, as, false)
])

# AC_SYS_SYMBOL_UNDERSCORE - does the compiler prefix global symbols
#                            with an underscore?
AC_DEFUN(AC_SYS_SYMBOL_UNDERSCORE,
[AC_REQUIRE([AC_PROG_NM])dnl
AC_REQUIRE([AC_SYS_NM_PARSE])dnl
AC_MSG_CHECKING([for _ prefix in compiled symbols])
AC_CACHE_VAL(ac_cv_sys_symbol_underscore,
[ac_cv_sys_symbol_underscore=no
cat > conftest.$ac_ext <<EOF
void nm_test_func(){}
int main(){nm_test_func;return 0;}
EOF
if AC_TRY_EVAL(ac_compile); then
  # Now try to grab the symbols.
  ac_nlist=conftest.nm
  if AC_TRY_EVAL(NM conftest.$ac_objext \| $ac_cv_sys_global_symbol_pipe \> $ac_nlist) && test -s "$ac_nlist"; then
    # See whether the symbols have a leading underscore.
    if egrep '^. _nm_test_func' "$ac_nlist" >/dev/null; then
      ac_cv_sys_symbol_underscore=yes
    else
      if egrep '^. nm_test_func ' "$ac_nlist" >/dev/null; then
	:
      else
	echo "configure: cannot find nm_test_func in $ac_nlist" >&AC_FD_CC
      fi
    fi
  else
    echo "configure: cannot run $ac_cv_sys_global_symbol_pipe" >&AC_FD_CC
  fi
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.c >&AC_FD_CC
fi
rm -rf conftest*
])
AC_MSG_RESULT($ac_cv_sys_symbol_underscore)
USE_SYMBOL_UNDERSCORE=${ac_cv_sys_symbol_underscore=no}
AC_SUBST(USE_SYMBOL_UNDERSCORE)dnl
])

# AC_CHECK_LIBM - check for math library
AC_DEFUN(AC_CHECK_LIBM, [
AC_CHECK_LIB(mw, _mwvalidcheckl)
AC_CHECK_LIB(m, cos)
])

# AC_LIBLTDL_CONVENIENCE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl convenience library, adds --enable-ltdl-convenience to
# the configure arguments.  Note that LIBLTDL is not AC_SUBSTed, nor
# is AC_CONFIG_SUBDIRS called.  If DIR is not provided, it is assumed
# to be `${top_builddir}/libltdl'.  Make sure you start DIR with
# '${top_builddir}/' (note the single quotes!) if your package is not
# flat, and, if you're not using automake, define top_builddir as
# appropriate in the Makefiles.
AC_DEFUN(AC_LIBLTDL_CONVENIENCE, [
  case "$enable_ltdl_convenience" in
  no) AC_MSG_ERROR([this package needs a convenience libltdl]) ;;
  "") enable_ltdl_convenience=yes
      ac_configure_args="$ac_configure_args --enable-ltdl-convenience" ;;
  esac
  LIBLTDL=ifelse($#,1,$1,['${top_builddir}/libltdl'])/libltdlc.la
])

# AC_LIBLTDL_INSTALLABLE[(dir)] - sets LIBLTDL to the link flags for
# the libltdl installable library, and adds --enable-ltdl-install to
# the configure arguments.  Note that LIBLTDL is not AC_SUBSTed, nor
# is AC_CONFIG_SUBDIRS called.  If DIR is not provided, it is assumed
# to be `${top_builddir}/libltdl'.  Make sure you start DIR with
# '${top_builddir}/' (note the single quotes!) if your package is not
# flat, and, if you're not using automake, define top_builddir as
# appropriate in the Makefiles.
# In the future, this macro may have to be called after AC_PROG_LIBTOOL.
AC_DEFUN(AC_LIBLTDL_INSTALLABLE, [
  AC_CHECK_LIB(ltdl, main, LIBLTDL="-lltdl", [
    case "$enable_ltdl_install" in
    no) AC_MSG_WARN([libltdl not installed, but installation disabled]) ;;
    "") enable_ltdl_install=yes
        ac_configure_args="$ac_configure_args --enable-ltdl-install" ;;
    esac
  ])
  if test x"$enable_ltdl_install" != x"no"; then
    LIBLTDL=ifelse($#,1,$1,['${top_builddir}/libltdl'])/libltdl.la
  fi
])

dnl old names
AC_DEFUN(AM_PROG_LIBTOOL, [indir([AC_PROG_LIBTOOL])])dnl
AC_DEFUN(AM_ENABLE_SHARED, [indir([AC_ENABLE_SHARED], $@)])dnl
AC_DEFUN(AM_ENABLE_STATIC, [indir([AC_ENABLE_STATIC], $@)])dnl
AC_DEFUN(AM_DISABLE_SHARED, [indir([AC_DISABLE_SHARED], $@)])dnl
AC_DEFUN(AM_DISABLE_STATIC, [indir([AC_DISABLE_STATIC], $@)])dnl
AC_DEFUN(AM_PROG_LD, [indir([AC_PROG_LD])])dnl
AC_DEFUN(AM_PROG_NM, [indir([AC_PROG_NM])])dnl
AC_DEFUN(AM_SYS_NM_PARSE, [indir([AC_SYS_NM_PARSE])])dnl
AC_DEFUN(AM_SYS_SYMBOL_UNDERSCORE, [indir([AC_SYS_SYMBOL_UNDERSCORE])])dnl
AC_DEFUN(AM_SYS_LIBTOOL_CYGWIN, [indir([AC_SYS_LIBTOOL_CYGWIN])])dnl

# Add --enable-maintainer-mode option to configure.
# From Jim Meyering

# serial 1

AC_DEFUN(AM_MAINTAINER_MODE,
[AC_MSG_CHECKING([whether to enable maintainer-specific portions of Makefiles])
  dnl maintainer-mode is disabled by default
  AC_ARG_ENABLE(maintainer-mode,
[  --enable-maintainer-mode enable make rules and dependencies not useful
                          (and sometimes confusing) to the casual installer],
      USE_MAINTAINER_MODE=$enableval,
      USE_MAINTAINER_MODE=no)
  AC_MSG_RESULT($USE_MAINTAINER_MODE)
  AM_CONDITIONAL(MAINTAINER_MODE, test $USE_MAINTAINER_MODE = yes)
  MAINT=$MAINTAINER_MODE_TRUE
  AC_SUBST(MAINT)dnl
]
)

# Define a conditional.

AC_DEFUN(AM_CONDITIONAL,
[AC_SUBST($1_TRUE)
AC_SUBST($1_FALSE)
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi])

dnl  Set up necessary compiler and linker flags and options for
dnl  compiling against either Open Inventor or Coin. Exit configure
dnl  if the wanted library can't be found or used.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl
dnl    * [mortene:19991114] this macro could be useful for others -- submit
dnl      to autoconf macro archive?
dnl
dnl    * [mortene:19991114] make macro work under MSWindows with Cygwin.
dnl
dnl    * [mortene:19991114] should have AC_REQUIREs on detection of the
dnl      OpenGL and GLU libraries.
dnl

AC_DEFUN(SIM_INCLUDE_INVENTOR_LIB,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])

dnl FIXME: this won't work under MSWindows. 19991114 mortene.
AC_REQUIRE([AC_PATH_XTRA])

dnl Inventor and Coin are C++ libraries.
AC_REQUIRE([AC_PROG_CXX])
AC_LANG_SAVE
AC_LANG_CPLUSPLUS

dnl *******************************************************************
dnl * Check if we want to build on top of Open Inventor (if available).
dnl *******************************************************************

AC_ARG_WITH(inventor,
  [  --with-inventor         build on top of Open Inventor (if found) instead of Coin [default=no]],
  [case "${withval}" in
    yes) want_inventor=yes ;;
    no)  want_inventor=no ;;
    *) AC_MSG_ERROR(bad value \"${withval}\" for --with-inventor) ;;
  esac],
  [want_inventor=no])

dnl *******************************************************************
dnl * Check if Open Inventor development system is installed (if necessary).
dnl *******************************************************************

if test "x$want_inventor" = "xyes"; then
  AC_MSG_CHECKING(value of the OIVHOME environment variable)
  if test "x$OIVHOME" = "x"; then
    AC_MSG_RESULT(empty!)
    AC_MSG_WARN(OIVHOME environment variable not set -- this might be an indication of a problem)
  else
    AC_MSG_RESULT($OIVHOME)
    CXXFLAGS="$CXXFLAGS -I$OIVHOME/include"
    LDFLAGS="$LDFLAGS -L$OIVHOME/lib"
  fi

  AC_MSG_CHECKING(for Open Inventor header files)
  AC_TRY_COMPILE([#include <Inventor/SbBasic.h>], [], inventor_dev=yes, inventor_dev=no)
  AC_MSG_RESULT($inventor_dev)
  if test "x$inventor_dev" = "xno"; then
    AC_MSG_ERROR(could not find the Open Inventor include files -- we need them to build!)
  fi

  dnl FIXME: do an AC_CHECK_LIB on libimage before
  dnl libInventor. 19991114 mortene.

  inventortest_save_LIBS=$LIBS
  AC_CHECK_LIB(Inventor, main, , inventor_dev=no, -limage -lMesaGLU -lMesaGL $X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS -lXext -ldl)
  if test "x$inventor_dev" = "xno"; then
    AC_MSG_ERROR(libInventor development system not found -- can't build on top of Open Inventor!)
  fi
  LIBS=$inventortest_save_LIBS

  dnl FIXME: "ugly hack"-alert! Should really clean this up. 19991107 mortene.
  LIBS="$LIBS -lInventor -limage -lMesaGLU -lMesaGL $X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS -lXmu -lXext -ldl"

else

  dnl *******************************************************************
  dnl * Check if libCoin is installed.
  dnl *******************************************************************
  
  AC_MSG_CHECKING(for Coin header files)

  dnl First try standard system locations.
  AC_TRY_CPP([#include <Inventor/SbBasic.h>], coin_dev=yes, coin_dev=no)

  dnl Not found in any of the standard system locations, try
  dnl installation directory.
  if test "x$coin_dev" = "xno"; then
    _PREFIX=$prefix
    test "x$_PREFIX" = xNONE && _PREFIX=$ac_default_prefix
    _EPREFIX=$exec_prefix
    test "x$_EPREFIX" = xNONE && _EPREFIX=$_PREFIX
    _SAVECPPFLAGS=$CPPFLAGS
    CPPFLAGS="-I$_PREFIX/include $CPPFLAGS"
    AC_TRY_CPP([#include <Inventor/SbBasic.h>], coin_dev=yes, coin_dev=no)
    CPPFLAGS=$_SAVECPPFLAGS
    if test "x$coin_dev" = "xyes"; then
      CPPFLAGS="-I$_PREFIX/include $CPPFLAGS"
      LDFLAGS="-L$_EPREFIX/lib $LDFLAGS"
    fi
  fi

  AC_MSG_RESULT($coin_dev)

  if test "x$coin_dev" = "xyes"; then
    dnl FIXME: this doesn't work, as the AC_CHECK_LIB only can check against
    dnl functions in a C library. Add a new macro AC_CHECK_CXXLIB? Ask on the
    dnl autoconf list. 19990918 mortene.
    dnl AC_CHECK_LIB(Coin, SoDB::init, , coin_dev=no)
    AC_CHECK_LIB(Coin, main, , coin_dev=no)
  fi
  if test "x$coin_dev" = "xno"; then
    AC_MSG_ERROR(libCoin development system not found)
  fi

  dnl FIXME: "ugly hack"-alert! Should really clean this up. 19991107 mortene.
  LIBS="$LIBS $X_LIBS -lXmu"
fi


AC_LANG_RESTORE
])

dnl  Check that the Qt installation looks ok and include the
dnl  necessary paths and link libraries. Exit configure if Qt
dnl  can't be found or used. Ditto for the QGL detection macro.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl
dnl    * [mortene:19991114] these macros could be useful for others -- submit
dnl      to autoconf macro archive?
dnl
dnl    * [mortene:19991114] make macros work under MSWindows with Cygwin.
dnl
dnl    * [mortene:19991114] search for other Qt detection macros, in KDE
dnl      for instance, and see if our macros can be improved (or
dnl      substituted?).
dnl

AC_DEFUN(SIM_INCLUDE_QT_LIB,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])

dnl FIXME: this won't work under MSWindows. 19991114 mortene.
AC_REQUIRE([AC_PATH_XTRA])

dnl Qt is a C++ library.
AC_REQUIRE([AC_PROG_CXX])
AC_LANG_SAVE
AC_LANG_CPLUSPLUS

dnl *** warn if QTDIR has not been set ***

AC_MSG_CHECKING(value of the QTDIR environment variable)
if test "x$QTDIR" = "x"; then
  AC_MSG_RESULT(empty!)
  AC_MSG_WARN(QTDIR environment variable not set -- this might be an indication of a problem)
else
  AC_MSG_RESULT($QTDIR)
  CXXFLAGS="$CXXFLAGS -I$QTDIR/include"
  LDFLAGS="$LDFLAGS -L$QTDIR/lib"
fi

dnl *** moc ***

if test "x$QTDIR" != "x"; then
  AC_PATH_PROG(MOC, moc, , $QTDIR/bin:$PATH)
else
  AC_PATH_PROG(MOC, moc)
fi

if test "x$MOC" = "x"; then
  AC_MSG_ERROR(could not find the moc tool -- we need a complete Qt installation to build!)
fi

dnl *** find Qt header files ***

AC_MSG_CHECKING(for Qt header files)
AC_TRY_COMPILE([#include <qapplication.h>], [], qt_dev=yes, qt_dev=no)
AC_MSG_RESULT($qt_dev)
if test "x$qt_dev" = "xno"; then
  AC_MSG_ERROR(could not find the Qt include files -- we need a complete Qt installation to build!)
fi

dnl *** find Qt link library ***

dnl FIXME: this doesn't work, as the AC_CHECK_LIB only can check against
dnl functions in a C library. Add a new macro AC_CHECK_CXXLIB? Ask on the
dnl autoconf list. 19990918 mortene.
dnl AC_CHECK_LIB(qt, qVersion, , AC_MSG_ERROR(could not find the Qt library!), $X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS)
AC_CHECK_LIB(qt, main, , AC_MSG_ERROR(could not find the Qt library!), $X_LIBS $X_PRE_LIBS -lX11 $X_EXTRA_LIBS)

AC_LANG_RESTORE
])


dnl *************************************************************************


AC_DEFUN(SIM_INCLUDE_QGL_LIB,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])

AC_REQUIRE([SIM_INCLUDE_QT_LIB])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS

dnl *** find QGL extension, header file ***

AC_MSG_CHECKING(for QGL header files)
AC_TRY_COMPILE([#include <qgl.h>], [], qgl_dev=yes, qgl_dev=no)
AC_MSG_RESULT($qgl_dev)
if test "x$qgl_dev" = "xno"; then
  AC_MSG_ERROR(could not find the QGL include file -- you must compile and install the QGLWidget library found in \$QTDIR/extensions/opengl to build!)
fi

dnl *** find QGL extension, link library ***

dnl FIXME: this doesn't work, as the AC_CHECK_LIB only can check against
dnl functions in a C library. Add a new macro AC_CHECK_CXXLIB? Ask on the
dnl autoconf list. 19990918 mortene.
dnl AC_CHECK_LIB(qgl, qGLVersion, , AC_MSG_ERROR(could not find the QGL library!))
AC_CHECK_LIB(qgl, main, , AC_MSG_ERROR(could not find the QGL library!))

AC_LANG_RESTORE
])

dnl  Let the user decide if compilation should be done in "debug mode".
dnl  If compilation is not done in debug mode, all assert()'s in the code
dnl  will be disabled.
dnl
dnl  Also sets enable_debug variable to either "yes" or "no", so the
dnl  configure.in writer can add package-specific actions. Default is "yes".
dnl
dnl  Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
dnl  in the configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl

AC_DEFUN(SIM_COMPILE_DEBUG,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(debug,
  [  --enable-debug          compile in debug mode [default=yes]],
  [case "${enableval}" in
    yes) enable_debug=yes ;;
    no)  enable_debug=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-debug) ;;
  esac],
  enable_debug=yes)

if test "x$enable_debug" = "xno"; then
  CFLAGS="$CFLAGS -DNDEBUG"
  CXXFLAGS="$CXXFLAGS -DNDEBUG"
fi
])

dnl  Let the user decide if debug symbol information should be compiled
dnl  in. The compiled libraries/executables will use a lot less space
dnl  if stripped for their symbol information.
dnl
dnl  Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
dnl  in the configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991114] make this work with compilers other than gcc/g++
dnl

AC_DEFUN(SIM_DEBUGSYMBOLS,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(symbols,
  [  --enable-symbols        (GCC only) include symbol debug information
                          [default=yes]],
  [case "${enableval}" in
    yes) enable_symbols=yes ;;
    no)  enable_symbols=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-symbols) ;;
  esac],
  enable_symbols=yes)

if test "x$enable_symbols" = "xno"; then
  if test "x$GXX" = "xyes" || "x$GCC" = "xyes"; then
    CFLAGS="`echo $CFLAGS | sed 's/-g//'`"
    CXXFLAGS="`echo $CXXFLAGS | sed 's/-g//'`"
  else
    AC_MSG_WARN(--disable-symbols only has effect when using GNU gcc or g++)
  fi
fi
])

dnl  Let the user decide if RTTI should be compiled in. The compiled
dnl  libraries/executables will use a lot less space if they don't
dnl  contain RTTI.
dnl
dnl  Note: this macro must be placed after AC_PROG_CXX in the
dnl  configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991114] make this work with compilers other than gcc/g++
dnl

AC_DEFUN(SIM_RTTI_SUPPORT,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(rtti,
  [  --enable-rtti           (g++ only) compile with RTTI [default=no]],
  [case "${enableval}" in
    yes) enable_rtti=yes ;;
    no)  enable_rtti=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-rtti) ;;
  esac],
  enable_rtti=no)

if test "x$enable_rtti" = "xno"; then
  if test "x$GXX" = "xyes"; then
    CXXFLAGS="$CXXFLAGS -fno-rtti"
  fi
else
  if test "x$GXX" != "xyes"; then
    AC_MSG_WARN(--enable-rtti only has effect when using GNU g++)
  fi
fi
])

dnl  Let the user decide if C++ exception handling should be compiled
dnl  in. The compiled libraries/executables will use a lot less space
dnl  if they have exception handling support.
dnl
dnl  Note: this macro must be placed after AC_PROG_CXX in the
dnl  configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991114] make this work with compilers other than gcc/g++
dnl

AC_DEFUN(SIM_EXCEPTION_HANDLING,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(exceptions,
  [  --enable-exceptions     (g++ only) compile with exceptions [default=no]],
  [case "${enableval}" in
    yes) enable_exceptions=yes ;;
    no)  enable_exceptions=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-exceptions) ;;
  esac],
  enable_exceptions=no)

if test "x$enable_exceptions" = "xno"; then
  if test "x$GXX" = "xyes"; then
    unset _exception_flag
    dnl This is for GCC >= 2.8
    SIM_COMPILER_OPTION(-fno-exceptions, _exception_flag=-fno-exceptions)
    if test "x$_exception_flag" = "x"; then
      dnl For GCC versions < 2.8
      SIM_COMPILER_OPTION(-fno-handle-exceptions, _exception_flag=-fno-handle-exceptions)
    fi
    if test "x$_exception_flag" = "x"; then
      AC_MSG_WARN(couldn't find a valid option for avoiding exception handling)
    else
      CXXFLAGS="$CXXFLAGS $_exception_flag"
    fi
  fi
else
  if test "x$GXX" != "xyes"; then
    AC_MSG_WARN(--enable-exceptions only has effect when using GNU g++)
  fi
fi
])

dnl  Use this file to store miscellaneous macros related to compiler
dnl  queries.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991125] make SIM_COMPILER_OPTION work with C compilers.
dnl


dnl SIM_COMPILER_OPTION(OPTION-TO-TEST, ACTION-IF-TRUE [, ACTION-IF-FALSE])
AC_DEFUN(SIM_COMPILER_OPTION,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_MSG_CHECKING(whether $CXX accepts [$1])
_save_cxxflags=$CXXFLAGS
CXXFLAGS="$CXXFLAGS [$1]"
AC_TRY_COMPILE( , , _accept_result=yes [$2], _accept_result=no [$3])
AC_MSG_RESULT($_accept_result)
CXXFLAGS=$_save_cxxflags
unset _accept_result _save_cxxflags
])

dnl  Let the user decide if profiling code should be compiled
dnl  in. The compiled libraries/executables will use a lot less space
dnl  if they don't contain profiling code information, and they will also
dnl  execute faster.
dnl
dnl  Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
dnl  in the configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991114] make this work with compilers other than gcc/g++
dnl

AC_DEFUN(SIM_PROFILING_SUPPORT,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(profile,
  [  --enable-profile        (GCC only) turn on inclusion of profiling code
                          [default=no]],
  [case "${enableval}" in
    yes) enable_profile=yes ;;
    no)  enable_profile=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-profile) ;;
  esac],
  enable_profile=no)

if test "x$enable_profile" = "xyes"; then
  if test "x$GXX" = "xyes" || test "x$GCC" = "xyes"; then
    CFLAGS="$CFLAGS -pg"
    CXXFLAGS="$CXXFLAGS -pg"
    LDFLAGS="$LDFLAGS -pg"
  else
    AC_MSG_WARN(--enable-profile only has effect when using GNU gcc or g++)
  fi
fi
])

dnl  Let the user decide if compilation should be done with all compiler
dnl  warnings turned on.
dnl
dnl  Note: this macro must be placed after either AC_PROG_CC or AC_PROG_CXX
dnl  in the configure.in script.
dnl
dnl  Author: Morten Eriksen, <mortene@sim.no>.
dnl
dnl  TODO:
dnl    * [mortene:19991114] make this work with compilers other than gcc/g++
dnl    * [mortene:19991114] find out how to get GCC's
dnl      -Werror-implicit-function-declaration option to work as expected
dnl    * [larsa:19991126] use -Wno-multichar under BeOS only (BeOS system
dnl      header files emit lots of warnings due to multichar definitions)
dnl


dnl SIM_COMPILER_WARNINGS( )
AC_DEFUN(SIM_COMPILER_WARNINGS,
[
dnl Autoconf is a developer tool, so don't bother to support older versions.
AC_PREREQ([2.13])
AC_ARG_ENABLE(warnings,
  [  --enable-warnings       (GCC only) turn on warnings when compiling
                          [default=yes]],
  [case "${enableval}" in
    yes) enable_warnings=yes ;;
    no)  enable_warnings=no ;;
    *) AC_MSG_ERROR(bad value \"${enableval}\" for --enable-warnings) ;;
  esac],
  enable_warnings=yes)

if test "x$enable_warnings" = "xyes"; then
  if test "x$GXX" = "xyes" || test "x$GCC" = "xyes"; then
    SIM_COMPILER_OPTION(-Wno-multichar, _warn_flags=-Wno-multichar)
    _warn_flags="-W -Wall -Wno-unused $_warn_flags"

    CFLAGS="$CFLAGS $_warn_flags"
    CXXFLAGS="$CXXFLAGS $_warn_flags"

    unset _warn_flags
  fi
else
  if test "x$GXX" != "xyes" && test "x$GCC" != "xyes"; then
    AC_MSG_WARN(--enable-warnings only has effect when using GNU gcc or g++)
  fi
fi
])

