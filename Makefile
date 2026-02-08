# 64 - C - Zba
# Toolchains
CC = riscv64-unknown-elf-gcc
AS = riscv64-unknown-elf-as
LD = riscv64-unknown-elf-ld
OBJCOPY = riscv64-unknown-elf-objcopy

# Flags
CCFLAGS = -march=rv64i_zba -mabi=lp64 -mlittle-endian -S #-fverbose-asm
ASFLAGS = -march=rv64i_zba -mabi=lp64 -mlittle-endian
LDFLAGS = -m elf64lriscv -b elf64-littleriscv -nostdlib
OBJCOPYFLAGS = -O verilog # --verilog-data-width=4

# Directories
SRC_DIR = sw
MEM_DIR = hdl/qs_run

# Files
SOURCES = $(SRC_DIR)/test.c
ASMFILES = $(SOURCES:.c=.s)
OBJECTS = $(ASMFILES:.s=.o)
ELF = $(OBJECTS:.o=.elf)
LINKER = $(SRC_DIR)/linker_64.ld
MEMORIES = $(MEM_DIR)/text.mem $(MEM_DIR)/data.mem

.PHONY: all clean

all: $(MEMORIES)

# Compile: .c -> .s
$(ASMFILES): $(SOURCES)
	$(CC) $(CCFLAGS) $< -o $@

# Assemble: .s -> .o, one to one
$(OBJECTS): $(ASMFILES)
	$(AS) $(ASFLAGS) $< -o $@

# Link: .o -> .elf, many to one
$(ELF): $(LINKER) $(OBJECTS)
	$(LD) $(LDFLAGS) -T $(LINKER) $(OBJECTS) -o $@

$(MEM_DIR)/text.mem: $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) --only-section=.text $< $@

$(MEM_DIR)/data.mem: $(ELF)
	$(OBJCOPY) $(OBJCOPYFLAGS) --only-section=.data --gap-fill 0x00 --pad-to 0x00000800 $< $@

clean:
	
#	rm -f $(OBJECTS) $(ELF) $(MEMORIES)