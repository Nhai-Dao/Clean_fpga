module wire_reg;
    reg clk;
    reg enable;
    reg rst_n; // reset = 0
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    wire [7:0] combinational_sum;   // kết quả tức thì
    reg [7:0] registered_sum;  // kết quả sau 1 clock

    //với output: wire -> assign còn reg -> always
    assign combinational_sum = operand_a + operand_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            registered_sum <= 0;    //reset về 0
        else if (enable)
            registered_sum <= operand_a + operand_b;   //enable = 1 -> tính        
    end

    // always @(posedge clk) begin
    //     registered_sum <= operand_a + operand_b;
    //end

    //clock 
    initial clk = 0;
    always #5 clk = ~clk;

    //waveform
    initial begin
        $dumpfile("wire_reg.vcd");
        $dumpvars(0, wire_reg);
    end
    

    //test
    initial begin
        rst_n = 0;
        enable = 0;
        operand_a = 8'd10;
        operand_b = 8'd20;

        #7 //chờ 3 đơn vị (chưa đến posedge)

        rst_n = 1;
        enable = 0;
        @(posedge clk); #1;
        $display("t = %0t | enable = 0 | registered_sum = %0d", $time, registered_sum);
        
        enable = 1;
        @(posedge clk);  // chờ đến posedge
        #1;              // chờ thêm 1 đơn vị sau posedge
        $display("t=%0t | enable = 1| registered_sum=%0d",
                $time, registered_sum);

        enable = 0;
        operand_a = 8'd99;       // thay đổi operand_a
        @(posedge clk);
        #1;
        $display("t=%0t | enable =0 | operand_a=99 | registered_sum=%0d",
                $time, registered_sum);

        enable = 1;
        @(posedge clk);
        #1;
        $display("t=%0t | enable = 1 | operand_a=99 | registered_sum=%0d",
                $time, registered_sum);

        enable = 1;
        @(posedge clk);
        #1;
        $display("t=%0t | enable = 1 | operand_a=99 | registered_sum=%0d", $time, registered_sum);

        #10 $finish;
    end    
endmodule
