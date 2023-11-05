#!/bin/tcsh

##### File and Directory Settings #####
source directory_setup.sh



##### load configs
source sim_tool.sh
source target.sh



##### Output Wave
set Waves = 1
set WaveOpt = ""



##### Simulation after Systemverilog to verilog (SV2V) Conversion
set SV2V = 0
if ( $SIM_TOOL =~ "iverilog" ) then
	# iverilog only supports verilog formats
	set SV2V = 1
endif



##### Defines
if ( $Waves =~ 1 ) then
	set DEFINE_LIST = ( $DEFINE_LIST WAVE_DUMP )
endif



##### Gate Level Simulation
set GATE = 0
#set GATE = 1
if ( $GATE =~ 1 ) then
	set DEFINE_LIST = ($DEFINE_LIST NETLIST)
endif



##### Process Setting
#set Process = "ASAP7"
set Process = "None"

switch ($Process)
	case "ASAP7" :
		set CELL_LIB = "./ASAP7_PDKandLIB_v1p6/lib_release_191006"
		set CELL_RTL_DIR = "${CELL_LIB}/asap7_7p5t_library/rev25/Verilog"
		set DEFINE_LIST = (${DEFINE_LIST} ASAP7)

		set CORNERS = ( \
			TT_08302018 \
		)
		#	FF_08302018 \
		#	SS_08302018 \

		set CELL_NAME = ( \
			${CELL_RTL_DIR}/asap7sc7p5t_SIMPLE_RVT \
			${CELL_RTL_DIR}/asap7sc7p5t_SEQ_RVT \
			${CELL_RTL_DIR}/asap7sc7p5t_OA_RVT \
			${CELL_RTL_DIR}/asap7sc7p5t_INVBUF_RVT \
			${CELL_RTL_DIR}/asap7sc7p5t_AO_RVT \
		)

		set LIB_FILE = ( \
    )
		foreach cell ( $CELL_NAME )
			foreach corner ( $CORNERS )
				set LIB_FILE = ( \
					${LIB_FILE} \
					${cell}_${corner}.v \
				)
			end
		end
	breaksw

	default :
		# Simulation with simple gate model (Process = "None")
		# Nothing to set
		set LIB_FILE = ( \
    )
	breaksw
endsw

