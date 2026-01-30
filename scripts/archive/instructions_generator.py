instr = {
    4096: "0062C3B3"
}

instr_new = {}
for key, value in instr.items():
    instr_new[key]   = value[6:8]
    instr_new[key+1] = value[4:6]
    instr_new[key+2] = value[2:4]
    instr_new[key+3] = value[0:2]

with open("qs/text.mem", "w") as file:
    file.write("// Data - Address\n")
    for x in range (8208):
        if x in instr_new:
            file.write(instr_new[x] + " // " + f"{x:#010x}" + "\n")
        else:
            file.write(f"{0:02x}" + " // " + f"{x:#010x}" + "\n")

# 8207 = 0x2000