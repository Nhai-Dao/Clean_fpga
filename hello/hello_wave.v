module hello_wave;

  reg clk;
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] result;

  // Tạo clock chu kỳ 10 đơn vị
  initial clk = 0;
  always #5 clk = ~clk;

  // Ghi waveform ra file .vcd
  initial begin
    $dumpfile("hello_wave.vcd");
    $dumpvars(0, hello_wave);
  end

  // Thay đổi a theo từng clock
  initial begin
    a = 8'd0;
    b = 8'd20;

    @(posedge clk); a = 8'd10;
    @(posedge clk); a = 8'd20;
    @(posedge clk); a = 8'd30;
    @(posedge clk); a = 8'd40;

    #20 $finish;
  end

  // Tính result tại mỗi posedge clock
  always @(posedge clk) begin
    result <= a + b;
  end

endmodule