###### Simulation Target Selection
if ( $# =~ 0 ) then
	set TOP_MODULE = $DEFAULT_DESIGN
else
	set TOP_MODULE = $1
endif


##### Simulation Tool Setup
switch( $SIM_TOOL )
	case "ncverilog" :
		if ( $Waves =~ 1 ) then
			set WaveOpt = +define+CADENCE
		endif

		set SIM_OPT = ( \
			+nc64bit \
			$WaveOpt \
			+access+r \
			+notimingchecks \
			-ALLOWREDEFINITION \
		)

		set SRC_EXT = ( \
			+xmc_ext+.c \
			+libext+.v.sv \
			+systemverilog_ext+.sv \
			+vlog_ext+.v \
		)

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				+define+$def \
				$DEFINES \
			) 
		end
		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				+incdir+$dir \
				$INCLUDE \
			)
		end
	breaksw

	case "xmverilog" :
		if ( $Waves =~ 1 ) then
			set WaveOpt = +define+CADENCE
		endif

		set SIM_OPT = ( \
			+64bit \
			$WaveOpt \
			+access+r \
			+notimingchecks \
			-ALLOWREDEFINITION \
		)

		set SRC_EXT = ( \
			+xmc_ext+.c \
			+libext+.v.sv \
			+systemverilog_ext+.sv \
			+vlog_ext+.v \
		)

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				+define+$def \
				$DEFINES \
			) 
		end
		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				+incdir+$dir \
				$INCLUDE \
			)
		end
	breaksw

	case "vcs" :
		if ( $Waves =~ 1 ) then
			set WaveOpt = +define+SYNOPSYS
		endif

		set SIM_OPT = ( \
			-o ${TOP_MODULE}.sim \
			-full64 \
			$WaveOpt \
			+incdir+.include \
			-debug_access+r \
			+notimingchecks \
			-ALLOWREDEFINITION \
		)
		set SRC_EXT = ( \
			+xmc_ext+.c \
			+libext+.v.sv \
			+systemverilogext+.sv \
			+verilog2001ext+.v \
		)

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				+define+$def \
				$DEFINES \
			) 
		end
		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				+incdir+$dir \
				$INCLUDE \
			)
		end
	breaksw

	case "verilator" :
		if ( $Waves =~ 1 ) then
			set WaveOpt = +define+VCD
		endif

		set SIM_OPT = ( \
			$WaveOpt \
			+notimingchecks \
		)

		set SRC_EXT = ( \
			+libext+.v.sv \
			+systemverilogext+.sv \
		)

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				+define+$def \
				$DEFINES \
			) 
		end

		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				+incdir+$dir \
				$INCLUDE \
			)
		end
	breaksw

	case "iverilog" :
		if ( $Waves =~ 1 ) then
			set WaveOpt = (-D VCD)
		endif

		set SIM_OPT = ( \
			$WaveOpt \
			-o ${TOP_MODULE}.sim \
		)

		set SRC_EXT = ()

		foreach def ( $DEFINE_LIST )
			set DEFINES = ( \
				-D $def \
				$DEFINES \
			)
		end

		foreach dir ( $INCDIR )
			set INCLUDE = ( \
				-I $dir \
				$INCLUDE \
			)
		end
	breaksw

	case "xilinx_sim" :
		set SIM_OPT = ( \
			$WaveOpt \
		)

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

    foreach lib ( $LIB_FILE )
      set LIB = ( \
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
if ( ${SIM_TOOL} =~ "xilinx_sim" ) then
	mkdir -p xilinx/${TOP_MODULE}
	set FILE_TCL = "./xilinx/${TOP_MODULE}/files.tcl"
	set DEFINE_TCL = "./xilinx/${TOP_MODULE}/defines.tcl"
  set DPI_TCL = "./xilinx/${TOP_MODULE}/dpi.tcl"
  set IP_TCL  = "./xilinx/${TOP_MODULE}/ip.tcl"
  set IP_YAML = "${TOPDIR}/${TOP_MODULE}_ip.yaml"

	### set design target
	echo "set TOP ${TOP_MODULE}" >! "./xilinx/top.tcl"

	### generate tcl file to designate source flies
	# Waveform configuration
	echo "set WAVEFORM $Waves" >! ${FILE_TCL}

	# Add Design RTL Files
	echo "set DESIGN_FILES [list \\" >> ${FILE_TCL}
	foreach files ( $RTL_FILE )
		echo "$files \\" >> ${FILE_TCL}
	end
	echo "]" >> ${FILE_TCL}

	# Add Test Files
	echo "set TEST_FILES [list \\" >> ${FILE_TCL}
	foreach files ( $TEST_FILE )
		echo "$files \\" >> ${FILE_TCL}
	end
	echo "]" >> ${FILE_TCL}

	# Add include directories
	echo "set INCLUDE_DIRS [list \\" >> ${FILE_TCL}
	foreach dirs ( $INCDIR )
		echo "$dirs \\" >> ${FILE_TCL}
	end
	echo "]" >> ${FILE_TCL}

  # Add library lists
  echo "set LIB_FILES [list \\" >> ${FILE_TCL}
  foreach libs ( $LIB_FILE )
    echo "$libs \\" >> ${FILE_TCL}
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
else if ( ${SIM_TOOL} =~ "verilator" ) then
  foreach lib ( $LIB_FILE )
    set LIB = ( \
      -v $lib \
    )
  end

  foreach dpilibs ( $DPI_LIB )
    set DPI = ( \
      --exe $dpilibs \
    )
  end

  verilator \
    ${SIM_OPT} \
    ${SRC_EXT} \
    ${TEST_FILE} \
    ${INCLUDE} \
    ${DEFINES} \
    -cc \
    --exe ./verilator/${TOP_MODULE}_test.cpp \
    $DPI \
    -Wno-WIDTH \
    ${LIB} \
    ${RTL_FILE}

  make -C obj_dir -f V${TOP_MODULE}_test.mk
  ./obj_dir/V${TOP_MODULE}_test 0 0

else
	${SIM_TOOL} \
		${SIM_OPT} \
		${SRC_EXT} \
		${INCLUDE} \
		${DEFINES} \
		${TEST_FILE} \
		${LIB_FILE} \
		${RTL_FILE}
endif
