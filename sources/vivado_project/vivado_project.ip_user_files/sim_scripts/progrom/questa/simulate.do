onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib progrom_opt

do {wave.do}

view wave
view structure
view signals

do {progrom.udo}

run -all

quit -force
