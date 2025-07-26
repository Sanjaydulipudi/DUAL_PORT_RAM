# Dual Port RAM – Verilog Implementation

### Project Overview  
This project demonstrates the design and simulation of a **True Dual Port RAM (256 x 8)** using **Verilog HDL**, tested in **Xilinx Vivado 2025.1**.  
The RAM supports simultaneous **read/write operations on two ports (A & B)**, independent clocks, and **smart arbitration** when conflicts occur.

The design was verified in **4 simulation phases**, starting from basic memory checks to complex arbitration logic.

---

##  What is Dual Port RAM?

A **Single Port RAM** allows only one read or write at a time, whereas a **Dual Port RAM** can handle **two simultaneous operations** on two separate ports.  

### **Key Features:**
- **Two Independent Ports:** Port A and Port B have separate address, data, and control lines.  
- **Separate Clocks:** Both ports operate with different clock domains.  
- **True Dual Port:** Both ports can read or write at the same time.  
- **Arbitration Logic:** When both try to write to the same location, Port A gets priority and Port B is redirected.

---

##  Project Specifications

- **Memory Size:** 256 x 8 (256 locations, 8 bits per location)  
- **Clocks:** Independent (`clk_a`, `clk_b`)  
- **Priority Rule:** Port A keeps its address; Port B redirected if a conflict occurs  
- **Tool:** Xilinx Vivado Simulator 2025.1  
- **Target Device:** Artix-7 FPGA (but simulation-only design)

---

##  Simulation Phases

The simulation was divided into **4 well-structured phases**, each targeting one functional verification step.

---

### Phase 1 – Initial Memory Check 

**Objective:** Confirm that all memory locations are initialized to `0` before any operation.

**What we did:**
- Both ports read addresses `0` to `9` immediately after reset.
- No write operation was performed.

**Key Observation:**
- Every memory location returned `0`, confirming proper initialization.

---

###  Phase 2 – Basic Write & Read Operations 

**Objective:** Test simple read and write operations for both ports independently.

**What we did:**
- Port A wrote data into addresses 5, 6, and 7.
- Port B wrote data into addresses 10, 11, and 12.
- Both ports later read back their respective data.

**Key Observation:**
- Both ports successfully wrote and read data from separate locations.
- No conflicts occurred since they accessed different addresses.

---

### Phase 3 – Independent Clock Operation  

**Objective:** Prove that both ports can work **asynchronously with different clock speeds**.

**What we did:**
- Port A was driven by a **fast clock** (~100 MHz) and performed multiple quick writes.
- Port B used a **slower clock** (~71 MHz) and read data gradually.
- The writes and reads were interleaved to show independent operation.

**Key Observation:**
- Port B was able to read correct data even while Port A was actively writing.
- Independent clock domains worked perfectly, proving true dual-port behavior.

---

### Phase 4 – Smart Arbitration (Conflict Handling)

**Objective:** Handle simultaneous write conflicts intelligently.

**What we did:**
- Pre-filled the memory to simulate a realistic scenario.
- Port A and Port B intentionally tried to write to the same address.
- **Smart Arbitration Logic** ensured:
  - Port A always kept its original address (highest priority).
  - Port B was redirected to the next available free location.

**Key Observation:**
- Conflicts were resolved without data corruption.
- Port B successfully stored its data in a redirected address.

---

## ** Key Learnings**

- Understanding **True Dual Port RAM architecture**.  
- Simulating **asynchronous clock domains** in Verilog.  
- Implementing **priority-based arbitration logic** for write conflicts.  
- Writing clean and structured testbenches for FPGA/ASIC-level design verification.

---

## ** Author**

 **Dulipudi Laashmith Sanjay**  
B.Tech ECE | VVIT College | VLSI Enthusiast  

This project was developed as part of academic learning and can be extended further for **pipelined RAM architectures** or **AXI-based memory systems**.

---
