`timescale 1ns / 1ps



module TB_Mips_Processor;

    // Inputs
    reg clk;
    reg reset;

    // Instantiating the MIPS Processor
    Mips_Processor uut (
        .clk(clk),
        .reset(reset)
    );


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end


    // Test sequence
    initial begin
        // ----------------------------------------------------------------------
        // Sample Program to load into Instruction Memory
        // This is the MIPS assembly and its machine code equivalent.
        // We load the machine code into the instruction memory of the processor.
        //
        // MIPS Assembly:
        // 0: add  $t0, $zero, 5     // $t0 = 5 (using addi, but implemented as add for simplicity)
        // 4: add  $t1, $zero, 7     // $t1 = 7
        // 8: add  $s0, $t0, $t1     // $s0 = $t0 + $t1 = 12
        // 12: sw  $s0, 16($zero)    // Memory[16] = 12
        // 16: lw  $s1, 16($zero)    // $s1 = Memory[16]
        // 20: beq $s1, $s0, 2       // Branch to instruction at PC+4+8 (address 32) if $s1 == $s0
        // 24: j 10                  // Jump to instruction 10 (address 40)
        // 28: <nop - this will be skipped by branch>
        // 32: add $t2, $zero, 1     // $t2 = 1 (branch target)
        // 36: <nop - this will be skipped by jump>
        // 40: add $t3, $zero, 2     // $t3 = 2 (jump target)
        // ----------------------------------------------------------------------

        // Machine Code (32-bit hex) for the program above:
        // Note: For simplicity, 'add $t0, $zero, 5' is manually encoded as an R-type instruction
        // where a register (e.g., $t2) is pre-loaded with 5. In a real scenario, this would be `addi`.
        // We will simulate it by adding two registers.
        // Simplified Program for this specific hardware:
        // 0: add $t1, $zero, $zero  // $t1 = 0
        // 4: add $t2, $zero, $zero  // $t2 = 0
        // ... this is hard to do without an assembler.
        //
        // Let's load a simpler, direct program:
        // Inst [0]: addi $t0, $zero, 5  (We'll simulate this with lw from a known memory location)
        // For this test, let's manually write values to registers and memory first
        // and then test the ALU and branching.

        // Initialize processor state for a clear test
        // Let's pretend reg $t0=5 and $t1=10
        uut.reg_file.registers[8]  = 5;  // $t0 = 5
        uut.reg_file.registers[9]  = 10; // $t1 = 10
        uut.reg_file.registers[10] = 5;  // $t2 = 5 (for beq test)


        // Load program into instruction memory
        uut.instr_mem.imem[0] = 32'h012A8020; // 0x00: add $s0, $t1, $t2  ($s0 = 10 + 5 = 15)
        uut.instr_mem.imem[1] = 32'hAE100010; // 0x04: sw  $s0, 16($zero) ($s0 (15) -> mem[16])
        uut.instr_mem.imem[2] = 32'h8E110010; // 0x08: lw  $s1, 16($zero) (mem[16] -> $s1)
        uut.instr_mem.imem[3] = 32'h12300002; // 0x0C: beq $s1, $s0, 2    (Branch to 0x18 if equal)
        uut.instr_mem.imem[4] = 32'h00000000; // 0x10: nop (will be executed if branch is not taken)
        uut.instr_mem.imem[5] = 32'h0800000A; // 0x14: j 10 (Jump to instruction at address 40)
        uut.instr_mem.imem[6] = 32'h00000000; // 0x18: nop (branch target)
        uut.instr_mem.imem[7] = 32'h00000000; // 0x1C: nop
        uut.instr_mem.imem[8] = 32'h00000000; // 0x20: nop
        uut.instr_mem.imem[9] = 32'h00000000; // 0x24: nop
        uut.instr_mem.imem[10] = 32'h00000000;// 0x28: nop (jump target)

        // Reset the processor
        reset = 1;
        #10;
        reset = 0;
        #10;

        // Monitor the values of key registers
        $display("Time\tPC\t\tInstr\t\t$s0(16)\t\t$s1(17)\t\tMem[16]");
        $monitor("%0t\t%h\t%h\t%d\t\t%d\t\t%d",
            $time, uut.pc_current, uut.instruction,
            uut.reg_file.registers[16],
            uut.reg_file.registers[17],
            uut.data_mem.dmem[4]);

        // Run simulation for a few cycles
        #100;

        $display("Simulation finished.");
        $finish;
    end

endmodule
