import re
import subprocess

# Files that will be used
asm_file     = "scripts/cordic.s"      # Assembly file containing the test instructions
elf_file     = "scripts/prog.elf"      # Stripped object file that contains only the instructions
textmem_file = "qs/text.mem"       # Memory file that will be read by QuestaSim
datamem_file = "qs/data.mem"
defpkg_file  = "definitions_pkg.sv" # The SV definitions package that contains the length of the instruction memory
linker_file  = "scripts/linker.ld"

##################################################
############## Assembling & Linking ##############
##################################################

#                 riscv32-unknown-elf-gcc    -march=rv32i    -mabi=ilp32    -nostdlib    -nostartfiles    -T   linker.ld    cordic.s   -o   prog.elf
assembler_cmd = ["riscv32-unknown-elf-gcc", "-march=rv32i", "-mabi=ilp32", "-nostdlib", "-nostartfiles", "-T", linker_file, asm_file, "-o", elf_file]
#                     riscv32-unknown-elf-objcopy    -O    verilog    --only-section=.text   prog.elf  text.mem
objcopy_instr_cmd = ["riscv32-unknown-elf-objcopy", "-O", "verilog", "--only-section=.text", elf_file, textmem_file]
#                    riscv32-unknown-elf-objcopy    -O    verilog    --only-section=.data   prog.elf  data.mem
objcopy_data_cmd = ["riscv32-unknown-elf-objcopy", "-O", "verilog", "--only-section=.data", elf_file, datamem_file]

print("Assembling & Linking", asm_file)
print("cmd: ", *assembler_cmd)
try:
    assembler_result = subprocess.run (
        assembler_cmd,
        capture_output=True,
        text=True,
        timeout=30  # Prevent hanging
    )
    print("Assembling & linking succeeded")
    print("Generated ELF file", elf_file)
    print("StdOut:", assembler_result.stdout)
    print("Return code: ", assembler_result.returncode, "\n")
except:
    print("Assembling & linking failed")
    print("StdOut:", assembler_result.stderr)
    print("Return code:", assembler_result.returncode, "\n")

################### TEXT MEM
print("Generating verilog instruction memory file", textmem_file, "from", elf_file)
print("cmd:", *objcopy_instr_cmd)
try:
    objcopy_instr_result = subprocess.run (
        objcopy_instr_cmd,
        capture_output=True,
        text=True,
        timeout=30  # Prevent hanging
    )
    print("Generation succeeded")
    print("Generated verilog instruction memory file", textmem_file)
    print("StdOut:", objcopy_instr_result.stdout)
    print("Return code:", objcopy_instr_result.returncode, "\n")
except:
    print("Generation failed\n")
    print("StdOut: ", objcopy_instr_result.stderr)
    print("Return code: ", objcopy_instr_result.returncode, "\n")

########################### DATA MEM
print("Generating verilog data memory file", datamem_file, "from", elf_file)
print("cmd:", *objcopy_data_cmd)
try:
    objcopy_data_result = subprocess.run (
        objcopy_data_cmd,
        capture_output=True,
        text=True,
        timeout=30  # Prevent hanging
    )
    print("Generation succeeded")
    print("Generated verilog data memory file", datamem_file)
    print("StdOut:", objcopy_data_result.stdout)
    print("Return code:", objcopy_data_result.returncode, "\n")
except:
    print("Generation failed\n")
    print("StdOut: ", objcopy_data_result.stderr)
    print("Return code: ", objcopy_data_result.returncode, "\n")

# This code will update the size of the instruction memory in the definitions package file
#instr_regex = r"(INSTR_SIZE\s*=\s*)(\d+)"
#instr_sub = rf"\g<1>{addr}"
#
#with open(defpkg_file, "r") as f:
#    text = f.read()
#
#text = re.sub(instr_regex, instr_sub, text, 1, re.IGNORECASE)
#
#with open(defpkg_file, "w") as f:
#    f.write(text)
#