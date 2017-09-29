@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto c15dd3b4c06d45c5a6a71d572676da02 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip -L xpm --snapshot simulazioneADC_BRIDGE_behav xil_defaultlib.simulazioneADC_BRIDGE -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
