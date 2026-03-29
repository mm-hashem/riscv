## Main Decoder
| opcode  | Type     | RegWrite | ImmSrc | ALUASrc | ALUBSrc | MemWrite | ResultSrc | Branch | Jump | ALUOp |
|:-------:|:--------:|:--------:|:------:|:-------:|:-------:|:--------:|:---------:|:------:|:----:|:-----:|
| 0000011 | I Load   | 1        | 000    | 00      | 1       | 0        | 01        | 0      | 0    | 00    |
| 0010011 | I ALU    | 1        | 000    | 00      | 1       | 0        | 00        | 0      | 0    | 10    |
| 0010111 | U: AUIPC | 1        | 100    | 10      | 1       | 0        | 00        | 0      | 0    | 00    |
| 0011011 | I ALU W  | 1        | 000    | 00      | 1       | 0        | 00        | 0      | 0    | 11    |
| 0100011 | S        | 0        | 001    | 00      | 1       | 1        | xx        | 0      | 0    | 00    |
| 0110011 | R        | 1        | xxx    | 00      | 0       | 0        | 00        | 0      | 0    | 10    |
| 0110111 | U: LUI   | 1        | 100    | 01      | 1       | 0        | 00        | 0      | 0    | 00    |
| 0111011 | R W      | 1        | xxx    | 00      | 0       | 0        | 00        | 0      | 0    | 11    |
| 1100011 | B        | 0        | 010    | 00      | 0       | 0        | xx        | 1      | 0    | 01    |
| 1100111 | I: JALR  | 1        | 000    | 00      | x       | 0        | 10        | 0      | 1    | xx    |
| 1101111 | J        | 1        | 011    | 00      | x       | 0        | 10        | 0      | 1    | xx    |

## ALU Decoder
| ALUOp_i | funct3_i | op_5_i | funct7_5_i | funct7_4_i | funct7_2_i | ALUCtrl_o    | Type: Instr               |
|:-------:|:--------:|:------:|:----------:|:----------:|:----------:|:------------:|:-------------------------:|
| 00      | xxx      | x      | x          | x          | x          | ADD          | I Load, I W Load, S       |
| 10      | 000      | 1      | 0          | x          | 0          | ADD          | R: add                    |
| 10      | 000      | 0      | x          | x          | x          | ADD          | I ALU: addi               |
| 10      | 000      | 1      | 1          | x          | x          | SUB          | R: sub                    |
| 01      | 00x      | 1      | x          | x          | x          | SUB          | B: beq, bne               |
| 10      | 111      | x      | x          | x          | x          | AND          | R: and, I ALU: andi       |
| 10      | 110      | 1      | 0          | 0          | x          | OR           | R: or                     |
| 10      | 110      | 0      | x          | 0          | x          | OR           | I ALU: ori                |
| 10      | 100      | 1      | 0          | 0          | x          | XOR          | R: xor                    |
| 10      | 100      | 0      | x          | 0          | x          | XOR          | I ALU: xori               |
| 01      | 10x      | 1      | x          | x          | x          | SLT          | B: blt, bge               |
| 10      | 010      | 1      | 0          | 0          | 0          | SLT          | R: slt                    |
| 10      | 010      | 0      | x          | 0          | x          | SLT          | I ALU: slti               |
| 10      | 001      | x      | 0          | 0          | 0          | SLL          | R: sll, I ALU: slli       |
| 11      | 001      | x      | 0          | 0          | 0          | SLL          | R W: sllw I ALU W: slliw  |
| 10      | 101      | x      | 0          | x          | x          | SRL          | R: srl, I ALU: srli       |
| 10      | 101      | x      | 1          | x          | x          | SRA          | R: sra, I ALU: srai       |
| 01      | 11x      | 1      | x          | x          | x          | SLTU         | B: bltu, bgeu             |
| 10      | 011      | x      | x          | x          | x          | SLTU         | R: sltu, I ALU: sltiu     |
| 11      | 000      | 1      | 0          | x          | 0          | ADDW         | R W: addw                 |
| 11      | 000      | 0      | x          | x          | x          | ADDW         | I ALU W: addiw            |
| 11      | 000      | 1      | 1          | x          | x          | SUBW         | R W: subw                 |
| 10      | 101      | x      | 0          | x          | x          | SRLW         | R W: srlw, I ALU W: srliw |
| 10      | 101      | x      | 1          | x          | x          | SRAW         | R W: sraw, I ALU W: sraiw |
| 10      | 010      | 1      | 0          | 1          | 0          | SH1ADD       | R: sh1add                 |
| 10      | 100      | 1      | 0          | 1          | 0          | SH2ADD       | R: sh2add                 |
| 10      | 110      | 1      | 0          | 1          | 0          | SH3ADD       | R: sh3add                 |
| 11      | 000      | 1      | 0          | x          | 1          | ADDUW        | R W: add.uw               |
| 11      | 010      | 1      | 0          | 1          | 0          | SH1ADDUW     | R W: sh1add.uw            |
| 11      | 100      | 1      | 0          | 1          | 0          | SH2ADDUW     | R W: sh2add.uw            |
| 11      | 110      | 1      | 0          | 1          | 0          | SH3ADDUW     | R W: sh1add.uw            |
| 10      | 001      | 0      | 0          | 0          | 1          | SLLUW        | I ALU W: slli.uw          |

