module ass_alw 
    reg clk;
    reg rst_n;
    reg enable;

    reg [0:7] a;
    reg [0:7] b;
    wire [0:7] sum_wire;
    reg [0:7] sum_reg;

    assign sum = a + b;
    
    always @(*) begin
        if(!rst_n)
            sum_reg = 0;
        else if (enable)
            sum_reg = a + b;
    end

    always @(posedge clk) begin
        if(!rst_n)
            sum_reg <= 0;
        else if (enable) 
            sum_reg <= a + b;
    end


endmodule