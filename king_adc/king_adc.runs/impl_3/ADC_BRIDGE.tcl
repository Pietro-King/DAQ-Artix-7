proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.cache/wt [current_project]
  set_property parent.project_path C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.xpr [current_project]
  set_property ip_output_repo C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.runs/synth_3/ADC_BRIDGE.dcp
  add_files -quiet c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator.dcp
  set_property netlist_only true [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator.dcp]
  add_files -quiet c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.dcp
  set_property netlist_only true [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.dcp]
  add_files -quiet c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp
  set_property netlist_only true [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp]
  add_files -quiet c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo.dcp
  set_property netlist_only true [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo.dcp]
  read_xdc -mode out_of_context -ref clock_generator -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clock_generator -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator_board.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator_board.xdc]
  read_xdc -ref clock_generator -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/clock_generator/clock_generator.xdc]
  read_xdc -mode out_of_context -ref ftdi_clock_gen -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_ooc.xdc]
  read_xdc -prop_thru_buffers -ref ftdi_clock_gen -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_board.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen_board.xdc]
  read_xdc -ref ftdi_clock_gen -cells inst c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/ftdi_clock_gen/ftdi_clock_gen.xdc]
  read_xdc -mode out_of_context -ref receiver_FIFO -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_ooc.xdc]
  read_xdc -ref receiver_FIFO -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO/receiver_FIFO.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO/receiver_FIFO.xdc]
  read_xdc -mode out_of_context -ref transmitter_fifo -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo_ooc.xdc]
  read_xdc -ref transmitter_fifo -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo/transmitter_fifo.xdc
  set_property processing_order EARLY [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo/transmitter_fifo.xdc]
  read_xdc C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/constrs_1/new/CONSTRAINTS_PROVA.xdc
  read_xdc -ref receiver_FIFO -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO/receiver_FIFO_clocks.xdc
  set_property processing_order LATE [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO/receiver_FIFO_clocks.xdc]
  read_xdc -ref transmitter_fifo -cells U0 c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo/transmitter_fifo_clocks.xdc
  set_property processing_order LATE [get_files c:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sources_1/ip/transmitter_fifo/transmitter_fifo/transmitter_fifo_clocks.xdc]
  link_design -top ADC_BRIDGE -part xc7a100tcsg324-1
  write_hwdef -file ADC_BRIDGE.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force ADC_BRIDGE_opt.dcp
  catch { report_drc -file ADC_BRIDGE_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force ADC_BRIDGE_placed.dcp
  catch { report_io -file ADC_BRIDGE_io_placed.rpt }
  catch { report_utilization -file ADC_BRIDGE_utilization_placed.rpt -pb ADC_BRIDGE_utilization_placed.pb }
  catch { report_control_sets -verbose -file ADC_BRIDGE_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force ADC_BRIDGE_routed.dcp
  catch { report_drc -file ADC_BRIDGE_drc_routed.rpt -pb ADC_BRIDGE_drc_routed.pb -rpx ADC_BRIDGE_drc_routed.rpx }
  catch { report_methodology -file ADC_BRIDGE_methodology_drc_routed.rpt -rpx ADC_BRIDGE_methodology_drc_routed.rpx }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file ADC_BRIDGE_timing_summary_routed.rpt -rpx ADC_BRIDGE_timing_summary_routed.rpx }
  catch { report_power -file ADC_BRIDGE_power_routed.rpt -pb ADC_BRIDGE_power_summary_routed.pb -rpx ADC_BRIDGE_power_routed.rpx }
  catch { report_route_status -file ADC_BRIDGE_route_status.rpt -pb ADC_BRIDGE_route_status.pb }
  catch { report_clock_utilization -file ADC_BRIDGE_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force ADC_BRIDGE_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

