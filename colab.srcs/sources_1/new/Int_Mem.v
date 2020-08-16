module Int_Mem(input clk,input [6:0] q,
                output [6:0] func7,opcode,
                output [4:0] rs1,rs2,rd,
                output [2:0] func3,
                output [3:0] con,
                output s,
                output l,
                output [1:0] mod
);
    reg [31:0] captured_inputs;
    reg [7:0] ins [0:127];
    initial begin
        $readmemb("a.txt",ins);
    end
    decoder d1(.captured_inputs(captured_inputs), .clk(clk), .func7(func7), .opcode(opcode), .rs1(rs1), .rs2(rs2), .rd(rd), .func3(func3), .con(con), .s(s), .l(l), .mod(mod));
    
    always @(posedge clk)begin
        captured_inputs <= {ins[q],ins[q+1],ins[q+2],ins[q+3]};
    end
endmodule
