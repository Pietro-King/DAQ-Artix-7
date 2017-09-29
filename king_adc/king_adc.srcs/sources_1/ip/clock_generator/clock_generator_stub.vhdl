-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (win64) Build 1756540 Mon Jan 23 19:11:23 MST 2017
-- Date        : Tue Sep 26 15:41:04 2017
-- Host        : DESKTOP-H3JQ5EJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/Valerio/Desktop/TESI_DIGITALE/axel_adc_bridge/axel_adc_bridge.srcs/sources_1/ip/clock_generator/clock_generator_stub.vhdl
-- Design      : clock_generator
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_generator is
  Port ( 
    CLK_OUT1 : out STD_LOGIC;
    CLK_OUT2 : out STD_LOGIC;
    CLK_OUT3 : out STD_LOGIC;
    CLK_OUT4 : out STD_LOGIC;
    CLK_OUT5 : out STD_LOGIC;
    RESET : in STD_LOGIC;
    LOCKED : out STD_LOGIC;
    CLK_IN1 : in STD_LOGIC
  );

end clock_generator;

architecture stub of clock_generator is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK_OUT1,CLK_OUT2,CLK_OUT3,CLK_OUT4,CLK_OUT5,RESET,LOCKED,CLK_IN1";
begin
end;
