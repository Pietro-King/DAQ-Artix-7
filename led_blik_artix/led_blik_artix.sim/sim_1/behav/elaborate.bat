@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 7fcc53297b5243be9830cfd10284e3d1 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot led_blink_behav xil_defaultlib.led_blink -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
