# microLIW-Processor
Small LIW/VLIW (long / very long instruction word) processor core built for my thesis project and for further personal research on processor architectures and the implementation of them.

**Static issue processor** based on a Long Instruction word topology (proof of concept).

Classic RISC 5-stage pipeline (hazard control is currently in progress)

**Early development specifications**

--Dual ALU 

--Dual AGU (Load / Store Unit)

--40bit instruction word (multiOp), two 20bit smaller instructions

--16 entry general purpose register file (4 read and 2 write ports)

--256 entry instruction memory 40bit

--65K data memory / 16bit data **temporary**

--Planned FPGA hardware -> XILINX ARTIX 7 (NEXYS 4 DDR BOARD)