## Data Control
| Instruction | Size        | Sign |
|:-----------:|:-----------:|:----:|
| sb          | 8'b00000001 | 1'b0 |
| sh          | 8'b00000011 | 1'b0 |
| sw          | 8'b00001111 | 1'b0 |
| sd          | 8'b11111111 | 1'b0 |
| lb          | 8'b00000001 | 1'b1 |
| lh          | 8'b00000011 | 1'b1 |
| lw          | 8'b00001111 | 1'b1 |
| lbu         | 8'b00000001 | 1'b0 |
| lhu         | 8'b00000011 | 1'b0 |
| lwu         | 8'b00001111 | 1'b0 |
| ld          | 8'b11111111 | 1'b1 |

Size: byte-enable
Sign: 1'b0 for Zero-Extend, 1'b1 for Sign-Extend

## Zba
| opcode  | funct3 | funct7  | Type    | Instruction              | Description                           | Operation                            |
|:-------:|:------:|---------|:-------:|:------------------------:|:-------------------------------------:|:------------------------------------:|
| 0011011 | 001    | 000010  | I ALU W | slli.uw   rd, rs1, shamt | Shift unsigned word left by Immediate | rd =  ZeroExt(rs1[31:0]) << shamt    |
| 0110011 | 010    | 0010000 | R       | sh1add    rd, rs1, rs2   | Shift               left by 1 and add | rd = (        rs1        << 1) + rs2 |
| 0110011 | 100    | 0010000 | R       | sh2add    rd, rs1, rs2   | Shift               left by 2 and add | rd = (        rs1        << 2) + rs2 |
| 0110011 | 110    | 0010000 | R       | sh3add    rd, rs1, rs2   | Shift               left by 3 and add | rd = (        rs1        << 3) + rs2 |
| 0111011 | 000    | 0000100 | R W     | add.uw    rd, rs1, rs2   | Add   unsigned word                   | rd =  ZeroExt(rs1[31:0])       + rs2 |
| 0111011 | 010    | 0010000 | R W     | sh1add.uw rd, rs1, rs2   | Shift unsigned word left by 1 and add | rd = (ZeroExt(rs1[31:0]) << 1) + rs2 |
| 0111011 | 100    | 0010000 | R W     | sh2add.uw rd, rs1, rs2   | Shift unsigned word left by 2 and add | rd = (ZeroExt(rs1[31:0]) << 2) + rs2 |
| 0111011 | 110    | 0010000 | R W     | sh3add.uw rd, rs1, rs2   | Shift unsigned word left by 3 and add | rd = (ZeroExt(rs1[31:0]) << 3) + rs2 |