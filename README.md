# xilinx_fpga_template
Xilinx fpga development environment template for my own projects

# Directory Structure
- rtl: Synthesizable Verilog (SystemVerilog) Modules
- include: Verilog (SystemVerilog) Include Files
- test: Test Vectors
- synthesis: Synthesis Scripts
- util: Some scripts

# Sample project
Sample projects targets the Arty Z7 board which uses Zynq-7000 series FPGA.
The sample design in ./rtl directory receives characters from UART RX and 
buffers 16 characters (can be adjusted in parameter: uart_buffering.BufSize) in SDRAM. 
After buffering 16 characters, these characters are echobacked through UART TX.
UART is operating at baud rate of 115200bps, with no parity and 1-bit stop bit.
