`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2020 04:41:03
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(input [63:0]a, input [63:0]b,
    input [3:0]con,input clk,input reset, output reg [63:0] out
    );
    always@(posedge clk)begin
        if(!reset) begin
        case(con)
            4'b0000:                    //add
                begin
                out <= a + b;
                end            
            4'b0001:                    //sub
                begin
                out <= a - b;
                end
            4'b0010:                    //mul
                begin
                out <= a * b;
                end
            4'b0011:                    //or
                begin
                out <= a | b;
                end
            4'b0100:                    //and
                begin
                out <= a & b;
                end     
            4'b0101:                    //xor
                begin
                out <= a ^ b;
                end
            4'b0110:                    //nand
                begin
                out <= ~(a & b);
                end
            4'b0111:                    //not
                begin
                out <= ~a;
                end
            4'b1000:                    //srl
                begin
                out <= a >> b;
                end
            4'b1001:                    //sra
                begin
                out <= a >>> b;
                end
            4'b1111:                    //return a
                begin
                out <= a;
                end
            default:                    //default
                begin
                out <= 64'b0;
                end
        endcase
        end
        else begin out <= 64'b0; end
    end
endmodule
