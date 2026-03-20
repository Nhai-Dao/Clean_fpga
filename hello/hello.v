module hello;

  reg clk;
  reg [7:0] addend_a;
  reg [7:0] addend_b;
  reg [7:0] sum_result;

  // Tạo clock: đảo mỗi 5 đơn vị thời gian
  // → chu kỳ = 10 đơn vị = 100MHz nếu 1 unit = 1ns
  initial clk = 0;
  always #5 clk = ~clk;

  // Ghi waveform ra file
  initial begin
    $dumpfile("hello.vcd");   // tên file output
    $dumpvars(0, hello);      // dump tất cả signal
  end

  // Logic chính
  initial begin
    addend_a = 8'd0;
    addend_b = 8'd20;

    // Chờ vài clock cycle rồi thay đổi addend_a
    @(posedge clk); addend_a = 8'd10;
    @(posedge clk); addend_a = 8'd20;
    @(posedge clk); addend_a = 8'd30;
    @(posedge clk); addend_a = 8'd40;

    #10 $finish;
  end

  // Tính sum_result mỗi posedge clock
  always @(posedge clk) begin
    sum_result <= addend_a + addend_b;
  end

endmodule