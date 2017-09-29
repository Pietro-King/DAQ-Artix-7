onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+receiver_FIFO -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.receiver_FIFO xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {receiver_FIFO.udo}

run -all

endsim

quit -force
