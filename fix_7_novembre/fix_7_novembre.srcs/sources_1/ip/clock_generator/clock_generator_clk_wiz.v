
// file: clock_generator.v
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// CLK_OUT1___100.000______0.000______50.0______176.533____144.334
// CLK_OUT2____50.000______0.000______50.0______200.408____144.334
// CLK_OUT3____32.000______0.000______50.0______217.462____144.334
// CLK_OUT4___100.000______0.000______50.0______176.533____144.334
// CLK_OUT5_____6.250______0.000______50.0______293.211____144.334
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary______________50_____________0.00

`timescale 1ps/1ps

module clock_generator_clk_wiz 

 (// Clock in ports
  // Clock out ports
  output        CLK_OUT1,
  output        CLK_OUT2,
  output        CLK_OUT3,
  output        CLK_OUT4,
  output        CLK_OUT5,
  // Status and control signals
  input         RESET,
  output        LOCKED,
  input         CLK_IN1
 );
  // Input buffering
  //------------------------------------
wire CLK_IN1_clock_generator;
wire clk_in2_clock_generator;
  IBUF clkin1_ibufg
   (.O (CLK_IN1_clock_generator),
    .I (CLK_IN1));


  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        CLK_OUT1_clock_generator;
  wire        CLK_OUT2_clock_generator;
  wire        CLK_OUT3_clock_generator;
  wire        CLK_OUT4_clock_generator;
  wire        CLK_OUT5_clock_generator;
  wire        clk_out6_clock_generator;
  wire        clk_out7_clock_generator;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        LOCKED_int;
  wire        clkfbout_clock_generator;
  wire        clkfboutb_unused;
    wire clkout0b_unused;
   wire clkout1b_unused;
   wire clkout2b_unused;
   wire clkout3b_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;
  wire        reset_high;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (16.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (8.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKOUT1_DIVIDE       (16),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKOUT1_USE_FINE_PS  ("FALSE"),
    .CLKOUT2_DIVIDE       (25),
    .CLKOUT2_PHASE        (0.000),
    .CLKOUT2_DUTY_CYCLE   (0.500),
    .CLKOUT2_USE_FINE_PS  ("FALSE"),
    .CLKOUT3_DIVIDE       (8),
    .CLKOUT3_PHASE        (0.000),
    .CLKOUT3_DUTY_CYCLE   (0.500),
    .CLKOUT3_USE_FINE_PS  ("FALSE"),
    .CLKOUT4_DIVIDE       (128),
    .CLKOUT4_PHASE        (0.000),
    .CLKOUT4_DUTY_CYCLE   (0.500),
    .CLKOUT4_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.0))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_clock_generator),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (CLK_OUT1_clock_generator),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (CLK_OUT2_clock_generator),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (CLK_OUT3_clock_generator),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (CLK_OUT4_clock_generator),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (CLK_OUT5_clock_generator),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_clock_generator),
    .CLKIN1              (CLK_IN1_clock_generator),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (LOCKED_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (reset_high));
  assign reset_high = RESET; 

  assign LOCKED = LOCKED_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------



  BUFG clkout1_buf
   (.O   (CLK_OUT1),
    .I   (CLK_OUT1_clock_generator));


  BUFG clkout2_buf
   (.O   (CLK_OUT2),
    .I   (CLK_OUT2_clock_generator));

  BUFG clkout3_buf
   (.O   (CLK_OUT3),
    .I   (CLK_OUT3_clock_generator));

  BUFG clkout4_buf
   (.O   (CLK_OUT4),
    .I   (CLK_OUT4_clock_generator));

  BUFG clkout5_buf
   (.O   (CLK_OUT5),
    .I   (CLK_OUT5_clock_generator));



endmodule