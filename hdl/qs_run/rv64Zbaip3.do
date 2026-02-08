vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/definitions_pkg.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/alu.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/alu_decoder.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/controller.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/data_ram.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/extend_imm.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/extend_read_data.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/extend_write_data.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/instruction_ram.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/main_decoder.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/program_counter.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/core/register_file.sv

vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/decode_cp.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/decode_dp.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/fetch.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/hazard_unit.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/stage3_cp.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/pipeline_3/stage3_dp.sv

vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../rtl/rv32i_pipe_3.sv
vlog -work work -vopt -sv +define+PIPELINE3+RV64+ZBA -stats=none ../testbench/testbench.sv