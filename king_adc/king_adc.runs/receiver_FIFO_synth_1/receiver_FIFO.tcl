# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -msgmgr_mode ooc_run
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.cache/wt [current_project]
set_property parent.project_path C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_ip -quiet C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.xci
set_property is_locked true [get_files C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.xci]

foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

set cached_ip [config_ip_cache -export -no_bom -use_project_ipc -dir C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1 -new_name receiver_FIFO -ip [get_ips receiver_FIFO]]

if { $cached_ip eq {} } {

synth_design -top receiver_FIFO -part xc7a100tcsg324-1 -mode out_of_context

#---------------------------------------------------------
# Generate Checkpoint/Stub/Simulation Files For IP Cache
#---------------------------------------------------------
catch {
 write_checkpoint -force -noxdef -rename_prefix receiver_FIFO_ receiver_FIFO.dcp

 set ipCachedFiles {}
 write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ receiver_FIFO_stub.v
 lappend ipCachedFiles receiver_FIFO_stub.v

 write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ receiver_FIFO_stub.vhdl
 lappend ipCachedFiles receiver_FIFO_stub.vhdl

 write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ receiver_FIFO_sim_netlist.v
 lappend ipCachedFiles receiver_FIFO_sim_netlist.v

 write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ receiver_FIFO_sim_netlist.vhdl
 lappend ipCachedFiles receiver_FIFO_sim_netlist.vhdl

 config_ip_cache -add -dcp receiver_FIFO.dcp -move_files $ipCachedFiles -use_project_ipc -ip [get_ips receiver_FIFO]
}

rename_ref -prefix_all receiver_FIFO_

write_checkpoint -force -noxdef receiver_FIFO.dcp

catch { report_utilization -file receiver_FIFO_utilization_synth.rpt -pb receiver_FIFO_utilization_synth.pb }

if { [catch {
  file copy -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO.dcp C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  write_verilog -force -mode synth_stub C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode synth_stub C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  write_verilog -force -mode funcsim C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  write_vhdl -force -mode funcsim C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}


} else {


if { [catch {
  file copy -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO.dcp C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO.dcp
} _RESULT ] } { 
  send_msg_id runtcl-3 error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}

if { [catch {
  file rename -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO_stub.v C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO_stub.vhdl C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO_sim_netlist.v C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_sim_netlist.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

if { [catch {
  file rename -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.runs/receiver_FIFO_synth_1/receiver_FIFO_sim_netlist.vhdl C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_sim_netlist.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}

}; # end if cached_ip 

if {[file isdir C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.ip_user_files/ip/receiver_FIFO]} {
  catch { 
    file copy -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.v C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.ip_user_files/ip/receiver_FIFO
  }
}

if {[file isdir C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.ip_user_files/ip/receiver_FIFO]} {
  catch { 
    file copy -force C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.srcs/sources_1/ip/receiver_FIFO/receiver_FIFO_stub.vhdl C:/Users/Valerio/Desktop/TESI_DIGITALE/test_Ax3/test_Ax3.ip_user_files/ip/receiver_FIFO
  }
}
