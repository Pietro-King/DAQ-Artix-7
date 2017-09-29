-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Mon May 22 16:09:23 2017
-- Host        : DESKTOP-H3JQ5EJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_stub.vhdl
-- Design      : ftdi_clock_gen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ftdi_clock_gen is
  Port ( 
    CLK_OUT1 : out STD_LOGIC;
    CLK_OUT2 : out STD_LOGIC;
    RESET : in STD_LOGIC;
    LOCKED : out STD_LOGIC;
    CLK_IN1 : in STD_LOGIC
  );

end ftdi_clock_gen;

architecture stub of ftdi_clock_gen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK_OUT1,CLK_OUT2,RESET,LOCKED,CLK_IN1";
begin
end;
