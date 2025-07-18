`timescale 1ns / 1ps


`define WORD_SIZE 32

module Instruction_Memory(
    input [`WORD_SIZE-1:0] address,
    output [`WORD_SIZE-1:0] instruction
    );
    
    // 256 words of instruction memory
    reg [`WORD_SIZE-1:0] imem [255:0];

    // Read instruction from memory based on PC address
    // The address from PC is byte-addressed, so we divide by 4 for word index
    assign instruction = imem[address[9:2]];

endmodule
