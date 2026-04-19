This directory contains a subset of `riscv-tests` adapted for this project.

I utilized RISC-V International's `riscv-tests`, making minor modifications to integrate it into my automated workflow:

- **Source:** [riscv-tests repository](https://github.com/riscv-software-src/riscv-tests)
- **License:** See [LICENSE.txt](LICENSE.txt)

Modifications:
- Added assembly directives and adjusted memory sections to match my custom linker script
- Modified test macros to align with core behavior
- Added code for register saving/loading
- Removed unused macros and code for simplicity

Original license and headers are preserved.