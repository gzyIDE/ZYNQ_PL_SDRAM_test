# Initialize design configuration
set testdir [exec pwd]
set tcldir  ${testdir}/xilinx
source ${tcldir}/top.tcl
source ${tcldir}/config.tcl
source ${tcldir}/${TOP}/files.tcl
source ${tcldir}/${TOP}/defines.tcl
source ${tcldir}/${TOP}/dpi.tcl
set TEST_MODULE ${TOP}_test
set prjdir  ${testdir}/xilinx/${TOP}

# Configure project for simulations
if {[open_project -quiet ./xilinx/${TOP}/${TOP}.xpr] == {}} {
	create_project -force ${TOP} ./xilinx/${TOP}
}
set_property "board_part" $board_name   [current_project]
set_property "part"       $device_name  [current_project]
set_property "corecontainer.enable" "0" [current_project]
set_property "ip_cache_permissions" "read write" [current_project]
set_property "ip_output_repo" "[file normalize "${prjdir}/repo/cache"]" [current_project]

if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
add_files -fileset sources_1 -scan_for_includes ${INCLUDE_DIRS} ${DESIGN_FILES}

if {[string equal [get_filesets -quiet sim_1] ""]} {
    create_fileset -simset sim_1
}
add_files -fileset sim_1 -scan_for_includes ${INCLUDE_DIRS} ${TEST_FILES}
if {[llength ${LIB_FILES}] != 0} {
  add_files -fileset sim_1 -scan_for_includes ${INCLUDE_DIRS} ${LIB_FILES}
}

# set top module
set_property top ${TEST_MODULE} [get_filesets -quiet sim_1]

# set verilog defines
set_property verilog_define ${DEFINE_LISTS} [get_filesets sim_1]

# set simulation configuration
set_property -name {xsim.simulate.runtime} -value ${runtime} -objects [get_filesets sim_1]
#set_property -name {xsim.elaborate.mt_level} -value {8} -objects [get_filesets sim_1]
if { $WAVEFORM == 1 } {
	set_property -name {xsim.elaborate.debug_level} -value {all} -objects [get_filesets sim_1]
	set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]

  set elabopt {--debug all}
} else {
  set elabopt {}
	set_property -name {xsim.elaborate.debug_level} -value {none} -objects [get_filesets sim_1]
}

# IP Setup
if {[file exists ${tcldir}/${TOP}/ip.tcl]} {
  source ${tcldir}/${TOP}/ip.tcl
}

lappend elabopt {--sv_root "/"}
foreach lib ${DPI_LISTS} {
  lappend elabopt "--sv_lib ${lib}"
}
set_property -name xelab.more_options -value [concat {*}${elabopt}] -objects [get_filesets sim_1]

# simulation
launch_simulation

close_project
