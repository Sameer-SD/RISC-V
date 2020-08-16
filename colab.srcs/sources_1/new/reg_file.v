module reg_file(
    input [63:0] in,
    input [4:0] rs1,rs2,rd,
    input [6:0] opcode,func7,
    input clk,
    output [63:0] a,b,c,
    input s,
    input ren,wen
    );
    wire [11:0] imm;
    wire [11:0] off;
    reg [63:0] X [0:31];
    initial begin
        $readmemh("X.txt", X);
    end
    assign off = {func7, rd}; 
    assign imm =(opcode == 7'b0100011) ? {func7, rd} : {func7,rs2};
    always@(posedge clk)begin
        if(wen == 1 && s == 1'b1) begin
            X[rd] = in;
            $writememh("X.txt", X);
        end
    end

    assign a = (ren == 1'b0) ? a : ((opcode == 7'b0110011) ? X[rs2]: ((imm[11] == 1'b0) ? imm : {52'b1111111111111111111111111111111111111111111111111111,imm}));
    assign b = (ren == 1'b0) ? b : X[rs1];
    assign c = X[rs2];
endmodule
