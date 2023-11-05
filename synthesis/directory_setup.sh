#!/bin/tcsh

# Files and Directories Settings
set TOPDIR      = `pwd`"/.."
set RTLDIR      = "${TOPDIR}/rtl"
set SYNDIR      = "${TOPDIR}/synthesis"
set INCDIR = ( \
	${TOPDIR}/include \
)

set DEFINE_LIST = ( \
	SYNTHESIS \
)
set INCLUDE = ()
set DEFINES = ()
set RTL_FILE = ()
set DPI_LIB = ()

# (Not used)
set TBDIR       = ${TOPDIR}
