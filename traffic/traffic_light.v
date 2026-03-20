`timescale 1ns/1ps
module traffic_light (
    input  wire clk,
    input  wire rst_n,
    output reg  red,
    output reg  green,
    output reg  yellow
);

  // ─── State encoding ───────────────────────────
  localparam RED_S    = 2'b00;
  localparam GREEN_S  = 2'b01;
  localparam YELLOW_S = 2'b10;

  // ─── State register + counter ─────────────────
  reg [1:0]  current_state;
  reg [1:0]  next_state;
  reg [11:0] counter;  // 12 bit đủ đếm đến 3000

  // ─── Block 1: State Register (D FF) ───────────
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= RED_S;
      counter       <= 0;
    end
    else begin
      if (current_state != next_state) begin
        // Chuyển state → reset counter
        current_state <= next_state;
        counter       <= 0;
      end
      else begin
        // Giữ state → đếm tiếp
        current_state <= current_state;
        counter       <= counter + 1;
      end
    end
  end

  // ─── Block 2: Next State Logic (LUT) ──────────
  always @(*) begin
    case (current_state)
      RED_S:    next_state = (counter >= 3000) ? GREEN_S  : RED_S;
      GREEN_S:  next_state = (counter >= 2500) ? YELLOW_S : GREEN_S;
      YELLOW_S: next_state = (counter >= 500)  ? RED_S    : YELLOW_S;
      default:  next_state = RED_S;
    endcase
  end

  // ─── Block 3: Output Logic (LUT) ──────────────
  always @(*) begin
    // Default về 0 trước — tránh latch
    red    = 0;
    green  = 0;
    yellow = 0;

    case (current_state)
      RED_S:    red    = 1;
      GREEN_S:  green  = 1;
      YELLOW_S: yellow = 1;
    endcase
  end

endmodule