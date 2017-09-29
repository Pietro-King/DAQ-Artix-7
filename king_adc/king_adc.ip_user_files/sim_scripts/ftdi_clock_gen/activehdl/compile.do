vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../test_Ax3.srcs/sources_1/ip/ftdi_clock_gen" "+incdir+../../../../test_Ax3.srcs/sources_1/ip/ftdi_clock_gen" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../test_Ax3.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_sim_netlist.vhdl" \

vlog -work xil_defaultlib "glbl.v"

