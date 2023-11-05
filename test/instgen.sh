#!/bin/tcsh

source directory_setup.sh

if ( $? =~ 1 ) then
  source target.sh
else
  set DEFAULT_DESIGN = $1
endif

foreach dir ( $INCDIR )
  set INCLUDE = ( \
    -incdir=$dir \
    $INCLUDE \
  )
end

# Simulation Target Selection
if ( $# =~ 0 ) then
	set TOP_MODULE = $DEFAULT_DESIGN
else
	set TOP_MODULE = $1
endif


# Test bench generation
./gen/makeinst.pl \
  #-i ${CPUDIR}/${TOP_MODULE}.sv \
  -i ${CACHEDIR}/${TOP_MODULE}.sv \
  -t ${TOP_MODULE} \
  ${INCLUDE}
