onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clock_generator_opt

do {wave.do}

view wave
view structure
view signals

do {clock_generator.udo}

run -all

quit -force
