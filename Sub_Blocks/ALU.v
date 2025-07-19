`timescale 1ns / 1ps


`define WORD_SIZE 32

module ALU(
    input [`WORD_SIZE-1:0] a,
    input [`WORD_SIZE-1:0] b,
    input [3:0] alu_op,
    output reg [`WORD_SIZE-1:0] result,
    output reg zero
    );
    
    // ALU operations
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;


    always @(*) begin
        case(alu_op)
            ALU_ADD: result = a + b;
            ALU_SUB: result = a - b;
            ALU_AND: result = a & b;
            ALU_OR : result = a | b;
            default: result = 32'hxxxxxxxx;
        endcase
        zero = (result == 32'b0);
    end
endmodule
