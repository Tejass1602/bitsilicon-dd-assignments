
# Digital Stopwatch using Verilog and Verilator

---

## 1. Overview

This project implements a Digital Stopwatch Controller using synthesizable Verilog RTL
and demonstrates a hardware–software co-design flow using Verilator.

The stopwatch measures elapsed time in minutes and seconds (MM:SS) and supports:
- Start
- Stop (pause)
- Resume
- Reset

All stopwatch logic, including timekeeping, control, and rollover behavior, is implemented
entirely in hardware (Verilog). A C++ control program is used only to drive the clock,
apply control inputs, and read the hardware outputs.

The software does not compute time or manage stopwatch state.

---

## Tools and Environment

- Host Operating System: Windows 11
- Linux Environment: Ubuntu (WSL)
- Shell: Bash
- Verilator: Version 5.044
- C++ Compiler: g++

Tool versions can be checked using:

## Top-Level Module Design

The top-level module, `stopwatch_top.v`, exposes the complete external interface of the stopwatch system.  
It provides:

- Clock and global reset inputs  
- Control inputs for start, stop (pause), and reset  
- Output signals for minutes, seconds, and the current FSM state  

The top-level module instantiates the following submodules:
- `control_fsm`
- `seconds_counter`
- `minutes_counter`

These modules are interconnected using clean, synchronous signals. The top-level module is responsible only for signal routing and integration; all functional behavior is implemented inside the respective submodules.

---

## Control FSM Design

A **Moore Finite State Machine (FSM)** is used to control the operation of the stopwatch.

---

## FSM States

The FSM consists of three states:

- **IDLE** – The stopwatch is stopped and time does not increment  
- **RUNNING** – The stopwatch is actively counting time  
- **PAUSED** – The stopwatch is paused and the current time is held  

---

## Why a Moore FSM Was Chosen

A Moore FSM was chosen for the following reasons:

- Output signals depend only on the current state  
- Control outputs are stable and glitch-free  
- The behavior is easier to reason about and debug  
- Fully synchronous operation is ensured  

This approach is well-suited for a stopwatch, where predictable and stable control behavior is required.

---

## Seconds Counter Design

### Functionality

The seconds counter:
- Implements a synchronous up-counter  
- Counts from **0 to 59**  
- Increments only when enabled  
- Resets to 0 after reaching 59  

---

## Rollover Signal

When the seconds counter transitions from **59 → 0**, it generates a **single-cycle rollover pulse**.

---

### Design Rationale

A rollover pulse is used instead of checking counter values in other modules because:

- All registers update simultaneously on a clock edge  
- Checking updated values can lead to off-by-one errors  
- A rollover pulse explicitly marks the exact rollover event  

This guarantees that the minutes counter increments at the correct time.

---

## Minutes Counter Design

### Functionality

The minutes counter:
- Implements a synchronous up-counter  
- Counts from **0 to 99**  
- Increments only when:
  - The stopwatch is enabled  
  - The seconds rollover pulse is asserted  

---

## Stopwatch Reset (`reset`)

- Clears the stopwatch time during operation  
- Does not interfere with rollover increments  
- Allows the FSM to return to the **IDLE** state  

Separating these reset mechanisms improves correctness and closely matches real hardware behavior.

---

## Hardware–Software Co-Design

### Hardware Responsibilities

The hardware (Verilog RTL) is responsible for:
- Timekeeping  
- State control  
- Counter rollover detection  
- Output generation  

---

### Software Responsibilities

The software (C++ control program) is responsible for:
- Driving the clock  
- Applying start, stop, and reset as **single-cycle pulses**  
- Reading minutes, seconds, and FSM state  
- Displaying time in **MM:SS** format  

---

## Output Format

The stopwatch output is displayed in **MM:SS** format with leading zeros.

