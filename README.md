# MIPS 32-bit Single-Cycle Processor

### 📝 Description
A fully modular 32-bit **Single-Cycle MIPS Processor** built using Verilog HDL, closely following the standard MIPS architecture.  
This project implements instruction fetch, decode, execute, memory access, and write-back stages in a **single clock cycle**.

---

### 📊 Architecture Diagram  
![MIPS Architecture Block Diagram](https://github.com/Srikar109755/32-bit-Single_Cycle-MIPS-processor/blob/main/images/Block_Diagram.png)

---

### 🧩 Features
- Supports **R-type**, **LW**, **SW**, **BEQ**, and **JUMP** instructions  
- Modular structure for each pipeline stage  
- Self-checking **Testbench** with initial register/memory loading  
- 256-word instruction and data memory  
- Hardwired control logic, sign extension, and PC branching logic

---

### 📂 File Structure
```
├── mips_processor.v         # Top-level processor module
├── pc_register.v            # Program counter logic
├── instruction_memory.v     # Instruction memory module
├── control_unit.v           # Main control signal generator
├── register_file.v          # Register file (32 registers)
├── alu_control.v            # ALU control logic
├── alu.v                    # 32-bit ALU module
├── data_memory.v            # Data memory unit
├── sign_extender.v          # 16-bit to 32-bit sign extension
├── tb_mips_processor.v      # Complete testbench
```

---

### ⚙️ Processor Datapath  
![MIPS Datapath Diagram](https://github.com/Srikar109755/32-bit-Single_Cycle-MIPS-processor/blob/main/images/DataPath_Diagram.png)

---

### 📌 Supported Instructions
| Instruction | Type   | Example               | Function                                |
|------------|--------|------------------------|------------------------------------------|
| `add`      | R-type | `add $s0, $t1, $t2`    | `$s0 = $t1 + $t2`                        |
| `sub`      | R-type | `sub $s1, $t3, $t4`    | `$s1 = $t3 - $t4`                        |
| `lw`       | I-type | `lw $s1, 16($zero)`    | Load from memory into `$s1`             |
| `sw`       | I-type | `sw $s0, 16($zero)`    | Store `$s0` into memory                 |
| `beq`      | I-type | `beq $s1, $s0, label`  | Branch if equal                         |
| `j`        | J-type | `j 40`                 | Jump to instruction address 40          |

---

### ▶️ How to Simulate
1. Load all `.v` files into your Verilog simulator (ModelSim, Vivado, Icarus, etc.)
2. Set `tb_mips_processor.v` as the top module
3. Run simulation and observe output using `$display` or waveform viewer

---

### 🔍 Sample Waveform  
![Simulation Waveform](https://github.com/Srikar109755/32-bit-Single_Cycle-MIPS-processor/blob/main/Outputs/Waveform.png)

---

### 📌 Example Output (Console)
```
Time    PC        Instr     $s0     $s1     Mem[16]
20      00000000 012A8020   15      0       0
30      00000004 AE100010   15      0       15
...
```

---

### 🧪 Testbench Highlights
- Initializes registers with known values  
- Loads instructions into memory using `imem[]`  
- Runs sample program with ALU ops, memory access, and control flow  
- Monitors output of `$s0`, `$s1`, and `mem[16]` during runtime  

---

### 📜 License
This project is open-source for educational and personal learning purposes.
</details>
