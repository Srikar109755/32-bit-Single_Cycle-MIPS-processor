`timescale 1ns / 1ps


`define WORD_SIZE 32

module Data_Memory(
    input clk,
    input [`WORD_SIZE-1:0] address,
    input [`WORD_SIZE-1:0] write_data,
    input mem_write,
    input mem_read,
    output reg [`WORD_SIZE-1:0] read_data
    );
    
    // 256 words of data memory
    reg [`WORD_SIZE-1:0] dmem [255:0];


    // Asynchronous read
    always @(*) begin
        if (mem_read)
            read_data = dmem[address[9:2]];
        else
            read_data = 32'hxxxxxxxx;
    end


    // Synchronous write
    always @(posedge clk) begin
        if (mem_write)
            dmem[address[9:2]] <= write_data;
    end
endmodule
