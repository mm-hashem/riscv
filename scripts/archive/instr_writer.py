with open("misc/prog_stripped.bin", "rb") as bin, open('qc/instr.mem', 'w') as mem:
    addr = 0
    for b in bin.read():
        mem.write(f"{b:02x}" + " // " + f"{addr:#010x}\n")
        addr += 1

#with open("definitions_pkg.sv", 'r+') as infile:
#    lines = infile.readlines() # Read all lines

