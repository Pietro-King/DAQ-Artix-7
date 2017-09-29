



#create_clock -period 16.666 -name ftdi_clk -waveform {0.000 8.333} [get_ports ftdi_clk]

#create_clock -period 5.000 -name CLK_IN1_P -waveform {0.000 2.500} [get_ports CLK_IN1_P]

#create_clock -name CLK_IN1_P -period 5 -waveform {0
#2.5} [get_ports  CLK_IN1_P]------------------------------------------------come si crea il negato????      ************




create_clock -period 16.667 -name ftdi_clk -waveform {0.000 8.334} -add [get_ports ftdi_clk]
create_clock -period 20.000 -name CLK_IN1_P -waveform {0.000 10.000} -add [get_ports CLK_IN1_P]



set_property PACKAGE_PIN G6 [get_ports {ftdi_dq[7]}]
set_property PACKAGE_PIN F6 [get_ports {ftdi_dq[6]}]
set_property PACKAGE_PIN H2 [get_ports {ftdi_dq[5]}]
set_property PACKAGE_PIN G2 [get_ports {ftdi_dq[4]}]
set_property PACKAGE_PIN J4 [get_ports {ftdi_dq[3]}]
set_property PACKAGE_PIN H4 [get_ports {ftdi_dq[2]}]
set_property PACKAGE_PIN H1 [get_ports {ftdi_dq[1]}]
set_property PACKAGE_PIN G1 [get_ports {ftdi_dq[0]}]
 

set_property PACKAGE_PIN G3 [get_ports ftdi_SIWU]
set_property PACKAGE_PIN C7 [get_ports ftdi_rdN]
set_property PACKAGE_PIN E7 [get_ports ftdi_txeN]
set_property PACKAGE_PIN D7 [get_ports ftdi_rxfN]
set_property PACKAGE_PIN P17 [get_ports CLK_IN1_P]
set_property PACKAGE_PIN F4 [get_ports ftdi_clk]
set_property PACKAGE_PIN M17 [get_ports LED_1]
set_property PACKAGE_PIN M18 [get_ports LED_2]
set_property PACKAGE_PIN L18 [get_ports lock_clk_out]
set_property PACKAGE_PIN D8 [get_ports ftdi_wrN]
set_property PACKAGE_PIN G4 [get_ports ftdi_oeN]
set_property PACKAGE_PIN M16 [get_ports LOCKED_FTDI]
#-----------------------------------------------------

set_property PACKAGE_PIN V1  [ get_ports i_read_button]

#-------------questi sono quelli aggiunti per l adc

set_property PACKAGE_PIN B7 [get_ports cs ]
set_property PACKAGE_PIN B6 [get_ports serial_adc_output ]
set_property PACKAGE_PIN E6 [get_ports  sclk ]
set_property PACKAGE_PIN E5 [get_ports  i_read_pin ]
#---------------------------------------------------

set_property IOSTANDARD LVCMOS33 [get_ports lock_clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports LED_2]
set_property IOSTANDARD LVCMOS33 [get_ports LOCKED_FTDI]
set_property IOSTANDARD LVCMOS33 [get_ports LED_1]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_IN1_P]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_wrN]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_rdN]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_txeN]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_rxfN]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_oeN]
set_property IOSTANDARD LVCMOS33 [get_ports ftdi_SIWU]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ftdi_dq[0]}]

#------------------------------------------------------

set_property IOSTANDARD LVCMOS33 [get_ports  i_read_button]

#-------------questi sono quelli aggiunti per l adc

set_property IOSTANDARD LVCMOS33 [get_ports cs ]
set_property IOSTANDARD LVCMOS33 [get_ports serial_adc_output ]
set_property IOSTANDARD LVCMOS33 [get_ports  sclk ]
set_property IOSTANDARD LVCMOS33 [get_ports  i_read_pin]
#---------------------------------------------------




set_false_path -reset_path -from [get_clocks -of_objects [get_pins MAIN_CLOCK/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins BRIDGE/register_and_buffer/ftdi_clock_generator/inst/mmcm_adv_inst/CLKOUT0]]

set_false_path -reset_path -from [get_clocks -of_objects [get_pins BRIDGE/register_and_buffer/ftdi_clock_generator/inst/mmcm_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins MAIN_CLOCK/inst/mmcm_adv_inst/CLKOUT0]]



