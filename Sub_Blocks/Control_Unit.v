`timescale 1ns / 1ps


module Control_Unit(
    input [5:0] opcode,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg Jump
    );

    // Instruction Opcodes
    parameter R_TYPE = 6'b000000;
    parameter LW     = 6'b100011;
    parameter SW     = 6'b101011;
    parameter BEQ    = 6'b000100;
    parameter JUMP   = 6'b000010;


    always @(*) begin
        // Setting default values to avoid latches
        RegDst   = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ALUOp    = 2'b00;

        case(opcode)
            R_TYPE: begin // add, sub
                RegDst   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            LW: begin // Load Word
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                ALUOp    = 2'b00; // ALU performs addition for address
            end
            SW: begin // Store Word
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00; // ALU performs addition for address
            end
            BEQ: begin // Branch if Equal
                Branch   = 1'b1;
                ALUOp    = 2'b01; // ALU performs subtraction for comparison
            end
            JUMP: begin // Jump
                Jump     = 1'b1;
            end
        endcase
    end
endmodule
