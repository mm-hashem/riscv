regfile = {
    5: "01234456",
    6: "89ABCDEF",
    7: "00000000"
}

with open("qc/regfile.mem", "w") as file:
    file.write("// Value - Register\n")
    for x in range (32):
        if x in regfile:
            file.write(regfile[x] + " // " + f"x{x}" + "\n")
        else:
            file.write(f"{0:08x}" + " // " + f"x{x}" + "\n")