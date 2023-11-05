#!/bin/tcsh

##### File and Directory Settings #####
source directory_setup.sh



##### load configs
source syn_tool.sh
source target.sh



###### Synthesis Target Selection
if ( $# =~ 0 ) then
	set TOP_MODULE = $DEFAULT_DESIGN
else
	set TOP_MODULE = $1
endif


##### Simulation Tool Setup
switch( $SYN_TOOL )
	#case "yosys" :
	#	set SYN_OPT = ( \
	#	)

	#	set SRC_EXT = ( \
	#	)

	#	foreach def ( $DEFINE_LIST )
	#		set DEFINES = ( \
	#			+define+$def \
	#			$DEFINES \
	#		) 
	#	end
	#	foreach dir ( $INCDIR )
	#		set INCLUDE = ( \
	#			+incdir+$dir \
	#			$INCLUDE \
	#		)
	#	end
	#breaksw

	case "vivado" :
		set SRC_EXT = ( \
		)

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				--define $def \
				$DEFINES \
			)
		end

		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				--include $dir \
				$INCLUDE \
			)
		end
	breaksw

	default :
		echo "Simulation Tool is not selected"
		exit 1
	breaksw
endsw



##### Load module list
source module.sh



##### run simulation
if ( ${SYN_TOOL} =~ "vivado" ) then
  mkdir -p ./report
	mkdir -p xilinx/${TOP_MODULE}
	set FILE_TCL = "./xilinx/${TOP_MODULE}/files.tcl"
	set DEFINE_TCL = "./xilinx/${TOP_MODULE}/defines.tcl"
  set DPI_TCL = "./xilinx/${TOP_MODULE}/dpi.tcl"
  set IP_TCL  = "./xilinx/${TOP_MODULE}/ip.tcl"
  set IP_YAML = "${TOPDIR}/${TOP_MODULE}_ip.yaml"

	### set design target
	echo "set TOP ${TOP_MODULE}" >! "./xilinx/top.tcl"

	# Add Design RTL Files
	echo "set DESIGN_FILES [list \\" >> ${FILE_TCL}
	foreach files ( $RTL_FILE )
		echo "$files \\" >> ${FILE_TCL}
	end
	echo "]" >> ${FILE_TCL}

	# Add include directories
	echo "set INCLUDE_DIRS [list \\" >> ${FILE_TCL}
	foreach dirs ( $INCDIR )
		echo "$dirs \\" >> ${FILE_TCL}
	end
	echo "]" >> ${FILE_TCL}

	# Add define lists
	echo "set DEFINE_LISTS [list \\" >! ${DEFINE_TCL}
	foreach dirs ( $DEFINE_LIST )
		echo "$dirs \\" >> ${DEFINE_TCL}
	end
	echo "]" >> ${DEFINE_TCL}

  # DPI file lists
  echo "set DPI_LISTS [list \\" >! ${DPI_TCL}
  foreach dpilibs ( $DPI_LIB )
    echo "$dpilibs \\" >> ${DPI_TCL}
  end
  echo "]" >> ${DPI_TCL}

  # Xilinx IP setup
  python ${TOPDIR}/util/yaml2tcl.py ${IP_YAML} ${IP_TCL}

	# create vivado projects for debug
	vivado -mode batch -source ./xilinx/prj.tcl -nojournal -log ${TOP_MODULE}.log
else if ( ${SYN_TOOL} =~ "yosys" ) then
  echo "yosys is not supported yet!"
endif
