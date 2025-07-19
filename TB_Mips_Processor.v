`timescale 1ns / 1ps


module TB_Mips_Processor;

    reg clk;
    reg reset;

    Mips_Processor uut (
        .clk(clk),
        .reset(reset)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    initial begin
        clk = 0;
        reset = 1;

        // Loading instructions before reset is de-asserted
        uut.instr_mem.imem[0]  = 32'h20080064; // addi $t0, $zero, 100
        uut.instr_mem.imem[1]  = 32'h20090019; // addi $t1, $zero, 25
        uut.instr_mem.imem[2]  = 32'h01098020; // add  $s0, $t0, $t1
        uut.instr_mem.imem[3]  = 32'h01098822; // sub  $s1, $t0, $t1
        uut.instr_mem.imem[4]  = 32'hAC100008; // sw   $s0, 8($zero)
        uut.instr_mem.imem[5]  = 32'h8C0A0008; // lw   $t2, 8($zero)
        uut.instr_mem.imem[6]  = 32'h12120002; // beq  $s0, $t2, 2
        uut.instr_mem.imem[7]  = 32'h00000000;
        uut.instr_mem.imem[8]  = 32'h00000000;
        uut.instr_mem.imem[9]  = 32'h0800000F; // j 15
        uut.instr_mem.imem[10] = 32'h00000000;
        uut.instr_mem.imem[11] = 32'h00000000;
        uut.instr_mem.imem[12] = 32'h00000000;
        uut.instr_mem.imem[13] = 32'h00000000;
        uut.instr_mem.imem[14] = 32'h00000000;
        uut.instr_mem.imem[15] = 32'h200D022B; // addi $t5, $zero, 555

        #20;  // Wait for memory to settle
        reset = 0; // Deassert reset AFTER instruction load

        $display("Loading MIPS Instructions");

        $display("\n------------------------------------------------------------------------------------------------");
        $display("Time(ns)   PC          Instr        $t0   $t1   $s0   $s1   $t2   $t5   Mem[2]");
        $display("------------------------------------------------------------------------------------------------");
        $monitor("%-10d %h  %h   %-4d  %-4d  %-4d  %-4d  %-4d  %-4d  %-4d",
                $time, uut.pc_current, uut.instruction,
                uut.reg_file.registers[8], uut.reg_file.registers[9],
                uut.reg_file.registers[16], uut.reg_file.registers[17],
                uut.reg_file.registers[10], uut.reg_file.registers[13],
                uut.data_mem.dmem[2]);

        #300;
        $display("\nSimulation completed.");
        $finish;
    end

endmodule
