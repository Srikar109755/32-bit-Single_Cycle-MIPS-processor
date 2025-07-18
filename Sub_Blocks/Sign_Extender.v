`timescale 1ns / 1ps


`define WORD_SIZE 32

module Sign_Extender(
    input [15:0] imm_in,
    output [`WORD_SIZE-1:0] imm_out
    );
    
    // Replicating the sign bit (MSB of input) 16 times
    assign imm_out = {{16{imm_in[15]}}, imm_in};
    
endmodule
