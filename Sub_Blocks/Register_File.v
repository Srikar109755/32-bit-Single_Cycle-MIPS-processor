`timescale 1ns / 1ps


module Register_File(
    input clk, rst,
    input write_enable,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [`WORD_SIZE-1:0] write_data,
    output [`WORD_SIZE-1:0] read_data1,
    output [`WORD_SIZE-1:0] read_data2
    );

    // 32 registers, each 32 bits wide
    reg [`WORD_SIZE-1:0] registers [0:31];

    // Initializing all registers to 0 on reset
    integer i;
    initial begin
      for (i=0; i<32; i=i+1) begin
        registers[i] = 0;
      end
    end


    // Asynchronous read
    assign read_data1 = registers[read_reg1];
    assign read_data2 = registers[read_reg2];


    // Synchronous write (on positive clock edge)
    always @(posedge clk) begin
        if (write_enable && (write_reg != 5'b00000)) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule
