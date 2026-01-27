**Overview =>
This project implements a parameterized asynchronous FIFO (First-In First-Out) buffer using Verilog HDL, designed to safely transfer data between two independent clock domains.
The FIFO uses binary counters for memory addressing and Gray-coded pointers for clock domain crossing (CDC). Pointer synchronization is handled using two-flip-flop synchronizers, 
significantly reducing metastability risk.
The design generates FULL and EMPTY flags using next-pointer comparison logic, ensuring reliable overflow and underflow protection.


**Features =>
Fully asynchronous FIFO with independent read and write clocks
Parameterized data width and depth for easy reuse
Gray-coded pointer synchronization for safe CDC
Binary pointers used for efficient memory addressing
Two-flip-flop synchronizers to reduce metastability
Registered FULL and EMPTY flags (glitch-free operation)
Dual-clock memory architecture
Overflow and underflow protection


**Tools Used =>
Verilog HDL
Xilinx Vivado (Simulation, Synthesis, Implementation)
FPGA Development Board (for hardware validation)
