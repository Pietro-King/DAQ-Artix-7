# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.xpr} [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo {c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/clock_generator/clock_generator.dcp}}
set_property used_in_implementation false [get_files {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/clock_generator/clock_generator.dcp}}]
add_files -quiet {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.dcp}}
set_property used_in_implementation false [get_files {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.dcp}}]
add_files -quiet {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp}}
set_property used_in_implementation false [get_files {{c:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp}}]
add_files -quiet {{C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo.dcp}}
set_property used_in_implementation false [get_files {{C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo.dcp}}]
read_vhdl -library xil_defaultlib {
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/utility.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/transmitter_fsm.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/receiver_fsm.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/arbiter.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/usb_fpga_bridge.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/command_block.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/PIPO_SHIFT.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/SINGLE_SHOT_ADC.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/FUNNEL.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/FUNNEL_FIFO.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/circular_buffer.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/imports/Desktop/Michele Ricci materiale/fpga/test_comunicazione/transmit_from_fpga_test/main.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/ADC_ARRAY.vhd}
  {C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/sources_1/new/program_spi.vhd}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/constrs_1/new/CONSTRAINTS_PROVA.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Tesista/Desktop/vivado projects/fix_7_novembre/fix_7_novembre.srcs/constrs_1/new/CONSTRAINTS_PROVA.xdc}}]


synth_design -top ADC_BRIDGE -part xc7a100tcsg324-1


write_checkpoint -force -noxdef ADC_BRIDGE.dcp

catch { report_utilization -file ADC_BRIDGE_utilization_synth.rpt -pb ADC_BRIDGE_utilization_synth.pb }