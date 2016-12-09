#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2016 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=numpy
VER=1.11.2
SUMMARY="numpy - package for scientific computing with Python"
DESC="$SUMMARY"


# This builds leaves uncleanable crud behind.  See pre_python_64() below for
# more details.
REMOVE_PREVIOUS=1

pre_python_64() {
	logmsg "prepping 64bit python build"
	# "./setup.py clean" was removed from numpy.  Use a more
	# brute-force approach.
	logcmd /bin/rm -rf build
}

save_function clean_up clean_up_orig

# Pardon the copy/paste, but we have to do this twice (2.6 & 2.7) for now.
# And the only way buildctl detects packages is by grepping for PKG assignment.

OLDPV=$PYTHONVER

set_python_version 2.6
XFORM_ARGS="-D PYTHONVER=$PYTHONVER"
PKG=library/python-2/numpy-26
RUN_DEPENDS_IPS="runtime/python-26"
init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
strip_install -x
make_package
clean_up

set_python_version 2.7
XFORM_ARGS="-D PYTHONVER=$PYTHONVER"
PKG=library/python-2/numpy-27
RUN_DEPENDS_IPS="runtime/python-27"
init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
strip_install -x
make_package
clean_up

set_python_version $OLDPV
