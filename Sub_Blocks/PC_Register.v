`timescale 1ns / 1ps


module PC_Register( input clk, reset, 
                    input [`WORD_SIZE-1:0] pc_in, 
                    output reg [`WORD_SIZE-1:0] pc_out
                  );
                  
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 32'h00000000;
        else
            pc_out <= pc_in;
    end
    
endmodule
