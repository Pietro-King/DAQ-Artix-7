set_property SRC_FILE_INFO {cfile:c:/Users/Valerio/Desktop/TESI_DIGITALE/axel_adc_bridge/axel_adc_bridge.srcs/sources_1/ip/clock_generator/clock_generator.xdc rfile:../../../axel_adc_bridge.srcs/sources_1/ip/clock_generator/clock_generator.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports CLK_IN1]] 0.0
