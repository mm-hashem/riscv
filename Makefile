# Core Configurations
XLEN   ?=
CORE   ?=
EXT    ?=
TEST   ?=
TOP    ?= rv_top
CCDBG  ?=
SIMGUI ?= 0
RGRS   ?= 0

# Memory Configurations
TEXT_MEM_LEN ?= 0x00002400
DATA_MEM_LEN ?= 0x00000800
STACK_LEN    ?= 0x00000400
END_ADDR     := $(shell printf "0x%X" $$(($(TEXT_MEM_LEN) + $(DATA_MEM_LEN) + 8))) # +8 for TOHOST

# Input validation
ifeq ($(filter $(MAKECMDGOALS),build_riscv_tests sim_riscv_tests run_riscv_tests build_sv),)
    ifeq ($(filter $(suffix $(TEST)),.c .s .S),)
        $(error The test program must be assembly (.s or .S) or C (.c))
    endif
endif

ifeq ($(filter $(XLEN),32 64),)
    $(error XLEN must be 32 or 64)
endif

ifeq ($(filter $(CORE),SINGLE STAGE3 STAGE5),)
    $(error Supported microarchitectures: SINGLE, STAGE3, or STAGE5)
endif

ifdef EXT
    ifeq ($(filter $(EXT), ZBA),)
        $(error Supported extensions: ZBA)
    endif
endif

