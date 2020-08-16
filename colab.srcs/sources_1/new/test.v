module test(

    );
    reg [6:0] q;                    //program counter
    reg clk;
    wire [6:0] func7,opcode;
    wire [4:0] rs1,rs2,rd;
    wire [2:0] func3;
    wire [3:0] con;                 //decoded instruction for alu
    wire [63:0] in;
    wire [63:0] in1, in2;           //outputs from different modules, mux is used to select the desired from 3
    reg [63:0] in3;
    wire [63:0] a,b,c;              //outputs of reg file
    wire s,l;                       //flags for write enable for reg file and data memory
    wire [1:0] mod;                 //flag for opcode
    integer counter;                //counter to run one instrucition in 5 clks
    reg ren, wen, len;              //flags for read and write enable
    wire [12:0] off;                //offset variables
    wire  [19:0] off2;
    wire  [11:0] off3;
    assign off = {func7[6],rd[0],func7[5:0],rd[4:1],1'b0};
    assign off2 = {func7[6],rs1,func3,rs2[0],func7[5:0],rs2[4:1],1'b0};
    assign off3 = {func7,rs2};
    
    initial begin
        counter = 5;
        q = 0;
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    Int_Mem  i(.clk(clk), .func7(func7), .opcode(opcode), .rs1(rs1), .rs2(rs2), .rd(rd), .func3(func3),.con(con), .s(s), .l(l), .q(q), .mod(mod));
    
    reg_file rf(.opcode(opcode), .func7(func7), .rs1(rs1), .rs2(rs2), .rd(rd), .clk(clk), .a(a), .b(b), .c(c), .in(in), .s(s), .ren(ren), .wen(wen));
    
    data_mem de(.des(in1), .clk(clk), .a(c), .in(in2), .l(l), .len(len));
    
    ALU alul(.a(a), .b(b), .out(in1), .con(con), .clk(clk), .reset(1'b0));
    
    
    assign in = (mod[1] == 1'b1) ? in3 : ((opcode == 7'b0000011) ? in2 : in1);
    
    always@(posedge clk) begin
        counter = counter + 1;
        if(counter == 1)begin
            ren <= 1'b1;
            wen <= 1'b0;
        end
        else if(counter == 3)begin
            len <= 1'b1;
            ren <= 1'b0;
            wen <= 1'b0;
        end
        else if(counter == 4)begin
            wen <= 1'b1;
            ren <= 1'b0;
        end
        else begin
            ren <= 1'b0;
            wen <= 1'b0;
        end
        if(counter >= 5) begin
            if(mod == 2'b00)begin               //normal operation
                q <= q + 4;
            end
            else if(mod == 2'b01) begin
                if(func3 == 3'b000)begin            //beq
                    if(c == b) begin
                        q <= q + off;
                    end
                    else begin
                        q <= q + 4;
                    end
                end
                else if(func3 == 3'b001)begin       //bne
                    if(b == c)begin
                        q <= q + 4;
                    end
                    else begin
                        q <= q + off;
                    end
                end
            end
            else if(mod == 2'b10)begin              //jal
                q <= q + off2;
                in3 <= q + 4;
            end
            else if(mod == 2'b11)begin              //jalr
                q <= b + off3;
                in3 <= q + 4;
            end
            counter = 0;
        end
    end
endmodule
