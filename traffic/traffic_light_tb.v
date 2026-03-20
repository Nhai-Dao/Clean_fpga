`timescale 1ns/1ps
module traffic_light_tb;

  // ─── Khai báo signal ──────────────────────────
  reg  clk;
  reg  rst_n;
  wire red;
  wire green;
  wire yellow;

  // ─── Kết nối module cần test ──────────────────
  traffic_light dut (
    .clk   (clk),
    .rst_n (rst_n),
    .red   (red),
    .green (green),
    .yellow(yellow)
  );

  // ─── Clock ────────────────────────────────────
  initial clk = 0;
  always #5 clk = ~clk;

  // ─── Waveform ─────────────────────────────────
  initial begin
    $dumpfile("traffic_light.vcd");
    $dumpvars(0, traffic_light_tb);
  end

  // ─── Test ─────────────────────────────────────
  initial begin
    // Reset
    rst_n = 0;
    #12;
    rst_n = 1;

    // Chờ đủ thời gian RED (3000 cycles × 10ns = 30,000ns)
    #30_100;
    $display("t=%0t | Sau RED   | red=%b green=%b yellow=%b",
              $time, red, green, yellow);

    // Chờ đủ thời gian GREEN (2500 cycles)
    #25_100;
    $display("t=%0t | Sau GREEN | red=%b green=%b yellow=%b",
              $time, red, green, yellow);

    // Chờ đủ thời gian YELLOW (500 cycles)
    #5_100;
    $display("t=%0t | Sau YELLOW| red=%b green=%b yellow=%b",
              $time, red, green, yellow);

    #100 $finish;
  end

endmodule