ifeq ($(RGRS),1)
    ifeq ($(SIMGUI),1)
        $(error Both regression flag (RGRS) and simulation GUI flag (SIMGUI) can't be 1 at the same time.)
    endif
endif

# Input Processing
override TEST := $(patsubst ./test/sw/%,%,$(TEST))
TEST_SLUG     := $(basename $(notdir $(TEST)))

####################
##### GCC Flow #####
####################

# Toolchains
CC      := riscv64-unknown-elf-gcc
LD      := riscv64-unknown-elf-ld
OBJCOPY := riscv64-unknown-elf-objcopy
PYTHON  := python3

# Directories
TEST_DIR     := ./test
BUILD_DIR    := ./build
TEST_SW_DIR  := $(TEST_DIR)/sw
BUILD_SW_DIR := $(BUILD_DIR)/sw
MEMORY_DIR   := $(BUILD_DIR)/memory
HEADERS      := -I$(TEST_SW_DIR)/headers -I$(TEST_SW_DIR)/riscv_tests/headers # RISCV TESTS

# Definitions
CCDEFS   := -DXLEN=$(XLEN) -DCORE=$(CORE) $(if $(filter ZBA,$(EXT)),-DZBA=1)

# Flags
ARCH_FLAGS := -march=rv$(XLEN)i$(if $(filter ZBA,$(EXT)),_zba)
ABI_FLAGS  := -mabi=$(if $(filter 64,$(XLEN)),lp64,ilp32)
DBG_FLAGS  := $(if $(filter $(CCDBG),1),-save-temps=obj -g,)

CCFLAGS      := $(ARCH_FLAGS) $(ABI_FLAGS) $(DBG_FLAGS) $(CCDEFS) \
                -mlittle-endian -Wall $(HEADERS)
LDFLAGS      := -m elf$(XLEN)lriscv -b elf$(XLEN)-littleriscv -nostdlib
OBJCOPYFLAGS := -I elf$(XLEN)-littleriscv -O verilog

# Files
CRT       := _start.S _exit.S
SOURCES   := $(addprefix $(TEST_SW_DIR)/,$(TEST)) $(addprefix $(TEST_SW_DIR)/crt/,$(CRT))
OBJECTS   := $(addprefix $(BUILD_SW_DIR)/,$(patsubst %.S,%.o,$(patsubst %.c,%.o,$(TEST) $(CRT))))
ELF       := $(BUILD_SW_DIR)/$(basename $(firstword $(notdir $(SOURCES)))).elf
LINKER    := $(TEST_SW_DIR)/linker/linker.ld
MEMORIES  := $(MEMORY_DIR)/text_$(TEST_SLUG).mem $(MEMORY_DIR)/data_$(TEST_SLUG).mem
CFGSV     := ./rtl/pkg/config_pkg.sv
UPDLINKER := $(BUILD_DIR)/.update_linker_stamp

RISCV_TESTS_32i   := $(wildcard $(TEST_SW_DIR)/riscv_tests/rv32i/*.S)
RISCV_TESTS_32ZBA := $(wildcard $(TEST_SW_DIR)/riscv_tests/rv32zba/*.S)
RISCV_TESTS_64i   := $(wildcard $(TEST_SW_DIR)/riscv_tests/rv64i/*.S)
RISCV_TESTS_64ZBA := $(wildcard $(TEST_SW_DIR)/riscv_tests/rv64zba/*.S)

RISCV_TEST_TARGET := RISCV_TESTS_$(XLEN)$(if $(filter $(EXT),ZBA),ZBA,i)
RISCV_TESTS = $($(RISCV_TEST_TARGET))

.PHONY: sim_riscv_tests build_riscv_tests build_cc_riscv_tests run build build_cc build_sv simlib simmap simcompile simopt sim

build_riscv_tests: build_cc_riscv_tests build_sv
build_sv: simopt
build_cc: $(MEMORIES)
build: build_cc build_sv
run: build sim
run_riscv_tests: build_riscv_tests sim_riscv_tests

build_cc_riscv_tests:
	@for t in $(RISCV_TESTS); do \
		$(MAKE) XLEN=$(XLEN) CORE=$(CORE) RGRS=$(RGRS) EXT=$(EXT) build_cc TEST=$$t; \
	done

sim_riscv_tests:
	@for t in $(RISCV_TESTS); do \
		$(MAKE) XLEN=$(XLEN) CORE=$(CORE) RGRS=$(RGRS) EXT=$(EXT) sim TEST=$$t; \
	done

# Update memory sizes and addresses
$(UPDLINKER): $(CFGSV) $(LINKER)
	$(PYTHON) $(TEST_SW_DIR)/scripts/update_offsets.py $(XLEN) \
	$(TEXT_MEM_LEN) $(DATA_MEM_LEN) $(STACK_LEN)
	@touch $@

$(BUILD_SW_DIR) $(MEMORY_DIR):
	@mkdir -p $@

# Compile: .c -> .o
$(BUILD_SW_DIR)/%.o: $(TEST_SW_DIR)/%.c $(UPDLINKER) | $(BUILD_SW_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CCFLAGS) $< -o $@

# Compile: .S -> .o
$(BUILD_SW_DIR)/%.o: $(TEST_SW_DIR)/%.S $(UPDLINKER) | $(BUILD_SW_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CCFLAGS) $< -o $@

# Compile: crt/.S -> .o
$(BUILD_SW_DIR)/%.o: $(TEST_SW_DIR)/crt/%.S $(UPDLINKER) | $(BUILD_SW_DIR)
	@mkdir -p $(dir $@)
	$(CC) -c $(CCFLAGS) $< -o $@

# Link: .o -> .elf
$(ELF): $(LINKER) $(OBJECTS) | $(BUILD_SW_DIR)
	$(LD) $(LDFLAGS) -T $^ -o $@

# Copy instructions to text.mem
$(MEMORY_DIR)/text_$(TEST_SLUG).mem: $(ELF) | $(MEMORY_DIR)
	$(OBJCOPY) $(OBJCOPYFLAGS) --only-section=.text $< $@

$(MEMORY_DIR)/data_$(TEST_SLUG).mem: $(ELF) | $(MEMORY_DIR)
	$(OBJCOPY) $(OBJCOPYFLAGS)  --only-section=.rodata --only-section=.data \
	--only-section=.bss --gap-fill 0x00 --pad-to $(END_ADDR) $< $@

###########################
##### Simulation Flow #####
###########################

# Flags
CMPLOG_FLAGS := $(if $(filter $(RGRS),1),,-l $(LOGS_DIR)/compilation.log)
SIMLOG_FLAGS := $(if $(filter $(RGRS),1),,-wlf $(WORK_DIR)/vsim.wlf -l $(LOGS_DIR)/simulation_$(TEST_SLUG).log)

VLOGFLAGS := -work work -sv -incr $(CMPLOG_FLAGS)
VOPTFLAGS := $(if $(filter $(RGRS),1),,+acc)
VSIMFLAGS := $(SIMLOG_FLAGS) $(if $(filter $(SIMGUI),1),-gui,$(if $(filter $(RGRS),1),-batch,-c))

# Definitions
VLOGDEFS := +define+XLEN=$(XLEN)+$(CORE)$(if $(EXT),+$(EXT))$(if $(filter $(RGRS),1),+RGRS,)

# Directories
TB_DIR   := $(TEST_DIR)/tb
SIM_DIR  := $(TEST_DIR)/sim
WORK_DIR := $(BUILD_DIR)/work
LOGS_DIR := $(BUILD_DIR)/logs
RTL_DIR  := ./rtl

# Files
TOP_FILE     := $(TB_DIR)/rv_top.sv
PKG_FILES    := -f $(SIM_DIR)/filelist_pkg.f
COMMON_FILES := -f $(SIM_DIR)/filelist_common.f

ifeq ($(CORE),SINGLE)
    CORE_FILES += $(RTL_DIR)/cores/rv_single.sv
else ifeq ($(CORE),STAGE3)
    CORE_FILES += $(RTL_DIR)/pipelined/stage3/hazard_unit.sv $(RTL_DIR)/cores/rv_stage3.sv
endif

RTL_FILES := $(PKG_FILES) $(COMMON_FILES) $(CORE_FILES)
VRF_FILES := -f $(SIM_DIR)/filelist_vrf.f
SV_FILES  := $(RTL_FILES) $(VRF_FILES) $(TOP_FILE)
DOFILE    := $(SIM_DIR)/sim.do

DOCMD := $(if $(filter $(SIMGUI),1),do $(DOFILE);,$(if $(filter $(RGRS),1),quietly vsim;,)) run -all; $(if $(filter $(SIMGUI),1),,quit -f;)

$(WORK_DIR) $(LOGS_DIR):
	@mkdir -p $@

# todo $(WORK_DIR)/_info update_offsets | $(WORK_DIR)
simlib: | $(WORK_DIR)
	vlib $(WORK_DIR)

simmap: simlib | $(WORK_DIR)
	vmap work $(WORK_DIR)

simcompile: simmap | $(LOGS_DIR)
	vlog $(VLOGFLAGS) $(VLOGDEFS) $(SV_FILES)

simopt: simcompile
	vopt $(VOPTFLAGS) $(TOP) -o design_opt

sim:
	vsim $(VSIMFLAGS) -do "$(DOCMD)" design_opt +TESTNAME="$(TEST_SLUG)"