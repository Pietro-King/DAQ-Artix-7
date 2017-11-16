// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Mon May 22 16:09:23 2017
// Host        : DESKTOP-H3JQ5EJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_stub.v
// Design      : ftdi_clock_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module ftdi_clock_gen(CLK_OUT1, CLK_OUT2, RESET, LOCKED, CLK_IN1)
/* synthesis syn_black_box black_box_pad_pin="CLK_OUT1,CLK_OUT2,RESET,LOCKED,CLK_IN1" */;
  output CLK_OUT1;
  output CLK_OUT2;
  input RESET;
  output LOCKED;
  input CLK_IN1;
endmodule
