`timescale 1ns / 1ps


module ALU_Control(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [3:0] alu_op_out
    );
    
    // ALU operations
    parameter ALU_ADD = 4'b0010;
    parameter ALU_SUB = 4'b0110;
    parameter ALU_AND = 4'b0000;
    parameter ALU_OR  = 4'b0001;


    // R-Type funct codes
    parameter FUNCT_ADD = 6'b100000;
    parameter FUNCT_SUB = 6'b100010;


    always @(*) begin
        case(ALUOp)
            2'b00: alu_op_out = ALU_ADD;                                            // for lw/sw
            2'b01: alu_op_out = ALU_SUB;                                            // for beq
            2'b10: begin                                                            // R-Type, need to check funct
                case(funct)
                    FUNCT_ADD: alu_op_out = ALU_ADD;
                    FUNCT_SUB: alu_op_out = ALU_SUB;
                    
                    // Adding other R-type functions here (AND, OR, SLT)
                    default:   alu_op_out = 4'bxxxx;                                // Undefined
                endcase
            end
            default: alu_op_out = 4'bxxxx;                                          // Undefined
        endcase
    end
endmodule

