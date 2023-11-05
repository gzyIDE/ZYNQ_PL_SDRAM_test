#!/bin/tcsh

switch ( $TOP_MODULE )
	case "top" : 
		set TEST_FILE = ${TBDIR}/${TOP_MODULE}_test.sv
		set RTL_FILE = ( \
			${RTLDIR}/${TOP_MODULE}.sv \
      ${RTLDIR}/cdc_sync.sv \
      ${RTLDIR}/led_blink.sv \
      ${RTLDIR}/reset_sync.sv \
      ${RTLDIR}/uart_buffering.sv \
      ${RTLDIR}/axi2lbus_bridge.sv \
		)
	breaksw


	default : 
		set TEST_FILE = ${TBDIR}/${TOP_MODULE}_test.sv
		set RTL_FILE = ( \
			${RTLDIR}/${TOP_MODULE}.sv \
		)
	breaksw
endsw
