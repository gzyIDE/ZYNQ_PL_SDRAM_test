# System clock
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];#set

# False path
set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks clk_out1_clk_wiz0]
set_false_path -from [get_clocks sys_clk_pin] -to [get_clocks clk_out2_clk_wiz0]
