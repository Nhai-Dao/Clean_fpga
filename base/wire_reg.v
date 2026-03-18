module wire_reg;
    reg clk;
    reg enable;
    reg rst_n; // reset = 0
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] sum_wire;   // kết quả tức thì
    reg [7:0] sum_reg;  // kết quả sau 1 clock

    //với output: wire -> assign còn reg -> always
    assign sum_wire= a+ b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_reg <= 0;    //reset về 0
        else if (enable)
            sum_reg <= a +b;   //enable = 1 -> tính        
    end

    // always @(posedge clk) begin
    //     sum_reg <= a+b ;
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
        a =8'd10;
        b =8'd20;

        #7 //chờ 3 đơn vị (chưa đến posedge)

        rst_n = 1;
        enable = 0;
        @(posedge clk); #1;
        $display("t = %0t | enable = 0 | sum_reg = %0d", $time, sum_reg);
        
        enable = 1;
        @(posedge clk);  // chờ đến posedge
        #1;              // chờ thêm 1 đơn vị sau posedge
        $display("t=%0t | enable = 1| sum_reg=%0d",
                $time, sum_reg);

        enable = 0;
        a = 8'd99;       // thay đổi a
        @(posedge clk);
        #1;
        $display("t=%0t | enable =0 | a=99 | sum_reg=%0d",
                $time, sum_reg);

        enable = 1;
        @(posedge clk);
        #1;
        $display("t=%0t | enable = 1 | a=99 | sum_reg=%0d",
                $time, sum_reg);

        enable = 1;
        @(posedge clk);
        #1;
        $display("t=%0t | enable = 1 | a=99 | sum_reg=%0d", $time, sum_reg);

        #10 $finish;
    end    
endmodule
