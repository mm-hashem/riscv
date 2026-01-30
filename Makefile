# Toolchains
AS = riscv32-unknown-elf-as
LD = riscv32-unknown-elf-ld
OBJCOPY = riscv32-unknown-elf-objcopy

# Flags
ASFLAGS = -march=rv32i -mabi=ilp32 -mlittle-endian
LDFLAGS = -m elf32lriscv -b elf32-littleriscv -nostdlib

# Directories
SRC_DIR = scripts
MEM_DIR = qs

# Files
SOURCES = $(SRC_DIR)/cordic.s
OBJECTS = $(SOURCES:.s=.o)
LINKER = $(SRC_DIR)/linker.ld
ELF = $(SOURCES:.s=.elf) # OR OBJECTS?
MEMORIES = $(MEM_DIR)/text.mem $(MEM_DIR)/data.mem

.PHONY: all clean

all: $(MEMORIES)

# Assemble: .s -> .o, one to one
%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# Link: .o -> .elf, many to one
$(ELF): $(LINKER) $(OBJECTS)
	$(LD) $(LDFLAGS) -T $(LINKER) $(OBJECTS) -o $@

$(MEM_DIR)/text.mem: $(ELF)
	$(OBJCOPY) -O verilog --only-section=.text $< $@

$(MEM_DIR)/data.mem: $(ELF)
	$(OBJCOPY) -O verilog --only-section=.data $< $@

clean:
	
#	rm -f $(OBJECTS) $(ELF) $(MEMORIES)

###################################

# riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 -mlittle-endian cordic.s -o cordic.o
# riscv32-unknown-elf-ld -m elf32lriscv -b elf32-littleriscv -nostdlib -T linker.ld cordic.o -o cordic.elf
# riscv32-unknown-elf-objcopy -O verilog --only-section=.text prog.elf text.mem
# riscv32-unknown-elf-objcopy -O verilog --only-section=.data prog.elf data.mem
