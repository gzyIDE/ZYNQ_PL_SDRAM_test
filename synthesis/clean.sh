#!/bin/tcsh

source syn_tool.sh

rm -rf log
rm -rf obj_dir

if ( $SYN_TOOL =~ "vivado" ) then
	echo "Removing simulation logs and results"
	rm -f webtalk*.jou >& /dev/null
	rm -f webtalk*.log >& /dev/null
	rm -f xsim*.jou >& /dev/null
	rm -f xsim*.log >& /dev/null
	rm -f xelab.log
	rm -f xelab.pb
	rm -f xvlog.log
	rm -f xvlog.pb
	rm -f waves.vcd
	rm -rf .Xil
	rm -rf xsim.dir
	rm -f waves.vcd
	rm -f waves.wdb

  rm -rf report

	echo "Removing Vivado-related log files"
	rm -f *.jou >& /dev/null
	rm -f *.log >& /dev/null
	#rm -f *.wdb

	pushd xilinx > /dev/null
	foreach file ( `/bin/ls` )
		if ( -d $file ) then
			rm -rf $file
		endif
	end
	popd > /dev/null
else if ( $SYN_TOOL =~ "yosys" ) then
endif
