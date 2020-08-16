`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2020 06:27:44
// Design Name: 
// Module Name: 
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


module test(

    );
    reg [4:0] q;
    reg [4:0] qw;
    reg clk;
    reg [31:0] captured_inputs;
    wire [6:0] func7,opcode;
    wire [4:0] rs1,rs2,rd;
    wire [2:0] func3;
    wire [3:0] con;
    wire [63:0] in;
    wire [63:0] in1;
    wire [63:0] in2;
    wire [63:0] a1;
    wire [63:0] a2;
    wire [63:0] a,b;
    wire s,l;
    wire [1:0] mod;
    integer counter;
    
    initial begin
        counter = 5;
        q = 0;
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    Int_Mem  i(.clk(clk), .func7(func7), .opcode(opcode), .rs1(rs1), .rs2(rs2), .rd(rd), .func3(func3),.con(con), .s(s), .l(l), .q(q), .mod(mod));
    
    reg_file rf(.opcode(opcode), .func7(func7), .rs1(rs1), .rs2(rs2), .rd(rd), .clk(clk), .a(a1), .b(b), .in(in), .s(s));
    
    data_mem de(.opcode(opcode), .func7(func7), .rs1(rs1), .rs2(rs2), .rd(rd), .clk(clk), .a(a2), .in(in), .l(l));
    
    assign a = (opcode == 7'b0000011) ? a2 : a1;
    
    ALU alul(.a(a), .b(b), .out(in1), .con(con), .clk(clk), .reset(0));
    
    pc p(.q(q), .a(a), .b(b), .func7(func7), .rd(rd), .rs1(rs1), .rs2(rs2), .opcode(opcode), .fucn3(func3), .qw(qw), .mod(mod), .c(in2));
    
    assign in = (mod[1] == 1'b1) ? in2 : in1;
    
    always@(posedge clk) begin
        counter = counter + 1;
        if(counter >= 5) begin
            q <= qw;
            counter = 0;
            if(q == 6) begin
                $finish;
            end
        end
    end
endmodule
