module data_mem(
    output [63:0] in,
    input [63:0] des,
    input clk,
    input [63:0] a,
    input l,len
    );
    reg [63:0] q [0:31];

    
    initial begin
        $readmemh("q.txt", q);
    end
    
    always@(posedge clk)begin
        if(l == 1'b1 && len == 1'b1) begin
            q[des/8] = a;
            $writememh("q.txt", q);
        end      
    end
    
    
    assign in = (l == 1'b1) ? 64'b0 : q[des/8];

endmodule
