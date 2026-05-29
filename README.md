# 4-Bit Structural ALU with Exhaustive Verification

![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)
![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)
![Status](https://img.shields.io/badge/Status-Verified-success.svg)

## Overview
This repository contains a 4-bit Arithmetic Logic Unit (ALU) designed entirely from foundational logic gates in SystemVerilog, accompanied by a self-checking, exhaustive verification environment.

Unlike standard behavioral ALU models that rely on high-level arithmetic operators, this project emphasizes structural hardware architecture and rigorous mathematical verification strategies. It serves as a practical demonstration of core hardware engineering principles and compiler behavior.

---

## Architecture Highlights

* **Structural Design:** Implemented using purely structural modeling (Full Adders, Multiplexers, custom logic gates) rather than behavioral abstractions.
* **Subtraction via Two's Complement:** Executes native subtraction without a dedicated subtractor unit. This is achieved utilizing the mathematical identity `A + ~B + 1`, controlled by multiplexed XOR routing directly into the Full Adder chain.
* **Status Flag Integrity:** Incorporates a custom flag-filtering module to enforce strict status register integrity. The `C` (Carry) and `V` (Overflow) flags are explicitly driven to logic zero during logical operations to prevent hardware latching and state retention.

---

## Verification Methodology (100% Coverage)

The design is validated using an industry-standard Golden Model and Scoreboard architecture, achieving complete mathematical coverage (2,048 unique states) without relying on manual test vectors.

* **Separation of Concerns:** The stimulus generator (triple-nested loop) is structurally isolated from the Golden Model (prediction block) to prevent testbench race conditions.
* **Bypassing Sign-Extension Limitations:** The software Golden Model accurately predicts the hardware Carry (`C`) flag by utilizing unsigned concatenation (`{1'b0, a} + {1'b0, ~b} + 1'b1`). This forces the simulator to evaluate raw physical gate logic, bypassing the SystemVerilog compiler's default signed math behavior.
* **Boundary Evaluation:** Signed overflow (`V`) prediction is protected from bit-truncation limits by leveraging the compiler's default 32-bit integer evaluation during conditional boundary checks.
* **Latch Prevention:** The Golden Model initializes all status flags to explicit zero-states at the beginning of every combinational evaluation to strictly prevent the simulator from synthesizing unintended memory latches.

---

## Execution Instructions

These files are compatible with standard Verilog simulation environments (e.g., Icarus Verilog, ModelSim) as well as web-based simulators such as EDA Playground.

1. Clone the repository to your local machine.
2. Ensure both `design.sv` and `testbench.sv` are located in the same directory.
3. Compile and run the simulation using your preferred environment. 
4. The automated scoreboard will evaluate all 2,048 combinations. Upon successful verification of all states against the Golden Model, the console will output a final confirmation message.
