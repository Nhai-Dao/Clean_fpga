module assign_always;
    reg clk;
    reg rst_n;
    reg enable;

    reg [0:7] operand_a;
    reg [0:7] operand_b;
    wire [0:7] combinational_sum;
    reg [0:7] registered_sum;

    assign combinational_sum = operand_a + operand_b;
    
    always @(*) begin
        if(!rst_n)
            registered_sum = 0;
        else if (enable)
            registered_sum = operand_a + operand_b;
    end

    always @(posedge clk) begin
        if(!rst_n)
            registered_sum <= 0;
        else if (enable) 
            registered_sum <= operand_a + operand_b;
    end


endmodule