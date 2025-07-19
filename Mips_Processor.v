`timescale 1ns / 1ps


`define WORD_SIZE 32


module Mips_Processor(
    input clk,
    input reset
    );

    wire [`WORD_SIZE-1:0] pc_current, pc_next, pc_plus_4, pc_branch;
    wire [`WORD_SIZE-1:0] instruction;
    wire [`WORD_SIZE-1:0] sign_extended_imm, jump_address;
    wire [4:0]  write_reg_addr;
    wire [`WORD_SIZE-1:0] reg_read_data_1, reg_read_data_2;
    wire [`WORD_SIZE-1:0] alu_result, alu_b_operand;
    wire [`WORD_SIZE-1:0] mem_read_data;
    wire [`WORD_SIZE-1:0] write_back_data;


    // Control Signals
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [1:0] ALUOp;
    wire [3:0] alu_control_signal;
    wire alu_zero_flag;


    //--- PC Logic ---
    PC_Register pc_reg( .clk(clk), 
                        .reset(reset), 
                        .pc_in(pc_next), 
                        .pc_out(pc_current)
                      );
                      
                      
    assign pc_plus_4 = pc_current + 4;
    assign pc_branch = pc_plus_4 + (sign_extended_imm << 2);
    assign jump_address = {pc_plus_4[31:28], instruction[25:0], 2'b00};
    wire branch_and_zero = Branch & alu_zero_flag;
    assign pc_next = Jump ? jump_address : (branch_and_zero ? pc_branch : pc_plus_4);


    //--- Instruction Fetch ---
    Instruction_Memory instr_mem( .address(pc_current), 
                                  .instruction(instruction) 
                                );


    //--- Control Unit ---
    Control_Unit ctrl_unit( .opcode(instruction[31:26]), 
                            .RegDst(RegDst), 
                            .ALUSrc(ALUSrc),
                            .MemtoReg(MemtoReg), 
                            .RegWrite(RegWrite), 
                            .MemRead(MemRead),
                            .MemWrite(MemWrite), 
                            .Branch(Branch), 
                            .ALUOp(ALUOp), 
                            .Jump(Jump) 
                          );


    //--- Decode & Register File ---
    Register_File reg_file( .clk(clk), 
                            .rst(reset), 
                            .write_enable(RegWrite),
                            .read_reg1(instruction[25:21]), 
                            .read_reg2(instruction[20:16]),
                            .write_reg(write_reg_addr), 
                            .write_data(write_back_data),
                            .read_data1(reg_read_data_1), 
                            .read_data2(reg_read_data_2) 
                          );
                            
    assign write_reg_addr = RegDst ? instruction[15:11] : instruction[20:16];
    
    
    // Sign Extender
    Sign_Extender sign_ext( .imm_in(instruction[15:0]), 
                            .imm_out(sign_extended_imm) 
                          );


    //--- Execute (ALU) ---
    ALU_Control alu_ctrl( .ALUOp(ALUOp), 
                          .funct(instruction[5:0]), 
                          .alu_op_out(alu_control_signal) 
                        );
                        
    assign alu_b_operand = ALUSrc ? sign_extended_imm : reg_read_data_2;
    
    ALU alu_unit( .a(reg_read_data_1), 
                  .b(alu_b_operand), 
                  .alu_op(alu_control_signal),
                  .result(alu_result), 
                  .zero(alu_zero_flag) 
                );


    //--- Memory Access ---
    Data_Memory data_mem( .clk(clk), 
                          .address(alu_result), 
                          .write_data(reg_read_data_2),
                          .mem_write(MemWrite), 
                          .mem_read(MemRead), 
                          .read_data(mem_read_data) 
                        );


    //--- Write Back ---
    assign write_back_data = MemtoReg ? mem_read_data : alu_result;

endmodule
