// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Thu Nov 02 17:18:06 2017
// Host        : DESKTOP-LG89K48 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/Tesista/Desktop/vivado
//               projects/program_asic_2/program_asic_2.srcs/sources_1/ip/clock_generator/clock_generator_stub.v}
// Design      : clock_generator
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_generator(CLK_OUT1, CLK_OUT2, CLK_OUT3, CLK_OUT4, CLK_OUT5, 
  RESET, LOCKED, CLK_IN1)
/* synthesis syn_black_box black_box_pad_pin="CLK_OUT1,CLK_OUT2,CLK_OUT3,CLK_OUT4,CLK_OUT5,RESET,LOCKED,CLK_IN1" */;
  output CLK_OUT1;
  output CLK_OUT2;
  output CLK_OUT3;
  output CLK_OUT4;
  output CLK_OUT5;
  input RESET;
  output LOCKED;
  input CLK_IN1;
endmodule
