#!/bin/tcsh

# Files and Directories Settings
set TOPDIR      = `pwd`"/.."
set RTLDIR      = "${TOPDIR}/rtl"
set TESTDIR     = "${TOPDIR}/test"
set TBDIR       = "${TESTDIR}/tb"
set TESTINCDIR  = "${TESTDIR}/include"
set INCDIR = ( \
	${TOPDIR}/include \
	${TESTINCDIR} \
)

set DEFINE_LIST = ( \
	SIMULATION \
)
set INCLUDE = ()
set DEFINES = ()
set RTL_FILE = ()
set DPI_LIB = ()
