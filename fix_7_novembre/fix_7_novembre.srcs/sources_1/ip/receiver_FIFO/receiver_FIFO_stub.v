// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
// Date        : Thu Oct 05 15:34:40 2017
// Host        : DESKTOP-LG89K48 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {C:/Users/Tesista/Documents/Git Repository Tesi
//               Fiorini/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.v}
// Design      : receiver_FIFO
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_1_3,Vivado 2016.4" *)
module receiver_FIFO(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  almost_full, empty)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[7:0],wr_en,rd_en,dout[7:0],full,almost_full,empty" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [7:0]din;
  input wr_en;
  input rd_en;
  output [7:0]dout;
  output full;
  output almost_full;
  output empty;
endmodule
