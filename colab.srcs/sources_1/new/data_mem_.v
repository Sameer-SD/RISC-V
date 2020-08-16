`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2020 06:14:26
// Design Name: 
// Module Name: data_mem
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

module data_mem(
    input [63:0] in,
    input [4:0] rs1,rs2,rd,
    input [6:0] opcode,func7,
    input clk,
    output [63:0] a,
    input l
    );
    wire [63:0] out;
    reg en;
    wire [4:0] s2;
    wire [11:0] imm;
    wire con;
    assign con = 4'b0;
    reg [63:0] q [0:31];
    assign imm = {func7,rs2};
    
    ALU alu2(.a({59'b0,rs1}), .b({42'b0,imm}), .out(out), .con(con), .clk(clk), .reset(0));
    assign s2 = out[4:0];
    
    
    initial begin
        en <= 1;
        $readmemh("C:/a/q.txt", q);
    end
    
    always@(posedge clk)begin
        if(en == 0 && l == 1'b1) begin
            q[rs1] <= in;
            en <= 1;
            $writememh("C:/a/q.txt", q);
        end
        else begin
            en <= 0;
        end
        
    end
    
    
    assign a = q[s2];

endmodule
