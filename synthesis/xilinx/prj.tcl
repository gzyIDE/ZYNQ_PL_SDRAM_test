# Initialize design configuration
set syndir  [exec pwd]
set repdir  ${syndir}/report
set tcldir  ${syndir}/xilinx
source ${tcldir}/config.tcl
source ${tcldir}/top.tcl
set prjdir      ${syndir}/xilinx/${TOP}
set xdcdir      ${syndir}/xdc
set xpr         ${TOP}.xpr
set pin_xdc     ${TOP}_pin.xdc
set timing_xdc  ${TOP}_timing.xdc
source ${prjdir}/files.tcl
source ${prjdir}/defines.tcl
source ${prjdir}/dpi.tcl

# Configure project for synthesis
if {[open_project -quiet ${prjdir}/${xpr}] == {}} {
	create_project -force ${TOP} ${prjdir}
}
set_property "board_part" $board_name   [current_project]
set_property "part"       $device_name  [current_project]
set_property "corecontainer.enable" "0" [current_project]
set_property "ip_cache_permissions" "read write" [current_project]
set_property "ip_output_repo" "[file normalize "${prjdir}/repo/cache"]" [current_project]

# load design files
if {[string equal [get_filesets -quiet sources_1] ""]} {
    create_fileset -srcset sources_1
}
add_files -fileset sources_1 -scan_for_includes ${INCLUDE_DIRS} ${DESIGN_FILES}

# set Constraints
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
if {[file exists ${xdcdir}/${pin_xdc}]} {
  add_files -fileset constrs_1 -norecurse ${xdcdir}/${pin_xdc}
}
if {[file exists ${xdcdir}/${timing_xdc}]} {
  add_files -fileset constrs_1 -norecurse ${xdcdir}/${timing_xdc}
}

# set verilog defines
set_property verilog_define ${DEFINE_LISTS} [get_filesets sim_1]

# IP Setup
if {[file exists ${prjdir}/ip.tcl]} {
  source ${prjdir}/ip.tcl
}

# synthesis
reset_runs [get_runs synth_1]
launch_runs synth_1 -jobs ${maxcore}
wait_on_run synth_1

# implementation
reset_runs [get_runs impl_1]
launch_runs impl_1 -jobs ${maxcore}
wait_on_run impl_1
open_run impl_1
report_utilization -file ${repdir}/${TOP}_utilization.rpt
report_timing -file ${repdir}/${TOP}_timing.rpt

# generate bitstream
launch_runs impl_1 -to_step write_bitstream -jobs ${maxcore}
wait_on_run impl_1

close_project
