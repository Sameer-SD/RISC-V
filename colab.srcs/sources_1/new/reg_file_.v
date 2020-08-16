`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2020 04:59:30
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input [63:0] in,
    input [4:0] rs1,rs2,rd,
    input [6:0] opcode,func7,
    input clk,
    output [63:0] a,b,
    input s
    );
    wire [3:0] con;
    wire [63:0] out;
    reg reset;
    reg en;
    assign con = 4'b0000;
    reg [11:0] imm;
    wire [11:0] off;
    reg [63:0] X [0:31];
    initial begin
        $readmemh("C:/a/X.txt", X);
        en = 1;
    end
    assign off = {func7, rd}; 
    ALU alu3(.a({59'b0,rs2}), .b({52'b0,off}), .out(out), .con(con), .clk(clk), .reset(0));
    assign s2 = out[4:0]; 
    always@(posedge clk)begin
        imm = {func7,rs2};
        if(en == 0 && s == 1'b1) begin
            X[rd] <= in;
            en <= 1;
            $writememh("C:/a/X.txt", X);
        end
        else begin
            en <= 0;
        end
    end

    assign a = (opcode == 7'b0010011) ? imm :( (opcode == 7'b0100011)? X[s2] : X[rs2]);
    assign b = X[rs1];
endmodule
