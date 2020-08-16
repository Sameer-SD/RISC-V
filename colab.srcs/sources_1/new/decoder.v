`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2020 23:02:53
// Design Name: 
// Module Name: decoder
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


module decoder(input clk,
    input [31:0] captured_inputs,
    output reg [6:0] func7,opcode,
    output reg [4:0] rs1,rs2,rd,
    output reg [2:0] func3,
    output reg [3:0] con,
    output reg s,
    output reg l,
    output reg [1:0] mod
);

always@(posedge clk)begin
    if(!captured_inputs) $finish;
    opcode = captured_inputs[6:0];
        rd = captured_inputs[11:7];
        func3 = captured_inputs[14:12];
        rs1 = captured_inputs[19:15];
        rs2 = captured_inputs[24:20];
        func7 = captured_inputs[31:25];
        mod = 2'b00;
        if(captured_inputs[6:0] == 7'b0110011) begin
            mod = 2'b00;
            s = 1'b1;
            l = 1'b0;
            if(captured_inputs[31:25] == 7'b0000000 && captured_inputs[14:12] == 3'b000)begin       //add
                con = 4'b0;
            end
            else if(captured_inputs[31:25] == 7'b0100000 && captured_inputs[14:12] == 3'b000)begin  //sub
                con = 4'b0001;
            end
            else if(captured_inputs[31:25] == 7'b0000000 && captured_inputs[14:12] == 3'b100)begin  //xor
                con = 4'b0101;
            end
            else if(captured_inputs[31:25] == 7'b0000000 && captured_inputs[14:12] == 3'b101) begin  //srl
                con = 4'b1000;
            end
            else if(captured_inputs[31:25] == 7'b0100000 && captured_inputs[14:12] == 3'b101) begin  //sra
                con = 4'b1001;
            end
            else if(captured_inputs[31:25] == 7'b0000000 && captured_inputs[14:12] == 3'b110) begin  //or
                con = 4'b0011;
            end
            else if(captured_inputs[31:25] == 7'b0000000 && captured_inputs[14:12] == 3'b111) begin  //and
                con = 4'b0100;
            end
        end
        else if(captured_inputs[6:0] == 7'b0010011)begin                        //addi
            s = 1'b1;
            l = 1'b0;
            mod = 2'b0;
            if(captured_inputs[14:12] == 3'b000)begin
                con = 4'b0000;
            end
        end
        else if(captured_inputs[6:0] == 7'b0000011)begin   //lw,ld
            s = 1'b1;
            l = 1'b0;
            mod = 2'b0;
            con = 4'b1111;
        end
        else if(captured_inputs[6:0] == 7'b0100011 )begin   //sw,sd
            s = 1'b0;
            l = 1'b1;
            mod = 4'b0;
            con = 4'b1111;
        end
        else if(captured_inputs[6:0] == 7'b1100011) begin
            s = 1'b0;
            l = 1'b0;
            mod = 2'b01;
            if(captured_inputs[14:12] == 3'b000) begin                      //beq
            end
            else if(captured_inputs[14:12] == 3'b001) begin                 //bne
            end
        end
        else if(captured_inputs[6:0] == 7'b1101111) begin                   //jal
            s = 1'b1;
            l = 1'b0;
            mod = 3'b10;
        end
        else if(captured_inputs[6:0] == 7'b1100111) begin                   //jalr
            s = 1'b1;
            l = 1'b0;
            mod = 2'b11;
        end
        else begin
            s = 1'b0;
            l = 1'b0;
            //$finish;
        end
    end
endmodule
