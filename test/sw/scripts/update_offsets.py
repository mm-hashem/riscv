#!/usr/bin/env python3

"""
update_offsets.py

Usage examples:
  python update_offsets.py 32 0x1000 0x800 0x400 0x10
"""

import sys
import re

if len(sys.argv) > 1:
    xlen      = int(sys.argv[1])
    text_len  = int(sys.argv[2], 16)
    data_len  = int(sys.argv[3], 16)
    stack_len = int(sys.argv[4], 16)
    mmio_len  = int(sys.argv[5], 16)
    #print(f"XLEN: {xlen}\nText Length: {text_len}\nData Length: {data_len}\nStack Length: {stack_len}\n")
else:
    print("No arguments provided.")
    sys.exit(1)

# Files
LINKER_FILE = r"test/sw/linker/linker.ld"
CFGSV_FILE  = r"rtl/pkg/config_pkg.sv"

with open(LINKER_FILE, "r") as lnk_f, open(CFGSV_FILE, "r") as cfgsv_f:
    lnk_lines   = lnk_f.read()
    cfgsv_lines = cfgsv_f.read()

lnk_regexs = [
    r"(elf)(\d+)(-littleriscv)",              
    r"(IMEM.*LENGTH\s*=\s*)(\d+)(K)",         
    r"(DMEM.*ORIGIN\s*=\s*)(0x\d+)(,.*)",     
    r"(DMEM.*LENGTH\s*=\s*)(\d+)(K)",
    r"(ASSERT\(_edata.*)(0x\d+)(.*)",      
    r"()(\d+)(\)?;\s*\/\*\*\/)"
]

cfgsv_regexs = [
    r"(CFG_TEXT_LENGTH\s*=\s+'h)(\d+)(,)",
    r"(CFG_DATA_ORG\s*=\s+'h)(\d+)(;)",   
    r"(CFG_DATA_LENGTH\s*=\s+'h)(\d+)(,)",
    r"(CFG_MMIO_LENGTH\s*=\s*'h)(\d+)(;)"
]

lnk_subs = [
    xlen,                    
    int(text_len / 0x400),
    f"{text_len:#010x}",  
    int(data_len / 0x400),
    f"{stack_len:#010x}", 
    int(xlen/8)
]

cfgsv_subs = [
    f"{text_len:08x}",  
    f"{text_len:08x}",  
    f"{data_len:08x}",
    f"{mmio_len:08x}"
]

lnk_writeEn   = False
cfgsv_writeEn = False

for index, regex in enumerate(lnk_regexs):
    matches = re.findall(rf"{regex}", lnk_lines)
    isUpdated = all(match[1] == str(lnk_subs[index]) for match in matches)
    if not isUpdated:
        lnk_lines = re.sub(rf"{regex}", rf"\g<1>{lnk_subs[index]}\g<3>", lnk_lines)
        lnk_writeEn = True

for index, regex in enumerate(cfgsv_regexs):
    matches = re.findall(rf"{regex}", cfgsv_lines)
    isUpdated = all(match[1] == str(cfgsv_subs[index]) for match in matches)
    if not isUpdated:
        cfgsv_lines = re.sub(rf"{regex}", rf"\g<1>{cfgsv_subs[index]}\g<3>", cfgsv_lines)
        cfgsv_writeEn = True

if lnk_writeEn:
    with open(LINKER_FILE, "w") as lnk_f:
        lnk_f.write(lnk_lines)
    print("Linker is configured.")
else:
    print("Linker is already updated. No changes were made.")

if cfgsv_writeEn:
    with open(CFGSV_FILE, "w") as cfgsv_f:
        cfgsv_f.write(cfgsv_lines)
    print("config package is configured.")
else:
    print("Config package is already updated. No changes were made.")