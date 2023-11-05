set prj       project_1
set ip        axi_uartlite
set ipname    axi_uartlite0
set uart_baud 115200
set uart_freq 125
set topdir    [pwd]
set vendor    xilinx.com
set version   2.0
set conf      [list CONFIG.C_BAUDRATE ${uart_baud} CONFIG.C_S_AXI_ACLK_FREQ_HZ_d ${uart_freq}]

set ipsrcdir  ${topdir}/${prj}/${prj}.srcs/sources_1/ip

if {[file exists ${ipsrcdir}/${ipname}/${ipname}.xci]} {
  read_ip ${ipsrcdir}/${ipname}/${ipname}.xci
} else {
  create_ip -name ${ip} -vendor ${vendor} -library ip -version ${version} -module_name ${ipname}
  set_property -dict $conf [get_ips ${ipname}]
  #set_property -dict [list \
  #  CONFIG.C_BAUDRATE ${uart_baud} \
  #  CONFIG.C_S_AXI_ACLK_FREQ_HZ_d ${uart_freq} \
  #] [get_ips ${ipname}]
  generate_target all [get_files ${ipsrcdir}/${ipname}/${ipname}.xci]
}
