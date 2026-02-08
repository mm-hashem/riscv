del /q vsim.wlf
del /q transcript
del /q modelsim.ini
rmdir /s /q work

vsim -do "vlib work; vmap work work; do rv64Zbaip3.do; vsim -gui work.testbench -voptargs=+acc; add wave -r *; run -all;"