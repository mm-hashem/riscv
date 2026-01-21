data = {
    8192: "0000000A"
}

data_new = {}
for key, value in data.items():
    data_new[key]   = value[6:8]
    data_new[key+1] = value[4:6]
    data_new[key+2] = value[2:4]
    data_new[key+3] = value[0:2]

with open("qc/data.mem", "w") as file:
    file.write("// Data - Address\n")
    for x in range (8208):
        if x in data_new:
            file.write(data_new[x] + " // " + f"{x:#010x}" + "\n")
        else:
            file.write(f"{0:02x}" + " // " + f"{x:#010x}" + "\n")

# 8207 = 0x2000