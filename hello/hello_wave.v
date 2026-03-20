module hello_wave;

  reg clk;
  reg [7:0] addend_a;
  reg [7:0] addend_b;
  reg [7:0] sum_result;

  // Tạo clock chu kỳ 10 đơn vị
  initial clk = 0;
  always #5 clk = ~clk;

  // Ghi waveform ra file .vcd
  initial begin
    $dumpfile("hello_wave.vcd");
    $dumpvars(0, hello_wave);
  end

  // Thay đổi addend_a theo từng clock
  initial begin
    addend_a = 8'd0;
    addend_b = 8'd20;

    @(posedge clk); addend_a = 8'd10;
    @(posedge clk); addend_a = 8'd20;
    @(posedge clk); addend_a = 8'd30;
    @(posedge clk); addend_a = 8'd40;

    #20 $finish;
  end

  // Tính sum_result tại mỗi posedge clock
  always @(posedge clk) begin
    sum_result <= addend_a + addend_b;
  end

endmodule