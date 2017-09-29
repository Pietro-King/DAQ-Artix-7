@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xsim simulazioneADC_BRIDGE_behav -key {Behavioral:sim_2:Functional:simulazioneADC_BRIDGE} -tclbatch simulazioneADC_BRIDGE.tcl -view C:/Users/Valerio/Desktop/TESI_DIGITALE/king_adc/king_adc.srcs/sim_2/imports/start_stop_5_13/command_test.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
